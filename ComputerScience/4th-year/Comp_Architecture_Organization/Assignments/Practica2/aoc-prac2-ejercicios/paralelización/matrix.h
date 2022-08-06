#ifndef _matrix_h_
#define _matrix_h_

#include <iostream>
#include <iomanip>
#include <cassert>
#include <algorithm>

template<typename T>
struct Matrix {
  size_t width;
  size_t height;
  T *data;

  Matrix(size_t h, size_t w) : width(w), height(h), data(new T[h * w]) { }
  Matrix(const Matrix& o) : width(o.width), height(o.height), data(new T[width * height]) {
    std::copy(&o.data[0], &o.data[height * width], data);
  }
  Matrix& operator=(const Matrix& o) {
    if (o.width * o.height != width * height) {
      delete[] data;
      data = new T[o.height * o.width];
    }
    width = o.width;
    height = o.height;
    std::copy(&o.data[0], &o.data[height * width], data);
  }
  
  ~Matrix() { delete[] data; }
  
  T* operator[](size_t row) const { return &data[row * width]; }
  T* operator[](size_t row) { return &data[row * width]; }

  void swap_data(Matrix<T>& o) {
    assert(width == o.width);
    assert(height == o.height);
    T* t = o.data;
    o.data = data;
    data = t;
  }
};

template<typename T>
std::ostream& operator<<(std::ostream& out, const Matrix<T>& m) {
    for (size_t i = 0; i < m.height; ++i) {
      for (size_t j = 0; j < m.width; ++j) {
        out << std::fixed << std::setw(7) << std::setprecision(3) << m[i][j] << " ";
      }
      out << '\n';
    }
    return out;
}

#endif
