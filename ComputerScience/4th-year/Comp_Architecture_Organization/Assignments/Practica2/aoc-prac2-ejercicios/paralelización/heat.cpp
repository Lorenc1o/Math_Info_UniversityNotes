#include "heat.h"

#include <iostream>

using namespace std;

extern bool verbose;

/*
 * Simula la propagación de calor en una superficie representada por
 * la matriz «state».
 *
 * Recibe el estado inicial en «state» y modifica la matriz
 * iterativamente hasta que ningún elemento de la misma cambia más de
 * «tolerance» entre dos itereciones.
 *
 * Devuelve el estado final en «state», el número de iteraciones
 * empleado en «iterations» y el mayor cambio de un elemento durante
 * la última itereción en «last_difference».
 */
void solve(Matrix<double>& state, double tolerance, int& iterations, double& last_difference) {
  Matrix<double> next_state = state;
  iterations = 0;
  double difference;
  do {
    difference = 0;
#pragma omp parallel for collapse(2) schedule(static) reduction(max: difference) 
    for (size_t i = 1; i < state.height - 1; ++i) {
      for (size_t j = 1; j < state.width - 1; ++j) {
        next_state[i][j] = (state[i][j]
                            + state[i + 1][j + 1]  
                            + state[i - 1][j + 1]  
                            + state[i + 1][j - 1]  
                            + state[i - 1][j - 1]) / 5;
        difference = max(difference, abs(next_state[i][j] - state[i][j]));
      }
    }

    state.swap_data(next_state);
    
    if (verbose) {
      cout << "Iteration " << iterations << ":\n" << state;
      cout << "Difference: " << difference << endl;
    }
    ++iterations;
  } while (difference > tolerance);
  last_difference = difference;
}

