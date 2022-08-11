package Ejercicio4;

import messagepassing.*;

public class Main {

	public static void main(String[] args) {
		//Este MailBox actúa como mutex para la impresión en pantalla, lanzamos el token para que puede ser pedido en un momento dado
		MailBox pantalla = new MailBox();
		pantalla.send("token");
		
		MailBox solicitud = new MailBox();
		MailBox liberacion = new MailBox();
		MailBox[] buzonOK = new MailBox[30];
		Hilo[] hilos = new Hilo[30];
		for(int i=0; i<30; i++) {
			buzonOK[i] = new MailBox();
			hilos[i] = new Hilo(i, buzonOK[i], solicitud, liberacion, pantalla);
		}
		Controlador c = new Controlador(solicitud, liberacion, buzonOK);
		
		c.start();
		for (Hilo hilo : hilos) {
			hilo.start();
		}
		
		try {
			for (Hilo hilo : hilos) {
				hilo.join();
			}
			c.join();
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}

}
