package Ejercicio1;

public class Hilo extends Thread {
	private String id;
	private Pantalla p;
	
	public Hilo(String idd, Pantalla pan) {
		id=idd;
		p=pan;
	}
	
	public void run() {
		for(int i=0; i<10; i++) {
			//Creamos la matriz
			int[][] M = new int[10][10];
			
			//Creamos un array en el que guardaremos la cantidad de ocurrencias de cada número generado aleatoriamente
			int[] cont = new int[10];
			for(int j=0; j<10; j++) {
				for(int k=0; k<10; k++) {
					int m= (int) (Math.random() * 10);
					cont[m]++;
					M[j][k]=m;
				}
			}
			
			//Imprimos por pantalla, en exclusión mutua
			p.imprime(id, M, cont);
		}
	}
}
