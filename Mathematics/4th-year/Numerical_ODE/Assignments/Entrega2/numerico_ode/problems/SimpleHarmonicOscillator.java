/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.problems;

import numerico_ode.interpolation.StateFunction;
import numerico_ode.interpolation.*;
import numerico_ode.methods.*;
import numerico_ode.ode.*;
import numerico_ode.tools.*;

/**
 *
 * @author paco
 */
public class SimpleHarmonicOscillator implements InitialValueProblem {
    static private double l = 0.7;
    static private double m = 1.0;
    static private double k = 1.5;

    static private double b = 0.; // 0.3
    static private double amp = 0.; // 0.4
    static private double freq = 1.3; // 2.4
    
    static private double Xo = 1.5;
    static private double Vo = 0;

    private long mEvaluations = 0L;
    
    public SimpleHarmonicOscillator() { }
    
    private double force(double time) {
        return amp*Math.sin(freq*time);
    }
    // ------------------
    // Implementation of InitialValueProblem
    // ------------------

    public double getInitialTime() { 
        return 0; 
    }
    
    public double[] getInitialState() { // x (m),vx (m/s)
        return new double[] { Xo, Vo };
    } 
    
    public double[] getDerivative(double t, double[] x) {
        mEvaluations++;
        return new double[] { x[1], 
                              -k/m * (x[0]-l) - b/m*x[1] + force(t)/m, 
                              };
    }

    public long getEvaluationCounter() {
        return mEvaluations;
    }
    public void resetEvaluationCounter() {
        mEvaluations = 0;
    }
    
    // ------------------
    // End of implementation of InitialValueProblem
    // ------------------

    
    static private class TrueSol implements StateFunction {
            static double Fo = Math.sqrt(k/m);
            
            public double[] getState(double time) {
                return new double[] { (Xo-l)*Math.cos(Fo*time) + l, 
                                      -Fo*(Xo-l)*Math.sin(Fo*time) };
            }
            public double getState(double time, int index) {
                switch (index) {
                    case 0 : return (Xo-l)*Math.cos(Fo*time)+l;
                    case 1 : return -Fo*(Xo-l)*Math.sin(Fo*time);
                    default : return Double.NaN;
                }
            }
                

    }
    
    

    
    public static void main(String[] args) {
        SimpleHarmonicOscillator shoProblem = new SimpleHarmonicOscillator();
        //FixedStepMethod method = new FixedStepEulerMethod(shoProblem,1.0e-4);

        double maxTime = 40;
        double tolerance = 1.0e-2;
        double initialStep = 0.1;
        
        NumericalSolution solution = FixedStepEulerMethod.extrapolateToTolerance(shoProblem, maxTime, 
                                                                        tolerance, initialStep, 1.0e-6);
        TrueSol sol = new TrueSol();
        
        int[] indexes = new int[]{0};
        double hStep = solution.getFirstStep();
        System.out.println ("Solution accepted for h = "+hStep);
        System.out.println ("Evaluations = "+shoProblem.getEvaluationCounter()+"\n");
        shoProblem.resetEvaluationCounter();

        FixedStepMethod method = new FixedStepEulerMethod(shoProblem,hStep);
        method.solve(maxTime);
        System.out.println ("Max Error for h ("+hStep+") is "+DisplaySolution.maximumError(method.getSolution(), sol, indexes));
        FixedStepMethod method2 = new FixedStepEulerMethod(shoProblem,hStep/2);
        method2.solve(maxTime);
        System.out.println ("Max Error for h/2 ("+hStep/2+")is "+DisplaySolution.maximumError(method2.getSolution(), sol, indexes));
        System.out.println ("Max Error for extrapolation is "+DisplaySolution.maximumError(solution, sol, indexes));
        System.out.println ("Evaluations = "+shoProblem.getEvaluationCounter()+"\n");
        DisplaySolution.listError(solution, new TrueSol(), indexes,10);

        
        if (false) {

            DisplaySolution.statePlot(solution, 0, 1, 10);
            DisplaySolution.timePlot(solution, indexes, 10);
//            DisplaySolution.timePlot(solution);
        }
    }
}
