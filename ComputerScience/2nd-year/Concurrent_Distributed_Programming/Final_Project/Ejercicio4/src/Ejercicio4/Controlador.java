package Ejercicio4;

import messagepassing.*;
import java.util.LinkedList;

public class Controlador extends Thread{
	private boolean A,B;
	private LinkedList<Mensaje> colaA, colaB; //Colas de espera de cada impresora
	private MailBox[] buzonOK; //Array que contiene los buzones de recepción de cada hilo para poder transmitirles la información relativa a la impresora asignada y el tiempo de impresión estimado
	private MailBox solicitud, liberacion; //Buzones de recepción del controlador, solicitud para pedir impresora, liberacion para liberarla
	private Selector s; //Para la estructura Select
	
	public Controlador(MailBox sol, MailBox l, MailBox[] b) {
		A=B=true;
		colaA=new LinkedList<Mensaje>();
		colaB=new LinkedList<Mensaje>();
		buzonOK=b;
		solicitud=sol;
		liberacion=l;
		s = new Selector();
		s.addSelectable(solicitud, false);
		s.addSelectable(liberacion, false);
	}
	
	public void run() {
		for(int i=0; i<300; i++) { //Hacemos nhilos*5*2 loops
			solicitud.setGuardValue(true);
			liberacion.setGuardValue(!A || !B); //Podremos liberar impresora si alguna está ocupada
			switch(s.selectOrBlock()) {
			//Recibimos una solicitud de impresión
			case 1: Mensaje m = (Mensaje) solicitud.receive();
			
					// Calculamos el tiempo de impresión, y dependiendo de este
					// hacemos una u otra acción
					int t = (int)(Math.random()*10+1);
					if(A && colaA.isEmpty() && t>=5) { //Directamente a la impresora rápida
						Mensaje msj = new Mensaje(t, 'A', m.getId());
						A=false;
						buzonOK[m.getId()].send(msj);
					}
					else if(B && colaB.isEmpty() && t<5) { //Directamente a la impresora lenta
						Mensaje msj = new Mensaje(t, 'B', m.getId());
						B=false;
						buzonOK[m.getId()].send(msj);
					}
					else if(A && !colaA.isEmpty() && t>=5) { //A la cola de la rápida, también sacamos primer elemento
						colaA.addFirst(new Mensaje(t, 'A', m.getId()));
						Mensaje msj = colaA.getLast();
						colaA.removeLast();
						A=false;
						buzonOK[msj.getId()].send(msj);
					}
					else if(B && !colaB.isEmpty() && t<5) { //A la cola de la lenta, sacamos primer elemento 
						colaB.addFirst(new Mensaje(t, 'B', m.getId()));
						Mensaje msj = colaB.getLast();
						colaB.removeLast();
						B=false;
						buzonOK[msj.getId()].send(msj);
					}
					else if(!A && t>=5) { //A la cola de la rápida
						colaA.addFirst(new Mensaje(t, 'A', m.getId()));
					}
					else { //A la cola de la lenta
						colaB.addFirst(new Mensaje(t, 'B', m.getId()));
					}
					break;
					
			//Recibimos información de liberación de una impresora
			case 2: Mensaje men = (Mensaje) liberacion.receive();
					//Distinguimos si debemos liberar la A o la B
					if(men.getImp()=='A') {
						A=true;
						//Si hay trabajos en espera, le asignamos, en orden FIFO, la impresora liberada
						if(!colaA.isEmpty()) {
							Mensaje msj = colaA.getLast();
							colaA.removeLast();
							buzonOK[msj.getId()].send(msj);
							A=false;
						}	
					}
					else {
						B=true;
						if(!colaB.isEmpty()) {
							Mensaje msj = colaB.getLast();
							colaB.removeLast();
							buzonOK[msj.getId()].send(msj);
							B=false;
						}	
					}
					break;			
			}
		}
	}
}
