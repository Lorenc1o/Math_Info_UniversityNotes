package numerico_ode.methods;

import java.util.LinkedList;

import javax.xml.bind.JAXBException;

import org.xml.sax.SAXException;

import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySequence;

public class RKFMethod{

	protected InitialValueProblem mProblem;
    protected double mStep, mMinStep, mMaxStep, tolerance;
    protected NumericalSolution mSolution;
    protected long mEvaluationCounter = 0;
    protected int k;
    protected LinkedList<Double> steps;
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the initial step to take. If negative, we'd solve backwards in time
     * @param minStep the minimum absolute value of the step we'd use
     * @param maxStep the maximum absolute value of the step we'd use
     */
    public RKFMethod(InitialValueProblem problem, double step, double minStep, double maxStep, double tol) {
        mProblem = problem;
        mStep = step;
        mMinStep = minStep;
        mMaxStep = maxStep;
        tolerance = Math.abs(tol);
        mSolution = new NumericalSolution(problem);
        k = 4;
        steps = new LinkedList<Double>();
    }

	public double[] doStep(double deltaTime, double time, double[] state) {
		double[] ret = new double[3];
		double[] k1 = mProblem.getDerivative(time, state);
		k1 = scale(k1, deltaTime);
		
		double[] stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.25*k1[i];
		double[] k2 = mProblem.getDerivative(time + 0.25*deltaTime, stateAux);
		k2 = scale(k2, deltaTime);
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.09375*k1[i]+0.28125*k2[i];
		double[] k3 = mProblem.getDerivative(time + 0.375*deltaTime, stateAux);
		k3 = scale(k3, deltaTime);
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.8793809741*k1[i]-3.277196177*k2[i]+3.320892126*k3[i];
		double[] k4 = mProblem.getDerivative(time + 12./13.*deltaTime, stateAux);
		k4 = scale(k4, deltaTime);
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 439./216.*k1[i]-8*k2[i]+3680./513.*k3[i]-845./4104.*k4[i];
		double[] k5 = mProblem.getDerivative(time + deltaTime, stateAux);
		k5 = scale(k5, deltaTime);
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += -8./27.*k1[i]+2*k2[i]-3544./2565.*k3[i]+1859./4104.*k4[i]-0.275*k5[i];
		double[] k6 = mProblem.getDerivative(time + 0.5*deltaTime, stateAux);
		k6 = scale(k6, deltaTime);
		
        addToEvaluationCounter(6);
        for (int i=0; i<state.length; i++) {
            state[i] = state[i] + 25./216.*k1[i] + 1408./2565.*k3[i] + 2197./4104.*k4[i] - 0.2*k5[i];
        }
        
        double R = getR(k1,k3,k4,k5,k6)/Math.abs(deltaTime);
        
        
        ret[0] = time + deltaTime;
    	double q = Math.pow(0.84*(tolerance/R),0.25);
    	q = Math.min(4,Math.max(q,0.1));
    	ret[1] = Math.min(deltaTime*q,mMaxStep);
    	ret[2] = 0; //0 for not accepted
        if(R <= tolerance) {
        	ret[2] = 1; //1 for accepted, 0 for not accepted
        }
        steps.add(ret[1]);
        return ret;
	}    
    
    public double norm(double[] v) {
    	double sum=0;
    	for(int i=0; i<v.length; i++) sum+=v[i]*v[i];
    	return Math.sqrt(sum);
    }
    
    public double[] scale(double[] a, double s) {
    	double[] ret = a.clone();
    	for(int i=0; i<a.length; i++) ret[i]*=s;
    	return ret;
    }
    
    public double[] sum(double[] a, double[] b) {
    	double[] ret = a.clone();
    	for(int i=0; i<a.length; i++) ret[i] += b[i];
    	return ret;
    }
    
    public double[] subtract(double[] a, double[] b) {
    	double[] ret = a.clone();
    	for(int i=0; i<a.length; i++) ret[i]-=b[i];
    	return ret;
    }
    
    public double getR(double[] k1, double[] k3, double[] k4, double[] k5, double[] k6) {
    	return (norm(sum(
    					sum(subtract(subtract(scale(k1,1./360.),
    										scale(k3,128./4275.)),
    								scale(k4, 2197./75240.)),
    						scale(k5, 0.02)),
    					scale(k6,2./55.))));
    }
    
    public NumericalSolutionPoint step() {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint();
        double[] time = new double[3];
        double t = lastPoint.getTime();
        double[] state = lastPoint.getState();
        double[] stateaux = state.clone();
        do {
        	state = stateaux;
        	stateaux = state.clone();
        	time = doStep(mStep,t,state);
        	mStep = time[1];
        	if (Double.isNaN(time[0])) return null;
        }while(time[2] != 1);
        mStep = time[1];
        return mSolution.add(time[0], state);
    }
    
    /**
     * Iteratively steps the problem until time equals or exceeds finalTime
     * @param finalTime the time which we want to reach or exceed
     * @return the actual time of the last computed solution point (may differ -exceed- the requested finalTime).
     * returns NaN if there was any error in the solving
     */
    public double solve(double finalTime) {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint();
        double[] time = new double[3];
        time[0] = lastPoint.getTime();
        double[] timeaux;
        double[] state = lastPoint.getState();
        double[] stateAux;
        if (mStep>0) {
            while (time[0]<finalTime) {
            	stateAux = state.clone();
                timeaux = doStep(mStep,time[0],state);
                if (Double.isNaN(timeaux[0])) return Double.NaN;
                if(timeaux[2] == 1) {
                	mSolution.add(timeaux[0],state);
                	time = timeaux;
                } else {
                	state = stateAux;
                }
            	mStep = timeaux[1];
            	
                if (mStep < mMinStep) return Double.NaN;
                if (mStep > mMaxStep) mStep = mMaxStep;
                
            }
        } 
        else if (mStep<0) {
        	while (time[0]>finalTime) {
            	stateAux = state.clone();
                timeaux = doStep(mStep,time[0],state);
                if (Double.isNaN(timeaux[0])) return Double.NaN;
                if(timeaux[2] == 1) {
                	mSolution.add(timeaux[0],state);
                	time = timeaux;
                } else {
                	state = stateAux;
                }
            	mStep = timeaux[1];
            	
                if (mStep < mMinStep) return Double.NaN;
                if (mStep > mMaxStep) mStep = mMaxStep;
                
            }
        } // does nothing if mStep = 0
        return time[0];
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
    
    public void stepEvol(int skip) {
			DisplaySequence.plotList(steps, skip);
    }

}
