package ecg;

public class OndaTInvertida extends IndicioDiagnostico {
	private static String descripcion = "Onda T Invertida: su amplitud es menor que -1 mV";

	public OndaTInvertida(int ciclo) {
		super(descripcion, ciclo);
	}
}
