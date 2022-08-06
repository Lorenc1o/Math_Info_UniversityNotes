/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;


import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;

/**
 * Fixed Step Euler Method
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public class AdaptiveStepPredictorCorrector4Method extends AdaptiveStepMethod {
    static public final int sSTEPS = 4;

    private double mCurrentStep;
    private double mMinimumStepAllowed; // Non-convergence minimum

    protected boolean mMustRestart=true;
    protected double[] mPredictorState, mCorrectorState;
    protected double[] mAuxState; // Required by the RK starter
    protected double[]   mTimes       = new double[sSTEPS-1];   // Times taken at restart
    protected double[][] mStates      = new double[sSTEPS-1][]; // ordered 2 = (i-2), 1 = (i-1) , 0 = i
    protected double[][] mDerivatives = new double[sSTEPS][];   // ordered 3 = (i-3), 2 = (i-2), 1 = (i-1) , 0 = i

    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public AdaptiveStepPredictorCorrector4Method(InitialValueProblem problem, double step, Event e, double tolerance) {
        super(problem,step,e);
        super.setTolerance(tolerance);
        mCurrentStep = step;
        mMinimumStepAllowed = Math.abs(step)/1.0e6;
        mPredictorState = problem.getInitialState();
        mCorrectorState = problem.getInitialState();
        for (int i=0; i<mStates.length; i++) mStates[i] = problem.getInitialState();
        mAuxState = problem.getInitialState();
    }

    /**
     * Extrapolated Euler method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    public double doStep(double deltaTime, double time, double[] state) {
        while (Math.abs(mCurrentStep)>=mMinimumStepAllowed) {
            double h24 = mCurrentStep/24.0;
            double currentTime=time;
            double[] currentState=state;
            if (mMustRestart) {
                restartMethod(time, state);
                currentTime  = mTimes[0];
                currentState = mStates[0];
            }
            // Predictor: 4-steps Adams-Bashford 
            super.addToEvaluationCounter(1);
            mDerivatives[0] = mProblem.getDerivative(currentTime, currentState);
            for  (int i=0; i<state.length; i++) {
                mPredictorState[i] = currentState[i] + h24 * ( 55*mDerivatives[0][i] - 59*mDerivatives[1][i] + 37*mDerivatives[2][i] -9*mDerivatives[3][i]);
            }
            // Corrector: 3-steps Adams-Moulton 
            super.addToEvaluationCounter(1);
            double[] derivativeIp1 = mProblem.getDerivative(currentTime+mCurrentStep, mPredictorState);
            for (int i=0; i<state.length; i++) {
                mCorrectorState[i] = currentState[i] + h24 * ( 9*derivativeIp1[i] + 19*mDerivatives[0][i] -5*mDerivatives[1][i] + mDerivatives[2][i]);
            }
            double norm = 0;
            for (int i=0; i<state.length; i++) {
                double diffInIndex = mCorrectorState[i]-mPredictorState[i];
                norm += diffInIndex*diffInIndex;
            }
            norm = Math.sqrt(norm);
            double error = 19.0*norm/270.0;
            double maxErrorAllowed = mTolerance*Math.abs(mCurrentStep);
            if (error<maxErrorAllowed) {
                time = currentTime + mCurrentStep;
                System.arraycopy(mCorrectorState,0,state,0,state.length);
                mStepList.add(mCurrentStep);
                if (mMustRestart) { // Add the starting steps
                    // This is somewhat unique. The first doStep() method that adds points to the solution by itself
                    for (int i=mStates.length-1; i>=0; i--) getSolution().add(mTimes[i], mStates[i]);
                    //System.out.println ("FOUR POINTS ADDED from  t = "+mTimes[2]+ " to t =  "+time);
                }
                
                if (error < maxErrorAllowed*0.1) { // error is really small --> adapt step
                    if (norm < 1.0e-16) { // Prevent division by zero
                        mCurrentStep = 2 * mCurrentStep;
                    } 
                    else {
                        double q = 1.5*Math.pow(maxErrorAllowed/norm, 0.25);
                        q = Math.min(4, q); // Do not grow too much
                        //System.out.print ("ACCEPTED: t = "+time+ " Old step is "+mCurrentStep+ " error = "+error);
                        mCurrentStep *= q;
                        //System.out.println ("  New step is "+mCurrentStep+" state= "+state[0]);
                    }   
                    mMustRestart = true;
                }
                else {
                    //System.out.println ("ACCEPTED: t = "+time+ " with step "+mCurrentStep+ " error = "+error);
                    for (int i=mDerivatives.length-1; i>0; i--) // Prepare next step
                        System.arraycopy(mDerivatives[i-1],0,mDerivatives[i],0,state.length);
                    mMustRestart = false;
                }
                return time;
            }
            // Try a new smaller step
            double q = 1.5*Math.pow(maxErrorAllowed/norm, 0.25);
            q = Math.max(q, 0.1); // Do not shrink too much
            mCurrentStep *= q;
            //System.out.println ("REJECTED: t = "+time+ " New step is "+mCurrentStep+ " error = "+error);
            mMustRestart = true;
        }
        // Was not able to reach tolerance before going below mMinimumStepAllowed
        return Double.NaN; 
    }

    protected void restartMethod(double time, double[] state) {
        //System.out.println ("Restarting RK: t = "+time+ " with step "+mCurrentStep+" state= "+state[0]);
        mDerivatives[3] = mProblem.getDerivative(time, state);
        mTimes[2] = rungeKuttaStep(mCurrentStep, time, state, mStates[2], mDerivatives[3]);
        
        mDerivatives[2] = mProblem.getDerivative(mTimes[2], mStates[2]);
        mTimes[1] = rungeKuttaStep(mCurrentStep, mTimes[2], mStates[2], mStates[1], mDerivatives[2]);
        
        mDerivatives[1] = mProblem.getDerivative(mTimes[1], mStates[1]);
        mTimes[0] = rungeKuttaStep(mCurrentStep, mTimes[1], mStates[1], mStates[0], mDerivatives[1]);
        // Yes, one could write this using a for loop...
    }

    
    protected double rungeKuttaStep(double deltaTime, double time, double[] state, double[] newState, double[] k1) {
        super.addToEvaluationCounter(3);
        double h2 = deltaTime/2.0;
        for (int i=0; i<state.length; i++) {
            mAuxState[i] = state[i] + h2 * k1[i];
        }
        double[] k2 = mProblem.getDerivative(time+h2, mAuxState);
        for (int i=0; i<state.length; i++) {
            mAuxState[i] = state[i] + h2 * k2[i];
        }
        double[] k3 = mProblem.getDerivative(time+h2, mAuxState);
        for (int i=0; i<state.length; i++) {
            mAuxState[i] = state[i] + deltaTime * k3[i];
        }
        double[] k4 = mProblem.getDerivative(time+deltaTime, mAuxState);
        double h6 = deltaTime/6;
        for (int i=0; i<state.length; i++) {
            newState[i] = state[i] + h6 * (k1[i]+2*k2[i]+2*k3[i]+k4[i]);
        }
        return time+deltaTime;
    }

	@Override
	double makeStep(double step, double time, double[] state) {
		super.addToEvaluationCounter(4);
        double h2 = step/2.0;
        double[] auxState = new double[state.length];
        double[] k1 = mProblem.getDerivative(time, state);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + h2 * k1[i];
        }
        double[] k2 = mProblem.getDerivative(time+h2, auxState);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + h2 * k2[i];
        }
        double[] k3 = mProblem.getDerivative(time+h2, auxState);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + step * k3[i];
        }
        double[] k4 = mProblem.getDerivative(time+step, auxState);
        double h6 = step/6;
        for (int i=0; i<state.length; i++) {
            state[i] += h6 * (k1[i]+2*k2[i]+2*k3[i]+k4[i]);
        }
        return time+step;
	}
    
}
