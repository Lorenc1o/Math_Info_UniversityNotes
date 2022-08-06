/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;

/**
 * Fixed Step Modified Euler Method
 * 
 * @author F. Esquembre
 * @version November 2020
 */
public class FixedStepModifiedEulerMethod extends FixedStepMethod {
    
    private double[] auxState;

    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    public FixedStepModifiedEulerMethod(InitialValueProblem problem, double step, Event e) {
        super(problem,step,e);
        auxState = problem.getInitialState();
    }

    /**
     * Modified Euler method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    public double doStep(double deltaTime, double time, double[] state) {
        super.addToEvaluationCounter(2);
        double h2 = deltaTime/2.0;
        double[] derivative = mProblem.getDerivative(time, state);
        for (int i=0; i<state.length; i++) {
            auxState[i] = state[i] + deltaTime * derivative[i];
        }
        double[] derivative2 = mProblem.getDerivative(time+deltaTime, auxState);
        for (int i=0; i<state.length; i++) {
            state[i] += h2 * (derivative[i]+derivative2[i]);
        }
        return time+deltaTime;
    }
        
}
