package numerico_ode.tools;

import numerico_ode.ode.NumericalSolutionPoint;

public class HermiteInterpolation {
	private NumericalSolutionPoint p1, p2;
	
	public HermiteInterpolation(NumericalSolutionPoint p, NumericalSolutionPoint pp) {
		p1=p;
		p2=pp;
	}
	
	public void interpolate(double[] sol, int variableObj, int derivada, double objetivo) {
		double y1=p1.getState(variableObj),y2=p2.getState(variableObj),vy=p1.getState(derivada),
				t1=p1.getTime(), t2=p2.getTime();
		//coefficients of the 2nd order equation obtained from Hermite
		double a=(y2-y1-vy*(t2-t1))/((t2-t1)*(t2-t1)),
				b=vy, c=y1-objetivo;
		//now, we check for solutions
		double discriminant = b*b-4*a*c;
		if(discriminant<0) sol[0]=Double.NaN; //If there are no solutions, we return NaN
		//else we get both solutions avoiding catastrophic cancellation
		if(b>=0) {
			sol[0] = -b-Math.sqrt(b*b-4*a*c)/(2*a);
			sol[1] = c/(a*sol[0])+t1;
			sol[0] += t1; //we sum t1 because we solved the eq a*(t-t1)^2+b*(t-t1)+c=0
		}
		else {
			sol[0] = -b+Math.sqrt(b*b-4*a*c)/(2*a);
			sol[1] = c/(a*sol[0])+t1;
			sol[0] += t1;
		}
	}	
}
