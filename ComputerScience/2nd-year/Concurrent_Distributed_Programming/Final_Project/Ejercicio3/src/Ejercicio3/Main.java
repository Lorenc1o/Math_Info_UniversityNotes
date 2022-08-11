package Ejercicio3;

public class Main {

	public static void main(String[] args) {
		Buffer buf = new Buffer();
		Consumidor[] c1 = new Consumidor[3];
		Consumidor[] c2 = new Consumidor[3];
		Productor[] p1 = new Productor[3];
		Productor[] p2 = new Productor[3];
		for(int i=0; i<3; i++) {
			c1[i]=new Consumidor(buf, 1, i);
			c2[i]=new Consumidor(buf, 2, i);
			p1[i]=new Productor(buf, 1, i);
			p2[i]=new Productor(buf, 2, i);	
		}
		for(int i=0; i<3; i++) {
			c1[i].start();
			c2[i].start();
			p1[i].start();
			p2[i].start();
		}
		try {
			for(int i=0; i<3; i++) {
				c1[i].join();
				c2[i].join();
				p1[i].join();
				p2[i].join();
			}
		} catch(InterruptedException e) {
			e.printStackTrace();
		}
	}

}
