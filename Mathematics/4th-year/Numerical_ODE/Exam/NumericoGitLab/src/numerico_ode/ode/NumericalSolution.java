/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.ode;

import java.util.ArrayList;
import java.util.Iterator;

import numerico_ode.interpolation.InterpolatorFunction;
import numerico_ode.interpolation.StateFunction;

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
    
    private NumericalSolutionPoint addOrderedForwards(NumericalSolutionPoint point) {
    	NumericalSolutionPoint before = getLastPointBeforeTimeForwards(point.getTime());
    	mPointList.add(mPointList.indexOf(before)+1, point);
    	return point;
    }
    
    private NumericalSolutionPoint addOrderedBackwards(NumericalSolutionPoint point) {
    	NumericalSolutionPoint before = getLastPointBeforeTimeBackwards(point.getTime());
    	mPointList.add(mPointList.indexOf(before)+1, point);
    	return point;
    }
    
    public NumericalSolutionPoint addOrdered(NumericalSolutionPoint point) {
    	if(mPointList.get(0).getTime()<mPointList.get(1).getTime()) return addOrderedForwards(point);
    	return addOrderedBackwards(point);
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
    
    public void removeLast(int howMany) {
        int size = mPointList.size();
        howMany = Math.min(howMany, size);
        for (int i=0,last=size-1; i<howMany; i++,last--) mPointList.remove(last);
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
    
    /**
     * Returns the NumericalSolutionPoint that best fits the time given from below, using binary search
     * with h>0
     * @param t double, time we want the point to fit
     * @return
     */
    protected NumericalSolutionPoint getLastPointBeforeTimeForwards(double t) {
    	if(t<mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return null;
    	} else if(t>mPointList.get(mPointList.size()-1).getTime()) {
    		System.out.println(t + " vs " + mPointList.get(mPointList.size()-1).getTime());
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return null;
    	} //If it is the last point, we return the previous one immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		return mPointList.get(mPointList.size()-2);
    	} //If it is the first point, we return it immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return mPointList.get(0);
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()>t) {
    			size=halfSize;
    			halfSize/=2;
    		} else if(mPointList.get(halfSize+1).getTime()<=t) {
    			halfSize += (size-halfSize)/2;
    		} else {
    			flag = true;
    		}
    	}
    	return p;
    }
    
    /**
     * Returns the NumericalSolutionPoint that best fits the time given from below (absolute value), 
     * using binary search, with h<0
     * @param t double, time we want the point to fit
     * @return
     */
    protected NumericalSolutionPoint getLastPointBeforeTimeBackwards(double t) {
    	if(t>mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return null;
    	} else if(t<mPointList.get(mPointList.size()-1).getTime()) {
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return null;
    	}  //If it is the last point, we return it immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		return mPointList.get(mPointList.size()-2);
    	}//If it is the first point, we return it immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return mPointList.get(0);
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()<=t) {
    			size=halfSize;
    			halfSize/=2;
    		} else if(mPointList.get(halfSize+1).getTime()>t) {
    			halfSize += (size-halfSize)/2;
    		} else {
    			flag = true;
    		}
    	}
    	return p;
    }
    
    /**
     * Returns the NumericalSolutionPoint that best fits the time given from above, using binary search
     * with h>0
     * @param t double, time we want the point to fit
     * @return
     */
    protected NumericalSolutionPoint getFirstPointAfterTimeForwards(double t) {
    	if(t<mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return null;
    	} else if(t>mPointList.get(mPointList.size()-1).getTime()) {
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return null;
    	}  //If it is the last point, we return it immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		System.out.println("hey");
    		return mPointList.get(mPointList.size()-1);
    	} //If it is the first point, we return the next one immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return mPointList.get(1);
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()<=t) {
    			halfSize += (size-halfSize)/2;
    		} else if(mPointList.get(halfSize-1).getTime()>t) {
    			size=halfSize;
    			halfSize/=2;
    		} else {
    			flag = true;
    		}
    	}
    	return p;
    }
    
    /**
     * Returns the NumericalSolutionPoint that best fits the time given from above (absolute value),
     * using binary search with h<0
     * @param t double, time we want the point to fit
     * @return
     */
    protected NumericalSolutionPoint getFirstPointAfterTimeBackwards(double t) {
    	if(t>mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return null;
    	} else if(t<mPointList.get(mPointList.size()-1).getTime()) {
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return null;
    	} //If it is the last point, we return it immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		return mPointList.get(mPointList.size()-1);
    	} //If it is the first point, we return the next one immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return mPointList.get(1);
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()>=t) {
    			halfSize += (size-halfSize)/2;
    		} else if(mPointList.get(halfSize-1).getTime()<t) {
    			size=halfSize;
    			halfSize/=2;
    		} else {
    			flag = true;
    		}
    	}
    	return p;
    }
    
    /**
     * Returns the next point after a given one, increase performance when we want to use the two previous
     * methods one after another, with h>0
     * @param before NumericalSolutionPoint, point before the one we want to get.
     * @return
     */
    protected NumericalSolutionPoint getNextPointForwards(NumericalSolutionPoint before) {
    	return mPointList.get(mPointList.indexOf(before)+1);
    }
    
    /**
     * Returns the next point after a given one, increase performance when we want to use the two previous
     * methods one after another, with h<0
     * @param before NumericalSolutionPoint, point before the one we want to get.
     * @return
     */
    protected NumericalSolutionPoint getNextPoint(NumericalSolutionPoint before) {
    	return mPointList.get(mPointList.indexOf(before)+1);
    }
    
    /**
     * Returns the index of the element just before time t
     * @param t time
     * @return index of the point whose time best suits t, from below
     */
    protected int getIndexBeforeTimeForwards(double t) {
    	if(t<mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return -1;
    	} else if(t>mPointList.get(mPointList.size()-1).getTime()) {
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return -1;
    	} //If it is the last point, we return the previous one immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		return mPointList.size()-2;
    	} //If it is the first point, we return it immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return 0;
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()>t) {
    			size=halfSize;
    			halfSize/=2;
    		} else if(mPointList.get(halfSize+1).getTime()<=t) {
    			halfSize += (size-halfSize)/2;
    		} else {
    			flag = true;
    		}
    	}
    	return halfSize;
    }
    
    /**
     * Returns the index of the element just before time t
     * @param t time
     * @return index of the point whose time best suits t, from below
     */
    protected int getIndexBeforeTimeBackwards(double t) {
    	if(t>mPointList.get(0).getTime()) {
    		System.err.println("Unreachable point, check introduced time.");
    		return -1;
    	} else if(t<mPointList.get(mPointList.size()-1).getTime()) {
    		System.err.println("Solution point not yet computed, "
    				+ "maybe you introduced the time wrongly, "
    				+ "or you want to continue computing the solution");
    		return -1;
    	} //If it is the last point, we return the previous one immediately. 
    	else if(t==mPointList.get(mPointList.size()-1).getTime()) {
    		return mPointList.size()-2;
    	} //If it is the first point, we return it immediately
    	else if(t==mPointList.get(0).getTime()) {
    		return 0;
    	}
    	int size = mPointList.size(), halfSize = size/2;
    	NumericalSolutionPoint p = null;
    	boolean flag = false;
    	while(!flag) {
    		p = mPointList.get(halfSize);
    		if(p.getTime()<=t) {
    			size=halfSize;
    			halfSize/=2;
    		} else if(mPointList.get(halfSize+1).getTime()>t) {
    			halfSize += (size-halfSize)/2;
    		} else {
    			flag = true;
    		}
    	}
    	return halfSize;
    }
    
    /**
     * Returns the solution at any given time between initial time and last computed time so far
     * @param t time at which we want to know the value of the solution
     * @return NumericalSolutionPoint of this solution at time t
     */
    public NumericalSolutionPoint getSolutionAt(double time, InterpolatorFunction interpolator, double tolerance, int maxStep) {
    	if(getInitialTime()<= time && time<=getLastTime()){
    		NumericalSolutionPoint before = getLastPointBeforeTimeForwards(time);
    		int index = mPointList.indexOf(before);
    		NumericalSolutionPoint after = mPointList.get(index+1);
    		interpolator.setStates(before, after);
    		interpolator.setTolerance(tolerance);
    		NumericalSolutionPoint interpolation = before;
    		int nStep = 0;
    		while(Math.abs(interpolation.getTime()- time) > tolerance && nStep<maxStep) {
    			interpolation = interpolator.getSolutionPoint(time);
    			if(interpolation == null) return null;
    			mPointList.add(index+1, interpolation);
    			if(interpolation.getTime()<=time) {
    				index++;
    				interpolator.setBefore(interpolation);;
    			} else {
    				interpolator.setAfter(interpolation);
    			}
    			nStep++;
    		}
    		return interpolation;
    	} else if(getInitialTime()>=time && time >= getLastTime()) {
    		NumericalSolutionPoint before = getLastPointBeforeTimeBackwards(time);
    		int index = mPointList.indexOf(before);
    		NumericalSolutionPoint after = mPointList.get(index+1);
    		interpolator.setStates(before, after);
    		interpolator.setTolerance(tolerance);
    		
    		NumericalSolutionPoint interpolation = before;
    		while(Math.abs(interpolation.getTime()- time) > tolerance ) {
    			interpolation = interpolator.getSolutionPoint(time);
    			if(interpolation == null) return null;
    			mPointList.add(getIndexBeforeTimeBackwards(interpolation.getTime()), interpolation);
    			if(interpolation.getTime()>=time) {
    				interpolator.setBefore(interpolation);;
    			} else {
    				interpolator.setAfter(interpolation);;
    			}
    		}
    		return interpolation;
    	}
    	return null;
    }
    
}
