package numerico_ode.problems;
import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.tools.DisplaySolution;

public class ParaboliThrowNoFriction implements InitialValueProblem {
	private double mGravity = 9.8;
	
	 public double getInitialTime() { 
	        return 0; 
	    }
	    
	    public double[] getInitialState() { // x,vx, y,vy (m/s)
	        return new double[] { 0, 100, 300, 0 };
	    } 
	    
	    public double[] getDerivative(double t, double[] x) {
	        return new double[] { x[1], 0, x[3], -mGravity };
	    }

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ParaboliThrowNoFriction problem = new ParaboliThrowNoFriction();
        FixedStepMethod method = new FixedStepEulerMethod(problem,0.005);
        
        if (false) method.solve(15);
        else { 
            double y = method.getSolution().getLastPoint().getState(2);
            while (y>0) y = method.step().getState(2);
        }
        DisplaySolution.statePlot(method.getSolution(), 0, 2);
        DisplaySolution.timePlot(method.getSolution(), new int[]{1,3});
        DisplaySolution.timePlot(method.getSolution());
        
        double y0=300.,v0=0.,t=method.getSolution().getLastTime(),t0=0.;
        double yf = y0 -1./2.*9.8*t*t;
        
        double yy=method.getSolution().getLastPoint().getState(2);
        double error = yf-yy;
        System.out.println(error + " " +t + " " + yf + " " + yy);
	}

}
