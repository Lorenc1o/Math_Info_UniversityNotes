package numerico_ode.methods;

import numerico_ode.ode.InitialValueProblem;

public class FixedStepRK4 extends FixedStepMethod {
	
	public FixedStepRK4(InitialValueProblem problem, double step) {
		super(problem, step);
	}
	
	@Override
	protected double doStep(double deltaTime, double time, double[] state) {
		double[] k1 = mProblem.getDerivative(time, state);
		for(int i=0; i<k1.length; i++) k1[i] *= deltaTime;
		
		double[] stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.5*k1[i];
		double[] k2 = mProblem.getDerivative(time + 0.5*deltaTime, stateAux);
		for(int i=0; i<k1.length; i++) k2[i] *= deltaTime;
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += 0.5*k2[i];
		double[] k3 = mProblem.getDerivative(time + 0.5*deltaTime, stateAux);
		for(int i=0; i<k1.length; i++) k3[i] *= deltaTime;
		
		stateAux = state.clone();
		for (int i=0; i<stateAux.length; i++)	stateAux[i] += k3[i];
		double[] k4 = mProblem.getDerivative(time + deltaTime, stateAux);
		for(int i=0; i<k1.length; i++) k4[i] *= deltaTime;
		
        super.addToEvaluationCounter(4);
        for (int i=0; i<state.length; i++) {
            state[i] = state[i] + 1./6. * (k1[i] + 2*k2[i] + 2*k3[i] + k4[i]);
        }
        return time+deltaTime;
	}

}
