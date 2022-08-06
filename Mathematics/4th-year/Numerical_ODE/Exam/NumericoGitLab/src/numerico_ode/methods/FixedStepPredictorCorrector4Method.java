/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;

/**
 * Fixed Step 4-steps Adams-Bashford Method
 * 
 * @author F. Esquembre
 * @version November 2020
 */
public class FixedStepPredictorCorrector4Method extends FixedStepAdamsBashford4Method {
    protected double[] predictorState;
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public FixedStepPredictorCorrector4Method(InitialValueProblem problem, double step, Event e) {
        super(problem,step,e);
        predictorState = problem.getInitialState();
    }

    
    public double doStep(double deltaTime, double time, double[] state) {
        super.addToEvaluationCounter(1);
        switch(lastStep) {
            case 0 : 
                derivativeIm3 = mProblem.getDerivative(time, state);
                time = super.rungeKuttaStep(deltaTime, time, state, derivativeIm3); 
                lastStep++;
                break;
            case 1 : 
                derivativeIm2 = mProblem.getDerivative(time, state);
                time = super.rungeKuttaStep(deltaTime, time, state, derivativeIm2); 
                lastStep++;
                break;
            case 2 : 
                derivativeIm1 = mProblem.getDerivative(time, state);
                time = super.rungeKuttaStep(deltaTime, time, state, derivativeIm1); 
                lastStep++;
                break;
            default :
                derivativeI = mProblem.getDerivative(time, state);
                adamsBashfordStep(deltaTime, time, state, predictorState);
                time = adamsMoultonStep(deltaTime, time, state, state);
                System.arraycopy(derivativeIm2,0,derivativeIm3,0,derivativeIm2.length);
                System.arraycopy(derivativeIm1,0,derivativeIm2,0,derivativeIm2.length);
                System.arraycopy(derivativeI  ,0,derivativeIm1,0,derivativeIm2.length);
                break;
        }
        return time;
    }
        
    /**
     * 3-steps Adams-Moulton method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    public double adamsMoultonStep(double deltaTime, double time, double[] state, double[] newState) {
        super.addToEvaluationCounter(1);
        double[] derivativeIp1 = mProblem.getDerivative(time, predictorState);
        double h24 = deltaTime/24.0;
        for (int i=0; i<state.length; i++) {
            newState[i] = state[i] + h24 * ( 9*derivativeIp1[i] + 19*derivativeI[i] -5*derivativeIm1[i] + derivativeIm2[i]);
        }
        return time+deltaTime;
    }
}
