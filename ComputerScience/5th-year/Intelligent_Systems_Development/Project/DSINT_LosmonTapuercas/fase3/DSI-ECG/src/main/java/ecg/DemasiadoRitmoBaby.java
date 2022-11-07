package ecg;

public class DemasiadoRitmoBaby extends IndicioDiagnostico {
	private static String descripcion = "Ritmo Cardíaco Demasiado Elevado: más de 100 lpm";

	public DemasiadoRitmoBaby(int ciclo) {
		super(descripcion, ciclo);
	}
}
