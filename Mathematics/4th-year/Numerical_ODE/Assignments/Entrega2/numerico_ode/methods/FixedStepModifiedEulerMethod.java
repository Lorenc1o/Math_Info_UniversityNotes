package numerico_ode.methods;

import numerico_ode.ode.InitialValueProblem;

public class FixedStepModifiedEulerMethod extends FixedStepMethod{
	
	public FixedStepModifiedEulerMethod(InitialValueProblem problem, double step){
		super(problem, step);
	}
	
	@Override
	protected double doStep(double deltaTime, double time, double[] state) {
		double[] derivative1 = mProblem.getDerivative(time, state);
		double[] state2 = state.clone();
		for (int i=0; i<state2.length; i++) {
			state2[i] += deltaTime*derivative1[i];
		}
		double[] derivative2 = mProblem.getDerivative(time+deltaTime, state2);
        super.addToEvaluationCounter(2);
        for (int i=0; i<state.length; i++) {
            state[i] = state[i] + deltaTime/2 * (derivative1[i] + derivative2[i]);
        }
        return time+deltaTime;
	}
}
