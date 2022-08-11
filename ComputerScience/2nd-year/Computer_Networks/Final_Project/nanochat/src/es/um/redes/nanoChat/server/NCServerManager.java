package es.um.redes.nanoChat.server;

import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;
import es.um.redes.nanoChat.server.roomManager.NCRoomManager;
import es.um.redes.nanoChat.server.roomManager.NCRoomManagerU;

/**
 * Esta clase contiene el estado general del servidor (sin la lógica relacionada
 * con cada sala particular)
 */
class NCServerManager {

	// Primera habitación del servidor
	final static byte INITIAL_ROOM = 'A';
	// Siguiente habitación que se creará
	byte nextRoom;
	// Usuarios registrados en el servidor
	private HashSet<String> users = new HashSet<String>();
	// Habitaciones actuales asociadas a sus correspondientes RoomManagers
	private HashMap<String, NCRoomManager> rooms = new HashMap<String, NCRoomManager>();

	NCServerManager() {
		nextRoom = INITIAL_ROOM;
		registerRoomManager(new NCRoomManagerU("Initial"));
	}

	// Método para registrar un RoomManager
	public boolean registerRoomManager(NCRoomManager rm) {
		// TODO Dar soporte para que pueda haber más de una sala en el servidor
		String roomName = rm.getDescription().getRoomName();
		return rooms.putIfAbsent(roomName, rm) == null;
	}

	// Devuelve la descripción de las salas existentes
	public synchronized ArrayList<NCRoomDescription> getRoomList() {
		ArrayList<NCRoomDescription> auxiliar = new ArrayList<NCRoomDescription>();
		// TODO Pregunta a cada RoomManager cuál es la descripción actual de su sala
		for (String string : rooms.keySet()) {
			// TODO Añade la información al ArrayList
			auxiliar.add(rooms.get(string).getDescription());
		}
		return auxiliar;
	}

	// Intenta registrar al usuario en el servidor.
	public synchronized boolean addUser(String user) {
		// TODO Devuelve true si no hay otro usuario con su nombre
		// TODO Devuelve false si ya hay un usuario con su nombre
		return users.add(user);
	}

	// Elimina al usuario del servidor
	public synchronized void removeUser(String user) {
		// TODO Elimina al usuario del servidor
		users.remove(user);
	}

	// Un usuario solicita acceso para entrar a una sala y registrar su conexión en
	// ella
	public synchronized NCRoomManager enterRoom(String u, String room, Socket s) {
		// TODO Verificamos si la sala existe
		if (!rooms.containsKey(room)) {
			// TODO Decidimos qué hacer si la sala no existe (devolver error O crear la
			// sala)
			return null;
		}
		// TODO Si la sala existe y si es aceptado en la sala entonces devolvemos el
		// RoomManager de la sala
		else {
			NCRoomManager aux = rooms.get(room);
			aux.registerUser(u, s);
			return aux;
		}
	}

	// Un usuario deja la sala en la que estaba
	public synchronized void leaveRoom(String u, String room) {
		// TODO Verificamos si la sala existe
		if (rooms.containsKey(room)) {
			// TODO Si la sala existe sacamos al usuario de la sala
			rooms.get(room).removeUser(u);

		}
		// TODO Decidir qué hacer si la sala se queda vacía
	}

	public synchronized boolean renameRoom(String previousName, String newName) {
		boolean aux = rooms.putIfAbsent(newName, rooms.get(previousName)) == null;
		if(aux) {
			rooms.remove(previousName);
			rooms.get(newName).setRoomName(newName);
			return true;
		}
		return false;
	}
}
