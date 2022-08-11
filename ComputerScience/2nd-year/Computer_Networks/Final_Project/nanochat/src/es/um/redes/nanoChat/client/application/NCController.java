package es.um.redes.nanoChat.client.application;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.ArrayList;
import java.util.Iterator;

import es.um.redes.nanoChat.client.comm.NCConnector;
import es.um.redes.nanoChat.client.shell.NCCommands;
import es.um.redes.nanoChat.client.shell.NCShell;
import es.um.redes.nanoChat.directory.connector.DirectoryConnector;
import es.um.redes.nanoChat.messageFV.NCMessage;
import es.um.redes.nanoChat.messageFV.NCRoomMessage;
import es.um.redes.nanoChat.messageFV.NCTextMessage;
import es.um.redes.nanoChat.messageFV.NCVarMessage;
import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;

public class NCController {
	// Diferentes estados del cliente de acuerdo con el autómata
	private static final byte PRE_CONNECTION = 1;
	private static final byte PRE_REGISTRATION = 2;
	private static final byte CONNECTED = 3;
	private static final byte ROOMED = 4;
	// Código de protocolo implementado por este cliente
	// TODO Cambiar para cada grupo
	private static final byte PROTOCOL = 69;
	// Conector para enviar y recibir mensajes del directorio
	private DirectoryConnector directoryConnector;
	// Conector para enviar y recibir mensajes con el servidor de NanoChat
	private NCConnector ncConnector;
	// Shell para leer comandos de usuario de la entrada estándar
	private NCShell shell;
	// Último comando proporcionado por el usuario
	private byte currentCommand;
	// Nick del usuario
	private String nickname;
	// Sala de chat en la que se encuentra el usuario (si está en alguna)
	private String room;
	// Mensaje enviado o por enviar al chat
	private String chatMessage;
	// Variable para guardar el parámetro de algunos comandos
	private String variableAuxiliar;
	// Dirección de internet del servidor de NanoChat
	private InetSocketAddress serverAddress;
	// Estado actual del cliente, de acuerdo con el autómata
	private byte clientStatus = PRE_CONNECTION;

	// Constructor
	public NCController() {
		shell = new NCShell();
	}

	// Devuelve el comando actual introducido por el usuario
	public byte getCurrentCommand() {
		return this.currentCommand;
	}

	// Establece el comando actual
	public void setCurrentCommand(byte command) {
		currentCommand = command;
	}

	// Registra en atributos internos los posibles parámetros del comando tecleado
	// por el usuario
	public void setCurrentCommandArguments(String[] args) {
		// Comprobaremos también si el comando es válido para el estado actual del
		// autómata
		switch (currentCommand) {
		case NCCommands.COM_NICK:
			if (clientStatus == PRE_REGISTRATION)
				nickname = args[0];
			break;
		case NCCommands.COM_ENTER:
			if (clientStatus == CONNECTED)
				room = args[0];
			break;
		case NCCommands.COM_CREATE_ROOM:
			if (clientStatus == CONNECTED)
				variableAuxiliar = args[0];
			break;
		case NCCommands.COM_SEND:
			if (clientStatus == ROOMED) {
				chatMessage = args[0];
			}
			break;
		case NCCommands.COM_RENAME:
		case NCCommands.COM_ASCENDER:
		case NCCommands.COM_EXPEL:
			if (clientStatus == ROOMED)
				variableAuxiliar = args[0];
			break;
		case NCCommands.COM_PRIVATE_SEND:
			if (clientStatus == ROOMED) {
				variableAuxiliar = args[0];
				chatMessage = args[1];
			}
			break;
		default:
		}
	}

	// Procesa los comandos introducidos por un usuario que aún no está dentro de
	// una sala
	public void processCommand() throws IOException {
		switch (currentCommand) {
		case NCCommands.COM_NICK:
			if (nickname.contains(",")) {
				System.out.println("Invalid nick, username cannot contain commas.");
			} else if (clientStatus == PRE_REGISTRATION)
				registerNickName();
			else
				System.out.println("* You have already registered a nickname (" + nickname + ")");
			break;
		case NCCommands.COM_ROOMLIST:
			// TODO LLamar a getAndShowRooms() si el estado actual del autómata lo permite
			if (clientStatus == CONNECTED)
				getAndShowRooms();
			// TODO Si no está permitido informar al usuario
			else
				System.out.println("Please, register a nickname first");
			break;
		case NCCommands.COM_ENTER:
			// TODO LLamar a enterChat() si el estado actual del autómata lo permite
			if (clientStatus == CONNECTED) {
				enterChat();
			} else {
				// TODO Si no está permitido informar al usuario
				System.out.println("Please, register a nickname first");
			}
			break;
		case NCCommands.COM_QUIT:
			// Cuando salimos tenemos que cerrar todas las conexiones y sockets abiertos
			ncConnector.disconnect();
			directoryConnector.close();
			break;
		case NCCommands.COM_CREATE_ROOM:
			if (clientStatus == CONNECTED) {
				createRoom();
			} else {
				// TODO Si no está permitido informar al usuario
				System.out.println("Please, register a nickname first");
			}
			break;
		default:
		}
	}

	// Método para registrar el nick del usuario en el servidor de NanoChat
	private void registerNickName() {
		try {
			// Pedimos que se registre el nick (se comprobará si está duplicado)
			boolean registered = ncConnector.registerNickname(nickname);
			// TODO: Cambiar la llamada anterior a registerNickname() al usar mensajes
			// formateados
			if (registered) {
				// TODO Si el registro fue exitoso pasamos al siguiente estado del autómata
				System.out.println("* Your nickname is now " + nickname);
				clientStatus = CONNECTED;
			} else
				// En este caso el nick ya existía
				System.out.println("* The nickname is already registered. Try a different one.");
		} catch (IOException e) {
			System.out.println("* There was an error registering the nickname");
		}
	}

	// Método que solicita al servidor de NanoChat la lista de salas e imprime el
	// resultado obtenido
	private void getAndShowRooms() {
		// TODO Lista que contendrá las descripciones de las salas existentes
		ArrayList<NCRoomDescription> salas = new ArrayList<NCRoomDescription>();
		// TODO Le pedimos al conector que obtenga la lista de salas
		// ncConnector.getRooms()
		try {
			salas = ncConnector.getRooms();
		} catch (IOException e) {
			e.printStackTrace();
		}
		// TODO Una vez recibidas iteramos sobre la lista para imprimir información de
		// cada sala
		for (NCRoomDescription ncRoomDescription : salas) {
			System.out.println(ncRoomDescription.toPrintableString());
		}
	}

	// Método para tramitar la solicitud de acceso del usuario a una sala concreta
	private void enterChat() throws IOException {
		boolean aux = false;
		// TODO Se solicita al servidor la entrada en la sala correspondiente
		// ncConnector.enterRoom()
		aux = ncConnector.enterRoom(room);
		// TODO Si la respuesta es un rechazo entonces informamos al usuario y salimos
		if (!aux) {
			System.out.println("The room does not exist");
		}
		// TODO En caso contrario informamos que estamos dentro y seguimos
		else {
			System.out.println("Access granted");
			// TODO Cambiamos el estado del autómata para aceptar nuevos comandos
			clientStatus = ROOMED;
			do {
				// Pasamos a aceptar sólo los comandos que son válidos dentro de una sala
				readRoomCommandFromShell();
				processRoomCommand();
			} while (clientStatus == ROOMED);
			System.out.println("* Your are out of the room");
			// TODO Llegados a este punto el usuario ha querido salir de la sala, cambiamos
			// el estado del autómata ??????????????????
		}
	}

	// Método para procesar los comandos específicos de una sala
	private void processRoomCommand() throws IOException {
		switch (currentCommand) {
		case NCCommands.COM_ROOMINFO:
			// El usuario ha solicitado información sobre la sala y llamamos al método que
			// la obtendrá
			getAndShowInfo();
			break;
		case NCCommands.COM_SEND:
			// El usuario quiere enviar un mensaje al chat de la sala
			sendChatMessage();
			break;
		case NCCommands.COM_PRIVATE_SEND:
			sendPrivateMessage();
			break;
		case NCCommands.COM_SOCKET_IN:
			// En este caso lo que ha sucedido es que hemos recibido un mensaje desde la
			// sala y hay que procesarlo
			processIncommingMessage();
			break;
		case NCCommands.COM_RENAME:
			renameRoom(variableAuxiliar);
			break;
		case NCCommands.COM_EXIT:
			// El usuario quiere salir de la sala
			exitTheRoom();
			break;
		case NCCommands.COM_ASCENDER:
			promoteUser();
			break;
		case NCCommands.COM_EXPEL:
			expelUser();
			break;
		}
		Iterator<NCMessage> it = ncConnector.getCola().iterator();
		while (it.hasNext()) {
			processMessage(it.next());
			it.remove();
		}
	}

	// Método para solicitar al servidor la información sobre una sala y para
	// mostrarla por pantalla
	private void getAndShowInfo() throws IOException {
		// TODO Pedimos al servidor información sobre la sala en concreto
		// TODO Mostramos por pantalla la información
		System.out.println(ncConnector.getRoomInfo().toPrintableString());
	}

	// Método para notificar al servidor que salimos de la sala
	private void exitTheRoom() {
		// TODO Mandamos al servidor el mensaje de salida
		try {
			ncConnector.leaveRoom(room);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// TODO Cambiamos el estado del autómata para indicar que estamos fuera de la
		// sala
		clientStatus = CONNECTED;
	}

	// Método para enviar un mensaje al chat de la sala
	private void sendChatMessage() throws IOException {
		// TODO Mandamos al servidor un mensaje de chat
		ncConnector.sendMessage(chatMessage);
	}

	private void sendPrivateMessage() throws IOException {
		if (variableAuxiliar.equals(nickname))
			System.out.println("You cannot send a message to yourself, get some friends");
		else if (!ncConnector.sendPrivateMessage(variableAuxiliar, chatMessage)) {
			System.out.println("The user does not exist.");
		}
	}

	private void createRoom() throws IOException {
		if (ncConnector.createRoom(variableAuxiliar)) {
			System.out.println("The room was successfully created");
		} else {
			System.out.println("A room with this name already existed");
		}
	}

	private void renameRoom(String roomName) throws IOException {
		if (!ncConnector.renameRoom(roomName))
			System.out.println("A room with this name already existed");
		else
			System.out.println("The room was successfully renamed");
	}

	// Método para procesar los mensajes recibidos del servidor mientras que el
	// shell estaba esperando un comando de usuario
	private void processIncommingMessage() throws IOException {
		// TODO Recibir el mensaje
		NCMessage message = ncConnector.receiveMessage();
		// TODO En función del tipo de mensaje, actuar en consecuencia
		// TODO (Ejemplo) En el caso de que fuera un mensaje de chat de broadcast
		// mostramos la información de quién envía el mensaje y el mensaje en sí
		processMessage(message);

	}

	private void promoteUser() throws IOException {
		NCMessage message = ncConnector.promoteUser(variableAuxiliar);
		switch (message.getOpcode()) {
		case NCMessage.OP_ASCENSO_OK:
			break;
		case NCMessage.OP_NOT_AN_ADMIN:
			System.out.println("You are not an admin, you are a loser");
			break;
		case NCMessage.OP_USER_IS_ADMIN:
			System.out.println("The user was already an admin");
			break;
		case NCMessage.OP_USER_NOT_FOUND:
			System.out.println("The user does not exist");
			break;
		}
	}

	private void expelUser() throws IOException {
		NCMessage message = ncConnector.expelUser(variableAuxiliar);
		switch (message.getOpcode()) {
		case NCMessage.OP_USER_EXPELLED:
			break;
		case NCMessage.OP_NOT_AN_ADMIN:
			System.out.println("You are not an admin, you are a loser");
			break;
		case NCMessage.OP_USER_IS_ADMIN:
			System.out.println("The user is an admin");
			break;
		case NCMessage.OP_USER_NOT_FOUND:
			System.out.println("The user does not exist");
			break;
		}
	}

	private void processMessage(NCMessage message) {
		String aux = null;
		switch (message.getOpcode()) {
		case NCMessage.OP_SEND_PUBLIC_RES:
			System.out.println(((NCTextMessage) message).toPrintableString());
			break;
		case NCMessage.OP_SEND_PRIVATE_RES:
			System.out.println("private message from " + ((NCTextMessage) message).toPrintableString());
			break;
		case NCMessage.OP_ASCENDIDO:
			aux = ((NCRoomMessage) message).getName();
			if (aux.equals(nickname))
				System.out.println("You have been promoted to admin");
			else
				System.out.println("The user " + aux + " has been promoted to admin");
			break;
		case NCMessage.OP_USER_LEFT:
			aux = ((NCRoomMessage) message).getName();
			System.out.println("The user " + aux + " has left the room");
			break;
		case NCMessage.OP_USER_ENTERED:
			aux = ((NCRoomMessage) message).getName();
			if (!aux.equals(nickname))
				System.out.println("The user " + aux + " has entered the room");
			break;
		case NCMessage.OP_KICKED:
			System.out.println("You have been expelled");
			clientStatus = CONNECTED;
			break;
		}
	}

	// MNétodo para leer un comando de la sala
	public void readRoomCommandFromShell() {
		// Pedimos un nuevo comando de sala al shell (pasando el conector por si nos
		// llega un mensaje entrante)
		shell.readChatCommand(ncConnector);
		// Establecemos el comando tecleado (o el mensaje recibido) como comando actual
		setCurrentCommand(shell.getCommand());
		// Procesamos los posibles parámetros (si los hubiera)
		setCurrentCommandArguments(shell.getCommandArguments());
	}

	// Método para leer un comando general (fuera de una sala)
	public void readGeneralCommandFromShell() {
		// Pedimos el comando al shell
		shell.readGeneralCommand();
		// Establecemos que el comando actual es el que ha obtenido el shell
		setCurrentCommand(shell.getCommand());
		// Analizamos los posibles parámetros asociados al comando
		setCurrentCommandArguments(shell.getCommandArguments());
	}

	// Método para obtener el servidor de NanoChat que nos proporcione el directorio
	public boolean getServerFromDirectory(String directoryHostname) {
		// Inicializamos el conector con el directorio y el shell
		System.out.println("* Connecting to the directory...");
		// Intentamos obtener la dirección del servidor de NanoChat que trabaja con
		// nuestro protocolo
		try {
			directoryConnector = new DirectoryConnector(directoryHostname);
			serverAddress = directoryConnector.getServerForProtocol(PROTOCOL);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			serverAddress = null;
		}
		// Si no hemos recibido la dirección entonces nos quedan menos intentos
		if (serverAddress == null) {
			System.out.println("* Check your connection, the directory is not available.");
			return false;
		} else
			return true;
	}

	// Método para establecer la conexión con el servidor de Chat (a través del
	// NCConnector)
	public boolean connectToChatServer() {
		try {
			// Inicializamos el conector para intercambiar mensajes con el servidor de
			// NanoChat (lo hace la clase NCConnector)
			ncConnector = new NCConnector(serverAddress);
		} catch (IOException e) {
			System.out.println("* Check your connection, the game server is not available.");
			serverAddress = null;
		}
		// Si la conexión se ha establecido con éxito informamos al usuario y cambiamos
		// el estado del autómata
		if (serverAddress != null) {
			System.out.println("* Connected to " + serverAddress);
			clientStatus = PRE_REGISTRATION;
			return true;
		} else
			return false;
	}

	// Método que comprueba si el usuario ha introducido el comando para salir de la
	// aplicación
	public boolean shouldQuit() {
		return currentCommand == NCCommands.COM_QUIT;
	}

}
