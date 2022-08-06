/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import java.util.Iterator;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 * Abstract class for a Fixed Step Method to solve an InitialValueProblem
 * 
 * @author F. Esquembre
 * @version September 2020
 */
abstract public class FixedStepMethod {
 
    /**
     * Computes the max error of two solutions taken one at half the step of the other
     * @param fullStep
     * @param halfStep
     * @return 
     */
    static public double maxHalfStepError (NumericalSolution fullStep, NumericalSolution halfStep) {
        Iterator<NumericalSolutionPoint> iteratorFull = fullStep.iterator();
        Iterator<NumericalSolutionPoint> iteratorHalf = halfStep.iterator();
        double maxError = 0;
        while (iteratorFull.hasNext() && iteratorHalf.hasNext()) {
            double[] stateFull = iteratorFull.next().getState();
            double[] stateHalf = iteratorHalf.next().getState();
            double estimatedError = 0;
            for (int i=0; i<stateFull.length; i++) {
                double estimatedErrorInI = Math.abs(stateHalf[i]-stateFull[i]); 
                estimatedError = Math.max(estimatedError,estimatedErrorInI);
            }
            maxError = Math.max(maxError, estimatedError);
            if (!iteratorHalf.hasNext()) return maxError;
            iteratorHalf.next();
        }
        return maxError;
    }
    
    
    protected InitialValueProblem mProblem;
    protected double mStep;
    protected NumericalSolution mSolution;
    protected long mEvaluationCounter = 0;
    protected InterpolatorFunction mInterpolator;
    protected static Event mEvent;
    
    /**
     * Initializes the method for a given InitialValueProblem
     * @param InitialValueProblem problem 
     * @param step the fixed step to take. If negative, we'd solve backwards in time
     */
    protected FixedStepMethod(InitialValueProblem problem, double step, Event e) {
        mProblem = problem;
        mStep = step;
        mEvent = e;
        mSolution = new NumericalSolution(problem);
        if(this instanceof AdaptiveStepMethod) {
        	mInterpolator = ((AdaptiveStepMethod) this).createInterpolator();
        }else {
        	 mInterpolator = createInterpolator();
        }
       
    }
    
    /**
     * Particular method implementation
     * @param deltaTime the step to take
     * @param time the current time
     * @param state the current state
     * @return the value of time of the step taken, state will contain the updated state
     */
    abstract public double doStep(double deltaTime, double time, double[] state);
    
    /**
     * Get the step
     * @return the initial step given
     */
    public double getStep() {
        return mStep;
    }
    
    /**
     * Steps the problem once
     * @return the newly computed solution point, null if there was any error
     */
    public NumericalSolutionPoint step() {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint();
        double time = lastPoint.getTime();
        double[] state = lastPoint.getState();
        time = doStep(mStep,time,state);
        if (Double.isNaN(time)) return null;
        return mSolution.add(time, state);
    }
    
    /**
     * Iteratively steps the problem until time equals or exceeds finalTime
     * @param finalTime the time which we want to reach or exceed
     * @return the actual time of the last computed solution point (may differ -exceed- the requested finalTime).
     * returns NaN if there was any error in the solving
     */
    public double solve(double finalTime) {
        NumericalSolutionPoint lastPoint = mSolution.getLastPoint(), currentPoint;
        double time = lastPoint.getTime();
        double[] state = lastPoint.getState();
        if (mStep>0) {
        	if(finalTime<time) return time; //If we already have got the solution at finalTime, we return the further time at which solution is computed
            while (time<finalTime && !mEvent.get_stopComputation()) {
                double time2 = doStep(mStep,time,state);
                if (Double.isNaN(time)) return Double.NaN;
                lastPoint = mSolution.getLastPoint();
                currentPoint = mSolution.add(time2, state);
                if(mEvent.crossed(time, time2, lastPoint.getState(), state)) {
                	NumericalSolutionPoint crossing = mEvent.getCrossingPoint(mSolution, lastPoint, currentPoint, mInterpolator);
                	if(crossing != null) {
                		double crossTime = crossing.getTime();
                    	double[] crossState = crossing.getState();
                    	mEvent.action(crossTime, crossState);
                	} else {
                		System.out.println("Something went wrong");
                		return Double.NaN;
                	}
                }
                time = time2;
            }
        } 
        else if (mStep<0) {
        	if(finalTime>time) return time; //If we already have got the solution at finalTime, we return the further time at which solution is computed
            while (time>finalTime && !mEvent.get_stopComputation()) {
            	double time2 = doStep(mStep,time,state);
                if (Double.isNaN(time)) return Double.NaN;
                lastPoint = mSolution.getLastPoint();
                currentPoint = mSolution.add(time2, state);
                if(mEvent.crossed(time, time2, lastPoint.getState(), state)) {
                	NumericalSolutionPoint crossing = mEvent.getCrossingPoint(mSolution, lastPoint, currentPoint, mInterpolator);
                	if(crossing != null) {
                		double crossTime = crossing.getTime();
                    	double[] crossState = crossing.getState();
                    	mEvent.action(crossTime, crossState);
                	} else {
                		System.out.println("Something went wrong");
                		return Double.NaN;
                	}
                }
                time = time2;
            }
        } // does nothing if mStep = 0
        return time;
    }
    
    /**
     * Gets the solution computed so far, when instantiating an Adaptive Step Method
     * @return an instance of NumericalSolution
     */
    public NumericalSolution getSolution() { return mSolution; }
    
    public static Event getEvent() {
    	return mEvent;
    }
    
    public void resetEvaluationCounter() { 
        mEvaluationCounter = 0;
    }
    
    public long getEvaluationCounter() {
        return mEvaluationCounter;
    }

    protected void addToEvaluationCounter(int add) {
        mEvaluationCounter += add;
    }
   
    /**
     * Creates an interpolator for the solution computed using a FixedStepMethod
     * @return an interpolator of mSolution
     */
    protected InterpolatorFunction createInterpolator() {
    	return new InterpolatorFunction() {
    		double h = mStep;	
    		
			@Override
			public NumericalSolutionPoint getSolutionPoint(double time) {
				if(h>0) {
					double t1 = before.getTime(), t2 = after.getTime();
					if(time<t1 || time>t2) return null;
					double step = (t2-t1)/2.;
					double[] interpolation = before.getState();
					double interpolatedTime = doStep(step, t1, interpolation);
					return new NumericalSolutionPoint(interpolatedTime, interpolation);		
				} else if(h<0) {
					double t1 = before.getTime(), t2 = after.getTime();
					if(time>t1 || time<t2) return null;
					double step = (t2-t1)/2.;
					double[] interpolation = before.getState();
					double interpolatedTime = doStep(step, t1, interpolation);
					return new NumericalSolutionPoint(interpolatedTime, interpolation);	
				}
				return null;
			}
			
			@Override
			public NumericalSolutionPoint getMiddlePoint() {
				double t1 = before.getTime(), t2 = after.getTime();
				double step = (t2-t1)/2.;
				double[] interpolation = before.getState();
				double interpolatedTime = doStep(step, t1, interpolation);
				return new NumericalSolutionPoint(interpolatedTime, interpolation);
			}
			
			@Override
			public double[] getState(double time) {
				return getSolutionPoint(time).getState();
			}

			@Override
			public double getState(double time, int index) {
				return getSolutionPoint(time).getState(index);
			}
    		
    	};
    }
    
    public InterpolatorFunction getInterpolator() {
    	return mInterpolator;
    }
    

}
