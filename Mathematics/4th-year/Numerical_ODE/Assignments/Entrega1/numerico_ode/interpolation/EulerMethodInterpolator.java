/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.interpolation;

import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 *
 * @author paco
 */
public class EulerMethodInterpolator implements StateFunction {
    
    private double mTime;
    private double[] mState, mDerivative;

    public EulerMethodInterpolator(InitialValueProblem problem, NumericalSolutionPoint point) {
        mTime = point.getTime();
        mState = point.getState();
        mDerivative = problem.getDerivative(mTime, mState);
    }
    
    public EulerMethodInterpolator(double time, double[] state, double[] derivative) {
        mTime  = time;
        mState = state;
        mDerivative = derivative;
    }
    
    public double getState(double time, int index) {
        double step = time - mTime;
        return mState[index] + step*mDerivative[index];
    }
    
    public double[] getState(double time) {
        double[] interpolation = new double[mState.length];
        double step = time - mTime;
        for (int i=0; i<mState.length; i++) {
            interpolation[i] = mState[i] + step*mDerivative[i];
        }
        return interpolation;
    }
   
}