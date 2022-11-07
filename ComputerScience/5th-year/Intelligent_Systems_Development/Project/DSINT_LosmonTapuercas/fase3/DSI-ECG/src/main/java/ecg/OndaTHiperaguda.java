package ecg;

public class OndaTHiperaguda extends IndicioDiagnostico {
	private static String descripcion = "Onda T Hiperaguda: altura > 8 mV";

	public OndaTHiperaguda (int ciclo) {
		super(descripcion, ciclo);
	}
}
