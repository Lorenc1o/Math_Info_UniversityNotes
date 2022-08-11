package Ejercicio3;
import java.util.concurrent.locks.*;
import java.util.LinkedList;

public class Buffer {
	ReentrantLock l = new ReentrantLock();
	Condition puedoIntroducirElem, puedoSacarElemT1, puedoSacarElemT2;
	//El buffer lo represento con dos listas, una para los elementos de cada tipo, que, como mucho podrán contener 10 elementos entre las dos
	LinkedList<Integer> tipo1;
	LinkedList<Integer> tipo2;
	int tam, cantidad1, cantidad2; //Tam es la cantidad de elementos en las dos listas, cantidadi indica cuántos elementos hay del tipo i
	
	public Buffer() {
		puedoIntroducirElem = l.newCondition();
		puedoSacarElemT1 = l.newCondition();
		puedoSacarElemT2 = l.newCondition();
		tipo1 = new LinkedList<Integer>();
		tipo2 = new LinkedList<Integer>();
		tam=cantidad1=cantidad2=0;
	}
	
	//Método que usarán los productores para insertar elementos
	public void insertar(int tipo) throws InterruptedException {
		l.lock();
		try {
			//Para poder introducir elementos, el buffer no puede estar lleno
			while(tam==10) {
				puedoIntroducirElem.await();
			}
			tam++;
			
			//Distinguimos el tipo de productor que quiere introducir elementos
			if(tipo==1) {
				tipo1.add(tipo);
				cantidad1++;
				//Imprimimos el estado del buffer
				info();
				//Avisamos a los consumidores del tipo 1 de que hay productos consumibles
				puedoSacarElemT1.signalAll();
			}
			else {
				tipo2.add(tipo);
				cantidad2++;
				info();
				//Avisamos a los consumidores del tipo 2 de que hay productos consumibles
				puedoSacarElemT2.signalAll();
			}
		} finally {
			l.unlock();
		}
	}
	
	//Método que usarán los consumidores para extraer elementos
	public void extraer(int tipo) throws InterruptedException {
		l.lock();
		//Distinguimos el tipo de consumidor que quiere acceder al buffer
		if(tipo==1) {
			try {
				//Si no hay elementos de tipo 1, los consumidores de tipo 1 quedan bloqueados
				while(cantidad1==0) {
					puedoSacarElemT1.await();
				}
				tipo1.remove();
				cantidad1--;
				tam--;
				puedoIntroducirElem.signal();
				info();
			} finally {
				l.unlock();
			}
			
		}
		else {
			try {
				//Lo mismo ocurre con los consumidores de tipo 2
				while(cantidad2==0) {
					puedoSacarElemT2.await();
				}
				tipo2.remove();
				cantidad2--;
				tam--;
				puedoIntroducirElem.signal();
				info();
			} finally {
				l.unlock();
			}
		}	
	}
	
	//Método auxiliar que imprime el estado del buffer, para poder hacer seguimiento del mismo
	private void info() {
		for (Integer integer : tipo1) {
			System.out.print(integer + " ");
		}
		for (Integer integer : tipo2) {
			System.out.print(integer + " ");
		}
		System.out.println();
	}
}
