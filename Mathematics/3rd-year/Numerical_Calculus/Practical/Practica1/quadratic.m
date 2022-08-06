## Copyright (C) 2019 Jose Antonio Lorencio

## -*- texinfo -*- 
## @deftypefn {} {@var{x1, x2} =} quadratic (@var{a}, @var{b}, @var{c})
##  En [x1,x2] estarán las raíces de ax^2+bx+c=0
## @seealso{}
## @end deftypefn

## Author: Jose Antonio Lorencio <jose@jose-HP-Laptop-15-bs0xx>
## Created: 2019-09-30

function [x1, x2] = quadratic (a,b,c)
  global n = 7;
  d = fls(b^2-4*a*c);
  numSuma = fls(-b+sqrt(d));
  numResta = fls(-b-sqrt(d));
  if(abs(numSuma)>abs(numResta))
    x1 = fls(numSuma/(2*a));
  else
    x1 = fls(numResta/(2*a));
  end
  x2 = fls(c/(a*x1));
end
