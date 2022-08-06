

## Author: apall <apall@DESKTOP-GFJQNNP>
## Created: 2019-05-12

function F_objetivo_X = objetivo (F, X)
  n=length(X);
  FX=feval(F,X);
  F_objetivo_X=0;
  for i=1:n
   F_objetivo_X=F_objetivo_X + FX(i).^2;
  end
endfunction
