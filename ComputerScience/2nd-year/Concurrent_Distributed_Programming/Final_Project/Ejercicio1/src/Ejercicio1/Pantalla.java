package Ejercicio1;

//Esta clase la usamos para imprimir la información requerida por pantalla en exclusión mutua
public class Pantalla {
	public synchronized void imprime(String id, int[][] M, int[] cont) {
		System.out.println("Hilo "+id);
		System.out.println();
		for(int i=0; i<10; i++) {
			for(int j=0; j<10; j++) {
				System.out.print(M[i][j]+" "); // Imprimimos el elemento (i,j)
			}
			System.out.println();
		}
		for(int i=0; i<10; i++) {
			System.out.println("Contador de "+ i +" = "+cont[i]); // Imprimimos la cantidad de ocurrencias del número i
		}
		System.out.println("Terminando hilo '"+id+"'");
		System.out.println();
	}
}
