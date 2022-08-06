## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} restaCubicas (@var{a}, @var{b})
## Se guarda en retval la resta de las raices cubicas de a y b
## @seealso{}
## @end deftypefn

## Author: Jose Antonio Lorencio <jose@jose-HP-Laptop-15-bs0xx>
## Created: 2019-09-30

function retval = restaCubicas (a, b, nn)
  global n=nn
  numerador = fls(a-b);
  denominador = fls(fls(fls(a^2)^(1/3))+fls(fls((a*b))^(1/3))+fls(fls(b^2)^(1/3)));
  retval = fls(numerador/denominador);
end
