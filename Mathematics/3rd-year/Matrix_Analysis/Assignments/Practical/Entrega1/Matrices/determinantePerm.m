function d = determinantePerm(P)
  d = 1;
  n = length(P);
  for k=1:n-1
    if P(k,k)==1
      continue
    endif
    for i=k+1:n
      if P(i,k)==1
        P([k,i],:)=P([i,k],:);
        d = -d;
        break
      endif
    endfor
  endfor
endfunction
