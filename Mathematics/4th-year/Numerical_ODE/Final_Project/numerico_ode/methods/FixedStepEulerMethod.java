/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import java.util.Iterator;

import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;

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
    public FixedStepEulerMethod(InitialValueProblem problem, double step, Event e) {
        super(problem,step,e);
    }

    /**
     * Euler method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    public double doStep(double deltaTime, double time, double[] state) {
        double[] derivative = mProblem.getDerivative(time, state);
        super.addToEvaluationCounter(1);
        for (int i=0; i<state.length; i++) {
            state[i] = state[i] + deltaTime * derivative[i];
        }
        return time+deltaTime;
    }
        
    static public NumericalSolution extrapolate (NumericalSolution fullStep, NumericalSolution halfStep) {
        NumericalSolution extrapolatedSolution = new NumericalSolution();
        Iterator<NumericalSolutionPoint> iteratorFull = fullStep.iterator();
        Iterator<NumericalSolutionPoint> iteratorHalf = halfStep.iterator();
        while (iteratorFull.hasNext() && iteratorHalf.hasNext()) {
            NumericalSolutionPoint pointFull = iteratorFull.next();
            double[] stateFull = pointFull.getState();
            double[] stateHalf = iteratorHalf.next().getState();
            for (int i=0; i<stateFull.length; i++) {
                stateFull[i] = (2*stateHalf[i]-stateFull[i]); // Reuse stateFull array
            }
            extrapolatedSolution.add(pointFull.getTime(), stateFull);
            if (!iteratorHalf.hasNext()) return extrapolatedSolution;
            iteratorHalf.next();
        }
        return extrapolatedSolution;
    }
    
    /**
     * Uses Richardson extrapolation for Euler method
     * @param problem
     * @param maxTime
     * @param tolerance
     * @param initialStep
     * @param minStepAllowed
     * @return 
     */
    static public NumericalSolution extrapolateToTolerance(InitialValueProblem problem, 
            double maxTime, double tolerance, 
            double initialStep, double minStepAllowed) {
        
        double h = initialStep;
        
        //Empty event, needed to inicialize method
        Event evento = new Event(tolerance, 0) {

			@Override
			public double crossFunction(double t, double[] state) {
				return 0;
			}

			@Override
			public void action(double crossingTime, double[] crossingPoint) {
			}
        	
        };
        FixedStepEulerMethod methodFull = new FixedStepEulerMethod(problem,h,evento);
        methodFull.solve(maxTime);
        NumericalSolution solutionFull = methodFull.getSolution();
        while (Math.abs(h)>Math.abs(minStepAllowed)) {
            System.out.println ("Trying for h = "+h+"...");
            FixedStepEulerMethod methodHalf = new FixedStepEulerMethod(problem,h/2,evento);
            methodHalf.solve(maxTime);
            NumericalSolution solutionHalf = methodHalf.getSolution();
            double maxError = maxHalfStepError(solutionFull,solutionHalf);
            System.out.println ("- Error (for h/2) ~= "+maxError);
            if (maxError<tolerance) {
                System.out.println ("Tolerance reached for h = "+h+"\n");
                return extrapolate(solutionFull,solutionHalf);
            }
            h /= 2;
            solutionFull = solutionHalf;
        }
        return null;
    }

}
