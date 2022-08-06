/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.problems;

import java.util.Arrays;
import numerico_ode.interpolation.StateFunction;
import numerico_ode.interpolation.*;
import numerico_ode.methods.*;
import numerico_ode.ode.*;
import numerico_ode.tools.*;

/**
 *
 * @author paco
 */
public class Rigid1D implements InitialValueProblem {

    // ------------------
    // Implementation of InitialValueProblem
    // ------------------

    public double getInitialTime() { 
        return 0; 
    }
    
    public double[] getInitialState() { // x,vx, y,vy 
        return new double[] { -1.0 };
    } 
    
    public double[] getDerivative(double t, double[] x) {
        return new double[] { 5*Math.exp(5*t)*(x[0]-t)*(x[0]-t) + 1 };
    }

    // ------------------
    // End of implementation of InitialValueProblem
    // ------------------

    static private class TrueSol implements StateFunction {
            
        public double[] getState(double time) {
            return new double[] { time - Math.exp(-5*time) };
        }
            
        public double getState(double time, int index) {
            return time - Math.exp(-5*time);
        }
                
    }


    public static void main(String[] args) {
        double maxTime = 6; // Paso fijo: probar 0.2 y 0.24 para t=6 y 8. RKF : probar 2.81 y 2.82, AdapPC4: 3.6 y 3.7
        InitialValueProblem problem = new Rigid1D();

        //Empty event, we are not finding zeros now
        Event rigidEvent = new Event(1e-4, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return 0;
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
				return;
			}
			
		};
        
        double hStep = 0.2; // Probar 0.24 y 0.25
        double tolerance = 1.0e-4;
        FixedStepMethod method = new FixedStepRungeKutta4Method(problem,hStep,rigidEvent);
        //method = new FixedStepPredictorCorrector4Method(problem,10);
        //method = new AdaptiveStepRKFehlbergMethod(problem,hStep, tolerance);
        
        double lastTime = method.solve(maxTime);
        DisplaySolution.listError(method.getSolution(), new TrueSol(), new int[]{0});
        if (method instanceof AdaptiveStepMethod) DisplaySequence.plot(((AdaptiveStepMethod) method).getStepList());
        System.out.println ("Evaluations ="+method.getEvaluationCounter());
        if (Double.isNaN(lastTime)) {
            System.out.println ("Method broke!");
        }

    }

	@Override
	public double[] getPartialDerivative(double time, double[] state) {
		// TODO Auto-generated method stub
		return null;
	}
}
