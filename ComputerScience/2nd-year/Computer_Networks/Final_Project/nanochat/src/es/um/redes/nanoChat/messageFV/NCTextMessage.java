package es.um.redes.nanoChat.messageFV;

public class NCTextMessage extends NCMessage{
	private final static String TEXT_FIELD = "text";
	private final static String USER_FIELD ="user";

	private String text;
	private String user;
	
	
	public String getText() {
		return text;
	}


	public String getUser() {
		return user;
	}


	public NCTextMessage(byte code, String text, String user) {
		this.opcode = code;
		this.text = text;
		this.user = user;
	}


	@Override
	public String toEncodedString() {
		StringBuffer sb = new StringBuffer();			
		sb.append(OPCODE_FIELD+DELIMITER+opcodeToOperation(opcode)+END_LINE); //Construimos el campo
		sb.append(TEXT_FIELD+DELIMITER+text+END_LINE); //Construimos el campo
		sb.append(USER_FIELD+DELIMITER+user+END_LINE); //Construimos el campo
		sb.append(END_LINE);  //Marcamos el final del mensaje
		return sb.toString(); //Se obtiene el mensaje
	}
	
	public static NCTextMessage readFromString(byte code, String message) {
		String[] lines = message.split(System.getProperty("line.separator"));
		int index = lines[1].indexOf(DELIMITER);
		String text = lines[1].substring(index+1);
		index = lines[2].indexOf(DELIMITER);
		String user = lines[2].substring(index+1);		
		return new NCTextMessage(code, text, user);
	}
	
	public String toPrintableString() {
		return user + ": " + text;
	}
}
