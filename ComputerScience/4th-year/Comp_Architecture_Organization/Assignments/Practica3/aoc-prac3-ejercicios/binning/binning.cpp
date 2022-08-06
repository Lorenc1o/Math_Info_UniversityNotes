#include "binning.h"

void BinParticles(const InputDataType  & inputData, BinsType & outputBins) {
  #pragma omp parallel num_threads(4)
  {
  	//Private variable for reduction
    BinsType reductionOutputBins;
    #pragma simd
    for(int i=0; i<nBinsX;i++)
      for(int j=0; j<nBinsY;j++)
        reductionOutputBins[i][j] = 0;

    /*#pragma omp for
	  for (int i = 0; i < inputData.numDataPoints; i++) { 
	    // Transforming from cylindrical to Cartesian coordinates:
	    const FTYPE x = inputData.r[i]*COS(inputData.phi[i]);
	    const FTYPE y = inputData.r[i]*SIN(inputData.phi[i]);

	    // Calculating the bin numbers for these coordinates:
	    const int iX = int((x - xMin)*binsPerUnitX);
	    const int iY = int((y - yMin)*binsPerUnitY);

	    // Incrementing the appropriate bin in the counter
	    ++reductionOutputBins[iX][iY];
    */
    #pragma omp for
    for(int ii=0; ii<inputData.numDataPoints; ii+=STRIP_WIDTH){
      int iX[STRIP_WIDTH] __attribute__((aligned(64)));
      int iY[STRIP_WIDTH] __attribute__((aligned(64)));

      const FTYPE* r = &(inputData.r[ii]);
      const FTYPE* phi = &(inputData.phi[ii]);

      #pragma vector aligned
      for(int c=0; c<STRIP_WIDTH; c++){
        const FTYPE x = r[c]*COS(phi[c]);
	      const FTYPE y = r[c]*SIN(phi[c]);
        iX[c] = int((x-xMin)*binsPerUnitX);
        iY[c] = int((y-yMin)*binsPerUnitY);
      }

      for(int c=0; c<STRIP_WIDTH; c++){
        reductionOutputBins[iX[c]][iY[c]]++;
      }
    }

    //Updating of outPutBins
    for(int i=0; i<nBinsX; i++)
      for(int j=0; j<nBinsY; j++)
        #pragma omp atomic
        outputBins[i][j] += reductionOutputBins[i][j];
  }

  
}



int main(int argv, char* argc[]) {
  // Greeting
  printf("\nParticle Binning Optimization Demo (%s)\n%s\n%s\n\n",
#ifdef DOUBLE_PRECISION
	 "double precision",
#else
	 "single precision",
#endif
	 "Additional information is available in accompanying papers at http://colfaxresearch.com/\n",
	 "(c) Colfax International, 2015.");

  // Allocate data
  InputDataType rawData; // Input of the calculation
  BinsType binnedData;   // Output of the calculation
  rawData.numDataPoints = n;
  rawData.r   = (FTYPE*) _mm_malloc(sizeof(FTYPE)*n,64);
  rawData.phi = (FTYPE*) _mm_malloc(sizeof(FTYPE)*n,64);

  // Get reference results and performance
  BinsType binnedDataRef;
  const double refPerf = GetReferenceResults(rawData, binnedDataRef);

  // Run the benchmark of the optimized code
  printf("\nBenchmarking...\n\n"); fflush(stdout);
  printf("\033[1m%7s %10s %10s %10s %s\033[0m\n", "Trial", "Time, s", "Speedup", "GP/s", "*");

  const int nTrials = 10;
  const int skipTrials = 2;
  double perf = 0.0, dperf = 0.0;

  for (int t=1; t<=nTrials; t++){
    // Reset counters
    for (size_t i = 0; i < nBinsX; ++i) {
      for (size_t j = 0; j < nBinsY; ++j) {
        binnedData[i][j] = 0;
      }
    }

    // Compute and benchmark
    double t0 = omp_get_wtime();
    BinParticles(rawData, binnedData);
    double t1 = omp_get_wtime();

    // Validating results
    if (t == 1) ValidateResults(binnedData, binnedDataRef);
      
    // Translate wall clock time to performance units
    if (t > skipTrials) {
      // Ignore the first few trials: those are warm-up
      perf += HztoPerf/(t1-t0);
      dperf += HztoPerf*HztoPerf/((t1-t0)*(t1-t0));
    }
      
    printf("%7d %10.3e %10.2f %10.2e %s\n", 
	   t, (t1-t0), HztoPerf/((t1-t0)*refPerf), HztoPerf/(t1-t0), (t<=skipTrials?"**":""));
    
    fflush(stdout);
   
  }
   
  perf /= (double)(nTrials-skipTrials); 
  dperf=sqrt(dperf/(double)(nTrials-skipTrials)-perf*perf);
  printf("---------------------------------------------------------\n");
  printf("\033[1m%s%7.2f \033[42m%10.2e +- %.2e GP/s\033[0m\n",
	 "Optimized performance:", perf/refPerf, perf, dperf);
  printf("---------------------------------------------------------\n");
  printf("*  - Performance unit 1 GP/s is 10^9 particles binned per second.\n"); 
  printf("** - warm-up, not included in average\n\n"); fflush(stdout);

  _mm_free(rawData.r);
  _mm_free(rawData.phi);
}
