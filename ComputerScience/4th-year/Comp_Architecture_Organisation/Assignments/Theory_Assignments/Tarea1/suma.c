//
// helloflops1
//
// A simple example to try 
// to get lots of Flops 
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

//
// Main program - 
// 
void main(int argc, char *argv[] ) 
{
  // Problem size parameters
  const int MAXFLOPS_ITERS = (argc > 1 ? atoi(argv[1]) : 10000000);
  const int LOOP_COUNT = (argc > 2 ? atoi(argv[2]) : 64);
        int i,j,k;
        float suma = 0.0;

        printf("Starting Compute\r\n");

        clock_t begin = clock();

        // loop many times to really get lots of calculations
        for(j=0; j<MAXFLOPS_ITERS; j++)  
        {
        //
        // just to sum a variable a lot of times 
        //
            for(k=0; k<LOOP_COUNT; k++)  
   	    {
               	suma+=1.0;
            }
        
        }
        clock_t end = clock();
        double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
        printf("tiempo = %f\n", time_spent);
       
	 

         //
         // Print the results
         //
         printf("suma = %10.3lf\r\n", suma);
}
