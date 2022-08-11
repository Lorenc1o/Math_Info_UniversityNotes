package Ejercicio2;

import java.util.concurrent.Semaphore;

public class Main {
	//Semáforo inicializado a -29, como está indicado en el pseudocódigo y explicado en la cuestión b)
	public static Semaphore sem = new Semaphore(-29);
	//Mutex para la exclusión mutua de la pantalla
	public static Semaphore pantalla = new Semaphore(1);

	public static void main(String[] args) {
		String[] palabras = new String[30];
		Hilo[] hilos = new Hilo[30];
		for(int i=0; i<30; i++) {
			hilos[i]=new Hilo(i, palabras);
		}
		
		for (Hilo hilo : hilos) {
			hilo.start();
		}
		
		try {
			for (Hilo hilo : hilos) {
				hilo.join();
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
	}

}
