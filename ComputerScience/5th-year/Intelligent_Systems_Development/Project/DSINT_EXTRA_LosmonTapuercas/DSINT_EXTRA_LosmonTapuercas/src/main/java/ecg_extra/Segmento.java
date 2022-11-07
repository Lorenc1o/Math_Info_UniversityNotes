package ecg_extra;

public abstract class Segmento extends Componente{
	private int duracion;
	private Onda empiezaEn;
	private Onda terminaEn;
	
	public Segmento(int ciclo, Onda inicio, Onda fin, int duracion) {
		super(ciclo);
		this.empiezaEn = inicio;
		this.terminaEn = fin;
		this.duracion = duracion;
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
