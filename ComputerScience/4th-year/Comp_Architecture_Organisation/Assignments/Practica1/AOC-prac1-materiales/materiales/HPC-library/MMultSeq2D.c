/* Program MMultSeq2D from elsewhere ...
Sequential Matrix multiplication: multiply two matrices A and B
to generate matrix C using a naive looping routine. */
/* --------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <omp.h>

// dtime
//
// returns the current wall clock time
//
double dtime()
{
    double tseconds = 0.0;
    struct timeval mytime;
    gettimeofday(&mytime,(struct timezone*)0);
    tseconds = (double)(mytime.tv_sec + mytime.tv_usec*1.0e-6);
    return( tseconds );
}

/*
 *   Function 'rerror' is called when the program detects an
 *   error and wishes to print an appropriate message and exit.
 */

void rerror (char *s)
{
   printf ("%s\n", s);
   exit (-1);
}

/*
 *   Function 'allocate_matrix", passed the number of rows and columns,
 *   allocates a two-dimensional matrix of floats.
 */   

void allocate_matrix (float ***subs, int rows, int cols) {
   int    i;
   float *lptr, *rptr;
   float *storage;

   storage = (float *) malloc (rows * cols * sizeof(float));
   *subs = (float **) malloc (rows * sizeof(float *));
   for (i = 0; i < rows; i++)
      (*subs)[i] = &storage[i*cols];
   return;
}

/*
 *   Given the name of a file containing a matrix of floats, function
 *   'read_matrix' opens the file and reads its contents.
 */

void read_matrix (
   char    *s,          /* File name */
   float ***subs,       /* 2D submatrix indices */
   int     *m,          /* Number of rows in matrix */
   int     *n)          /* Number of columns in matrix */
{
   char     error_msg[80];
   FILE    *fptr;          /* Input file pointer */

   fptr = fopen (s, "r");
   if (fptr == NULL) {
      sprintf (error_msg, "Can't open file '%s'", s);
      rerror (error_msg);
   }
   fread (m, sizeof(int), 1, fptr);
   fread (n, sizeof(int), 1, fptr);
   allocate_matrix (subs, *m, *n);
   fread ((*subs)[0], sizeof(float), *m * *n, fptr);
   fclose (fptr);
   return;
}

/*
 *   Passed a pointer to a two-dimensional matrix of floats and
 *   the dimensions of the matrix, function 'print_matrix' prints
 *   the matrix elements to standard output. If the matrix has more
 *   than 10 columns, the output may not be easy to read.
 */

void print_matrix (float **a, int rows, int cols)
{
   int i, j;

   for (i = 0; i < rows; i++) {
      for (j = 0; j < cols; j++)
	 printf ("%6.2f ", a[i][j]);
      putchar ('\n');
   }
   putchar ('\n');
   return;
}

/*
 *   Function 'matrix_multiply' multiplies two matrices containing
 *   floating-point numbers.
 */

void matrix_multiply (float **a, float **b, float **c,
		      int arows, int acols, int bcols)
{
   int i, j, k;
   float tmp;

   for (i = 0; i < arows; i++)
      for (j = 0; j < bcols; j++) {
	  tmp = 0.0;
	  for (k = 0; k < acols; k++)
	    tmp += a[i][k] * b[k][j];
	  c[i][j] = tmp;
      }
   return;
}

void matrix2_multiply (float **a, float **b, float **c,
		      int arows, int acols, int bcols)
{
   int i, j, k;
   float tmp;

   for (i = 0; i < arows; i++)
      for (j = 0; j < bcols; j++) 
	  for (k = 0; k < acols; k++)
	    c[i][j] += a[i][k] * b[k][j];
   return;
}

void setmat(int arows, int bcols, float **a)
{
   int i, j ;

   for (i=0;i<arows; i++)
      for (j = 0 ; j<bcols; j++)
      {
         a[i][j] = 0.0 ;
      }
}

int main (int argc, char *argv[])
{
   int m1, n1;        /* Dimensions of matrix 'a' */
   int m2, n2;        /* Dimensions of matrix 'b' */
   int nt;            /* actual number of threads */
   int nIter= 5;     /* Number of iterations */
   float **a, **b;    /* Two matrices being multiplied */
   float **c;         /* Product matrix */
   double tstart, tstop, runtime;
   double aveTime=0.0;
   double minTime=1.0e6,maxTime=0.0;
   double gflops = 0.0;


   if (argc != 3) {
      printf ("Correct syntax: %s <name_mat_A> <name_mat_B>\n", argv[0]);
      exit (-1);
   }

   read_matrix (argv[1], &a, &m1, &n1);
   read_matrix (argv[2], &b, &m2, &n2);

#ifdef VERBOSE
   print_matrix (a, m1, n1);
   print_matrix (b, m2, n2);
#endif

   if (n1 != m2) rerror ("Incompatible matrix dimensions");
   allocate_matrix (&c, m1, n2);

/* this first pragma is just to get the actual #threads used
(sanity check). */
/*#pragma omp parallel
{
#pragma omp single
   nt = omp_get_num_threads();
}
*/

   printf ("\nStarting matrix multiplication: %s by %s \n", argv[1], argv[2]);

/* warm up run to overcome setup overhead in benchmark runs below. */
   matrix_multiply (a, b, c, m1, n1, n2);

/* run the matrix multiplication function nIter times and compute
average runtime. */
for(int i=0; i < nIter; i++) {
   tstart = dtime();
   matrix_multiply (a, b, c, m1, n1, n2);
   tstop = dtime();
   //elasped time
   runtime = tstop - tstart;
   maxTime=(maxTime > runtime)?maxTime:runtime;
   minTime=(minTime < runtime)?minTime:runtime;
   aveTime += runtime;
}
   aveTime /= nIter;
// # of gigaflops we just calculated
// exact value: n1*(n1-1)
// approximates to 2*n1
   gflops = (double)( 2.0e-9*n1*m1*n2);
//
// Print the results
//
   printf("%s nThreads: %d matrixA[%d,%d] matrixB[%d,%d] maxRT %g minRT %g aveRT %g GFlop/s %g\n",
argv[0],nt,m1,n1,m2,n2,maxTime,minTime,aveTime,gflops/aveTime);


/* run the matrix multiplication function nIter times and compute
average runtime. */
aveTime=0.0;
for(int i=0; i < nIter; i++) {
   setmat (m1, n2, c);
   tstart = dtime();
   matrix2_multiply (a, b, c, m1, n1, n2);
   tstop = dtime();
   //elasped time
   runtime = tstop - tstart;
   maxTime=(maxTime > runtime)?maxTime:runtime;
   minTime=(minTime < runtime)?minTime:runtime;
   aveTime += runtime;
}
   aveTime /= nIter;
// # of gigaflops we just calculated
// exact value: n1*(n1-1)
// approximates to 2*n1
   gflops = (double)( 2.0e-9*n1*m1*n2);
//
// Print the results
//
   printf("\n version 2 \n");
   printf("%s nThreads: %d matrixA[%d,%d] matrixB[%d,%d] maxRT %g minRT %g aveRT %g GFlop/s %g\n",
argv[0],nt,m1,n1,m2,n2,maxTime,minTime,aveTime,gflops/aveTime);


#ifdef VERBOSE
   print_matrix (c, m1, n2);
#endif    

}
