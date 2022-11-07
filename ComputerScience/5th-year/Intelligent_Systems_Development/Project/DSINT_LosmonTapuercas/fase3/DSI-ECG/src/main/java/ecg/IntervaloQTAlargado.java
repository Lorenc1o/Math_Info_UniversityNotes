package ecg;

public class IntervaloQTAlargado extends IndicioDiagnostico {
	private static String descripcion = "Intervalo QT Alargado: Longitud mayor que 440ms";

	public IntervaloQTAlargado(int ciclo) {
		super(descripcion, ciclo);
	}
}
