/* Program MMult2Seq2D from Intel ...
Sequential Matrix multiplication: multiply two square matrices A and B
to generate matrix C using a looping routine  */


#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
//#include <omp.h>

#define MATSIZE 4096
#define BLOCKSIZE 512

void setmat() ;
void fillmat() ;
void abasicmm() ;
void abettermm() ;
void checkmatmult() ;

// returns the current wall clock time
//
double dtime(struct timespec ts1, struct timespec ts2)
{
      double t1, tmp ;
      t1 =  ts2.tv_sec-ts1.tv_sec;
      tmp = ts2.tv_nsec-ts1.tv_nsec;
      tmp /= 1.0e+09 ;
      t1 += tmp ;
    return( t1 );
}


int main(int argc, char *argv[])
{

   float *a, *b, *c, *aa ;
   unsigned int n ;
   unsigned i, j, k, iInner, jInner, kInner, blockSize, nt ;
   struct timespec ts1, ts2, ts3, ts4, ts5, ts6, ts7 ;
   int nIter= 5;     /* Number of iterations */
   double runtime, aveTime;
   double minTime=1.0e6,maxTime=0.0;
   double gflops = 0.0;

   blockSize = BLOCKSIZE ; // default settings

/* this first pragma is just to get the actual #threads used
(sanity check). 
#pragma omp parallel
{
#pragma omp single
   nt = omp_get_num_threads();
}
*/

/*   if (argc != 3)
   {
      printf("input matrix size and blocksize\n") ;
      exit(0);
   }
*/
   n = (argc>1 ? atoi(argv[1]) : MATSIZE);
/*   blockSize = atoi(argv[2]) ; */

   printf("matrix size %d blocksize %d\n", n,blockSize) ;
   if (n%blockSize)
   {
      printf("for this simple example matrix size must be a multiple of the block size.\n  Please re-start \n") ;
      exit(0);
   }
// allocate matrices
   a = (float *)calloc(n*n, sizeof(float)) ;
   b = (float *)calloc(n*n, sizeof(float)) ;
   c = (float *)calloc(n*n, sizeof(float)) ;
   aa = (float *)calloc(n*n, sizeof(float)) ;
   if (aa == NULL) // cheap check only the last allocation checked.
   {
     printf("insufficient memory \n") ;
     exit(0) ;
   }

// fill matrices

   setmat(n, n, a) ;
   setmat(n, n, aa) ;


   srand(4.16) ; // set random seed (change to go off time stamp to make it better

   fillmat(n,n,b) ;
   fillmat(n,n,c) ;

/* warm up run to overcome setup overhead in benchmark runs below. */
   abasicmm (n,n,a,b,c) ;

/* run the matrix multiplication function nIter times and compute
average runtime. */
   aveTime=0.0;
for(i=0; i < nIter; i++) {
   setmat(n, n, a) ;
   clock_gettime(CLOCK_REALTIME, &ts1) ;
// multiply matrices
   abasicmm (n,n,a,b,c) ;
   clock_gettime(CLOCK_REALTIME, &ts2) ;
   //elasped time
   runtime = dtime(ts1,ts2);
   maxTime=(maxTime > runtime)?maxTime:runtime;
   minTime=(minTime < runtime)?minTime:runtime;
   aveTime += runtime;
}
   aveTime /= nIter;
// # of gigaflops we just calculated
// exact value: n1*(n1-1)
// approximates to 2*n1
   gflops = (double)( 2.0e-9*n*n*n);
//
// Print the results
//
   printf("ijk ordering basic time \n");
   printf("%s matrixB[%d,%d] matrixC[%d,%d] maxRT %g minRT %g aveRT %g GFlop/s %g\n",
argv[0],n,n,n,n,maxTime,minTime,aveTime,gflops/aveTime);

/* run the matrix multiplication function nIter times and compute
average runtime. */
   minTime=1.0e6;
   maxTime=0.0;
   aveTime=0.0;
for(i=0; i < nIter; i++) {
   setmat(n, n, a) ;
   clock_gettime(CLOCK_REALTIME, &ts3) ;
// multiply matrices
   abettermm (n,n,a,b,c) ;
   clock_gettime(CLOCK_REALTIME, &ts4) ;
   //elasped time
   runtime = dtime(ts3,ts4);
   maxTime=(maxTime > runtime)?maxTime:runtime;
   minTime=(minTime < runtime)?minTime:runtime;
   aveTime += runtime;
}
   aveTime /= nIter;
// # of gigaflops we just calculated
// exact value: n1*(n1-1)
// approximates to 2*n1
   gflops = (double)( 2.0e-9*n*n*n);
//
// Print the results
//
   printf("ikj ordering better time \n");
   printf("%s matrixB[%d,%d] matrixC[%d,%d] maxRT %g minRT %g aveRT %g GFlop/s %g\n",
argv[0],n,n,n,n,maxTime,minTime,aveTime,gflops/aveTime);


   printf("matrix multplies complete \n") ; fflush(stdout) ;

/*
   checkmatmult(n,n,a,aa) ;


*/
}

void setmat(int n, int m, float a[n][m])
{
   int i, j ;

   for (i=0;i<n; i++)
      for (j = 0 ; j<m; j++)
      {
         a[i][j] = 0.0 ;
      }
}

void fillmat(int n, int m, float a[n][m])
{
   int i, j ;

   for (i = 0; i<n; i++)
      for (j = 0 ; j < m; j++)
      {
         a[i][j] = (float)rand() / 3.1e03 ;
      }
}

void abasicmm(int n, int m, float a[n][m], float b[n][m], float c[n][m])
{
   int i, j, k ;

   for (i=0;i<n; i++)
      for (j = 0; j<n; j++)
         for (k=0;k<n; k++)
            a[i][j] += b[i][k]* c[k][j] ;
}

void abettermm(int n, int m, float a[n][m], float b[n][m], float c[n][m])
{
   int i, j, k ;

   for (i=0;i<n; i++)
      for (k=0;k<n; k++)
         for (j = 0; j<n; j++)
            a[i][j] += b[i][k]* c[k][j] ;
}

void checkmatmult(int n,int m, float a[n][m], float aa[n][m])
{
// crude check.  Never compare floating point or double with ==.
// most floating point results are too sensitive to order of operations.
// this worked(sizes up to about 4600) it was quick, in general this is not safe
   int i, j ;
for (i=0;i<n;i++)
for (j=0;j<m;j++)
   if (a[i][j]-aa[i][j] != 0.0) printf("diff i %d %d diff %lf\n",i,j,a[i][j]=aa[i][j]) ;
printf("check OK\n") ;
}

   

