package es.um.redes.nanoChat.messageFV;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;

import es.um.redes.nanoChat.auxiliarClass.Message;
import es.um.redes.nanoChat.server.roomManager.NCRoomDescription;


public abstract class NCMessage {
	protected byte opcode;
	//TODO Implementar el resto de los opcodes para los distintos mensajes
	public static final byte OP_INVALID_CODE = 0;
	
	public static final byte OP_NICK = 1;
	public static final byte OP_NICK_OK = 2;
	public static final byte OP_NICK_DUP = 3;

	public static final byte OP_ASCENDIDO = 4;
	public static final byte OP_ASCENSO = 5;
	public static final byte OP_ASCENSO_OK = 29;
	public static final byte OP_EXPEL_USER = 6;
	public static final byte OP_CREATEROOM = 7;
	
	public static final byte OP_ROOM_LIST = 8;
	public static final byte OP_ROOM_LIST_RES = 9;
	
	public static final byte OP_ENTER = 10;
	public static final byte OP_ENTER_OK = 11;
	public static final byte OP_ENTER_NO = 12;
	
	public static final byte OP_EXIT = 13;
	
	public static final byte OP_RENAME = 14;
	public static final byte OP_RENAME_OK = 15;
	
	public static final byte OP_NOT_AN_ADMIN = 16;
	public static final byte OP_USER_NOT_FOUND= 17;
	public static final byte OP_USER_EXPELLED= 18;
	public static final byte OP_USER_IS_ADMIN = 19;
	
	public static final byte OP_ROOM_OK = 20;
	public static final byte OP_ROOM_ALREADY_EXISTED = 21;
	
	public static final byte OP_INFO = 22;
	public static final byte OP_INFO_RES = 23;
	
	public static final byte OP_SEND_PRIVATE_REQ = 24;
	public static final byte OP_SEND_OK = 25;
	public static final byte OP_SEND_PRIVATE_RES = 26;
	
	public static final byte OP_SEND_PUBLIC_REQ = 27;
	public static final byte OP_SEND_PUBLIC_RES = 28;
	
	public static final byte OP_USER_LEFT = 30;
	public static final byte OP_USER_ENTERED = 31;
	
	public static final byte OP_KICKED = 32;




	//Constantes con los delimitadores de los mensajes de field:value
	public static final char DELIMITER = ':';    //Define el delimitador
	public static final String SEPARATOR =",";
	public static final char END_LINE = '\n';    //Define el carácter de fin de línea
	
	public static final String OPCODE_FIELD = "operation";

	/**
	 * Códigos de los opcodes válidos  El orden
	 * es importante para relacionarlos con la cadena
	 * que aparece en los mensajes
	 */
	private static final Byte[] _valid_opcodes = { 
		OP_NICK, OP_ENTER, OP_ASCENSO, OP_EXPEL_USER, OP_CREATEROOM,
		OP_NICK_OK, OP_NICK_DUP, OP_ROOM_LIST, OP_ENTER_OK, OP_ENTER_NO, OP_EXIT,
		OP_SEND_OK, OP_INFO, OP_RENAME_OK, OP_NOT_AN_ADMIN, OP_ASCENDIDO,
		OP_USER_NOT_FOUND, OP_USER_EXPELLED, OP_USER_IS_ADMIN, OP_ROOM_OK,
		OP_ROOM_ALREADY_EXISTED, OP_ROOM_LIST_RES, OP_INFO_RES, OP_SEND_PRIVATE_REQ, OP_SEND_PUBLIC_RES,
		OP_SEND_PUBLIC_REQ, OP_SEND_PRIVATE_RES, OP_RENAME, OP_ASCENSO_OK, OP_USER_LEFT, OP_USER_ENTERED,
		OP_KICKED
		};

	/**
	 * cadena exacta de cada orden
	 */
	private static final String[] _valid_operations = {
		"Nick", "Enter", "Ascenso", "ExpelUser", "CreateRoom", "NickOK", "NickDup",
		"RoomList", "EnterOK", "EnterNO", "Exit", "SendOK", "Info", "RenameOK", 
		"NotAnAdmin", "Ascendido", "UserNotFound", "UserExpelOk", "UserIsAdmin", "RoomOK", "RoomAlreadyExisted",
		"RoomListRes", "InfoRes", "SendPrivateReq", "SendPublicRes", "SendPublicReq", "SendPrivateRes", "Rename",
		"AscensoOK", "UserLeft", "UserEntered", "Kicked"
		};

	/**
	 * Transforma una cadena en el opcode correspondiente
	 */
	protected static byte operationToOpcode(String opStr) {
		//Busca entre los opcodes si es válido y devuelve su código
		for (int i = 0;	i < _valid_operations.length; i++) {
			if (_valid_operations[i].equalsIgnoreCase(opStr)) {
				return _valid_opcodes[i];
			}
		}
		//Si no se corresponde con ninguna cadena entonces devuelve el código de código no válido
		return OP_INVALID_CODE;
	}

	/**
	 * Transforma un opcode en la cadena correspondiente
	 */
	protected static String opcodeToOperation(byte opcode) {
		//Busca entre los opcodes si es válido y devuelve su cadena
		for (int i = 0;	i < _valid_opcodes.length; i++) {
			if (_valid_opcodes[i] == opcode) {
				return _valid_operations[i];
			}
		}
		//Si no se corresponde con ningún opcode entonces devuelve null
		return null;
	}
	
	
	
	//Devuelve el opcode del mensaje
	public byte getOpcode() {
		return opcode;
	}

	//Método que debe ser implementado específicamente por cada subclase de NCMessage
	public abstract String toEncodedString();

	//Extrae la operación del mensaje entrante y usa la subclase para parsear el resto del mensaje
	public static NCMessage readMessageFromSocket(DataInputStream dis) throws IOException {
		String message = dis.readUTF();
		String[] lines = message.split(System.getProperty("line.separator"));
		if (!lines[0].equals("")) { // Si la línea no está vacía
			int idx = lines[0].indexOf(DELIMITER); // Posición del delimitador
			String field = lines[0].substring(0, idx).toLowerCase(); // minúsculas
			String value = lines[0].substring(idx + 1).trim();
			if (!field.equalsIgnoreCase(OPCODE_FIELD)) return null;
			byte code = operationToOpcode(value);
			if (code == OP_INVALID_CODE) return null;
			switch (code) {
			case OP_NICK:
			case OP_ENTER:
			case OP_ASCENSO:
			case OP_EXPEL_USER:
			case OP_CREATEROOM:
			case OP_RENAME:
			case OP_SEND_PUBLIC_REQ:
			case OP_ASCENDIDO:
			case OP_USER_LEFT:
			case OP_USER_ENTERED:
			{
				return NCRoomMessage.readFromString(code, message);
			}
			case OP_NICK_OK:
			case OP_NICK_DUP:
			case OP_ROOM_LIST:
			case OP_ENTER_OK:
			case OP_ENTER_NO:
			case OP_EXIT:
			case OP_SEND_OK:
			case OP_INFO:
			case OP_RENAME_OK:
			case OP_NOT_AN_ADMIN:
			case OP_USER_IS_ADMIN:
			case OP_USER_NOT_FOUND:
			case OP_ROOM_OK:
			case OP_ROOM_ALREADY_EXISTED:
			case OP_ASCENSO_OK:
			case OP_USER_EXPELLED:
			case OP_KICKED:
			{
				return NCControlMessage.readFromString(code, message);
			}
			case OP_ROOM_LIST_RES:
			case OP_INFO_RES:
			{
				return NCVarMessage.readFromString(code, message);
			}
			case OP_SEND_PRIVATE_REQ:
			case OP_SEND_PUBLIC_RES:
			case OP_SEND_PRIVATE_RES:
				return NCTextMessage.readFromString(code, message);
			default:
				System.err.println("Unknown message type received:" + code);
				return null;
			}
		} else
			return null;
	}

	//Método para construir un mensaje de tipo Room a partir del opcode y del nombre
	public static NCMessage makeRoomMessage(byte code, String name) {
		return new NCRoomMessage(code, name);
	}
	public static NCMessage makeControlMessage(byte code) {
		return new NCControlMessage(code);
	}
	public static NCMessage makeVarMessage(byte code, ArrayList<NCRoomDescription> salas) {
		return new NCVarMessage(code, salas);
	}
	public static NCMessage makeTextMessage(byte code, String text, String user) {
		return new NCTextMessage(code, text, user);
	}
}
