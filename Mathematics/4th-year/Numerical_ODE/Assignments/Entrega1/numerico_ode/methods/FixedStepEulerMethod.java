/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import numerico_ode.ode.InitialValueProblem;

/**
 * Fixed Step Euler Method
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public class FixedStepEulerMethod extends FixedStepMethod {
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public FixedStepEulerMethod(InitialValueProblem problem, double step) {
        super(problem,step);
    }

    /**
     * Euler method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    protected double doStep(double deltaTime, double time, double[] state) {
        double[] derivative = mProblem.getDerivative(time, state);
        for (int i=0; i<state.length; i++) {
            state[i] = state[i] + deltaTime * derivative[i];
        }
        return time+deltaTime;
    }
    
}
