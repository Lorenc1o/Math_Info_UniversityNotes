package ecg;

public class Taquicardia extends Diagnostico {
	private static String nombre = "Taquicardia";
	
	public Taquicardia(int ciclo, IndicioDiagnostico...diagnosticos) {
		super(ciclo, nombre, diagnosticos);
	}
}
