#ifndef _heat_h_
#define _heat_h_

#include "matrix.h"

void solve(Matrix<double>& state, double tolerance, int& iterations, double& last_difference);

#endif
