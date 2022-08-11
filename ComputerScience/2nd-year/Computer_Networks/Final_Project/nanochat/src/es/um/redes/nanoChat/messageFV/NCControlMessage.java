package es.um.redes.nanoChat.messageFV;

public class NCControlMessage extends NCMessage{

	
	public NCControlMessage(byte type) {
		this.opcode = type;
	}

	//Pasamos los campos del mensaje a la codificación correcta en field:value
	@Override
	public String toEncodedString() {
		StringBuffer sb = new StringBuffer();			
		sb.append(OPCODE_FIELD+DELIMITER+opcodeToOperation(opcode)+END_LINE); //Construimos el campo
		sb.append(END_LINE);  //Marcamos el final del mensaje
		return sb.toString(); //Se obtiene el mensaje

	}


	//Parseamos el mensaje contenido en message con el fin de obtener los distintos campos
	public static NCControlMessage readFromString(byte code, String message) {
		return new NCControlMessage(code);
	}

	
}
