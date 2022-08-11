package es.um.redes.nanoChat.server.roomManager;

import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;

import es.um.redes.nanoChat.auxiliarClass.Member;
import es.um.redes.nanoChat.auxiliarClass.Pair;
import es.um.redes.nanoChat.messageFV.NCMessage;

public class NCRoomManagerU extends NCRoomManager {
	private HashMap<String, Pair<Boolean, Socket>> mapa;
	private long timeLastMessage;

	public NCRoomManagerU(String name) {
		roomName = name;
		timeLastMessage = 0;
		mapa = new HashMap<String, Pair<Boolean, Socket>>();
	}

	@Override
	public synchronized  void registerUser(String u, Socket s) {
		try {
			broadcastGeneralMessage(NCMessage.makeRoomMessage(NCMessage.OP_USER_ENTERED, u));
		} catch (IOException e) {
			e.printStackTrace();
		}
		mapa.put(u, new Pair<Boolean, Socket>(usersInRoom() == 0, s));
	}

	@Override
	public synchronized void broadcastMessage(String u, String message) throws IOException {
		// TODO Auto-generated method stub
		timeLastMessage = (new java.util.Date()).getTime();
		broadcastGeneralMessage(NCMessage.makeTextMessage(NCMessage.OP_SEND_PUBLIC_RES, message, u));
	}

	/*
	 * Método para enviar mensajes a un único usuario. (Mejora 4)
	 */
	public synchronized boolean privateMessage(String u, String destination, String message) throws IOException {
		if (!mapa.containsKey(destination))
			return false;
		else {
			DataOutputStream dos = new DataOutputStream(mapa.get(destination).getSecond().getOutputStream());
			dos.writeUTF(NCMessage.makeTextMessage(NCMessage.OP_SEND_PRIVATE_RES, message, u).toEncodedString());
			return true;
		}
	}

	@Override
	public synchronized void removeUser(String u) {
		if (mapa.containsKey(u)) {
			mapa.remove(u);
			try {
				broadcastGeneralMessage(NCMessage.makeRoomMessage(NCMessage.OP_USER_LEFT, u));
			} catch (IOException e) {
				e.printStackTrace();
			}
			// if there are no admins left in the room, and it is not empty, someone becomes
			// an admin
			boolean aux = true;
			for (String member : mapa.keySet())
				if (mapa.get(member).getFirst())
					aux = false;
			if (aux && mapa.size() > 0) {
				String primero = mapa.keySet().iterator().next();
				mapa.get(primero).setFirst(true);
			}
		}
	}

	@Override
	public synchronized void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	@Override
	public synchronized NCRoomDescription getDescription() {
		ArrayList<Member> members = new ArrayList<Member>();
		for (String user : mapa.keySet())
			members.add(new Member(user, mapa.get(user).getFirst()));
		return new NCRoomDescription(roomName, members, timeLastMessage);
	}

	@Override
	public synchronized int usersInRoom() {
		return mapa.size();
	}

	public synchronized byte promoteUser(String user, String newAdmin) throws IOException {
		if (!mapa.get(user).getFirst())
			return NCMessage.OP_NOT_AN_ADMIN;
		if (mapa.get(newAdmin) == null)
			return NCMessage.OP_USER_NOT_FOUND;
		if (mapa.get(newAdmin).getFirst())
			return NCMessage.OP_USER_IS_ADMIN;
		mapa.get(newAdmin).setFirst(true);
		broadcastGeneralMessage(NCMessage.makeRoomMessage(NCMessage.OP_ASCENDIDO, newAdmin));
		return NCMessage.OP_ASCENSO_OK;
	}

	public synchronized byte expelUser(String user, String toRemove) throws IOException {
		if (!mapa.get(user).getFirst())
			return NCMessage.OP_NOT_AN_ADMIN;
		if (mapa.get(toRemove) == null)
			return NCMessage.OP_USER_NOT_FOUND;
		if (mapa.get(toRemove).getFirst())
			return NCMessage.OP_USER_IS_ADMIN;
		Socket aux = mapa.get(toRemove).getSecond();
		removeUser(toRemove);
		DataOutputStream dos = new DataOutputStream(aux.getOutputStream());
		dos.writeUTF(NCMessage.makeControlMessage(NCMessage.OP_KICKED).toEncodedString());
		return NCMessage.OP_USER_EXPELLED;
	}

	public synchronized boolean isUserInRoom(String user) {
		return mapa.containsKey(user);
	}

	private synchronized void broadcastGeneralMessage(NCMessage message) throws IOException {
		for (Pair<Boolean, Socket> pbs : mapa.values()) {
			DataOutputStream dos = new DataOutputStream(pbs.getSecond().getOutputStream());
			dos.writeUTF(message.toEncodedString());
		}
	}
}
