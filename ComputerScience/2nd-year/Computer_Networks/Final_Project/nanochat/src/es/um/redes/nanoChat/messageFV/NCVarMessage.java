package es.um.redes.nanoChat.messageFV;

import java.util.ArrayList;

import es.um.redes.nanoChat.auxiliarClass.Member;
import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;

public class NCVarMessage extends NCMessage {
	private ArrayList<NCRoomDescription> salas;
	
	private final static String INFO_FIELD = "info";
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public ArrayList<NCRoomDescription> getSalas() {
		return salas;
	}
	public NCVarMessage(byte code, ArrayList<NCRoomDescription> salas) {
		this.opcode = code;
		this.salas = salas;
	}
	@Override
	public String toEncodedString() {
		StringBuffer sb = new StringBuffer();
		sb.append(OPCODE_FIELD+DELIMITER+opcodeToOperation(opcode)+END_LINE); //Construimos el campo
		for (NCRoomDescription ncRoomDescription : salas) {
			sb.append(INFO_FIELD+DELIMITER+ ncRoomDescription.getRoomName()+SEPARATOR + ncRoomDescription.getTimeLastMessage());
			for(Member member : ncRoomDescription.getMembers()) {
				sb.append(SEPARATOR + member.getName() + SEPARATOR  + member.isAdmin());
			}
			sb.append(END_LINE);
		}
		sb.append(END_LINE);
		return sb.toString();
	}
	
	public static NCVarMessage readFromString(byte code, String message) {
		ArrayList<NCRoomDescription> salas = new ArrayList<NCRoomDescription>();
		String[] infos = message.split(System.getProperty("line.separator"));
		for (int i=1; i<infos.length; i++) {
			int index = infos[i].indexOf(DELIMITER);
			String[] auxiliar = infos[i].substring(index+1).split(SEPARATOR);
			ArrayList<Member> members = new ArrayList<Member>();
			for(int j=2; j<auxiliar.length; j+=2) {
				members.add(new Member(auxiliar[j], auxiliar[j+1].equals("true")));
			}
			salas.add(new NCRoomDescription(auxiliar[0], members, Long.parseLong(auxiliar[1])));
		}
		return new NCVarMessage(code, salas);
	}
}
