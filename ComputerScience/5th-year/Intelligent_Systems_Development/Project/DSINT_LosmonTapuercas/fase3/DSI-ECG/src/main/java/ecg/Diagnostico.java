package ecg;

import java.util.LinkedList;

public abstract class Diagnostico {
	private int ciclo;
	private String nombreEnfermedad;
	private LinkedList<IndicioDiagnostico> indicios;

	public Diagnostico(int ciclo, String nombre) {
		this.ciclo = ciclo;
		this.nombreEnfermedad = nombre;
		this.indicios = new LinkedList<IndicioDiagnostico>();
	}
	
	public Diagnostico(int ciclo, String nombre, IndicioDiagnostico ... diagnosticos) {
		this(ciclo, nombre);
		for (int i = 0; i < diagnosticos.length; i++)
			this.indicios.add(diagnosticos[i]);
	}

	public int getCiclo() {
		return ciclo;
	}
	
	public void setCiclo(int ciclo) {
		this.ciclo = ciclo;
	}
	
	public void addIndicio(IndicioDiagnostico iDiagnostico) {
		this.indicios.add(iDiagnostico);
	}

	@Override
	public String toString() {
		return "Diagnostico: " + nombreEnfermedad + "\nCiclo: " + ciclo + "\nIndicios: " + indicios.toString();
	}
}
