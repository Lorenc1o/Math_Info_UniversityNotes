/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.interpolation;

import java.util.Arrays;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 *
 * @author paco
 */
public class FixedStepMethodInterpolator implements StateFunction {
    private FixedStepMethod mMethod;
    private double mTime;
    private double[] mState;

    public FixedStepMethodInterpolator(FixedStepMethod method, NumericalSolutionPoint point) {
        mMethod = method;
        mTime   = point.getTime();
        mState  = point.getState();
    }
        
    public double getState(double time, int index) {
        double[] interpolation = Arrays.copyOf(mState,mState.length);;
        mMethod.doStep(time-mTime, time, interpolation);
        return interpolation[index];
    }
    
    public double[] getState(double time) {
        double[] interpolation = Arrays.copyOf(mState,mState.length);;
        mMethod.doStep(time-mTime, time, interpolation);
        return interpolation;
    }
   
}