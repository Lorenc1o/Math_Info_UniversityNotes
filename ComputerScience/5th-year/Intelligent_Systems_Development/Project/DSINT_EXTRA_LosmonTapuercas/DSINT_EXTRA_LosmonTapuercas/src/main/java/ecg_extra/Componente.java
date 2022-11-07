package ecg_extra;

public abstract class Componente{
	private int Ciclo;
	
	public Componente(int ciclo) {
		super();
		Ciclo = ciclo;
	}

	public int getCiclo() {
		return Ciclo;
	}

	public void setCiclo(int ciclo) {
		Ciclo = ciclo;
	}
}
