package ecg_extra;

import java.util.LinkedList;
import java.util.List;

public abstract class Complejo extends Componente{
	private int duracion;
	private List<Componente>combinacionDe;
	
	public Complejo(int ciclo, int duracion, LinkedList<Componente> combinacionDe) {
		super(ciclo);
		this.duracion = duracion;
		this.combinacionDe = new LinkedList<Componente>(combinacionDe);
	}

	public int getDuracion() {
		return duracion;
	}

	public void setDuracion(int duracion) {
		this.duracion = duracion;
	}
	
	public List<Componente> getCombinacionDe() {
		return new LinkedList<Componente>(combinacionDe);
	}
}
