/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package numerico_ode;

import numerico_ode.tools.DisplaySequence;

/**
 *
 * @author paco
 */
public class Introduccion {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        diezVecesCeroUno();
        sumaSencilla();
        double[] seq = sucesionRecurrente(20);
        DisplaySequence.list(seq);
        double[] seq2= sucesionRecurrente(40);
        DisplaySequence.animate(seq2);
    }
    
    
    static private void diezVecesCeroUno (){
      double x = 0.1;
      double y = x+x+x+x+x + x+x+x+x+x;
      if (y==1.0) System.out.println("10 veces 0.1 = 1");
      else        System.out.println("10 veces 0.1 NO es igual a 1");
    }
    
    static private void sumaSencilla() {
        double s1 = 23.53 + 5.88 + 17.64;
        double s2 = 23.53 + 17.64 + 5.88;
        
        if (s1==s2) System.out.println("La suma es conmutativa (y asociativa)");
        else         System.out.println("La suma NO siempre es conmutativa (y asociativa)");
    }
    
    static private double[] sucesionRecurrente(int max) {
        double x[] = new double[max];
        int n=2;
        x[0]=1;
        x[1]=1./3.;
        while (n<max) {
            x[n] = (13./3.)*x[n-1] - (4./3.)*x[n-2];
            n = n+1;
        }
        return x;
    }
 
}
