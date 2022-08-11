package Ejercicio2;

import java.util.LinkedList;

public class Hilo extends Thread {
	private int id;
	private String[] palabras; // Array con las palabras generadas por todos los hilos
	private LinkedList<String> words; // Lista con las palabras que empiezan por la misma letra que la palabra generada por este hilo
	
	public Hilo(int idd, String[] pals) {
		id=idd;
		palabras = pals;
		words = new LinkedList<String>();
	}
	
	public void run() {
		//Determinamos la longitud de la palabra
		int len = (int) (Math.random()*10+1);
		
		//Comenzamos con una palabra vacía
		String palabra="";
		for(int i=0; i<len; i++) {
			//y la vamos completando
			int n=(int) (Math.random()*26+'a');
			palabra+=(char) n;
			try {
				Thread.sleep(n);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		//La añadimos al array de palabras, podemos introducirlo sin exclusión mutua en la posición id, pues somos los únicos que accedemos a esta posición
		palabras[id]=palabra;
		//Sumamos uno al semáforo, mientras este sea negativo
		Main.sem.release();
		try {
			//Cuando sea positivo, podremos cogerlo y seguir con la ejecución del programa
			Main.sem.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		Main.sem.release(); // Para que no se queden bloqueados los demás hilos, al hacer el acquire
		
		//Contamos cuantas palabras comienzan con la misma letra que la nuestra, sin exclusión mutua, pues no modificamos la información del array
		for (String string : palabras) {
			if(string.startsWith(palabra.substring(0,1))) {
				words.add(string);
			}
		}
		
		//Pedimos la exclusión mutua para imprimir por pantalla
		try {
			Main.pantalla.acquire();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		System.out.println("Hilo "+id);
		System.out.println();
		System.out.print("Todas las palabras = ");
		for (String string : palabras) {
			System.out.print(string + " ");
		}
		System.out.println();
		System.out.print("Palabra hilo " + id + " = " + palabra);
		System.out.println();
		System.out.print("Palabras que empiezan con mi letra = ");
		for (String string : words) {
			System.out.print(string + " ");
		}
		System.out.println();
		System.out.println("Terminando Hilo "+id);
		System.out.println();

		//Una vez hemos imprimido toda la información necesaria, liberamos la pantalla
		Main.pantalla.release();
	}
}
