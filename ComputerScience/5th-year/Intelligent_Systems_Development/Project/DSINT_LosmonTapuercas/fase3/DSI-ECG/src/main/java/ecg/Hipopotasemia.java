package ecg;

public class Hipopotasemia extends Diagnostico {
	private static String nombre = "Hipopotasemia";
	
	public Hipopotasemia (int ciclo, IndicioDiagnostico...diagnosticos) {
		super(ciclo, nombre, diagnosticos);
	}
}
