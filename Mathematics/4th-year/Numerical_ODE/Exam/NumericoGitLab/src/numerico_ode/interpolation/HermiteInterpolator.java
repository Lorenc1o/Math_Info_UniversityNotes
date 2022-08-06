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
public class HermiteInterpolator implements StateFunction {

    private double mTimeA, mTimeB, mDeltaTime;
    private double[] mStateA, mDerivativeA;
    private double[] mStateB, mDerivativeB;

    public HermiteInterpolator(InitialValueProblem problem, NumericalSolutionPoint pointA, 
            NumericalSolutionPoint pointB) {
        mTimeA = pointA.getTime();
        mStateA = pointA.getState();
        mDerivativeA = problem.getDerivative(mTimeA, mStateA);
        mTimeB = pointB.getTime();
        mStateB = pointB.getState();
        mDerivativeB = problem.getDerivative(mTimeB, mStateB);
        mDeltaTime = mTimeB - mTimeA;
    }

    public double getState(double time, int index) {
        double theta = (time - mTimeA) / mDeltaTime;
        double minus1 = theta - 1;
        double prod1 = theta * minus1;
        double prod2 = prod1 * (1 - 2 * theta);
        double coefX0 = -minus1 - prod2;
        double coefX1 = theta + prod2;
        double coefF0 = prod1 * minus1 * mDeltaTime;
        double coefF1 = prod1 * theta * mDeltaTime;
        return coefX0 * mStateA[index] + coefX1 * mStateB[index] + coefF0 * mDerivativeA[index] + coefF1 * mDerivativeB[index];
    }

    public double[] getState(double time) {
        double theta = (time - mTimeA) / mDeltaTime;
        double minus1 = theta - 1;
        double prod1 = theta * minus1;
        double prod2 = prod1 * (1 - 2 * theta);
        double coefX0 = -minus1 - prod2;
        double coefX1 = theta + prod2;
        double coefF0 = prod1 * minus1 * mDeltaTime;
        double coefF1 = prod1 * theta * mDeltaTime;
        
        double[] interpolation = new double[mStateA.length];
        for (int i = 0; i < mStateA.length; i++) {
            interpolation[i] = coefX0 * mStateA[i] + coefX1 * mStateB[i] + coefF0 * mDerivativeA[i] + coefF1 * mDerivativeB[i];
        }
        return interpolation;
    }

}
