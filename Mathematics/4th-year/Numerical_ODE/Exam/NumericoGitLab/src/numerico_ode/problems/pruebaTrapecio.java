package numerico_ode.problems;

import numerico_ode.methods.FixedStepMethod;
import numerico_ode.methods.ImplicitEulerMethod;
import numerico_ode.methods.TrapezoidMethod;
import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySolution;

public class pruebaTrapecio implements InitialValueProblem {
	private static double h =0.025;

	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() {
		return new double[]{-1}; //y(0), y'(0)
	}

	@Override
	public double[] getDerivative(double time, double[] state) {
		return new double[] {5*Math.exp(5*time)*(state[0]-time)*(state[0]-time)+1};
	}

	@Override
	public double[] getPartialDerivative(double time, double[] state) {
		return new double[] {10*Math.exp(5*time)*(state[0]-time)};
	}

	public static void main(String[] args) {
		InitialValueProblem trap = new pruebaTrapecio();
		
		Event trapecioEvent = new Event(1e-4, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return t-4;
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				System.out.println("Reached t=4");
				stopComputation=true;
			}
			
		};
		
		Event ImpEulerEvent = new Event(1e-4, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return t-4;
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				System.out.println("Reached t=4");
				stopComputation=true;
			}
			
		};
		
		Event ImpEulerSecantEvent = new Event(1e-4, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return t-4;
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				System.out.println("Reached t=4");
				stopComputation=true;
			}
			
		};
		
		FixedStepMethod trapecio = new TrapezoidMethod(trap, h, trapecioEvent, 1e-6, 100);
		
		trapecio.solve(6);
		//trapecio.getSolutionAt(0.5);
		//trapecio.getSolutionAt(0.2);
		//trapecio.getSolutionAt(0.21);
		//trapecio.getSolutionAt(0.6);
		NumericalSolution solucion = trapecio.getSolution();
		
		NumericalSolutionPoint p1;
		
		p1 = solucion.getSolutionAt(0.653, trapecio.getInterpolator(), 1e-6, 100);
		p1.println();

		FixedStepMethod eulerImp = new ImplicitEulerMethod(trap, h, ImpEulerEvent, 1e-6, 100);
		
		eulerImp.solve(6);
		
		
		System.out.println("con newton");
		solucion = eulerImp.getSolution();
		solucion.getLastPoint().println();
		
		System.out.println("con secante");
		solucion.getLastPoint().println();
		
		NumericalSolution realSol = new NumericalSolution();
		
		for(double time=0; time<6; time+=h) {
			realSol.add(time, new double[]{time-Math.exp(-5*time)});
		}
		
		DisplaySolution.timePlot(trapecio.getSolution());
		DisplaySolution.timePlot(eulerImp.getSolution());
		DisplaySolution.timePlot(realSol);

	}

}
