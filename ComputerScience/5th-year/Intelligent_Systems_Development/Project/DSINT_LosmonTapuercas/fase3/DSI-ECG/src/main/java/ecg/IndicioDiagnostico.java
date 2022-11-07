package ecg;

public abstract class IndicioDiagnostico {
	private String descripcion;
	private int ciclo;
	
	public IndicioDiagnostico(String desc, int ciclo) {
		this.descripcion = desc;
		this.ciclo = ciclo;
	}
	
	public int getCiclo() {
		return this.ciclo;
	}
	
	public String getDescripcion() {
		return this.descripcion;
	}

	@Override
	public String toString() {
		return descripcion;
	}
}
