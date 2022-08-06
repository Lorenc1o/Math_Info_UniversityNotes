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
public class AdaptiveStepRK4Method extends AdaptiveStepMethod {
    private double mCurrentStep;
    private double mMinimumStepAllowed; // Non-convergence minimum
    private double[] mHalfStepState;
    private double[] mHalfStepCompleteState;
    private double[] mFullStepState; 
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public AdaptiveStepRK4Method(InitialValueProblem problem, double step, Event e, double tolerance) {
        super(problem,step,e);
        super.setTolerance(tolerance);
        mCurrentStep = step;
        mHalfStepState = problem.getInitialState();
        mHalfStepCompleteState = problem.getInitialState();
        mFullStepState = problem.getInitialState();
        mMinimumStepAllowed = Math.abs(step)/1.0e6;
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
            double halfStep = mCurrentStep/2;
            oneStep(mCurrentStep, time,          state,          mFullStepState);
            oneStep(halfStep,     time,          state,          mHalfStepState);
            oneStep(halfStep,     time+halfStep, mHalfStepState, mHalfStepCompleteState);
            
            double error = 0;
            for (int i=0; i<state.length; i++) {
                double errorInIndex = mHalfStepCompleteState[i]-mFullStepState[i];
                error += errorInIndex*errorInIndex;
            }
            error = 16.0*Math.sqrt(error)/15.0;
            if (error<mTolerance*Math.abs(mCurrentStep)) {
                for (int i=0; i<state.length; i++) {
                    //state[i] = mHalfStepCompleteState[i]; 
                    state[i] = (16.0*mHalfStepCompleteState[i] - mFullStepState[i])/15.0;
                }
                time += mCurrentStep;
                mStepList.add(mCurrentStep);
                // Adapt step
                if (error<1.0e-10) mCurrentStep = 2*mCurrentStep;
                else {
                    double q = Math.pow((mTolerance*Math.abs(mCurrentStep))/(2.0*error),0.25);
                    q = Math.min(4, Math.max(q, 0.1));
                    mCurrentStep *= q;
                }
                //System.out.println ("ACCEPTED: t = "+time+ " New step is "+mCurrentStep+ " error = "+error);
                return time;
            }
            // Try a new smaller step
            double q = Math.pow((mTolerance*Math.abs(mCurrentStep))/(2.0*error),0.25);
            q = Math.min(4, Math.max(q, 0.1));
            mCurrentStep *= q;
            System.out.println ("REJECTED: t = "+time+ " New step is "+mCurrentStep+ " error = "+error);
        }
        // Was not able to reach tolerance before going below mMinimumStepAllowed
        return Double.NaN; 
    }
    
    
    
    /**
     * RK4 method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    private double oneStep(double deltaTime, double time, double[] state, double[] finalState) {
        super.addToEvaluationCounter(4);
        double h2 = deltaTime/2.0;
        double[] k1 = mProblem.getDerivative(time, state);
        for (int i=0; i<state.length; i++) {
            finalState[i] = state[i] + h2 * k1[i];
        }
        double[] k2 = mProblem.getDerivative(time+h2, finalState);
        for (int i=0; i<state.length; i++) {
            finalState[i] = state[i] + h2 * k2[i];
        }
        double[] k3 = mProblem.getDerivative(time+h2, finalState);
        for (int i=0; i<state.length; i++) {
            finalState[i] = state[i] + deltaTime * k3[i];
        }
        double[] k4 = mProblem.getDerivative(time+deltaTime, finalState);
        h2 = deltaTime/6;
        for (int i=0; i<state.length; i++) {
            finalState[i] = state[i] + h2 * (k1[i]+2*k2[i]+2*k3[i]+k4[i]);
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
