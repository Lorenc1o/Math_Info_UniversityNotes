//
// helloflops2
//
// A simple example to try 
// to get lots of Flops 
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
//
// dtime -
//
// utility routine to return 
// the current wall clock time
//
double dtime()
{
    double tseconds = 0.0;
    struct timeval mytime;
    gettimeofday(&mytime,(struct timezone*)0);
    tseconds = (double)(mytime.tv_sec + mytime.tv_usec*1.0e-6);
    return( tseconds );
}


// Floating pt ops per inner loop iteration
#define FLOPSPERCALC 14

//
// Main program - pedal to the metal...calculate tons o'flops!
// 
int main(int argc, char *argv[] ) 
{
  // Problem size parameters
  const int MAXFLOPS_ITERS = (argc > 1 ? atoi(argv[1]) : 10000000);
  const int LOOP_COUNT = (argc > 2 ? atoi(argv[2]) : 64);
        int j,k;
        double tstart, tstop, ttime;
	double gflops = 0.0;
        float suma1 = 0.0, suma2 = 0.0, suma3 = 0.0, suma4 = 0.0, suma5 = 0.0, suma6 = 0.0, suma7 = 0.0, suma8 = 0.0;
        float suma11 = 0.0, suma12 = 0.0, suma13 = 0.0, suma14 = 0.0, suma15 = 0.0, suma16 = 0.0;

        printf("Starting Compute\r\n");

        tstart = dtime();	
        // loop many times to really get lots of calculations
        for(j=0; j<MAXFLOPS_ITERS; j++)  
        {
        //
        // just to sum a variable a lot of times 
        //
            for(k=0; k<LOOP_COUNT; k++)  
   	    {
               	suma1+=1.0;
		suma2+=1.0;
		suma3+=1.0;
		suma4+=1.0;
		suma5+=1.0;
		suma6+=1.0;
		suma7+=1.0;
		suma8+=1.0;
               	suma11+=1.0;
               	suma12+=1.0;
               	suma13+=1.0;
               	suma14+=1.0;
               	suma15+=1.0;
               	suma16+=1.0;
            }
	 }
         tstop = dtime();

         // # of gigaflops we just calculated  
         gflops = (double)( 1.0e-9*LOOP_COUNT*MAXFLOPS_ITERS*FLOPSPERCALC);    

	 // elasped time
         ttime = tstop - tstart;

         //
         // Print the results
         //
         if ((ttime) > 0.0)
         {
             printf("GFlop = %10.3lf, Secs = %10.3lf, GFlop per sec = %10.3lf (GFLOPs), suma1 = %10.3lf, suma2 = %10.3lf \r\n",
                     gflops, ttime, gflops/ttime, suma1+suma2+suma3+suma4+suma5+suma6+suma7+suma8, suma11+suma12+suma13+suma14+suma15+suma16);
         }
         
         return 0;
}
