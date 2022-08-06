/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.problems;

import numerico_ode.interpolation.StateFunction;
import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.*;
import numerico_ode.tools.DisplaySolution;

/**
 *
 * @author paco
 */


public class Taylor1DExample implements InitialValueProblem {

    static private double sTo = 0;
    static private double sYo = 0.5;

    static public class Taylor1DExample2ndOrderSolver extends FixedStepMethod {

        public Taylor1DExample2ndOrderSolver(InitialValueProblem problem, double step) {
            super(problem, step);
        }
    
        @Override
        protected double doStep(double h, double t, double[] state) {
            double wi = state[0];
            state[0] = wi +  h * ( (1+h/2.0) * (wi-t*t+1) - h*t );
            return t + h;
        }
    }

    static public class Taylor1DExample4thdOrderSolver extends FixedStepMethod {

        public Taylor1DExample4thdOrderSolver(InitialValueProblem problem, double step) {
            super(problem, step);
        }
    
        @Override
        protected double doStep(double h, double t, double[] state) {
            double wi = state[0];
            state[0] = wi +  h * ( (1 + h/2. + h*h/6. + h*h*h/24.) * (wi-t*t) - h*t * (1 + h/3. + h*h/24.) 
                                 + (1 + h/2.-h*h/6. - h*h*h/24.)) ;
            return t + h;
        }
    }
        
    // ------------------
    // Implementation of InitialValueProblem
    // ------------------

    public double getInitialTime() { 
        return sTo; 
    }
    
    public double[] getInitialState() { // x (m),vx (m/s)
        return new double[] { sYo };
    } 
    
    public double[] getDerivative(double t, double[] y) {
        return new double[] { y[0]-t*t+1 };
    }
    
    // ------------------
    // End of implementation of InitialValueProblem
    // ------------------

    
    static private class TrueSol implements StateFunction {    
        public double[] getState(double t) {
            return new double[] { (t+1)*(t+1) - 0.5*Math.exp(t) };
        }
        public double getState(double t, int index) {
            switch (index) {
                case 0 : return (t+1)*(t+1) - 0.5*Math.exp(t);
                default : return Double.NaN;
            }
        }         
    }
    
    
    public static void main(String[] args) {
        double maxTime = 2;
        double h = 0.1;
        
        Taylor1DExample problem = new Taylor1DExample();
        TrueSol sol = new TrueSol();

        FixedStepMethod taylor2Method = new Taylor1DExample2ndOrderSolver(problem,h);
        FixedStepMethod taylor4Method = new Taylor1DExample4thdOrderSolver(problem,h);
        FixedStepMethod eulerMethod     = new FixedStepEulerMethod (problem,h);
        FixedStepMethod eulerHalfMethod = new FixedStepEulerMethod (problem,h/2);

        eulerMethod.solve(maxTime);
        eulerHalfMethod.solve(maxTime);
        taylor2Method.solve(maxTime);
        taylor4Method.solve(maxTime);
        NumericalSolution extrapolated = FixedStepEulerMethod.extrapolate(eulerMethod.getSolution(),eulerHalfMethod.getSolution());

        int[] indexes = new int[]{0};
        System.out.println ("Euler h        : Max Error = "+DisplaySolution.maximumError(eulerMethod.getSolution()    , sol, indexes));
        System.out.println ("Euler h/2      : Max Error = "+DisplaySolution.maximumError(eulerHalfMethod.getSolution(), sol, indexes));
        System.out.println ("Extrapolation  : Max Error = "+DisplaySolution.maximumError(extrapolated                 , sol, indexes));
        System.out.println ("Taylor order 2 : Max Error = "+DisplaySolution.maximumError(taylor2Method.getSolution()  , sol, indexes));
        System.out.println ("Taylor order 4 : Max Error = "+DisplaySolution.maximumError(taylor4Method.getSolution()  , sol, indexes));
        //DisplaySolution.listError(taylorMethod4.getSolution(), new TrueSol(), indexes,10);

        
        if (true) {
            DisplaySolution.timePlot(taylor4Method.getSolution());
        }
    }
}
