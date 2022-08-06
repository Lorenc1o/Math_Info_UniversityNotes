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
public class ParabolicThrowWithFriction implements InitialValueProblem {
    static private double mGravity = 9.8;

    private final double mFrictionCoefficient;
    private final double mMass = 1;
    
    private final double constant;
    
    public ParabolicThrowWithFriction(double coefficient) {
        mFrictionCoefficient = coefficient;
        constant = mFrictionCoefficient/mMass;
    }
    // ------------------
    // Implementation of InitialValueProblem
    // ------------------

    public double getInitialTime() { 
        return 0; 
    }
    
    public double[] getInitialState() { // x,vx, y,vy (m/s)
        return new double[] { 0, 100, 300, 0 };
    } 
    
    public double[] getDerivative(double t, double[] x) {
        double speed = Math.sqrt(x[1]*x[1]+x[3]*x[3]);
        return new double[] { x[1], -constant * x[1] * speed, 
                              x[3], -constant * x[3] * speed - mGravity };
    }

    // ------------------
    // End of implementation of InitialValueProblem
    // ------------------

    
    static private class TrueSol implements StateFunction {
            public double[] getState(double time) {
                return new double[] { 100*time, 100, 300 - 0.5*mGravity*time*time, -mGravity};
            }
            public double getState(double time, int index) {
                switch (index) {
                    case 0 : return 100*time;
                    case 1 : return 100;
                    case 2 : return 300 - 0.5*mGravity*time*time;
                    case 3 : return -mGravity;
                    default : return Double.NaN;
                }
            }
                
            public double yZeroAt() {
                return Math.sqrt(2*300/mGravity);
            }

    }
    
    
    public static void main(String[] args) {
        InitialValueProblem problem = new ParabolicThrowWithFriction(0.0);
        
        Event parabolicEvent = new Event(1e-2, 2) {

    		@Override
    		public double crossFunction(double t, double[] state) {
    			return state[2];
    		}

    		@Override
    		public void action(double crossingTime, double[] crossingPoint) {
    			System.out.println("Impact!! At time "+crossingTime);
    			this.stopComputation = true;
    		}
        	
        };
        
        FixedStepMethod method = new FixedStepEulerMethod(problem,1.0e-2, parabolicEvent);
        method = new AdaptiveStepEulerMethod(problem, 1e-2, 1e-3, parabolicEvent);
        method = new AdaptiveStepRKFehlbergMethod(problem, 1e-2, parabolicEvent, 1e-6);
        FixedStepMethod method1 = new AdaptiveStepPredictorCorrector4Method(problem, 1e-2, parabolicEvent, 1e-3);
        
        NumericalSolutionPoint previousPoint, currentPoint;
        
        //method1.solve(15);
        if (true) method1.solve(8);
        else { 
            previousPoint = currentPoint = method.getSolution().getLastPoint();
            while (currentPoint.getState(2)>0) {
                previousPoint = currentPoint;
                currentPoint = method.step();
            }
            previousPoint.println();
            currentPoint.println();
        }
        
        TrueSol sol = new TrueSol();
        if (false) { // find zero
            StateFunction interpolator = new EulerMethodInterpolator(problem, previousPoint);
            double zeroYAt = BisectionMethod.findZero (interpolator, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 2);
            if (Double.isNaN(zeroYAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                double yZero = interpolator.getState(zeroYAt, 2);
                System.out.println ("Zero at t="+zeroYAt+", y = "+yZero);
                System.out.println ("Analytical zero at t="+sol.yZeroAt());
            }
        }
        System.out.println ("Evaluations ="+method.getEvaluationCounter());

        DisplaySolution.listError(method.getSolution(), new TrueSol(), new int[]{0, 2});

        if (true) {

            //DisplaySolution.statePlot(method.getSolution(), 0, 2);
            //DisplaySolution.timePlot(method.getSolution(), new int[]{1,3});
            DisplaySolution.timePlot(method.getSolution());
            DisplaySolution.timePlot(method1.getSolution());
        }
    }

	@Override
	public double[] getPartialDerivative(double time, double[] state) {
		// TODO Auto-generated method stub
		return null;
	}
}
