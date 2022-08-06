/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.ode;

import java.util.ArrayList;
import java.util.Iterator;

/**
 * Numerical Solution is a list of NumericalSolutionPoints (t,Y(t)), 
 * t is time (the independent variable), Y(t) is state at t.
 * 
 * @author F. Esquembre
 * @version September 2020
 */
public class NumericalSolution {
    private ArrayList<NumericalSolutionPoint> mPointList;
   
    /**
     * Creates an empty NumericalSolution
     * @param problem the InitialValueProblem being solved
     */
    public NumericalSolution() {
        mPointList = new ArrayList<>();
    }
    /**
     * Creates a NumericalSolution with the initial condition as first point
     * @param problem the InitialValueProblem being solved
     */
    public NumericalSolution(InitialValueProblem problem) {
        mPointList = new ArrayList<>();
        mPointList.add(new NumericalSolutionPoint(problem.getInitialTime(),problem.getInitialState()));        
    }
    
    /**
     * Adds a solution point
     * 
     * @param time the time of the point to add: t
     * @param state the state: Y(t)
     * @return  the newly added NumericalSolutionPoint if successful, null if failed
     */
    public NumericalSolutionPoint add(double time, double[] state) {
        NumericalSolutionPoint point = new NumericalSolutionPoint(time,state);
        if (mPointList.add(point)) return point;
        return null;
    }

    /**
     * Gets the time of the first point in the solution
     * @return 
     */
    public double getInitialTime() { return getFirstPoint().getTime(); }
    
    /**
     * Gets the time of the last point of the solution
     * @return 
     */
    public double getLastTime() { return getLastPoint().getTime(); }

    /**
     * Gets the first point in the solution
     * @return 
     */
    public NumericalSolutionPoint getFirstPoint() { 
        return mPointList.get(0);
    }
    
    /**
     * Gets the last point of the solution
     * @return 
     */
    public NumericalSolutionPoint getLastPoint() { 
        return mPointList.get(mPointList.size()-1);
    }
    
    public double getFirstStep() {
        if (mPointList.size()<=1) return Double.NaN;
        NumericalSolutionPoint secondPoint = mPointList.get(1);
        return secondPoint.getTime()-getInitialTime();
    }
    
    /**
     * Returns an iterator to iterate through the whole list of points in the solution
     * @return 
     */
    public Iterator<NumericalSolutionPoint> iterator() {
        return mPointList.iterator();
    }
    
    /**
     * Returns an iterator to iterate through the last few points in the solution
     * @param numberOfPoints int, number of points at the end
     * @return 
     */
    public Iterator<NumericalSolutionPoint> iterator(int numberOfPoints) {
        int size = mPointList.size();
        return mPointList.subList(size-numberOfPoints, size).iterator();
    }
    
}
