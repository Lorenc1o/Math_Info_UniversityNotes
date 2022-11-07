package ecg;

public class Hipocalcemia extends Diagnostico {
	private static String nombre = "Hipocalcemia";
	
	public Hipocalcemia (int ciclo, IndicioDiagnostico ... diagnosticos) {
		super(ciclo, nombre, diagnosticos);
	}
}
