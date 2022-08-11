package Ejercicio3;

public class Productor extends Thread{
	private Buffer buffer;
	private int tipo;
	private int id;
	
	public Productor(Buffer b, int t, int idd) {
		buffer = b;
		tipo = t;
		id = idd;
	}
	
	public void run() {
		//Hacemos 20 inserciones
		for(int i=0; i<20; i++) {
			try {
				buffer.insertar(tipo);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}
