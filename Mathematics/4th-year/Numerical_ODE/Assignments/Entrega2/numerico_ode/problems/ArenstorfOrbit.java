package numerico_ode.problems;

import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.methods.FixedStepRK4;
import numerico_ode.methods.RK4Richardson;
import numerico_ode.methods.RichardsonAdaptativeMethod;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySolution;

public class ArenstorfOrbit implements InitialValueProblem {
	static private double h0 = 1e-2, x0=0.994, vx0=0, y0=0, vy0=-2.001585106, Mmoon=0.012277471, Mearth=1.-Mmoon;
	static private double tolerance;

	public ArenstorfOrbit(double tol) {
		tolerance = tol;
	};
	
	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() {
		return new double[] {x0, y0, vx0, vy0};
	}

	public double D1(double x, double y) {
		double mod = Math.sqrt((x+Mearth)*(x+Mearth)+y*y);
		return mod*mod*mod;
	}
	
	public double D2(double x, double y) {
		double mod = Math.sqrt((x-Mmoon)*(x-Mmoon)+y*y);
		return mod*mod*mod;
	}
	
	@Override
	public double[] getDerivative(double time, double[] state) {
		return new double[] {
				state[2],
				state[3],
				state[0]+2*state[3]-Mmoon*(state[0]+Mearth)/D1(state[0],state[1])-Mearth*(state[0]-Mmoon)/D2(state[0],state[1]),
				state[1]-2*state[2]-Mmoon*state[1]/D1(state[0],state[1])-Mearth*state[1]/D2(state[0],state[1])
		};
	}

	public static void main(String[] args) {
		InitialValueProblem problem = new ArenstorfOrbit(2);
		RichardsonAdaptativeMethod method = new RK4Richardson(problem, h0, 1e-8, 2, tolerance);
		
		method.solve(2);
		NumericalSolutionPoint currentPoint = method.getSolution().getLastPoint();
		currentPoint.println();
		DisplaySolution.statePlot(method.getSolution(), 0, 1);
		
		FixedStepMethod rk4 = new FixedStepRK4(problem,1e-6);
		rk4.solve(5);
		currentPoint = rk4.getSolution().getLastPoint();
		currentPoint.println();
		DisplaySolution.statePlot(rk4.getSolution(), 0, 1,5000);
		
		/*FixedStepMethod eu = new FixedStepEulerMethod(problem,1e-2);
		eu.solve(2);
		currentPoint = eu.getSolution().getLastPoint();
		currentPoint.println();
		DisplaySolution.statePlot(eu.getSolution(), 0, 1,100);
        */

	}

}
