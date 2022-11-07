package ecg;

public abstract class Intervalo extends Componente{
	private int duracion;
	private Onda empiezaEn;
	private Onda terminaEn;
	
	public Intervalo(int ciclo, Onda inicio, Onda fin, int duracion) {
		super(ciclo);
		this.duracion = duracion;
		this.empiezaEn = inicio;
		this.terminaEn = fin;
	}
	
	public int getDuracion() {
		return duracion;
	}

	public void setDuracion(int duracion) {
		this.duracion = duracion;
	}

	public Onda getEmpiezaEn() {
		return empiezaEn;
	}

	public void setEmpiezaEn(Onda empiezaEn) {
		this.empiezaEn = empiezaEn;
	}

	public Onda getTerminaEn() {
		return terminaEn;
	}

	public void setTerminaEn(Onda terminaEn) {
		this.terminaEn = terminaEn;
	}
}
