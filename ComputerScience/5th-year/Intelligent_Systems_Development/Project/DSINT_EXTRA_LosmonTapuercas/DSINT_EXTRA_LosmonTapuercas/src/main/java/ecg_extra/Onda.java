package ecg_extra;

public abstract class Onda extends Componente{
	private int inicio;
	private int fin;
	private double altura;
	
	public Onda(int ciclo, int inicio, int fin, double altura) {
		super(ciclo);
		this.inicio = inicio;
		this.fin = fin;
		this.altura = altura;
	}
	
	public int getInicio() {
		return inicio;
	}
	public void setInicio(int inicio) {
		this.inicio = inicio;
	}
	public int getFin() {
		return fin;
	}
	public void setFin(int fin) {
		this.fin = fin;
	}
	public double getAltura() {
		return altura;
	}
	public void setAltura(double altura) {
		this.altura = altura;
	}
}
