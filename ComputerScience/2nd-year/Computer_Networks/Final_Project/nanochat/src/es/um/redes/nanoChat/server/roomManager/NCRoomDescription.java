package es.um.redes.nanoChat.server.roomManager;

import java.io.DataInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import es.um.redes.nanoChat.auxiliarClass.Member;

public class NCRoomDescription {
	//Campos de los que, al menos, se compone una descripción de una sala 
	private String roomName;
	private ArrayList<Member> members;
	private long timeLastMessage;
	
	//Constructor a partir de los valores para los campos
	public NCRoomDescription(String roomName, ArrayList<Member> members, long timeLastMessage) {
		this.roomName = roomName;
		this.members = members;
		this.timeLastMessage = timeLastMessage;
	}
	public String getRoomName() {
		return roomName;
	}
	public ArrayList<Member> getMembers() {
		return members;
	}
	public long getTimeLastMessage() {
		return timeLastMessage;
	}
	//Método que devuelve una representación de la Descripción lista para ser impresa por pantalla
	public String toPrintableString() {
		StringBuffer sb = new StringBuffer();
		sb.append("Room Name: "+roomName+"\t Members ("+members.size()+ ") : ");
		for (Member member: members) {
			sb.append(member.toString()+"; ");
		}
		if (timeLastMessage != 0)
			sb.append("\tLast message: "+new Date(timeLastMessage).toString());
		else 
			sb.append("\tLast message: not yet");
		return sb.toString();
	}
}
