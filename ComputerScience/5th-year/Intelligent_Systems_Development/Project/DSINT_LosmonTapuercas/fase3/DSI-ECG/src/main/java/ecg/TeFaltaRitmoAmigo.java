package ecg;

public class TeFaltaRitmoAmigo extends IndicioDiagnostico {
	private static String descripcion = "Ritmo Card�aco Demasiado Lento: menos de 60 lpm";

	public TeFaltaRitmoAmigo(int ciclo) {
		super(descripcion, ciclo);
	}
}
