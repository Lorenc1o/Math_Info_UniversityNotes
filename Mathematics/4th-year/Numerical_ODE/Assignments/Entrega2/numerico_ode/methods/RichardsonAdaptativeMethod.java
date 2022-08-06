package numerico_ode.methods;

import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;

public abstract class RichardsonAdaptativeMethod {
	protected InitialValueProblem mProblem;
    protected double mStep, mMinStep, mMaxStep, tolerance;
    protected NumericalSolution mSolution;
    protected long mEvaluationCounter = 0;
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the initial step to take. If negative, we'd solve backwards in time
     * @param minStep the minimum absolute value of the step we'd use
     * @param maxStep the maximum absolute value of the step we'd use
     */
    protected RichardsonAdaptativeMethod(InitialValueProblem problem, double step, double minStep, double maxStep, double tol) {
        mProblem = problem;
        mStep = step;
        mMinStep = minStep;
        mMaxStep = maxStep;
        tolerance = Math.abs(tol);
        mSolution = new NumericalSolution(problem);
    }
    
    /**
     * Particular method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    abstract protected double doStep(double deltaTime, double time, double[] state);
    
    /**
     * Get the step
     * @return the initial step given
     */
    public double getStep() {
        return mStep;
    }
    
    /**
     * Steps the problem once
     * @return the newly computed solution point, null if there was any error
     */
    public NumericalSolutionPoint step() {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint();
        double time = lastPoint.getTime();
        double[] state = lastPoint.getState();
        time = doStep(mStep,time,state);
        if (Double.isNaN(time)) return null;
        return mSolution.add(time, state);
    }
    
    
    public double norm(double[] v) {
    	double sum=0;
    	for(int i=0; i<v.length; i++) sum+=v[i]*v[i];
    	return Math.sqrt(sum);
    }
    
    public double[] substract(double[] a, double[] b) {
    	double[] ret = a.clone();
    	for(int i=0; i<a.length; i++) ret[i]-=b[i];
    	return ret;
    }
    /**
     * Iteratively steps the problem until time equals or exceeds finalTime
     * @param finalTime the time which we want to reach or exceed
     * @return the actual time of the last computed solution point (may differ -exceed- the requested finalTime).
     * returns NaN if there was any error in the solving
     */
    public double solve(double finalTime) {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint();
        double time = lastPoint.getTime();
        double time2, timeaux;
        double[] state = lastPoint.getState();
        double[] state2, stateAux;
        if (mStep>0) {
            while (time<finalTime) {
            	time2=time;
            	timeaux=time;
            	state2=state.clone();
            	stateAux=state.clone();
                time = doStep(mStep,time,state);
                time2 = doStep(mStep/2.,time2,state2);
                if (Double.isNaN(time) || Double.isNaN(time2)) return Double.NaN;
                double error = 16/15*norm(substract(state, state2));
                /*for(int i=0; i<state.length;i++) {
                	System.out.println("yh ["+i+"]="+state[i]);
                }
                for(int i=0; i<state.length;i++) {
                	System.out.println("yh/2 ["+i+"]="+state2[i]);
                }*/
                System.out.println("error=" +error+ " tol*h= "+tolerance*mStep);
                if(error<tolerance*mStep) {
                	for(int i=0; i<state.length; i++) {
                		state[i] = (16*state2[i]-state[i])/15.;
                	}
                	mSolution.add(time,state);
                } else {
                	double q = Math.sqrt((tolerance*mStep)/(2*error));
                	q = Math.sqrt(q); 
                	q = Math.min(4,Math.max(q,0.1));
                	mStep = q*mStep;
                	state = stateAux;
                	time = timeaux;
                }
                
                if (mStep < mMinStep) return Double.NaN;
                if (mStep > mMaxStep) mStep = mMaxStep;
            }
        } 
        else if (mStep<0) {
            while (time>finalTime) {
                time = doStep(mStep,time,state);
                if (Double.isNaN(time)) return Double.NaN;
                mSolution.add(time, state);
            }
        } // does nothing if mStep = 0
        return time;
    }
    
    /**
     * Gets the solution computed so far
     * @return an instance of NumericalSolution
     */
    public NumericalSolution getSolution() { return mSolution; }
    
    public void resetEvaluationCounter() { 
        mEvaluationCounter = 0;
    }
    
    public long getEvaluationCounter() {
        return mEvaluationCounter;
    }

    protected void addToEvaluationCounter(int add) {
        mEvaluationCounter += add;
    }
}
