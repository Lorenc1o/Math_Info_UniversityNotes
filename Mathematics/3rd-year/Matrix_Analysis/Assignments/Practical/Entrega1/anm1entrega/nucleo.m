function N=nucleo(A)
  
    [L,U,P,Q,r]=LUPQGeneral(A);

    control_factorizacion=norm(P*A*Q-L*U);
    
    [m,n]=size(A);

    %esto tenía sentido cuando realizaba el ejercicio, ahora pongo ; para 
    %que no moleste
    U %imprimimos U para ver que tiene la forma del enunciado, vemos como
      %Ur tiene dimensión 3x3 y G 3x3 (con r=3, n=6)
    Ur=U(1:r,1:r);
    G=U(1:r,r+1:n); %para verlo aún más claramente

    Kr=solveU(Ur,-G); %obtenemos Kr, de dimensión rx(n-r)

    %ahora generamos K
    K=zeros(n,r);
    K(1:r,1:(n-r))=Kr;
    K(r+1:n,1:r)=eye(n-r);
    K; %Para ver cómo queda K

    %Vamos a comprobar que es una base del núcleo. Como U es rxn, el núcleo estará
    %determinado por una base de r vectores columna, en nuestro caso 3

    for i=1:(n-r)
      Ki=U*K(1:n,i);
      if norm(Ki) > 10e-15
        printf("No es un vector del núcleo\n")
         %esto no llega a imprimirse nunca en el ej 1: OK
        K(1:n,i)=zeros(n,1);
      endif
    endfor 
    
    %Por último, generamos el núcleo de A y lo devolvemos
    N=Q*K;
  
endfunction