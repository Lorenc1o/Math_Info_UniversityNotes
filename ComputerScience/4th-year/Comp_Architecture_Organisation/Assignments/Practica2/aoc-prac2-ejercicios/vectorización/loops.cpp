#include <iostream>

using namespace std;

constexpr int iterations = 100;
constexpr int arrays_size = 1000000;

double A[arrays_size];
double B[arrays_size];
double C[arrays_size];

int main(int argc, char** argv) {
  
  double total = 0;
  for (int i = 0; i < iterations; ++i) {

    /*for (int i = 0; i < arrays_size - 1; ++i) {
      A[i] = i * 2 / 3;
      B[i + 1] = A[i] - B[i];
    }*/
    for (int i = 0; i < arrays_size; ++i) A[i] = i* 2/3;
    /*for (int i = 0; i < arrays_size - 5; ++i) {
      B[i + 5] = A[i+4] - A[i+3] + A[i+2] - A[i+1] + A[i] - B[i];
    }*/
    for (int i = 0; i < arrays_size - 4; ++i) {
      B[i + 4] = A[i+3] - A[i+2] + A[i+1] - A[i] + B[i];
    }
    for (int i = 0; i < 5; ++i){
     B[i+1] = A[i] - B[i];
    }  

    for (int i = 0; i < arrays_size - 1; ++i) {
      A[i] = A[i] - B[i];
      B[i + 1] = C[i] * 2;
    }
    
    /*for (int i = arrays_size; i > 0; --i) {
      A[i - 1] = A[i] + C[i];
      B[i] = C[i] - B[i];
    }*/
    
    for (int i = arrays_size; i > arrays_size-5; --i) {
      A[i - 1] = A[i] + C[i];
    }
    
    for (int i = arrays_size; i > 5; --i) {
      A[i - 5] = A[i] + C[i] + C[i-1] + C[i-2] + C[i-3] + C[i-4];
    }
    
    for (int i = arrays_size; i > 0; --i) {
      B[i] = C[i] - B[i];
    }

    for (int i = 0; i < arrays_size; ++i) {
      C[i] = A[i] + 2 * B[i];
    }
	
    double aux[4*4];
    for (int i = 0; i < arrays_size/(4*4); ++i) {
    	for (int j=0; j<4*4; j++){
    	  aux[j] += C[16*i+j];
    	}
      
    }
    for (int i=arrays_size; i> arrays_size-arrays_size%16; --i) {
    	total = total + C[i];
    }
    for (int i=0; i<16; i++){
      total = total + aux[i];
    }
    
  }
  
  cout << total << endl; 
  
  return 0;
}
