
## Author: apall <apall@DESKTOP-GFJQNNP>
## Created: 2019-05-12

function [Xm, FXm, npasos] = descensoRapido (Fobjetivo, X0, nmaxiter)
  global precision;
  global paso;
  Xm=X0;
  npasos=0;
  while npasos < nmaxiter
    FXm=feval(Fobjetivo,Xm);
    gradiente=gradienteApr(Fobjetivo,Xm);
    if abs(gradiente)<100*eps    
      warning('Posible punto estacionario, gradiente nulo');
      break;
    end
    u=-1/norm(gradiente)*gradiente;  %normalizamos el opuesto al gradiente
    alpha=1;
    F3=feval(Fobjetivo,Xm+alpha*u); 
    while F3  > FXm    
      alpha=alpha/2;
      F3=feval(Fobjetivo,Xm+alpha*u);
    end
    if alpha < precision
      Xm=Xm+alpha*u;
      FXm=F3;
      display('No se puede mejorar la aproximacion');
      display('proceso completado, debemos tener aproximado un minimo');
      break;
    end
    F2=feval(Fobjetivo,Xm+alpha/2*u);
    h1=2*(F2-FXm)/alpha;
    h2=2*(F3-F2)/alpha;
    h12=(h2-h1)/alpha;
    if abs(h12)>100*eps
     alpha_m=0.5*(alpha/2-h1/h12);
    else 
     alpha_m=alpha/2;
    end 
    Falpha_m=feval(Fobjetivo,Xm+alpha_m*u);
    if Falpha_m > F3 
      Xm=Xm+alpha*u;
      FXm=F3;
    else
      Xm=Xm+alpha_m*u;
      FXm=Falpha_m;
    end
    npasos=npasos+1;
   end
   if npasos == nmaxiter
     error('descenso Rapido no encuentra minimno relativo');
   end
endfunction
