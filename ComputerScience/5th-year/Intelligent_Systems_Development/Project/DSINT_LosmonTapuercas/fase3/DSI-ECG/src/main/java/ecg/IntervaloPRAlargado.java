package ecg;

public class IntervaloPRAlargado extends IndicioDiagnostico {
	private static String descripcion = "Intervalo PR Alargado: Longitud mayor que 200ms";

	public IntervaloPRAlargado(int ciclo) {
		super(descripcion, ciclo);
	}
}
