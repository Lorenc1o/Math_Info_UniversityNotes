package es.um.redes.nanoChat.directory.connector;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;

/**
 * Cliente con métodos de consulta y actualización específicos del directorio
 */
public class DirectoryConnector {
	private static final byte REGISTRATION_CODE = 1;
	private static final byte QUERY_CODE = 2;
	private static final byte ACK_CODE = 3;
	private static final byte EMPTY_ANSWER_CODE = 5;
	private static final byte INFO_CODE = 4;
	private static final int EMPTY_ANSWER_SIZE = 1;
	private static final int QUERY_MESSAGE_SIZE = 2;
	private static final int REGISTRATION_SIZE = 6;
	private static final int MAX_TRIES = 5;
	// Tamaño máximo del paquete UDP (los mensajes intercambiados son muy cortos)
	private static final int PACKET_MAX_SIZE = 128;
	// Puerto en el que atienden los servidores de directorio
	private static final int DEFAULT_PORT = 6868;
	// Valor del TIMEOUT
	private static final int TIMEOUT = 1000;

	private DatagramSocket socket; // socket UDP
	private InetSocketAddress directoryAddress; // dirección del servidor de directorio

	public DirectoryConnector(String agentAddress) throws IOException {
		// TODO A partir de la dirección y del puerto generar la dirección de conexión
		// para el Socket
		directoryAddress = new InetSocketAddress(InetAddress.getByName(agentAddress), DEFAULT_PORT);
		// TODO Crear el socket UDP
		socket = new DatagramSocket();
	}

	/**
	 * Envía una solicitud para obtener el servidor de chat asociado a un
	 * determinado protocolo
	 * 
	 */
	public InetSocketAddress getServerForProtocol(byte protocol) throws IOException {
		// TODO Generar el mensaje de consulta llamando a buildQuery()
		byte[] message = buildQuery(protocol);
		// TODO Construir el datagrama con la consulta
		DatagramPacket p = new DatagramPacket(message, message.length, directoryAddress);
		// TODO Enviar datagrama por el socket
		socket.send(p);
		// TODO preparar el buffer para la respuesta
		byte[] buff = new byte[PACKET_MAX_SIZE];
		// TODO Establecer el temporizador para el caso en que no haya respuesta
		socket.setSoTimeout(TIMEOUT);
		// TODO Recibir la respuesta
		DatagramPacket answer = new DatagramPacket(buff, buff.length);
		// TODO Procesamos la respuesta para devolver la dirección que hay en ella
		int cont = MAX_TRIES;
		while (cont > 0) {
			try {
				socket.receive(answer);
				cont = 0;
			} catch (java.net.SocketTimeoutException e) {
				cont--;
				socket.setSoTimeout(TIMEOUT);
				socket.send(p);
			}
		}
		return getAddressFromResponse(answer);
	}

	// Método para generar el mensaje de consulta (para obtener el servidor asociado
	// a un protocolo)
	private byte[] buildQuery(byte protocol) {
		// TODO Devolvemos el mensaje codificado en binario según el formato acordado
		ByteBuffer bb = ByteBuffer.allocate(QUERY_MESSAGE_SIZE);
		bb.put(QUERY_CODE);
		bb.put(protocol);
		byte[] queryMessage = bb.array();
		return queryMessage;
	}

	// Método para obtener la dirección de internet a partir del mensaje UDP de
	// respuesta
	private InetSocketAddress getAddressFromResponse(DatagramPacket packet) throws UnknownHostException {
		// TODO Analizar si la respuesta no contiene dirección (devolver null)
		ByteBuffer bb = ByteBuffer.wrap(packet.getData());
		byte code = bb.get();
		// TODO Si la respuesta no está vacía, devolver la dirección (extraerla del
		// mensaje)
		switch (code) {
		case EMPTY_ANSWER_CODE:
			return null;
		case INFO_CODE:
			byte ip[] = new byte[4];
			bb.get(ip);
			InetSocketAddress aux = new InetSocketAddress(InetAddress.getByAddress(ip), bb.getInt());
			System.out.println(aux);
			return aux;
		}
		return null;
	}

	/**
	 * Envía una solicitud para registrar el servidor de chat asociado a un
	 * determinado protocolo
	 * 
	 */
	public boolean registerServerForProtocol(byte protocol, int port) throws IOException {

		// TODO Construir solicitud de registro (buildRegistration)
		byte[] buffer = buildRegistration(protocol, port);
		byte[] answerBuffer = new byte[PACKET_MAX_SIZE];
		DatagramPacket p = new DatagramPacket(buffer, buffer.length, directoryAddress);
		DatagramPacket answer = new DatagramPacket(answerBuffer, answerBuffer.length);
		// TODO Enviar solicitud
		int cont = MAX_TRIES;
		socket.setSoTimeout(TIMEOUT);
		socket.send(p);
		// TODO Recibe respuesta
		while (cont > 0) {
			try {
				socket.receive(answer);
				cont = 0;
			} catch (java.net.SocketTimeoutException e) {
				cont--;
				socket.send(p);
				socket.setSoTimeout(TIMEOUT);
			}
		}
		// TODO Procesamos la respuesta para ver si se ha podido registrar correctamente
		ByteBuffer bb = ByteBuffer.wrap(answer.getData());
		byte code = bb.get();
		return code == ACK_CODE;
	}

	// Método para construir una solicitud de registro de servidor
	// OJO: No hace falta proporcionar la dirección porque se toma la misma desde la
	// que se envió el mensaje
	private byte[] buildRegistration(byte protocol, int port) {
		// TODO Devolvemos el mensaje codificado en binario según el formato acordado
		ByteBuffer bb = ByteBuffer.allocate(REGISTRATION_SIZE);
		bb.put(REGISTRATION_CODE);
		bb.putInt(port);
		bb.put(protocol);
		return bb.array();
	}

	public void close() {
		socket.close();
	}
}
