package numerico_ode.interpolation;

import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;

public class rk4Interpolator implements StateFunction {
	private double mTime;
    private double[] mState;
    private InitialValueProblem mProblem;
    
    public rk4Interpolator(InitialValueProblem problem, NumericalSolutionPoint point) {
        mTime = point.getTime();
        mState = point.getState();
        mProblem = problem;
    }
    
	@Override
	public double[] getState(double time) {
		double[] interpolation = new double[mState.length];
        double step = time - mTime;
        double[] k1 = mProblem.getDerivative(time, mState);
		for(int i=0; i<k1.length; i++) k1[i] *= step;
		
		double[] stateAux = mState.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.5*k1[i];
		double[] k2 = mProblem.getDerivative(time + 0.5*step, stateAux);
		for(int i=0; i<k1.length; i++) k2[i] *= step;
		
		stateAux = mState.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.5*k2[i];
		double[] k3 = mProblem.getDerivative(time + 0.5*step, stateAux);
		for(int i=0; i<k1.length; i++) k3[i] *= step;
		
		stateAux = mState.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += k3[i];
		double[] k4 = mProblem.getDerivative(time + step, stateAux);
		for(int i=0; i<k1.length; i++) k4[i] *= step;
		
        for (int i=0; i<mState.length; i++) {
            interpolation[i] = mState[i] + 1./6. * (k1[i] + 2*k2[i] + 2*k3[i] + k4[i]);
        }
        return interpolation;
	}

	@Override
	public double getState(double time, int index) {
        return getState(time)[index];
	}

}
