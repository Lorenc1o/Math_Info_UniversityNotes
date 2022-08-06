package numerico_ode.ode;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.interpolation.StateFunction;
import numerico_ode.tools.BisectionMethod;

public abstract class Event {
	protected double tolerance;
	protected boolean stopComputation = false;
	protected int importantIndex;
	
	public Event(double tol, int index) {
		tolerance=tol;
		importantIndex = index;
	}
	
	abstract public double crossFunction(double t, double[] state);
	
	public double crossFunction(NumericalSolutionPoint p) {
		return crossFunction(p.getTime(), p.getState());
	}
	
	public boolean crossed(double t1, double t2, double[] state1, double[] state2) {
		if(crossFunction(t1, state1)*crossFunction(t2, state2) < 0) return true;
		return false;
	}
	
	public abstract void action(double crossingTime, double[] crossingPoint);
	
	public NumericalSolutionPoint getCrossingPoint(NumericalSolution sol, NumericalSolutionPoint p1, NumericalSolutionPoint p2, InterpolatorFunction interpolator) {
		double zeroAt = BisectionMethod.findZero2(sol, this, interpolator, p1, p2, importantIndex, tolerance);
        if (Double.isNaN(zeroAt)) {
            return null;
        }
        else {
            return sol.getSolutionAt(zeroAt, interpolator, tolerance, 100);

        }
	}
	
	public boolean get_stopComputation() {
		return stopComputation;
	}
	
	public void reset_stopComputation() {
		stopComputation = false;
	}
}
