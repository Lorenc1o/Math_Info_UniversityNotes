package Ejercicio3;

public class Consumidor extends Thread{
	private Buffer buffer;
	private int tipo;
	private int id;
	
	public Consumidor(Buffer b, int t, int idd) {
		buffer = b;
		tipo = t;
		id = idd;
	}
	
	public void run() {
		// Hacemos 20 extracciones
		for(int i=0; i<20; i++) {
			try {
				buffer.extraer(tipo);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}
