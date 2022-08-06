% Funcion para evaluar el spline en t
% Entradas:   
%            - x       = vector que contiene las abscisas de los puntos a interpolar (nodos)
%            - a,b,c,d = coeficientes del spline
%            - t       = valor donde se evaluar el spline, puede ser un valor o un
%                         vector de coordenadas.
% Salida: 
%            - valor = evaluación del spline en t 
%            

function valor = splineEval(x,a,b,c,d,t)
  n=length(x)-1;
  m=length(t);
  valor=zeros(1,m);
  if(t(1)==x(1))
   valor(1)=a(1);
  end
  for i=1:n
    lugar=and(x(i)<t,t<=x(i+1));
    valor=valor+lugar.*(a(i)+(t-x(i)).*(b(i)+(t-x(i)).*(c(i)+(t-x(i)).*d(i))));
  end
end

