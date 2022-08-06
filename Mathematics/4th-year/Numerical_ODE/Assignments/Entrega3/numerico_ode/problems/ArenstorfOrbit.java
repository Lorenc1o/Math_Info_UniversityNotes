package numerico_ode.problems;

import numerico_ode.interpolation.EulerMethodInterpolator;
import numerico_ode.interpolation.HermiteInterpolator;
import numerico_ode.interpolation.ModifiedEulerMethodInterpolator;
import numerico_ode.interpolation.StateFunction;
import numerico_ode.interpolation.rk4Interpolator;
import numerico_ode.interpolation.rkfInterpolator;
import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.methods.FixedStepModifiedEulerMethod;
import numerico_ode.methods.FixedStepRK4;
import numerico_ode.methods.RK4Richardson;
import numerico_ode.methods.RKFMethod;
import numerico_ode.methods.RichardsonAdaptativeMethod;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.BisectionMethod;
import numerico_ode.tools.DisplaySolution;
import numerico_ode.tools.HermiteInterpolation;

public class ArenstorfOrbit implements InitialValueProblem {
	static private double h0 = 1e-1, x0=0.994, vx0=0., y0=0., vy0=-2.001585106, Mmoon=0.012277471, Mearth=1.-Mmoon;
	static private double tolerance;
	static private int nVueltas = 2;

	public ArenstorfOrbit(double tol) {
		tolerance = tol;
	};
	
	@Override
	public double getInitialTime() {
		return 0;
	}

	@Override
	public double[] getInitialState() {
		return new double[] {x0, y0, vx0, vy0};
	}

	public double D1(double x, double y) {
		double mod = Math.sqrt((x+Mmoon)*(x+Mmoon)+y*y);
		return mod*mod*mod;
	}
	
	public double D2(double x, double y) {
		double mod = Math.sqrt((x-Mearth)*(x-Mearth)+y*y);
		return mod*mod*mod;
	}
	
	@Override
	public double[] getDerivative(double time, double[] state) {
		return new double[] {
				state[2],
				state[3],
				state[0]+2*state[3]-Mearth*(state[0]+Mmoon)/D1(state[0],state[1])-Mmoon*(state[0]-Mearth)/D2(state[0],state[1]),
				state[1]-2*state[2]-Mearth*state[1]/D1(state[0],state[1])-Mmoon*state[1]/D2(state[0],state[1])
		};
	}

	public static void main(String[] args) {
		//voy a considerar que la órbita se cierra cuando  el punto inicial y el final se diferencian en <1e-2
		
		InitialValueProblem problem = new ArenstorfOrbit(1e-8);
		
		NumericalSolutionPoint previousPoint, currentPoint;
		
		FixedStepMethod eu = new FixedStepEulerMethod(problem,1e-5);
		currentPoint = eu.getSolution().getLastPoint();
		if (false) {
			eu.solve(30);
			currentPoint = eu.getSolution().getLastPoint();
			currentPoint.println();
		}
        else { 
        	int speedChange=0, loops=0;
            previousPoint = currentPoint = eu.getSolution().getLastPoint();
            while (loops<nVueltas) {
                previousPoint = currentPoint;
                currentPoint = eu.step();
                if(previousPoint.getState(3)*currentPoint.getState(3)<=0) speedChange++;
                if(speedChange == 6 && currentPoint.getState(1)<=0) {
                	loops++;
                	speedChange = 0;
                }
            }            
        }
		
		StateFunction interpolateEu = new EulerMethodInterpolator(problem, previousPoint);
        double zeroAt = BisectionMethod.findZero (interpolateEu, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
        if (Double.isNaN(zeroAt)) {
            System.out.print ("Zero not found!!!");
        }
        else{
            double[] finalState = interpolateEu.getState(zeroAt);
            double dif = (finalState[0]-x0)*(finalState[0]-x0)+(finalState[1]-y0)*(finalState[1]-y0);
            dif = Math.sqrt(dif);
            dif = dif/Math.sqrt(x0*x0+y0*y0);
            System.out.println ("Euler method gives us a hitting time ="+zeroAt+" with a relative error of "+ dif);
        }
        
        System.out.println("It does it in " + eu.getEvaluationCounter() + " evaluations");
		//DisplaySolution.statePlot(eu.getSolution(), 0, 1, 1000);
		
		//Con Euler, usando un paso de 1e-6, Java nos da un error de memoria en el Heap
		//usando un paso de 1e-5, obtenemos un error en el cierre de 0.0467 en la segunda vuelta
        
        FixedStepMethod EuMod = new FixedStepModifiedEulerMethod(problem,1e-5);
		currentPoint = EuMod.getSolution().getLastPoint();
		if (false) {
			EuMod.solve(30);
			currentPoint = EuMod.getSolution().getLastPoint();
			currentPoint.println();
		}
        else { 
        	int speedChange=0, loops=0;
            previousPoint = currentPoint = EuMod.getSolution().getLastPoint();
            while (loops<nVueltas) {
                previousPoint = currentPoint;
                currentPoint = EuMod.step();
                if(previousPoint.getState(3)*currentPoint.getState(3)<=0) speedChange++;
                if(speedChange == 6 && currentPoint.getState(1)<=0) {
                	loops++;
                	speedChange = 0;
                }
            }            
        }
		
		StateFunction interpolateEuMod = new HermiteInterpolator(problem, previousPoint, currentPoint);
        zeroAt = BisectionMethod.findZero (interpolateEuMod, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
        if (Double.isNaN(zeroAt)) {
            System.out.print ("Zero not found!!!");
        }
        else{
            double[] finalState = interpolateEuMod.getState(zeroAt);
            double dif = (finalState[0]-x0)*(finalState[0]-x0)+(finalState[1]-y0)*(finalState[1]-y0);
            dif = Math.sqrt(dif);
            dif = dif/Math.sqrt(x0*x0+y0*y0);
            System.out.println ("Modified Euler method gives us a hitting time ="+zeroAt+" with an error of "+ dif);
        }
        
        System.out.println("It does it in " + EuMod.getEvaluationCounter() + " evaluations");
		//DisplaySolution.statePlot(EuMod.getSolution(), 0, 1, 1000);
		
		//Con Euler modificado obtenemos, con paso 1e-5, un error relativo de 0.019
		//de ~2% al dar dos vueltas
		
		FixedStepMethod rk4 = new FixedStepRK4(problem,4e-4);
		currentPoint = rk4.getSolution().getLastPoint();
		if (false) {
			rk4.solve(30);
			currentPoint = rk4.getSolution().getLastPoint();
			currentPoint.println();
		}
        else { 
        	int speedChange=0, loops=0;
            previousPoint = currentPoint = rk4.getSolution().getLastPoint();
            while (loops<nVueltas) {
                previousPoint = currentPoint;
                currentPoint = rk4.step();
                if(previousPoint.getState(3)*currentPoint.getState(3)<=0) speedChange++;
                if(speedChange == 6 && currentPoint.getState(1)<=0) {
                	loops++;
                	speedChange = 0;
                }
            }            
        }
		
		StateFunction interpolateRK4Fix = new rk4Interpolator(problem, previousPoint);
        zeroAt = BisectionMethod.findZero (interpolateRK4Fix, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
        if (Double.isNaN(zeroAt)) {
            System.out.print ("Zero not found!!!");
        }
        else{
            double[] finalState = interpolateRK4Fix.getState(zeroAt);
            double dif = (finalState[0]-x0)*(finalState[0]-x0)+(finalState[1]-y0)*(finalState[1]-y0);
            dif = Math.sqrt(dif);
            dif = dif/Math.sqrt(x0*x0+y0*y0);
            System.out.println ("RK4 fixed step method gives us a hitting time ="+zeroAt+" with an error of "+ dif);
        }
        
        System.out.println("It does it in " + rk4.getEvaluationCounter() + " evaluations");
		//DisplaySolution.statePlot(rk4.getSolution(), 0, 1, 100);
		
		//Con un paso de 1e-3, rk4 da un error de 1.6, demasiado y con paso 1e-4, nos da error relativo
		//3.74e-5. Vamos a intentar agrandar el paso. Con paso 4e-4, obtenemos un error relativo de 0.6e-2
		//menor que el error que hemos considerado asumible
		
        
		
		
		RichardsonAdaptativeMethod method = new RK4Richardson(problem, h0, 1e-10, 2, 1e-6);
		
		currentPoint = method.getSolution().getLastPoint();
		
		if (false) {
			method.solve(30);
			currentPoint = method.getSolution().getLastPoint();
			currentPoint.println();
		}
        else { 
        	int speedChange=0, loops=0;
            previousPoint = currentPoint = method.getSolution().getLastPoint();
            while (loops<nVueltas) {
                previousPoint = currentPoint;
                currentPoint = method.step();
                if(previousPoint.getState(3)*currentPoint.getState(3)<0) speedChange++;
                if(speedChange == 6 && currentPoint.getState(1)<0) {
                	loops++;
                	speedChange = 0;
                }
            }            
        }
		
		StateFunction interpolateRK4 = new rk4Interpolator(problem, previousPoint);
        zeroAt = BisectionMethod.findZero (interpolateRK4, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
        if (Double.isNaN(zeroAt)) {
            System.out.print ("Zero not found!!!");
        }
        else{
            double[] finalState = interpolateRK4.getState(zeroAt);
            double dif = (finalState[0]-x0)*(finalState[0]-x0)+(finalState[1]-y0)*(finalState[1]-y0);
            dif = Math.sqrt(dif);
            dif = dif/Math.sqrt(x0*x0+y0*y0);
            System.out.println ("RK4 adaptative step method gives us a hitting time ="+zeroAt+" with an error of "+ dif);
        }
        
        System.out.println("It does it in " + method.getEvaluationCounter() + " evaluations");
		//DisplaySolution.statePlot(method.getSolution(), 0, 1);
		
		//El RK4 adaptativo, con una tolerancia de error de truncamiento local de 1e-6
		//nos proporciona un error relativo al final de las dos vueltas de 0.00106
		
		
		RKFMethod method2 = new RKFMethod(problem, h0, 1e-10, 2, 1e-6);
		
		currentPoint = method2.getSolution().getLastPoint();
		
		
		if (false) {
			method2.solve(17);
			currentPoint = method2.getSolution().getLastPoint();
		}
        else { 
        	int speedChange=0, loops=0;
            previousPoint = currentPoint = method2.getSolution().getLastPoint();
            while (loops < nVueltas) {
                previousPoint = currentPoint;
                currentPoint = method2.step();
                if(previousPoint.getState(3)*currentPoint.getState(3)<0) speedChange++;
                if(speedChange == 6 && currentPoint.getState(1)<0) {
                	loops++;
                	speedChange = 0;
                }
            }             
        }
		
		StateFunction interpolateOrbit = new rkfInterpolator(problem, previousPoint);
        zeroAt = BisectionMethod.findZero (interpolateOrbit, previousPoint.getTime(), currentPoint.getTime(), 1.0e-8, 1);
        if (Double.isNaN(zeroAt)) {
            System.out.print ("Zero not found!!!");
        }
        else{
            double[] finalState = interpolateOrbit.getState(zeroAt);
            double dif = (finalState[0]-x0)*(finalState[0]-x0)+(finalState[1]-y0)*(finalState[1]-y0);
            dif = Math.sqrt(dif);
            dif = dif/Math.sqrt(x0*x0+y0*y0);
            System.out.println ("RKF method gives us a hitting time ="+zeroAt+" with an error of "+ dif);
        }
		
		System.out.println("It does it in " + method2.getEvaluationCounter() + " evaluations");
		
		//DisplaySolution.statePlot(method2.getSolution(), 0, 1);
		
		
		//RKF con una tolerancia en el RLT de 1e-6 nos da un error relativo final de 0.0056, dentro de nuestra
		//orquilla de confianza, aunque mayor que el RK4 adaptativo, con la misma tolerancia
		
		
		method.stepEvol(1);
		method2.stepEvol(1);
		
		//Comparando las evoluciones de los pasos en ambos métodos, vemos que la forma de la gráfica obtenida es muy
		//similar, pero en RKF obtenemos valores del paso mucho mayores, es por esto por lo que necesita
		//utilizar una cantidad considerable menor de evaluaciones, a pesar de que en cada paso 
		//RK4 necesita 4 evaluaciones y RKF necesita 6

	}

}
