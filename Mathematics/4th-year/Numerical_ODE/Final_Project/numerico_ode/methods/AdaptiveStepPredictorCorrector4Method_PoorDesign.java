/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;


import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 * Fixed Step Euler Method
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public class AdaptiveStepPredictorCorrector4Method_PoorDesign extends AdaptiveStepMethod {
    protected int lastStep=0;
    private double mCurrentStep;
    private double mMinimumStepAllowed; // Non-convergence minimum

    protected double[] predictorState, correctorState;
    protected double[] auxState;
    protected double[] derivativeIm3,derivativeIm2,derivativeIm1, derivativeI;

    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public AdaptiveStepPredictorCorrector4Method_PoorDesign(InitialValueProblem problem, double step, Event e, double tolerance) {
        super(problem,step,e);
        super.setTolerance(tolerance);
        mCurrentStep = step;
        mMinimumStepAllowed = Math.abs(step)/1.0e6;
        predictorState = problem.getInitialState();
        correctorState = problem.getInitialState();
        auxState = problem.getInitialState();
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
            super.addToEvaluationCounter(1);
            switch(lastStep) {
                case 0 : 
                    //System.out.println ("Restarting RK: t = "+time+ " with step "+mCurrentStep+" state= "+state[0]);
                    derivativeIm3 = mProblem.getDerivative(time, state);
                    lastStep++;
                    return rungeKuttaStep(mCurrentStep, time, state, derivativeIm3); 
                case 1 : 
                    derivativeIm2 = mProblem.getDerivative(time, state);
                    lastStep++;
                    return rungeKuttaStep(mCurrentStep, time, state, derivativeIm2); 
                case 2 : 
                    lastStep++;
                    derivativeIm1 = mProblem.getDerivative(time, state);
                    return rungeKuttaStep(mCurrentStep, time, state, derivativeIm1); 
                default: break; // Do nothing
            }
            double h24 = mCurrentStep/24.0;
            // Predictor: 4-steps Adams-Bashford 
            derivativeI = mProblem.getDerivative(time, state);
            for  (int i=0; i<state.length; i++) {
                predictorState[i] = state[i] + h24 * ( 55*derivativeI[i] - 59*derivativeIm1[i] + 37*derivativeIm2[i] -9*derivativeIm3[i]);
            }
            // Corrector: 3-steps Adams-Moulton 
            super.addToEvaluationCounter(1);
            double[] derivativeIp1 = mProblem.getDerivative(time+mCurrentStep, predictorState);
            for (int i=0; i<state.length; i++) {
                correctorState[i] = state[i] + h24 * ( 9*derivativeIp1[i] + 19*derivativeI[i] -5*derivativeIm1[i] + derivativeIm2[i]);
            }
            double norm = 0;
            for (int i=0; i<state.length; i++) {
                double diffInIndex = correctorState[i]-predictorState[i];
                norm += diffInIndex*diffInIndex;
            }
            norm = Math.sqrt(norm);
            double error = 19.0*norm/270.0;
            if (error<Math.abs(mTolerance*mCurrentStep)) {
                time += mCurrentStep;
                for (int i=0; i<state.length; i++) state[i] = correctorState[i];
                mStepList.add(mCurrentStep);

                if (error < Math.abs(mTolerance * mCurrentStep) / 10) {
                    // Adapt step
                    if (norm < 1.0e-15) {
                        mCurrentStep = 2 * mCurrentStep;
                    } 
                    else {
                        double q = 1.5*Math.pow(Math.abs(mTolerance * mCurrentStep) / norm, 0.25);
                        q = Math.min(4, Math.max(q, 0.1));
                        //System.out.print ("ACCEPTED: t = "+time+ " Old step is "+mCurrentStep+ " error = "+error);
                        mCurrentStep *= q;
                        //System.out.println ("  New step is "+mCurrentStep+" state= "+state[0]);
                    }   
                    lastStep = 0;
                }
                else {
                    lastStep = 4;                
                    //System.out.println ("ACCEPTED: t = "+time+ " with step "+mCurrentStep+ " error = "+error);
                    System.arraycopy(derivativeIm2,0,derivativeIm3,0,derivativeIm2.length);
                    System.arraycopy(derivativeIm1,0,derivativeIm2,0,derivativeIm2.length);
                    System.arraycopy(derivativeI  ,0,derivativeIm1,0,derivativeIm2.length);
                }
                return time;
            }
            // Try a new smaller step
            double q = 1.5*Math.pow((Math.abs(mTolerance * mCurrentStep)) / norm, 0.25);
            q = Math.min(4, Math.max(q, 0.1));
            mCurrentStep *= q;
            //System.out.println ("REJECTED: t = "+time+ " New step is "+mCurrentStep+ " error = "+error);
            if (lastStep<4) getSolution().removeLast(3);
            NumericalSolutionPoint last = getSolution().getLastPoint();
            time = last.getTime();
            System.arraycopy(last.getState(),0,state,0,state.length);
            //System.out.println ("After removing: t = "+last.getTime()+ " state = "+last.getState()[0]);

            lastStep = 0;
        }
        // Was not able to reach tolerance before going below mMinimumStepAllowed
        return Double.NaN; 
    }
        
    protected double rungeKuttaStep(double deltaTime, double time, double[] state, double[] k1) {
        super.addToEvaluationCounter(3);
        double h2 = deltaTime/2.0;
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + h2 * k1[i];
        }
        double[] k2 = mProblem.getDerivative(time+h2, auxState);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + h2 * k2[i];
        }
        double[] k3 = mProblem.getDerivative(time+h2, auxState);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + deltaTime * k3[i];
        }
        double[] k4 = mProblem.getDerivative(time+deltaTime, auxState);
        double h6 = deltaTime/6;
        for (int i=0; i<state.length; i++) {
            state[i] += h6 * (k1[i]+2*k2[i]+2*k3[i]+k4[i]);
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
