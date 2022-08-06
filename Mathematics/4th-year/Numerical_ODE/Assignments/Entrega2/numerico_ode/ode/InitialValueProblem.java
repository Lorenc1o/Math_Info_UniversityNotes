/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.ode;

/**
 * Interface for an InitialValueProblem of Ordinary Differential Equations
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public interface InitialValueProblem {
    
    /**
     * The initial value of time (independent variable)
     * @return 
     */
    public double getInitialTime();
    
    /**
     * The initial value of the state
     * @return a newly created array with a copy of the initial state
     */
    public double[] getInitialState();
    
    /**
     * Computes the derivative f(t,Y(t)) that defines the ODE
     * @param time the given time
     * @param state the given state
     * @return a newly created array with the value of the derivative
     */
    public double[] getDerivative(double time, double[] state);
    
}
