package ecg;

public class DemasiadoRitmoBaby extends IndicioDiagnostico {
	private static String descripcion = "Ritmo Card�aco Demasiado Elevado: m�s de 100 lpm";

	public DemasiadoRitmoBaby(int ciclo) {
		super(descripcion, ciclo);
	}
}
