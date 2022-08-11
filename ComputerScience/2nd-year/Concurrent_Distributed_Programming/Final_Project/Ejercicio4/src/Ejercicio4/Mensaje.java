package Ejercicio4;

import java.io.Serializable;

//Clase usada para poder enviar la información necesaria para la tarea

public class Mensaje implements Serializable  {
	private int time;
	private char imp;
	private int id;
	
	public Mensaje(int t, char i, int idd) {
		time=t;
		imp=i;
		id=idd;
	}

	public int getTime() {
		return time;
	}

	public char getImp() {
		return imp;
	}

	public int getId() {
		return id;
	}
	
}
