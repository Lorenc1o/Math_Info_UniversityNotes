#ifndef _INCLUDED_BINNING_H_
#define _INCLUDED_BINNING_H_

#include <cassert>
#include <random>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <string>
#include <omp.h>

#ifdef DOUBLE_PRECISION
#define FTYPE double
#define SIN sin
#define COS cos
#else
#define FTYPE float
#define SIN sinf
#define COS cosf
#endif

// Input data arrives as arrays of cylindrical coordinates
// of particles: r and phi. Size of each array is numDataPoints
struct InputDataType {
  int numDataPoints;
  FTYPE* r;
  FTYPE* phi;
};


// The application bins particles defined in InputDataType
// into bins in Cartesian coordinates
const int nBinsX=10;
const int nBinsY=10;
typedef int BinsType[nBinsX][nBinsY];

// We assume that the radial coordinate does not exceed this value
const FTYPE maxMagnitudeR=5.0;

// Boundaries of bins:
const FTYPE xMin = -maxMagnitudeR*1.000001;
const FTYPE xMax = +maxMagnitudeR*1.000001;
const FTYPE yMin = -maxMagnitudeR*1.000001;
const FTYPE yMax = +maxMagnitudeR*1.000001;

// Reciprocal of widths of bins:
const FTYPE binsPerUnitX = (FTYPE)nBinsX/(xMax - xMin);
const FTYPE binsPerUnitY = (FTYPE)nBinsY/(yMax - yMin);

// Size of the data sample
const int n=1<<26;

// Numerical factor for conversion from wall clock time to performance units
const double HztoPerf = double(n)*1e-9;

//Strip width
const int STRIP_WIDTH = 64;


void BinParticlesReference(const InputDataType  & inputData, BinsType & outputBins) {
  // Reference implementation: scalar, serial code without optimization

  // Loop through all particle coordinates
  for (int i = 0; i < inputData.numDataPoints; i++) { 
    // Transforming from cylindrical to Cartesian coordinates:
    const FTYPE x = inputData.r[i]*COS(inputData.phi[i]);
    const FTYPE y = inputData.r[i]*SIN(inputData.phi[i]);

    // Calculating the bin numbers for these coordinates:
    const int iX = int((x - xMin)*binsPerUnitX);
    const int iY = int((y - yMin)*binsPerUnitY);

    // Incrementing the appropriate bin in the counter:
    ++outputBins[iX][iY];
  }
}

void ValidateResults(const BinsType& binnedData, const BinsType& binnedDataRef) {
  bool valid = true;

  // Comparing results. Some variation (1e-5) is acceptable due to rounding errors
  for (int i = 0; i < nBinsX; i++) {
    for (int j = 0; j < nBinsY; j++) {
      if (fabs(binnedData[i][j] - binnedDataRef[i][j]) > 1e-5*(binnedData[i][j] + binnedDataRef[i][j])) {
	valid = false;
      }
    }
  }
  
  if (!valid) {
    printf ("\nERROR: optimized algorithm produces incorrect results!\n");
    for (int i = 0; i < nBinsX; i++) {
      for (int j = 0; j < nBinsY; j++) {
        printf("[%d/%d] ", binnedData[i][j], binnedDataRef[i][j]);
      }
      printf("\n");
    }
    exit(1);
  }
}

template<typename T>
void InitializeRandomArray(T* dest, size_t size, double min, double max) {
  std::uniform_real_distribution<double> dist(min, max);
  std::default_random_engine re;
  for (size_t i = 0; i < size; ++i) {
    dest[i] = dist(re);
  }
}

double GetReferenceResults(const InputDataType & rawData, BinsType & binnedDataRef) {
  double t0 = omp_get_wtime(); printf("Initialization..."); fflush(stdout);

  // Initializing counters
  for (size_t i = 0; i < nBinsX; ++i) {
    for (size_t j = 0; j < nBinsY; ++j) {
      binnedDataRef[i][j] = 0;
    }
  }

  // Initializing arrays to some random values
  InitializeRandomArray(rawData.r, n, 0.0, maxMagnitudeR);
  InitializeRandomArray(rawData.phi, n, 0.0, 2.0*M_PI);
  
  double t1 = omp_get_wtime(); printf(" done in %.3f seconds.\n", t1-t0); fflush(stdout);

  // Computing the correct answer with the reference implementation to validate optimized implementations
  double t2 = omp_get_wtime(); printf("Computing reference result..."); fflush(stdout);
  BinParticlesReference(rawData, binnedDataRef);
  double t3 = omp_get_wtime(); printf(" done in %.3f seconds.\n", t3-t2); fflush(stdout);
  const double refTime = t3 - t2;
  const double refPerf = HztoPerf/refTime;
  printf("\033[1m%s \033[42m%10.2e GP/s\033[0m\n",
	 "Baseline performance:", refPerf);

  return refPerf;
}

#endif
