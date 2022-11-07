package ecg;

import java.util.LinkedList;

public class ComplejoQRS extends Complejo {

	public ComplejoQRS(int ciclo, Onda q, Onda r, Onda s, int duracion) {
		super(ciclo, duracion, new LinkedList<Componente>());
		this.getCombinacionDe().add(q);
		this.getCombinacionDe().add(r);
		this.getCombinacionDe().add(s);
	}
}
