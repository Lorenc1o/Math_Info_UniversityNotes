package numerico_ode.methods;

import numerico_ode.ode.Event;
import numerico_ode.ode.InitialValueProblem;

public class ImplicitEulerMethod extends FixedStepMethod {
	private int maxIt;
	private double tolerance;

	public ImplicitEulerMethod(InitialValueProblem problem, double step, Event e, double tol, int max) {
		super(problem,step,e);
		maxIt = max;
		tolerance = tol;
	}

	@Override
	public double doStep(double deltaTime, double time, double[] state) {
		double[] derivative = mProblem.getDerivative(time, state);
		super.addToEvaluationCounter(1);
		double[] w0 = state.clone();
		double[] wi = state.clone();
		
		int j=1, flag=0;
		
		double[] partialDerivative;
		
		while(flag==0) {
			derivative = mProblem.getDerivative(time+deltaTime, w0);
			partialDerivative = mProblem.getPartialDerivative(time+deltaTime, w0);
			super.addToEvaluationCounter(2);
			for(int i=0; i<state.length; i++) {
				state[i] = w0[i] - 
							(w0[i]-deltaTime*derivative[i]-wi[i])/
							(1-deltaTime*partialDerivative[i]);
			}
			if(mod(state, w0)<tolerance) flag=1;
			else {
				j++;
				w0=state.clone();
				if(j>maxIt) {
					System.out.println("Maximum number of iteration exceeded");
					return Double.NaN;
				}
			}
		}
		
//		for(int i=0; i<state.length; i++) {
//			System.out.println(state[i] + " ");
//		}
		return time+deltaTime;
	}
	
	double mod(double[] a, double[] b) {
		if(a.length != b.length) {
			return Double.NaN;
		}
		double ret = 0;
		for(int i=0; i<a.length; i++) {
			ret += (a[i]-b[i])*(a[i]-b[i]);
			//System.out.print(a[i]+" ");
		}
//		System.out.println();
//		for(int i=0; i<a.length; i++) {
//			System.out.print(b[i]+" ");
//		}
//		System.out.println();
		ret = Math.sqrt(ret);
//		System.out.println(ret);
		return ret;
	}

}
