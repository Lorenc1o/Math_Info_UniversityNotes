function comparar(f, a, b, n)
  int_gl = gauss_legendre(f, a, b, n);

  int_gc = gauss_chebyshev(f, a, b, n);

  int_trap = trapecios_fi(f, a, b, 50);
  int_simp = simpson_fi(f, a, b, 10);
  
  int_quad = quad(f, a, b);
  int_quadl = quadl(f, a, b);
  xx=linspace(a,b,100);
  yy=f(xx);
  int_trapz=0.01*trapz(yy);
  
  printf('Función: ');
  f
  fprintf('n\tGauss-Legendre\tGauss-Chebyshev\n');
  fprintf('%d\t%3.7e\t%3.7e\n\n',n, int_gl, int_gc);
  
  fprintf('Con errores absolutos: \n');
  fprintf('|GL-Trapecios|\t|GL-Simpson|\t|GC-Trapecios|\t|GC-Simpson|\n');
  fprintf('%3.7e\t%3.7e\t%3.7e\t%3.7e\n\n', abs(int_gl-int_trap), abs(int_gl-int_simp), abs(int_gc-int_trap), abs(int_gc-int_simp));
  
  
  fprintf('Comparamos con quad, quadl, trapz:\n');
  fprintf('|GL-quad|\t|GL-quadl|\t|GL-trapz|\t|GC-quad|\t|GC-quadl|\t|GC-trapz|\n');
  fprintf('%3.7e\t%3.7e\t%3.7e\t%3.7e\t%3.7e\t%3.7e\n\n\n', abs(int_gl-int_quad),abs(int_gl-int_quadl),abs(int_gl-int_trapz),abs(int_gc-int_quad),abs(int_gc-int_quadl),abs(int_gc-int_trapz));
endfunction