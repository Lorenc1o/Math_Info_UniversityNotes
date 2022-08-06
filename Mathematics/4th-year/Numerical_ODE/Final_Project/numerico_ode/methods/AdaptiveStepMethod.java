/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.methods;

import java.util.ArrayList;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 * Abstract class for a Fixed Step Method to solve an InitialValueProblem
 * 
 * @author F. Esquembre
 * @version September 2020
 */
abstract public class AdaptiveStepMethod extends FixedStepMethod {
 
    protected double mTolerance = 1.0e-4;
    protected ArrayList<Double> mStepList = new ArrayList<Double>();
    protected NumericalSolutionPoint mState;

    public AdaptiveStepMethod(InitialValueProblem problem, double step, Event e) {
        super(problem,step,e);
        mState = new NumericalSolutionPoint(problem.getInitialTime(), problem.getInitialState());
    }
    
    /**
     * Advance at least a step of h
     * @param h the step size 
     * @return the further time at which the solution is computed
     */
    public double fullStep(double h) {
    	double time = mState.getTime();
    	double maxTime = solve(time+h);
    	mState = mSolution.getSolutionAt(time+h, mInterpolator, mTolerance, 100);
    	return maxTime;
    }
    
    /**
     * In this method relies the basic way of computing a step for the adaptive methods
     * @param step size os the step
     * @param time start time
     * @param state start state
     * @return time+step
     */
    abstract double makeStep(double step, double time, double[] state);
    
    public void setTolerance(double tolerance) {
        mTolerance = tolerance;
    }

    public double getTolerance() {
        return mTolerance;
    }
    
    public ArrayList<Double> getStepList() {
        return mStepList;
    }
    
    @Override
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
					double interpolatedTime = makeStep(step, t1, interpolation);
					return new NumericalSolutionPoint(interpolatedTime, interpolation);		
				} else if(h<0) {
					double t1 = before.getTime(), t2 = after.getTime();
					if(time>t1 || time<t2) return null;
					double step = (t2-t1)/2.;
					double[] interpolation = before.getState();
					double interpolatedTime = makeStep(step, t1, interpolation);
					return new NumericalSolutionPoint(interpolatedTime, interpolation);	
				}
				return null;
			}
			
			@Override
			public NumericalSolutionPoint getMiddlePoint() {
				double t1 = before.getTime(), t2 = after.getTime();
				double step = (t2-t1)/2.;
				double[] interpolation = before.getState();
				double interpolatedTime = makeStep(step, t1, interpolation);
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
    
}
