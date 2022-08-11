import java.io.IOException;
import java.net.InetSocketAddress;

import es.um.redes.nanoChat.directory.connector.DirectoryConnector;

public class Tester {
	
	private static final int CHAT_PORT = 6969;
	private static final byte MY_PROTOCOL = 42;
	
	public static void main(String[] args) throws IOException {
		
		// TODO Auto-generated method stub
		DirectoryConnector dc = new DirectoryConnector("localhost");
		dc.registerServerForProtocol(MY_PROTOCOL, CHAT_PORT);
		InetSocketAddress addr = dc.getServerForProtocol(MY_PROTOCOL);
		if(addr == null)
			System.out.println("Servidor no encontrado");
		else
			System.out.println("Obtenido el servidor " + addr);
	}

}
