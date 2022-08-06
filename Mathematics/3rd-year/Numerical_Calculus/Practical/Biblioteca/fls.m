## Copyright (C) 2019 Jose Antonio Lorencio
## -*- texinfo -*- 
## Usa una variable global n con el número de dígitos a redondear
## @deftypefn {} {@var{retval} =} fls (@var{x})
    ## x es la variable a redondear
    ## retval es el valor redondeado
##
## @seealso{}
## @end deftypefn

## Author: Jose Antonio Lorencio <jose@jose-HP-Laptop-15-bs0xx>
## Created: 2019-09-30



function retval = fls (x)
  global n;
  retval = eval(mat2str(x,n));
end
