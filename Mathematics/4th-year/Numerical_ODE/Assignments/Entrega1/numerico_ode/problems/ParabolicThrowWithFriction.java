/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.problems;

import java.util.Iterator;

import javax.swing.JFrame;

import org.opensourcephysics.frames.PlotFrame;

import numerico_ode.methods.FixedStepEulerMethod;
import numerico_ode.methods.FixedStepMethod;
import numerico_ode.ode.InitialValueProblem;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;
import numerico_ode.tools.DisplaySolution;

/**
 *
 * @author paco
 */
public class ParabolicThrowWithFriction implements InitialValueProblem {
    private static double mFrictionCoefficient = 0.01;
    private static double mMass = 1;
    private static double mGravity = 9.8;
    
    private static double constant = mFrictionCoefficient/mMass;
    
    // ------------------
    // Implementation of InitialValueProblem
    // ------------------

    public double getInitialTime() { 
        return 0; 
    }
    
    public double[] getInitialState() { // x,vx, y,vy (m/s)
        return new double[] { 0, 100, 300, 0 };
    } 
    
    public double[] getDerivative(double t, double[] x) {
        double speed = Math.sqrt(x[1]*x[1]+x[3]*x[3]);
        return new double[] { x[1], -constant * x[1] * speed, x[3], -constant * x[3] * speed - mGravity };
    }
    
    public static double abs(double x) {
    	if(x>=0) return x;
    	else return -x;
    }
    
    public static double[] biseccion(double t1, double t2, double[] x1, double tol) {
    	double[] x = x1.clone();
    	
    	double tActual = t1+(t2-t1)/2;
    	double speed, deltaT = tActual-t1;
    	
    	
    	while(abs(x[2])>tol) {
    		speed = Math.sqrt(x[1]*x[1]+x[3]*x[3]);
    		x[0] += x[1]*deltaT;
    		x[1] -= constant * x[1] * speed * deltaT;
    		x[2] += x[3] * deltaT;
    		x[3] -= (constant * x[3] * speed + mGravity)*deltaT;
    		
    		if(x[2]>0) {
    			t1 = tActual;
    			tActual = t1+(t2-t1)/2;
        		deltaT = tActual-t1;
    		} else if(x[2]<0){
    			t2 = tActual;
    			tActual = t1+(t2-t1)/2;
        		deltaT = tActual-t2;
    		}   		
    	}
    	
    	double[] sol = new double[5];
    	for(int i=0;i<4;i++) sol[i]=x[i];
    	sol[4]=tActual;
    	return sol;
    }

    // ------------------
    // End of implementation of InitialValueProblem
    // ------------------

    
    public static void main(String[] args) {
        ParabolicThrowWithFriction problem = new ParabolicThrowWithFriction();
        FixedStepMethod method = new FixedStepEulerMethod(problem,0.01);
        
        if (false) method.solve(15);
        else { 
            double y = method.getSolution().getLastPoint().getState(2);
            while (y>0) y = method.step().getState(2);
        }
        DisplaySolution.statePlot(method.getSolution(), 0, 2);
        DisplaySolution.timePlot(method.getSolution(), new int[]{1,3});
        DisplaySolution.timePlot(method.getSolution());
        
        
        //para obtener un tiempo de impacto preciso
        
        //biseccion
        NumericalSolutionPoint[] X = method.getSolution().getLastItems(2);
        double[] x1 = X[0].getState(), x2 = X[1].getState();
        
        double t1 = X[0].getTime(), t2 = X[1].getTime();
        
        double[] sol = biseccion(t1, t2, x1, 1e-5);
        
        System.out.println("tiempo= "+ sol[4]+ " altura= "+ sol[2]);
        
        //interpolacion lineal
        
        double tLineal = -x1[2]*(t2-t1)/(x2[2]-x1[2])+t1;
        System.out.println("tiempo= "+tLineal);
        
        //interpolación de Hermite
        
        double a = (x2[2]-x1[2]-x1[3]*(t2-t1))/((t2-t1)*(t2-t1)), b=x1[3], c=x1[2];
        
        double tHermite1 = (-b+Math.sqrt(b*b-4*a*c))/(2*a)+t1, 
        		tHermite2 = (-b-Math.sqrt(b*b-4*a*c))/(2*a)+t1;
        
        System.out.println("tiempo 1 = "+ tHermite1+ ", tiempo 2 = "+ tHermite2); //nos quedamos con el 2
        
    }
}
