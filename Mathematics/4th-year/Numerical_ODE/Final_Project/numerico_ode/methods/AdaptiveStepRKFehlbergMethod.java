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
public class AdaptiveStepRKFehlbergMethod extends AdaptiveStepMethod {
    private double mCurrentStep;
    private double mMinimumStepAllowed; // Non-convergence minimum
    private double[] mRK4; 
    private double[] mRK5; 
    private double[] mAux; 
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public AdaptiveStepRKFehlbergMethod(InitialValueProblem problem, double step, Event e, double tolerance) {
        super(problem,step,e);
        super.setTolerance(tolerance);
        mCurrentStep = step;
        mRK4 = problem.getInitialState();
        mRK5 = problem.getInitialState();
        mAux = problem.getInitialState();
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
        double[] k1 = mProblem.getDerivative(time, state);
        super.addToEvaluationCounter(1);
        while (Math.abs(mCurrentStep)>=mMinimumStepAllowed) {
            oneStep(time, state, k1);
            
            double error = 0;
            for (int i=0; i<state.length; i++) {
                double errorInIndex = mRK5[i]-mRK4[i];
                error += errorInIndex*errorInIndex;
            }
            error = Math.sqrt(error);
            if (error<mTolerance*Math.abs(mCurrentStep)) {
                for (int i=0; i<state.length; i++) {
                    state[i] = mRK5[i];
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
            //System.out.println ("REJECTED: t = "+time+ " New step is "+mCurrentStep+ " error = "+error);
        }
        // Was not able to reach tolerance before going below mMinimumStepAllowed
        return Double.NaN; 
    }
    
    
    
    /** Runge-Kutta-Fehlberg method implementation
     * @param time the current time
     * @param state the current state
     * @param k1 the first derivative
     * @return the value of time of the step taken, state will contain the updated state
     */
    private void oneStep(double time, double[] state, double[] k1) {
        super.addToEvaluationCounter(5);
        for (int i=0; i<state.length; i++) {
            mAux[i] = state[i] + mCurrentStep * (1.0/4.0 * k1[i]);
        }
        double[] k2 = mProblem.getDerivative(time+mCurrentStep/4.0, mAux);
        
        for (int i=0; i<state.length; i++) {
            mAux[i] = state[i] + mCurrentStep * (3.0/32.0 * k1[i] + 9.0/32.0 * k2[i]);
        }
        double[] k3 = mProblem.getDerivative(time+3.0/8.0*mCurrentStep, mAux);
        
        for (int i=0; i<state.length; i++) {
            mAux[i] = state[i] + mCurrentStep * (1932.0/2197.0 * k1[i] - 7200.0/2197.0 * k2[i] + 7296.0/2197.0 * k3[i]);
        }
        double[] k4 = mProblem.getDerivative(time+12.0/13.0*mCurrentStep, mAux);

        for (int i=0; i<state.length; i++) {
            mAux[i] = state[i] + mCurrentStep * (439.0/216.0 * k1[i] - 8.0 * k2[i] + 3680.0/513.0 * k3[i] - 845.0/4104.0 * k4[i]);
        }
        double[] k5 = mProblem.getDerivative(time+mCurrentStep, mAux);

        for (int i=0; i<state.length; i++) {
            mAux[i] = state[i] + mCurrentStep * ( - 8.0/27.0 * k1[i] + 2.0 * k2[i] - 3544.0/2565.0 * k3[i] + 1859.0/4104.0 * k4[i] - 11.0/40.0 * k5[i]);
        }
        double[] k6 = mProblem.getDerivative(time+1.0/2.0*mCurrentStep, mAux);

        for (int i=0; i<state.length; i++) {
            mRK4[i] = state[i] + mCurrentStep  * (25.0/216.0 * k1[i] + 1408.0/ 2565.0 * k3[i] + 2197.0 / 4104.0 * k4[i] - 1.0/5.0 * k5[i]);
            mRK5[i] = state[i] + mCurrentStep  * (16.0/135.0 * k1[i] + 6656.0/12825.0 * k3[i] + 28561.0/56430.0 * k4[i] - 9.0/50.0 * k5[i] + 2.0/55.0  * k6[i]);
        }
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
