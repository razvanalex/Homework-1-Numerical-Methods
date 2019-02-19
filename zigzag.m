function Z = zigzag(n)
  val = 0;
  for i = 1:2*n
   % parcurgere pe liniile cu i impar
    if mod(i, 2) == 1  
      for j=1:i-1
        % j si i-j trebuie sa fie mai mici ca n => matrice n x n
        if j <= n && i - j <= n
          Z(j, i-j) = val;
          val++;  %incrementare valoare curenta
        endif
      endfor
    else % parcurgere pe liniile cu i par
      for j=i-1:-1:1
        % j si i-j trebuie sa fie mai mici ca n => matrice n x n
        if j <= n && i - j <= n
          Z(j, i-j) = val;
          val++;  %incrementare valoare curenta
        endif
      endfor
    endif
  endfor
endfunction