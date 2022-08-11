package es.um.redes.nanoChat.auxiliarClass;
/**
 * 
 * @author jose & pablo
 * Esta es una clase auxiliar que utilizamos 
 * para simplificar el envío de un mensaje
 * por parte de un usuario a una sala.
 * Un mensaje consta de:
 * String user: el usuario que envía el mensaje
 * String text: el propio mensaje
 */
public class Message {
	private final String user;
	private final String text;
	
	public String getUser() {
		return user;
	}
	public String getText() {
		return text;
	}
	public Message(String user, String text) {
		this.user = user;
		this.text = text;
	}
	
}
