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
        
        boolean[] crossed = {false, false};
        double[] times = new double[2];
        Event shoEvent = new Event(1e-5, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return state[0];
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				if(!crossed[0]) {
					times[0] = crossingTime;
					crossed[0]=true;
				}else if(!crossed[1]) crossed[1] = true;
				else {
					times[1] = crossingTime;
					System.out.println("The period is " + (times[1] - times[0]));
					stopComputation = true;
				}
				
			}
        	
        };

        double maxTime = 40;
        double tolerance = 1.0e-2;
        double initialStep = 0.1;
        
//        NumericalSolution solution = FixedStepEulerMethod.extrapolateToTolerance(shoProblem, maxTime, 
//                                                                        tolerance, initialStep, 1.0e-6);
        TrueSol sol = new TrueSol();
        
        int[] indexes = new int[]{0};
        double hStep;
//        hStep = solution.getFirstStep();
//        System.out.println ("Solution accepted for h = "+hStep);
//        System.out.println ("Evaluations = "+shoProblem.getEvaluationCounter()+"\n");
//        shoProblem.resetEvaluationCounter();
        
        
        hStep = 1e-5;
        FixedStepMethod method = new FixedStepEulerMethod(shoProblem,hStep,shoEvent);
        method.solve(maxTime);
        System.out.println ("Max Error for h ("+hStep+") is "+DisplaySolution.maximumError(method.getSolution(), sol, indexes));
//        FixedStepMethod method2 = new FixedStepEulerMethod(shoProblem,hStep/2);
//        method2.solve(maxTime);
//        System.out.println ("Max Error for h/2 ("+hStep/2+")is "+DisplaySolution.maximumError(method2.getSolution(), sol, indexes));
//        System.out.println ("Max Error for extrapolation is "+DisplaySolution.maximumError(solution, sol, indexes));
//        System.out.println ("Evaluations = "+shoProblem.getEvaluationCounter()+"\n");
//        DisplaySolution.listError(solution, new TrueSol(), indexes,10);

        NumericalSolution solution = method.getSolution();
        if (true) {

            DisplaySolution.statePlot(solution, 0, 1, 1000);
            DisplaySolution.timePlot(solution, indexes, 1000);
//            DisplaySolution.timePlot(solution);
        }
    }

	@Override
	public double[] getPartialDerivative(double time, double[] state) {
		// TODO Auto-generated method stub
		return null;
	}
}
