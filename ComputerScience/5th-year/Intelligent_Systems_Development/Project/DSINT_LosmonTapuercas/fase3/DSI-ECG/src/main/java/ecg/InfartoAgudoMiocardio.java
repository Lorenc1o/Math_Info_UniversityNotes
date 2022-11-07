package ecg;

public class InfartoAgudoMiocardio extends Diagnostico {
	private static String nombre = "Infarto agudo de miocardio";
	
	public InfartoAgudoMiocardio (int ciclo, IndicioDiagnostico...diagnosticos) {
		super(ciclo, nombre, diagnosticos);
	}
}
