package numerico_ode.interpolation;

import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;

public class rkfInterpolator implements StateFunction {
	private double mTime;
    private double[] mState;
    private InitialValueProblem mProblem;
    
    public rkfInterpolator(InitialValueProblem problem, NumericalSolutionPoint point) {
        mTime = point.getTime();
        mState = point.getState();
        mProblem = problem;
    }
    
    public double[] scale(double[] a, double s) {
    	double[] ret = a.clone();
    	for(int i=0; i<a.length; i++) ret[i]*=s;
    	return ret;
    }
    
	@Override
	public double[] getState(double time) {
		double[] interpolation = new double[mState.length];
		double step = time - mTime;
		double[] k1 = mProblem.getDerivative(time, mState);
		k1 = scale(k1, step);
		
		double[] mStateAux = mState.clone();
		for (int i=0; i<mStateAux.length; i++)	mStateAux[i] += 0.25*k1[i];
		double[] k2 = mProblem.getDerivative(time + 0.25*step, mStateAux);
		k2 = scale(k2, step);
		
		mStateAux = mState.clone();
		for (int i=0; i<mStateAux.length; i++)	mStateAux[i] += 0.09375*k1[i]+0.28125*k2[i];
		double[] k3 = mProblem.getDerivative(time + 0.375*step, mStateAux);
		k3 = scale(k3, step);
		
		mStateAux = mState.clone();
		for (int i=0; i<mStateAux.length; i++)	mStateAux[i] += 0.8793809741*k1[i]-3.277196177*k2[i]+3.320892126*k3[i];
		double[] k4 = mProblem.getDerivative(time + 12./13.*step, mStateAux);
		k4 = scale(k4, step);
		
		mStateAux = mState.clone();
		for (int i=0; i<mStateAux.length; i++)	mStateAux[i] += 439./216.*k1[i]-8*k2[i]+3680./513.*k3[i]-845./4104.*k4[i];
		double[] k5 = mProblem.getDerivative(time + step, mStateAux);
		k5 = scale(k5, step);
		
		mStateAux = mState.clone();
		for (int i=0; i<mStateAux.length; i++)	mStateAux[i] += -8./27.*k1[i]+2*k2[i]-3544./2565.*k3[i]+1859./4104.*k4[i]-0.275*k5[i];
		double[] k6 = mProblem.getDerivative(time + 0.5*step, mStateAux);
		k6 = scale(k6, step);
        for (int i=0; i<mState.length; i++) {
            interpolation[i] = mState[i] + 25./216.*k1[i] + 1408./2565.*k3[i] + 2197./4104.*k4[i] - 0.2*k5[i];
        }
		return interpolation;
	}

	@Override
	public double getState(double time, int index) {
		return getState(time)[index];
	}

}
