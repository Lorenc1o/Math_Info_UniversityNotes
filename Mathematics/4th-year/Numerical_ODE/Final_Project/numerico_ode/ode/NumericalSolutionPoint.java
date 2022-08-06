/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.ode;

import java.util.Arrays;

/**
 * Point of a Numerical Solution (t,Y(t)), t is Time, Y(t) is State.
 * The object is created immutable. That is, you can access its value, but not change it.
 * Passed arrays are copied by value (not by reference).
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public class NumericalSolutionPoint {
    private double mTime;
    private double[] mState;
    
    public NumericalSolutionPoint(double time, double[] state) {
        mTime =  time;
        mState = Arrays.copyOf(state,state.length);
    }
    
    /**
     * Get the time (independent variable) of the solution point
     * @return 
     */
    public double getTime() { return mTime; }
    
    /**
     * Get a copy of the state Y(t) of the point
     * @return a newly created double array with the state
     */
    public double[] getState() { 
        return Arrays.copyOf(mState,mState.length);
    }
    
    /**
     * Get one of the components of the state array
     * @param index the index desired, from 0 to dimension-1
     * @return 
     */
    public double getState(int index) {
        return mState[index];
    }
    
    public void println() {
        System.out.print ("Point at t="+mTime+" = ("+mState[0]);
        for (int i=1; i<mState.length; i++) System.out.print(", "+mState[i]);
        System.out.println(")");
    }
}
