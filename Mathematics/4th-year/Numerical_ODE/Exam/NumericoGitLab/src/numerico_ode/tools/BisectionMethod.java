/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.tools;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.interpolation.StateFunction;
import numerico_ode.ode.Event;
import numerico_ode.ode.NumericalSolution;
import numerico_ode.ode.NumericalSolutionPoint;

/**
 *
 * @author paco
 */
public class BisectionMethod {
    /**
     * Default value for tolerance, if the user inputs zero
     */
    static public final double DEFAULT_TOLERANCE = 1.0e-8;
    /**
     * Maximum difference between times considered for bisection. Beyond this, zero finding methods fail
     */
    static public final double MAXIMUM_TIME_RESOLUTION = 1.0e-12;
    
    /**
     * Find a zero (if it exists) in the function between two given times
     * @param function
     * @param initialTime
     * @param finalTime
     * @param tolerance
     * @param index 
     * @return the time at which zero is found (with the given tolerance). NaN if not found
     */
    static public double findZero (StateFunction function, double initialTime, double finalTime, double tolerance, int index) {
        tolerance = Math.abs(tolerance);
        if (tolerance==0) tolerance = DEFAULT_TOLERANCE;

        // Trivial checks
        double initialState = function.getState(initialTime, index);
        if (Math.abs(initialState)<=tolerance) return initialTime;

        double finalState = function.getState(finalTime, index);
        if (Math.abs(finalState)  <=tolerance) return finalTime;
        
        if (initialState*finalState>0) return Double.NaN;
        
        do {
            double middleTime  = (initialTime+finalTime)/2;
            double middleState = function.getState(middleTime, index);
            if (Math.abs(middleState)<=tolerance) return middleTime;
            if (initialState*middleState<0) {
                finalTime = middleTime;
                finalState = middleState;
            }
            else {
                initialTime  = middleTime;
                initialState = middleState;
            }
        } while (Math.abs(finalTime-initialTime)>MAXIMUM_TIME_RESOLUTION);
        return Double.NaN;
    }
    
    static public double findZero2 (NumericalSolution sol, Event e, InterpolatorFunction function, NumericalSolutionPoint p1, NumericalSolutionPoint p2, int index, double tolerance) {
    	if(e.crossFunction(p1)*e.crossFunction(p2)>0) return Double.NaN;
		function.setStates(p1, p2);
		NumericalSolutionPoint pIn = new NumericalSolutionPoint(p1.getTime(), p1.getState()),
				pFin = new NumericalSolutionPoint(p2.getTime(), p2.getState());
        do {
            NumericalSolutionPoint middleState = function.getMiddlePoint();
            if(Math.abs(e.crossFunction(middleState))<=tolerance) {
            	sol.addOrdered(middleState);
            	return middleState.getTime();
            }
            if (e.crossFunction(pIn)*e.crossFunction(middleState)<0) {
            	pFin = middleState;
                function.setAfter(middleState);
            }
            else {
            	pIn = middleState;
                function.setBefore(middleState);
            }
        } while (Math.abs(pIn.getTime()-pFin.getTime())>MAXIMUM_TIME_RESOLUTION);
        return Double.NaN;
	}
    
}
