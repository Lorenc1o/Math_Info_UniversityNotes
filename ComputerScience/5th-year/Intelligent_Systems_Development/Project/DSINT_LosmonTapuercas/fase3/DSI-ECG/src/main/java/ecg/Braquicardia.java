package ecg;

public class Braquicardia extends Diagnostico {
	private static String nombre = "Braquicardia";
	
	public Braquicardia(int ciclo, IndicioDiagnostico...diagnosticos) {
		super(ciclo, nombre, diagnosticos);
	}
}
