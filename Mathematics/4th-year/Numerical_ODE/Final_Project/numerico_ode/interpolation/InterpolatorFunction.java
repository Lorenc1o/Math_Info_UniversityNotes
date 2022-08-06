package numerico_ode.interpolation;

import numerico_ode.ode.NumericalSolutionPoint;

public abstract class InterpolatorFunction implements StateFunction {
	protected double h;
	protected NumericalSolutionPoint before, after;
	protected double tolerance;
	
	abstract public NumericalSolutionPoint getSolutionPoint(double time);
	
	abstract public NumericalSolutionPoint getMiddlePoint();
	
	abstract public double[] getState(double time);

    abstract public double getState(double time, int index);
    
    public void setStates(NumericalSolutionPoint bef, NumericalSolutionPoint aft) {
    	before = bef;
    	after = aft;
    }
    
    public void setBefore(NumericalSolutionPoint bef) {
    	before = bef;
    }
    
    public void setAfter(NumericalSolutionPoint aft) {
    	after = aft;
    }
    
    public void setTolerance(double tol) {
    	tolerance = tol;
    }
}
