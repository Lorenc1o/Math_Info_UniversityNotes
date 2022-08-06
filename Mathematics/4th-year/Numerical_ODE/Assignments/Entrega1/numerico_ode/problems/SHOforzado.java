package numerico_ode.problems;

import javax.swing.JFrame;

import org.opensourcephysics.frames.PlotFrame;

import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySolution;
import numerico_ode.tools.DisplaySequence;
import java.lang.Math;

public class SHOforzado implements InitialValueProblem {
	private static double m=1, k=1.5, l=0.7;
	private static double[] w = {1.3, 2.4, 3.5, 1.2417};
	private double b,A;
	
	public SHOforzado(double bb, double AA) {
		b=bb;
		A=AA;
	}

	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() {
		return new double[] {0.5,0};
	}
	
	public double f(double t, int i) {
		return A*Math.sin(w[i]*t);
	}
	
	//Definimos la derivada:
	// x[0]'=x[1]
	// x[1]'={lo que da la fórmula}
	@Override
	public double[] getDerivative(double time, double[] state) {
		return new double[] {state[1], -k/m*(state[0]-l)-b/m*state[1]+f(time, 3)/m};
	}
	
	//con el primer w, oscila cada vez más
	//con el segundo w, parece que se estabiliza
	//con el tercer w, parece que se estabiliza, pero con menor amplitud
	//parece que van decreciendo en los dos últimos casos,
	//de forma poco perceptible a simple vista
	
	public static void main(String[] args) {
		double b=0.3, A=0.4;
		SHOforzado problem = new SHOforzado(b, A);
		FixedStepMethod method = new FixedStepEulerMethod(problem, 0.01);
		
		if (false) method.solve(15);
        else { 
        	double time = method.getSolution().getLastPoint().getTime();
            while (time<40) time = method.step().getTime();
        }
		
		
		
		//Mostramos la posición respecto el tiempo
        DisplaySolution.timePlot(method.getSolution(), new int[] {0});
        
        //Mostramos la velocidad respecto el tiempo
        DisplaySolution.timePlot(method.getSolution(), new int[] {1});
        
        //Para validar, usamos la ecuación que describe el SHO sin rozamiento,
        //que sabemos resolver
        b=0;
        A=0;
        
        SHOforzado problem2 = new SHOforzado(b,A);
        
        FixedStepMethod method2 = new FixedStepEulerMethod(problem2, 0.01);
        
        double paso=0.01;
		int n = (int) Math.round(40/paso); 
        double[] x = new double[n];
        double[] y = new double[n];
        
		if (false) method2.solve(15);
        else { 
        	   		
    		x[0]=y[0]=problem2.getInitialState()[0];
    		double x0=x[0];
    		
    		int i=0;
    		
        	double time = method2.getSolution().getLastPoint().getTime();
            while (time<40) {
            	method2.step();
            	//Obtenemos la solución analítica de la EDO
        		// x=l+(x0-l)*sen(\sqrt(k/m)*t+(x0-l))
            	//le restamos lo que obtenemos con el método
            	x[i]=l+(x0-l)*Math.cos(Math.sqrt(k/m)*time+(x0-l));
            	y[i]=Math.abs(x[i]-method2.getSolution().getLastPoint().getState(0));
    			time += paso;
    			i++;
            }
        }	
		//DisplaySequence.plot(x);
		//DisplaySolution.timePlot(method2.getSolution(), new int[] {0});
		//DisplaySequence.plot(y);
		
		//System.out.println("A lo largo de 40 segundos obtenemos un error de "+ x[n-1]+
		//		"de un total de "+ method2.getSolution().getLastPoint().getState(0));
		//este error parece suficientemente bajo, nos desviamos 0.06 respecto a 0.6, 
		//es decir, un 10% en 40s 
		
		//ahora, como sabemos que el método de Euler produce un error lineal, viendo
		//que con un paso de 0.01 obtenemos un error de ~10%, si queremos que el error
		//sea del ~1%, ponemos un paso de 0.001
		
		b=0;
        A=0;
        
        SHOforzado problem3 = new SHOforzado(b,A);
        
        FixedStepMethod method3 = new FixedStepEulerMethod(problem3, 0.001);
        
        paso=0.001;
        // 40/0.001=40000, necesitamos 10 arrays
		n = 4000;
        
        double media=0;
        double time = method3.getSolution().getLastPoint().getTime();
        double x0=problem3.getInitialState()[0];
        double periodo=-1;
        for(int i=0; i<10; i++) {
        	x[0]=method3.getSolution().getLastPoint().getState(0);
        	int j=0;
        	while(j<4000) {
        		method3.step();
        		x[j]=l+(x0-l)*Math.cos(Math.sqrt(k/m)*time);
        		y[j]=Math.abs(x[j]-method3.getSolution().getLastPoint().getState(0));
        		if(Math.abs(x0-method3.getSolution().getLastPoint().getState(0))<1e-5 && periodo<0 && time>0.5) {
        			periodo=time*1;
        		}
    			time += paso;
    			media += y[j];
    			j++;  			
        	}
        }
		media=media/40000;
		System.out.println("La media del error es:"+media);
		System.out.println("El periodo es: "+periodo);
		
		double frec=2*Math.PI/periodo;
		
		//System.out.println("A lo largo de 40 segundos obtenemos un error de "+ x[n-1]+
		//		"de un total de "+ method3.getSolution().getLastPoint().getState(0));
		//para calcular la frecuencia del movimiento no forzado, hacemos
		//buscamos el segundo punto que repite el valor inicial
		
		//Vamos a usar la solución del problem3, que es la más precisa
		
		
		//6 no me da tiempo
	}
}
