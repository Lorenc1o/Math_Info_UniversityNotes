function norm_res=residuo3dconstsyme(D,x,b)
n=length(b);
% res = b- matriz*x
d=b(1)-D*x(1)+x(2);
norm_res=d*d;
for i=2:n-1 
  d=b(i)+x(i-1)-D*x(i)+x(i+1);
  norm_res=norm_res+d*d;
end
d=b(n)+x(n-1)-D*x(n);
res=sqrt(norm_res+d*d);
end
