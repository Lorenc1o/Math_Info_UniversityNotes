package es.um.redes.nanoChat.directory.server;

import java.io.*;
import java.net.*;
import java.nio.ByteBuffer;
import java.util.HashMap;


public class DirectoryThread extends Thread {
	private static final byte REGISTRATION_CODE = 1;
	private static final byte QUERY_CODE = 2;
	private static final byte  ACK_CODE = 3;
	private static final byte EMPTY_ANSWER_CODE = 5;
	private static final byte INFO_CODE = 4;
	private static final int EMPTY_ANSWER_SIZE = 1;
	private static final int INFO_ANSWER_SIZE = 9;
	private static final int ACK_SIZE = 1;
	private static final int PORT = 6868;
	//Tamaño máximo del paquete UDP
	private static final int PACKET_MAX_SIZE = 128;
	//Estructura para guardar las asociaciones ID_PROTOCOLO -> Dirección del servidor
	protected HashMap<Byte,InetSocketAddress> servers;

	//Socket de comunicación UDP
	protected DatagramSocket socket = null;
	//Probabilidad de descarte del mensaje
	protected double messageDiscardProbability;

	public DirectoryThread(String name, int directoryPort,
			double corruptionProbability)
			throws SocketException {
		super(name);
		//TODO Anotar la dirección en la que escucha el servidor de Directorio
		InetSocketAddress serverAddress = new InetSocketAddress(directoryPort);
 		//TODO Crear un socket de servidor
		socket = new DatagramSocket(serverAddress);
		messageDiscardProbability = corruptionProbability;
		//Inicialización del mapa
		servers = new HashMap<Byte,InetSocketAddress>();
	}

	public void run() {
		byte[] buf = new byte[PACKET_MAX_SIZE];

		System.out.println("Directory starting...");
		boolean running = true;
		while (running) {
				DatagramPacket pckt = new DatagramPacket(buf, buf.length);
				//TODO 1) Recibir la solicitud por el socket
				try {
					socket.receive(pckt);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//TODO 2) Extraer quién es el cliente (su dirección)
				InetSocketAddress ca = (InetSocketAddress) pckt.getSocketAddress();
				// 3) Vemos si el mensaje debe ser descartado por la probabilidad de descarte

				double rand = Math.random();
				if (rand < messageDiscardProbability) {
					System.err.println("Directory DISCARDED corrupt request from... ");
					continue;
				}
				
				//TODO 4) Analizar y procesar la solicitud (llamada a processRequestFromCLient)
				try {
					processRequestFromClient(pckt.getData(), ca);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//TODO 5) Tratar las excepciones que puedan producirse
		}
		socket.close();
	}

	//Método para procesar la solicitud enviada por clientAddr
	public void processRequestFromClient(byte[] data, InetSocketAddress clientAddr) throws IOException {
		//TODO 1) Extraemos el tipo de mensaje recibido
		ByteBuffer bb = ByteBuffer.allocate(data.length);
		bb = ByteBuffer.wrap(data);
		byte code = bb.get();
		byte protocol;
		switch(code) {
		//TODO 2) Procesar el caso de que sea un registro y enviar mediante sendOK
			case REGISTRATION_CODE:
				int port = bb.getInt();
				protocol = bb.get();
				servers.put(protocol, new InetSocketAddress(clientAddr.getAddress(), port));
				sendOK(clientAddr);
				break;
		//TODO 3) Procesar el caso de que sea una consulta
			case QUERY_CODE:
				protocol = bb.get();
				InetSocketAddress dir = servers.get(protocol);
		//TODO 3.1) Devolver una dirección si existe un servidor (sendServerInfo)
				if(dir != null) {
					sendServerInfo(dir, clientAddr);
				}
		//TODO 3.2) Devolver una notificación si no existe un servidor (sendEmpty)
				else {
					sendEmpty(clientAddr);
				}
				break;
		}
	}

	//Método para enviar una respuesta vacía (no hay servidor)
	private void sendEmpty(InetSocketAddress clientAddr) throws IOException {
		//TODO Construir respuesta
		ByteBuffer bb = ByteBuffer.allocate(EMPTY_ANSWER_SIZE);
		bb.put(EMPTY_ANSWER_CODE);
		byte[] emptyMessage = bb.array();
		DatagramPacket p = new DatagramPacket(emptyMessage, emptyMessage.length, clientAddr);
		//TODO Enviar respuesta
		socket.send(p);
	}

	//Método para enviar la dirección del servidor al cliente
	private void sendServerInfo(InetSocketAddress serverAddress, InetSocketAddress clientAddr) throws IOException {
		ByteBuffer bb = ByteBuffer.allocate(INFO_ANSWER_SIZE);
		//TODO Obtener la representación binaria de la dirección
		bb.put(INFO_CODE);
		bb.put(serverAddress.getAddress().getAddress());
		bb.putInt(serverAddress.getPort());
		//TODO Construir respuesta
		DatagramPacket p = new DatagramPacket(bb.array(), INFO_ANSWER_SIZE, clientAddr);
		//TODO Enviar respuesta
		socket.send(p);
	}

	//Método para enviar la confirmación del registro
	private void sendOK(InetSocketAddress clientAddr) throws IOException {
		//TODO Construir respuesta
		ByteBuffer bb = ByteBuffer.allocate(ACK_SIZE);
		bb.put(ACK_CODE);
		DatagramPacket pckt = new DatagramPacket(bb.array(), ACK_SIZE, clientAddr);
		//TODO Enviar respuesta
		socket.send(pckt);
	}
}
