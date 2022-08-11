package es.um.redes.nanoChat.client.comm;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.LinkedList;

import es.um.redes.nanoChat.messageFV.NCControlMessage;
import es.um.redes.nanoChat.messageFV.NCMessage;
import es.um.redes.nanoChat.messageFV.NCRoomMessage;
import es.um.redes.nanoChat.messageFV.NCTextMessage;
import es.um.redes.nanoChat.messageFV.NCVarMessage;
import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;

//Esta clase proporciona la funcionalidad necesaria para intercambiar mensajes entre el cliente y el servidor de NanoChat
public class NCConnector {
	private Socket socket;
	protected DataOutputStream dos;
	protected DataInputStream dis;
	private LinkedList<NCMessage> cola;

	public NCConnector(InetSocketAddress serverAddress) throws UnknownHostException, IOException {
		// TODO Se crea el socket a partir de la dirección proporcionada
		socket = new Socket(serverAddress.getHostName(), serverAddress.getPort());
		// TODO Se extraen los streams de entrada y salida
		dos = new DataOutputStream(socket.getOutputStream());
		dis = new DataInputStream(socket.getInputStream());
		cola = new LinkedList<NCMessage>();
	}

	public LinkedList<NCMessage> getCola() {
		return cola;
	}

	// Método para registrar el nick en el servidor. Nos informa sobre si la
	// inscripción se hizo con éxito o no.
	public boolean registerNickname_UnformattedMessage(String nick) throws IOException {
		// Funcionamiento resumido: SEND(nick) and RCV(NICK_OK) or RCV(NICK_DUPLICATED)
		// TODO Enviamos una cadena con el nick por el flujo de salida
		dos.writeUTF(nick);
		// TODO Leemos la cadena recibida como respuesta por el flujo de entrada
		String respuesta = dis.readUTF();
		// TODO Si la cadena recibida es NICK_OK entonces no está duplicado (en función
		// de ello modificar el return)
		return respuesta.equals("NICK_OK");
	}

	// Método para registrar el nick en el servidor. Nos informa sobre si la
	// inscripción se hizo con éxito o no.
	public boolean registerNickname(String nick) throws IOException {
		// Funcionamiento resumido: SEND(nick) and RCV(NICK_OK) or RCV(NICK_DUPLICATED)
		// Creamos un mensaje de tipo RoomMessage con opcode OP_NICK en el que se
		// inserte el nick
		NCRoomMessage message = (NCRoomMessage) NCMessage.makeRoomMessage(NCMessage.OP_NICK, nick);
		// Obtenemos el mensaje de texto listo para enviar
		String rawMessage = message.toEncodedString();
		// Escribimos el mensaje en el flujo de salida, es decir, provocamos que se
		// envíe por la conexión TCP
		dos.writeUTF(rawMessage);
		// TODO Leemos el mensaje recibido como respuesta por el flujo de entrada
		NCMessage returnMessage = NCMessage.readMessageFromSocket(dis);
		// TODO Analizamos el mensaje para saber si está duplicado el nick (modificar el
		// return en consecuencia)
		return returnMessage.getOpcode() == NCMessage.OP_NICK_OK;
	}

	// Método para obtener la lista de salas del servidor
	public ArrayList<NCRoomDescription> getRooms() throws IOException {
		// Funcionamiento resumido: SND(GET_ROOMS) and RCV(ROOM_LIST)
		// TODO completar el método
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		dos.writeUTF(((NCControlMessage) NCMessage.makeControlMessage(NCMessage.OP_ROOM_LIST)).toEncodedString());
		NCMessage message = NCMessage.readMessageFromSocket(dis);
		return ((NCVarMessage) message).getSalas();
	}

	// Método para solicitar la entrada en una sala
	public boolean enterRoom(String room) throws IOException {
		// Funcionamiento resumido: SND(ENTER_ROOM<room>) and RCV(IN_ROOM) or
		// RCV(REJECT)
		// TODO completar el método
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_ENTER, room).toEncodedString());
		return NCMessage.readMessageFromSocket(dis).getOpcode() == NCMessage.OP_ENTER_OK;
	}

	// Método para salir de una sala
	public void leaveRoom(String room) throws IOException {
		// Funcionamiento resumido: SND(EXIT_ROOM)
		// TODO completar el método
		dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_EXIT).toEncodedString());
	}

	// Método que utiliza el Shell para ver si hay datos en el flujo de entrada
	public boolean isDataAvailable() throws IOException {
		return (dis.available() != 0);
	}

	public NCMessage receiveMessage() throws IOException {
		return NCMessage.readMessageFromSocket(dis);
	}

	// IMPORTANTE!!
	// TODO Es necesario implementar métodos para recibir y enviar mensajes de chat
	// a una sala

	public boolean sendPrivateMessage(String destination, String text) throws IOException {
		dos.writeUTF(NCMessage.makeTextMessage(NCMessage.OP_SEND_PRIVATE_REQ, text, destination).toEncodedString());
		NCMessage message = null;
		while (message == null || (message.getOpcode() != NCMessage.OP_SEND_OK
				&& message.getOpcode() != NCMessage.OP_USER_NOT_FOUND)) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		return message.getOpcode() == NCMessage.OP_SEND_OK;
	}

	public void sendMessage(String text) throws IOException {
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_SEND_PUBLIC_REQ, text).toEncodedString());
	}

	// Método para crear una sala
	public boolean createRoom(String name) throws IOException {
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_CREATEROOM, name).toEncodedString());
		NCMessage message = null;
		while (message == null || (message.getOpcode() != NCMessage.OP_ROOM_OK
				&& message.getOpcode() != NCMessage.OP_ROOM_ALREADY_EXISTED)) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		return message.getOpcode() == NCMessage.OP_ROOM_OK;
	}

	// Método para obtener la información de la sala.
	public NCRoomDescription getRoomInfo() throws IOException {
		// Funcionamiento resumido: SND(GET_ROOMINFO) and RCV(ROOMINFO)
		dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_INFO).toEncodedString());
		// TODO Construimos el mensaje de solicitud de información de la sala específica
		// TODO Recibimos el mensaje de respuesta
		NCMessage message = null;
		while (message == null || message.getOpcode() != NCMessage.OP_INFO_RES) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		// TODO Devolvemos la descripción contenida en el mensaje
		return ((NCVarMessage) message).getSalas().get(0);
	}

	public boolean renameRoom(String roomName) throws IOException {
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_RENAME, roomName).toEncodedString());
		NCMessage message = null;
		while (message == null || (message.getOpcode() != NCMessage.OP_RENAME_OK
				&& message.getOpcode() != NCMessage.OP_ROOM_ALREADY_EXISTED)) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		return message.getOpcode() == NCMessage.OP_RENAME_OK;
	}

	public NCMessage promoteUser(String user) throws IOException {
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_ASCENSO, user).toEncodedString());
		NCMessage message = null;
		while (message == null || (message.getOpcode() != NCMessage.OP_ASCENSO_OK
				&& message.getOpcode() != NCMessage.OP_NOT_AN_ADMIN && message.getOpcode() != NCMessage.OP_USER_IS_ADMIN
				&& message.getOpcode() != NCMessage.OP_USER_NOT_FOUND)) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		return message;
	}

	public NCMessage expelUser(String user) throws IOException {
		dos.writeUTF(NCMessage.makeRoomMessage(NCMessage.OP_EXPEL_USER, user).toEncodedString());
		NCMessage message = null;
		while (message == null || (message.getOpcode() != NCMessage.OP_USER_EXPELLED
				&& message.getOpcode() != NCMessage.OP_NOT_AN_ADMIN && message.getOpcode() != NCMessage.OP_USER_IS_ADMIN
				&& message.getOpcode() != NCMessage.OP_USER_NOT_FOUND)) {
			if (message != null)
				cola.add(message);
			message = receiveMessage();
		}
		return message;
	}

	// Método para cerrar la comunicación con la sala
	// TODO (Opcional) Enviar un mensaje de salida del servidor de Chat
	public void disconnect() {
		try {
			if (socket != null) {
				socket.close();
			}
		} catch (IOException e) {
		} finally {
			socket = null;
		}
	}

}
