package es.um.redes.nanoChat.server;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

import es.um.redes.nanoChat.auxiliarClass.Member;
import es.um.redes.nanoChat.messageFV.NCControlMessage;
import es.um.redes.nanoChat.messageFV.NCMessage;
import es.um.redes.nanoChat.messageFV.NCRoomMessage;
import es.um.redes.nanoChat.messageFV.NCTextMessage;
import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;
import es.um.redes.nanoChat.server.roomManager.NCRoomManager;
import es.um.redes.nanoChat.server.roomManager.NCRoomManagerU;

/**
 * A new thread runs for each connected client
 */
public class NCServerThread extends Thread {

	private Socket socket = null;
	// Manager global compartido entre los Threads
	private NCServerManager serverManager = null;
	// Input and Output Streams
	private DataInputStream dis;
	private DataOutputStream dos;
	// Usuario actual al que atiende este Thread
	String user;
	// RoomManager actual (dependerá de la sala a la que entre el usuario)
	NCRoomManager roomManager;
	// Sala actual

	// Inicialización de la sala
	public NCServerThread(NCServerManager manager, Socket socket) throws IOException {
		super("NCServerThread");
		this.socket = socket;
		this.serverManager = manager;
	}

	// Main loop
	public void run() {
		try {
			// Se obtienen los streams a partir del Socket
			dis = new DataInputStream(socket.getInputStream());
			dos = new DataOutputStream(socket.getOutputStream());
			// En primer lugar hay que recibir y verificar el nick
			receiveAndVerifyNickname();
			// Mientras que la conexión esté activa entonces...
			while (true) {
				// TODO Obtenemos el mensaje que llega y analizamos su código de operación
				NCMessage message = NCMessage.readMessageFromSocket(dis);
				switch (message.getOpcode()) {
				// TODO 1) si se nos pide la lista de salas se envía llamando a sendRoomList();
				case NCMessage.OP_ROOM_LIST:
					sendRoomList();
					break;
				// TODO 2) Si se nos pide entrar en la sala entonces obtenemos el RoomManager de
				// la sala,
				case NCMessage.OP_ENTER:
					roomManager = serverManager.enterRoom(user, ((NCRoomMessage) message).getName(), socket);
					// TODO 2) notificamos al usuario que ha sido aceptado y procesamos mensajes con
					// processRoomMessages()
					if (roomManager != null) {
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_ENTER_OK).toEncodedString());
						// currentRoom = roomManager.getDescription().getRoomName();
						processRoomMessages();
					}
					// TODO 2) Si el usuario no es aceptado en la sala entonces se le notifica al
					// cliente
					else {
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_ENTER_NO).toEncodedString());
					}
					break;
				case NCMessage.OP_CREATEROOM:
					String name = ((NCRoomMessage) message).getName();
					dos.writeUTF(NCMessage.makeControlMessage(
							(serverManager.registerRoomManager(new NCRoomManagerU(name)) ? NCMessage.OP_ROOM_OK
									: NCMessage.OP_ROOM_ALREADY_EXISTED))
							.toEncodedString());
					break;
				}
			}
		} catch (Exception e) {
			// If an error occurs with the communications the user is removed from all the
			// managers and the connection is closed
			System.out.println("* User " + user + " disconnected.");
			if(user != null) {
				if (roomManager != null)
					serverManager.leaveRoom(user, roomManager.getDescription().getRoomName());
				serverManager.removeUser(user);
			}
		} finally {
			if (!socket.isClosed())
				try {
					socket.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
		}
	}

	// Obtenemos el nick y solicitamos al ServerManager que verifique si está
	// duplicado
	private void receiveAndVerifyNickname() throws IOException {
		// La lógica de nuestro programa nos obliga a que haya un nick registrado antes
		// de proseguir
		// TODO Entramos en un bucle hasta comprobar que alguno de los nicks
		// proporcionados no está duplicado
		String nick = null;
		while (true) {
			// TODO Extraer el nick del mensaje
			NCMessage aux = NCMessage.readMessageFromSocket(dis);
			nick = ((NCRoomMessage) aux).getName();
			// TODO Validar el nick utilizando el ServerManager - addUser()
			// TODO Contestar al cliente con el resultado (éxito o duplicado)
			if (serverManager.addUser(nick)) {
				try {
					user = nick;
					dos.writeUTF(
							((NCControlMessage) NCMessage.makeControlMessage(NCMessage.OP_NICK_OK)).toEncodedString());
				} catch (IOException e) {
					e.printStackTrace();
				}
				break;
			} else {
				try {
					dos.writeUTF(
							((NCControlMessage) NCMessage.makeControlMessage(NCMessage.OP_NICK_DUP)).toEncodedString());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	// TODO dnsjadnasuidas
	private boolean sendPrivateMessage(String u, String destination, String message) throws IOException {
		Member aux = new Member(destination, false);
		dos.writeUTF(NCMessage.makeTextMessage(NCMessage.OP_SEND_PRIVATE_RES, message, u).toEncodedString());
		return true;
	}

	// Mandamos al cliente la lista de salas existentes
	private void sendRoomList() {
		// TODO La lista de salas debe obtenerse a partir del RoomManager y después
		// enviarse mediante su mensaje correspondiente
		ArrayList<NCRoomDescription> aux = serverManager.getRoomList();
		try {
			dos.writeUTF(NCMessage.makeVarMessage(NCMessage.OP_ROOM_LIST_RES, aux).toEncodedString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void processRoomMessages() throws IOException, InterruptedException {
		// TODO Comprobamos los mensajes que llegan hasta que el usuario decida salir de
		// la sala
		boolean exit = false;
		while (!exit && ((NCRoomManagerU) roomManager).isUserInRoom(user)) {
			// TODO Se recibe el mensaje enviado por el usuario
			NCMessage message = null;
			if (dis.available() > 0) {
				message = NCMessage.readMessageFromSocket(dis);
				// TODO Se analiza el código de operación del mensaje y se trata en consecuencia
				switch (message.getOpcode()) {
				case NCMessage.OP_INFO:
					ArrayList<NCRoomDescription> aux = new ArrayList<NCRoomDescription>();
					aux.add(roomManager.getDescription());
					dos.writeUTF(NCMessage.makeVarMessage(NCMessage.OP_INFO_RES, aux).toEncodedString());
					break;
				case NCMessage.OP_EXIT:
					serverManager.leaveRoom(user, roomManager.getDescription().getRoomName());
					exit = true;
					break;
				case NCMessage.OP_SEND_PUBLIC_REQ:
					roomManager.broadcastMessage(user, ((NCRoomMessage) message).getName());
					break;
				case NCMessage.OP_RENAME:
					String lastName = roomManager.getDescription().getRoomName();
					String newName = ((NCRoomMessage) message).getName();
					if (serverManager.renameRoom(lastName, newName)) {
						roomManager.setRoomName(newName);
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_RENAME_OK).toEncodedString());
					} else {
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_ROOM_ALREADY_EXISTED).toEncodedString());
					}
					break;
				case NCMessage.OP_SEND_PRIVATE_REQ:
					if (((NCRoomManagerU) roomManager).privateMessage(user, ((NCTextMessage) message).getUser(),
							((NCTextMessage) message).getText()))
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_SEND_OK).toEncodedString());
					else
						dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_USER_NOT_FOUND).toEncodedString());
					break;
				case NCMessage.OP_ASCENSO:
					byte opcodeA = ((NCRoomManagerU) roomManager).promoteUser(user,
							((NCRoomMessage) message).getName());
					dos.writeUTF(NCMessage.makeControlMessage(opcodeA).toEncodedString());
					break;
				case NCMessage.OP_EXPEL_USER:
					byte opcodeE = ((NCRoomManagerU) roomManager).expelUser(user, ((NCRoomMessage) message).getName());
					dos.writeUTF(NCMessage.makeControlMessage(opcodeE).toEncodedString());
					break;

				}
			} else
				TimeUnit.MILLISECONDS.sleep(50);
		}
	}
}
