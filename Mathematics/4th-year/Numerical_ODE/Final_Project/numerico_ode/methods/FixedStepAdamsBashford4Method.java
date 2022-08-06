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
public class FixedStepAdamsBashford4Method extends FixedStepMethod {
    protected int lastStep=0;
    protected double[] auxState;
    protected double[] derivativeIm3,derivativeIm2,derivativeIm1, derivativeI;
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public FixedStepAdamsBashford4Method(InitialValueProblem problem, double step, Event e) {
        super(problem,step,e);
        auxState = problem.getInitialState();
    }

    
    public double doStep(double deltaTime, double time, double[] state) {
        super.addToEvaluationCounter(1);
        switch(lastStep) {
            case 0 : 
                derivativeIm3 = mProblem.getDerivative(time, state);
                time = rungeKuttaStep(deltaTime, time, state, derivativeIm3); 
                lastStep++;
                break;
            case 1 : 
                derivativeIm2 = mProblem.getDerivative(time, state);
                time = rungeKuttaStep(deltaTime, time, state, derivativeIm2); 
                lastStep++;
                break;
            case 2 : 
                derivativeIm1 = mProblem.getDerivative(time, state);
                time = rungeKuttaStep(deltaTime, time, state, derivativeIm1); 
                lastStep++;
                break;
            default :
                derivativeI = mProblem.getDerivative(time, state);
                time = adamsBashfordStep(deltaTime, time, state, state);
                System.arraycopy(derivativeIm2,0,derivativeIm3,0,derivativeIm2.length);
                System.arraycopy(derivativeIm1,0,derivativeIm2,0,derivativeIm2.length);
                System.arraycopy(derivativeI  ,0,derivativeIm1,0,derivativeIm2.length);
                break;
        }
        return time;
    }

    /**
     * 4-steps Adams-Bashford method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    public double adamsBashfordStep(double deltaTime, double time, double[] state, double[] newState) {
        double h24 = deltaTime/24.0;
        for (int i=0; i<state.length; i++) {
            newState[i] = state[i] + h24 * ( 55*derivativeI[i] - 59*derivativeIm1[i] + 37*derivativeIm2[i] -9*derivativeIm3[i]);
        }
        return time+deltaTime;
    }
    /**
     * Euler method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
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
        
}
