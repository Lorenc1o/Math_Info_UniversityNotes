package numerico_ode.problems;

import numerico_ode.interpolation.EulerMethodInterpolator;
import numerico_ode.interpolation.StateFunction;
import numerico_ode.interpolation.rk4Interpolator;
import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.methods.FixedStepModifiedEulerMethod;
import numerico_ode.methods.FixedStepRK4;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.BisectionMethod;
import numerico_ode.tools.DisplaySolution;
import numerico_ode.tools.HermiteInterpolation;

public class Problem2Bodies implements InitialValueProblem {
	//Valores principales:
	//x0=152.100533, y0=0.0, vx0=0.0, vy0=0.105444,
	//G=8.6498928e-4, M1=5.9724e-3, M2=1.9885e3, cte = G*(M1+M2);
	static double h = 1.0e-0, x0=152.100533, y0=0.0, vx0=0.0, vy0=0.105444,
			G=8.6498928e-4, M1=5.9724e-3, M2=1.9885e3, cte = G*(M1+M2);
	static int nyears=1;
	static double realPeriod = 365.256363*nyears;
	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() {
		return new double[] {x0,y0,vx0,vy0};
	}

	@Override
	public double[] getDerivative(double time, double[] state) {
		double mod = Math.sqrt(state[0]*state[0]+state[1]*state[1]);
		mod = mod*mod*mod;
		//double mod = Math.pow(state[0]*state[0]+state[1]*state[1], 3/2);
		return new double[] {
				state[2],
				state[3],
				-cte*state[0]/mod, 
				-cte*state[1]/mod};
	}

	public static void main(String[] args) {
		Problem2Bodies problem = new Problem2Bodies();
		
		//We start with modified Euler method
		
		FixedStepModifiedEulerMethod eulerM = new FixedStepModifiedEulerMethod(problem, h);
		
        NumericalSolutionPoint previousPoint, currentPoint;
        NumericalSolutionPoint perihelionPrev = new NumericalSolutionPoint(0, new double[] {0});
        NumericalSolutionPoint perihelionPost = new NumericalSolutionPoint(0, new double[]{0});
		boolean halfWay = false; //when we are half the way (perihelion), it becomes true
		//poner a True para probar diferentes trayectorias
		if (false) {
			eulerM.solve(50000);
			currentPoint = eulerM.getSolution().getLastPoint();
			currentPoint.println();
		}
        else { 
        	int years=0;
            previousPoint = currentPoint = eulerM.getSolution().getLastPoint();
            while (/*!(currentPoint.getState(1) > 0 && halfWay) && */years<nyears) {
                previousPoint = currentPoint;
                currentPoint = eulerM.step();
                if(currentPoint.getState(1)<0 && !halfWay) {
                	halfWay = true;
                	perihelionPrev = (NumericalSolutionPoint) previousPoint.clone();
                	perihelionPost = (NumericalSolutionPoint) currentPoint.clone();
                }
                else if(currentPoint.getState(1)>0 && halfWay) {
                	halfWay = false;
                	years++;
                }
            }
            //previousPoint.println();
            //currentPoint.println();
            //Now we interpolate to get the hitting time
    		
    		HermiteInterpolation hinter = new HermiteInterpolation(previousPoint, currentPoint);
    		double[] hittingTime = new double[2];
    		hinter.interpolate(hittingTime, 1,3,0);
    		double interpolatedTime;
    		if(hittingTime[0]*hittingTime[1]<0) interpolatedTime = Math.max(hittingTime[0], hittingTime[1])/24.;
    		else interpolatedTime = Math.min(hittingTime[0], hittingTime[1])/24.;
    		System.out.println("Modified Euler method gives us a hitting time of "+interpolatedTime+" days");
    		
    		//And the perihelion
            StateFunction interpolatorPerihelion = new EulerMethodInterpolator(problem, perihelionPrev);
            double perihelionAt = BisectionMethod.findZero (interpolatorPerihelion, perihelionPrev.getTime(), perihelionPost.getTime(), 1.0e-8, 1);
            if (Double.isNaN(perihelionAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                double perihelion = interpolatorPerihelion.getState(perihelionAt,0);
                System.out.println ("Modified Euler method gives us a perihelion ="+perihelion);
            }
            

    		System.out.println();
    		System.out.println("Modified Euler gives a relative error of "+ Math.abs(interpolatedTime-realPeriod)/realPeriod +
    				" and does it in " + eulerM.getEvaluationCounter() + " evaluations");
    		System.out.println();
        }
		
		
		//Regular Euler method
		
		FixedStepMethod method = new FixedStepEulerMethod(problem,h);
        
		halfWay = false;
        if (false) {
        	method.solve(2400);
			currentPoint = method.getSolution().getLastPoint();
			currentPoint.println();
        }
        else { 
        	int years=0;
            previousPoint = currentPoint = method.getSolution().getLastPoint();
            while (years < nyears ) {
                previousPoint = currentPoint;
                currentPoint = method.step();
                if(currentPoint.getState(1)<0 && !halfWay) {
                	halfWay = true;
                	perihelionPrev = (NumericalSolutionPoint) previousPoint.clone();
                	perihelionPost = (NumericalSolutionPoint) currentPoint.clone();
                }
                else if(currentPoint.getState(1)>0 && halfWay) {
                	halfWay = false;
                	years++;
                }
            }
            //previousPoint.println();
            //currentPoint.println();
            
            //And we interpolate
            StateFunction interpolator = new EulerMethodInterpolator(problem, previousPoint);
            double zeroYAt = BisectionMethod.findZero (interpolator, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
            if (Double.isNaN(zeroYAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                System.out.println ("Regular Euler method gives us a hitting time of t="+zeroYAt/24.);
            }
            
            //And the perihelion
            StateFunction interpolatorPeri = new EulerMethodInterpolator(problem, perihelionPrev);
            double perihelionAt = BisectionMethod.findZero (interpolatorPeri, perihelionPrev.getTime(), perihelionPost.getTime(), 1.0e-8, 1);
            if (Double.isNaN(perihelionAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                double perihelion = interpolatorPeri.getState(perihelionAt,0);
                System.out.println ("Regular Euler method gives us a perihelion ="+perihelion);
            }
            System.out.println();
            System.out.println("Euler gives a relative error of "+ Math.abs(zeroYAt/24.-realPeriod)/realPeriod +
    				" and does it in " + method.getEvaluationCounter() + " evaluations");
            System.out.println();
        }
        
        
        //To finish, RK4
        
        FixedStepMethod rk4 = new FixedStepRK4(problem,h);
        
        halfWay = false;
        if (false) {
        	rk4.solve(2400);
			currentPoint = rk4.getSolution().getLastPoint();
			currentPoint.println();
        }
        else { 
        	int years = 0;
            previousPoint = currentPoint = rk4.getSolution().getLastPoint();
            while (years < nyears ) {
                previousPoint = currentPoint;
                currentPoint = rk4.step();
                if(currentPoint.getState(1)<0 && !halfWay) {
                	halfWay = true;
                	perihelionPrev = (NumericalSolutionPoint) previousPoint.clone();
                	perihelionPost = (NumericalSolutionPoint) currentPoint.clone();
                }
                else if(currentPoint.getState(1)>0 && halfWay) {
                	halfWay = false;
                	years++;
                }
            }
            //previousPoint.println();
            //currentPoint.println();
           
            //Interpolamos el período orbital
            
            StateFunction interpolatorRk4 = new rk4Interpolator(problem, previousPoint);
            double zeroYAt = BisectionMethod.findZero (interpolatorRk4, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
            if (Double.isNaN(zeroYAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                double yZero = interpolatorRk4.getState(zeroYAt, 0);
                System.out.println ("RK4 method gives us a hitting time of t="+zeroYAt/24.);
            }
            
            //And the perihelion
            StateFunction interpolatorPerihelionRk = new rk4Interpolator(problem, perihelionPrev);
            double perihelionAt = BisectionMethod.findZero (interpolatorPerihelionRk, perihelionPrev.getTime(), perihelionPost.getTime(), 1.0e-8, 1);
            if (Double.isNaN(perihelionAt)) {
                System.out.print ("Zero not found!!!");
            }
            else{
                double perihelion = interpolatorPerihelionRk.getState(perihelionAt,0);
                System.out.println ("RK4 method gives us a perihelion ="+perihelion);
            }
            System.out.println();
            System.out.println("RK4 gives a relative error of "+ Math.abs(zeroYAt/24.-realPeriod)/realPeriod +
    				" and does it in " + rk4.getEvaluationCounter() + " evaluations");
            System.out.println();

        }
        
        
        DisplaySolution.statePlot(eulerM.getSolution(), 0, 1, (int)Math.round(nyears/h));
		DisplaySolution.statePlot(method.getSolution(), 0, 1, (int)Math.round(nyears/h));
		DisplaySolution.statePlot(rk4.getSolution(), 0, 1, (int)Math.round(nyears/h));
	}

}
