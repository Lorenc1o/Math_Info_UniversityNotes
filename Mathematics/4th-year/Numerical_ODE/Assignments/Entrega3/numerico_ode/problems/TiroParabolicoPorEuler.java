/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode.problems;

import javax.swing.JFrame;
import org.opensourcephysics.frames.PlotFrame;

/**
 * Una solución demasiado básica
 * @author F. Esquembre
 */
public class TiroParabolicoPorEuler {
    
    public static void main(String[] args) {
        listSolution();
        plotSolution();
    }
    
    static public void listSolution() {
        double c = 0.01, m = 1, g = 9.8;
        double t = 0, dt = 0.1;
        double x = 0, y = 300, vx = 100, vy = 0;
        
        while (y>0) {
            x = x + dt*vx;
            vx = vx + dt * (-c/m*vx*Math.sqrt(vx*vx+vy*vy));
            y = y + dt*vy;
            vy = vy + dt * (-c/m*vy*Math.sqrt(vx*vx+vy*vy) - g);
            t += dt;
            
            System.out.println("t="+t+", x="+x+", y="+y+", vx="+vx+", vy="+vy);
        }
    }
    
    
     static public void plotSolution() {
        PlotFrame frame = new PlotFrame ("time" , "x[*]" , "Time plot frame") ;
        frame.setConnected(true); // sets default to connect dataset points
        frame.setSize(800,600);
        frame.setXYColumnNames (0 , "time" ,"x")  ; // sets names for each dataset
        frame.setXYColumnNames (1 , "time" ,"vx") ; // sets names for each dataset
        frame.setXYColumnNames (2 , "time" ,"y")  ; // sets names for each dataset
        frame.setXYColumnNames (3 , "time" ,"vy") ; // sets names for each dataset
        
        double c = 0.01, m = 1, g = 9.8;
        double t = 0, dt = 0.1;
        double x = 0, y = 300, vx = 100, vy = 0;
        
        while (y>0) {
            x = x + dt*vx;
            vx = vx + dt * (-c/m*vx*Math.sqrt(vx*vx+vy*vy));
            y = y + dt*vy;
            vy = vy + dt * (-c/m*vy*Math.sqrt(vx*vx+vy*vy) - g);
            t += dt;
            frame.append(0, t, x);
            frame.append(1, t, vx);
            frame.append(2, t, y);
            frame.append(3, t, vy);
        }
        frame.setVisible ( true ) ;
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE) ;
    }
}
