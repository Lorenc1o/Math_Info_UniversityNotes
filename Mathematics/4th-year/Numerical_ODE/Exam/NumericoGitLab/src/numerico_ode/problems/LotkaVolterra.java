package numerico_ode.problems;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.methods.AdaptiveStepEulerMethod;
import numerico_ode.methods.AdaptiveStepMethod;
import numerico_ode.methods.AdaptiveStepRK4Method;
import numerico_ode.methods.AdaptiveStepRKFehlbergMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySequence;
import numerico_ode.tools.DisplaySolution;

public class LotkaVolterra implements InitialValueProblem {
	private static double a=0.1, b=0.2, c=0.2, d=0.05, x0=0.25;
	private static double[] y0 = {0.1,0.25,0.4,0.5,0.8};
	private static double y00 = y0[2];
	private static double f=0.0;
	
	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() { //x,y
		return new double[] {x0,y00};
	}

	@Override
	public double[] getDerivative(double time, double[] state) {
		return new double[] {
				a*state[0]-b*state[0]*state[1]-f*state[0],
				-c*state[1]+d*state[0]*state[1]-f*state[1]
		};
	}

	@Override
	public double[] getPartialDerivative(double time, double[] state) { //no vamos a usar esto
		return null;
	}
	
	public static void main(String[] args) {
		double hStep = 0.01;
		double tolerance = 1e-7;
		
		
		//Creamos el problema
		InitialValueProblem LVProblem = new LotkaVolterra();
		
		//Creamos el evento
		
		Event LVEvent = new Event(tolerance, 0) {
			boolean firstReached = false;
			double firstTime;
			int i=1; // para calcular varios periodos
			@Override
			public double crossFunction(double t, double[] state) {
				return state[0]-1; //buscamos cuando y rebasa a x
			}
			
			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				if(firstReached && a*crossingPoint[0]-b*crossingPoint[0]*crossingPoint[1]>0) //segundo máximo de y encontrado
					{double finaltime = crossingTime-firstTime;
					System.out.println("El período en el lapso "+ i +" es: " + finaltime); //imprimimos el período
					firstReached = false;
					i++;
					//stopComputation=true; //habilitar si solo queremos el primer periodo
					} 
				else if(a*crossingPoint[0]-b*crossingPoint[0]*crossingPoint[1]>0 && !firstReached) { //máximo de y si y>x
					firstReached=true;
					firstTime=crossingTime;
				}
				
			}
		};
		
		FixedStepMethod RKF = new AdaptiveStepRKFehlbergMethod(LVProblem, hStep, LVEvent, tolerance);
		RKF.solve(5000);
		
		DisplaySolution.timePlot(RKF.getSolution(), new int[]{0,1});
		
		NumericalSolution solucion = RKF.getSolution();
		
		InterpolatorFunction interpolador = RKF.getInterpolator();
		double periodo = 66.3096; //estamos en el caso 0.25, 0.4
		//periodo = 66.9583; // 0.25, 0.8
		//periodo = 58.5232; // 0.5, 0.5
		//periodo = 55.7431; // 0.7, 0.3
		periodo = 71.1461; //f=0.1; 0.25, 0.4
		periodo = 72.2929; //f=0.1; 0.25, 0.8
		double integralX=0, integralY=0;
		double paso=0.005;
		for(double i=0; i<periodo; i+=paso) {
			double[] state = solucion.getSolutionAt(i, interpolador, tolerance, 50).getState();
			integralX += paso*state[0];
			integralY += paso*state[1];
		}
		double pobMediaX = integralX/periodo, pobMediaY = integralY/periodo;
		
		System.out.println("población media de X = "+ pobMediaX + " y la de Y es = " + pobMediaY);

		System.out.println("Ha necesitado " + RKF.getEvaluationCounter() + " evaluaciones de la función de evaluación");
		if (RKF instanceof AdaptiveStepMethod) 
            DisplaySequence.plot(((AdaptiveStepMethod) RKF).getStepList());
	}

}
