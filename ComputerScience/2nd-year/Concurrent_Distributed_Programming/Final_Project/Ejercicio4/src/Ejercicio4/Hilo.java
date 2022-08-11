package Ejercicio4;

import messagepassing.*;

public class Hilo extends Thread {
	private int id;
	private MailBox buzonOK, solicitud, liberacion, pantalla;
	//buzonOK sirve para recibir el mensaje de asignación de impresora y notificación de tiempo de impresión; pantalla sirve para efectuar la exclusión mutua de la pantalla
	public Hilo(int idd, MailBox b, MailBox s, MailBox l, MailBox p) {
		id=idd;
		buzonOK=b;
		solicitud=s;
		liberacion=l;
		pantalla=p;
	}
	
	public void run() {
		for(int i=0; i<5; i++) {
			
			//Enviamos la solicitud de impresora
			solicitud.send(new Mensaje(0, '0', id));
			
			//Esperamos a recibir la información con el tiempo de impresión y la impresora asignada
			Mensaje msj=(Mensaje)buzonOK.receive();
			try {
				Thread.sleep(msj.getTime());
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
			//Informamos de que hemos acabado la impresión del trabajo
			liberacion.send(msj);
			
			//Buscamos conseguir la exclusión mutua para imprimir la información requerida
			Object token = pantalla.receive();
			System.out.println("Hilo "+id+" ha usado la impresora "+msj.getImp()+" para realizar la impresión número "+(i+1));
			System.out.println("Tiempo de uso = "+msj.getTime());
			System.out.println();
			
			pantalla.send(token);
			
		}
	}
}
