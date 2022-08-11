package es.um.redes.nanoChat.auxiliarClass;
/**
 * 
 * @author jose & pablo
 * Esta es una clase auxiliar que utilizaremos
 * para representar a los miembros de una sala.
 * Un miembro se compone de
 * String name: nombre de usuario
 * boolean admin: indica si el usuario es admin
 * 		de la sala en la que se encuentra (true) 
 * 		o no (false)
 *
 */
public class Member {
	private final String name;
	private boolean admin;
	
	public Member(String name, boolean admin) {
		this.name = name;
		this.admin = admin;
	}

	public boolean isAdmin() {
		return admin;
	}

	public void setAdmin(boolean admin) {
		this.admin = admin;
	}

	public String getName() {
		return name;
	}
	@Override
	public String toString() {
		return getName() + ((isAdmin()) ? "(Admin)" : "");
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}
/**
 * Para el equals no tenemos en cuenta
 * si el usuario es admin o no, pues,
 * en caso contrario, dificultaría la
 * eliminación de usuarios de una sala.
 * Podemos hacer esto porque los nombres 
 * de usuario son únicos dentro del servidor.
 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Member other = (Member) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
	
	
}
