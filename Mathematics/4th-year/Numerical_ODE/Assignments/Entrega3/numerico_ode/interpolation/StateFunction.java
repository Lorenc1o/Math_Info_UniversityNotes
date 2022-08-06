/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.interpolation;

/**
 *
 * @author paco
 */
public interface StateFunction {
    
    public double[] getState(double time);

    public double getState(double time, int index);
    
}
