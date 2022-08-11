package Ejercicio1;

public class Principal {

	public static void main(String[] args) {
		Pantalla p = new Pantalla();
		Hilo h1 = new Hilo("hilo 1", p);
		Hilo h2 = new Hilo("hilo 2", p);
		Hilo h3 = new Hilo("hilo 3", p);
			
		h1.start();
		h2.start();
		h3.start();
		try {
			h1.join();
			h2.join();
			h3.join();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
