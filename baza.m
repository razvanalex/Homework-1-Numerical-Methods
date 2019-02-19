function r = baza(sursa, b1, b2)
  n = length(sursa);  % obtine lungimea sir sursa
  s = zeros(1, n);  % initializare rezultat cu 0-uri
  nr_10 = [0];
  r = 0;
  
  % verificare conditii baze
  if b1 < 2 || b1 > 30
    return;
  endif
  if b2 < 2 || b2 > 30
    return;
  endif
  
  % conversie catre vector
  baza1 = NumToVect(b1);
  baza2 = NumToVect(b2);
  
  for i=1:n
    % conversie caractere in cifre
    if sursa(i) > 96 && sursa(i) < 123   % conversie a-z in cifre
      s(i) = sursa(i) - 87;
    elseif sursa(i) > 64 && sursa(i) < 91   % conversie A-Z in cifre
      s(i) = sursa(i) - 55; 
    elseif sursa(i) >= 48 && sursa(i) <= 57  % conversie 0-9 in cifre
      s(i) = sursa(i) - 48;
    endif
    
    % conversie in baza 10    
    nr_10 = add(nr_10, mult(s(i),pow(baza1, n-i)));
  endfor

  % conversie din baza 10 in baza b2
  i = 1;
  while cmp(nr_10, 0) == 1
    [nr_10 rez] = divQR(nr_10, baza2);
    r(i) = VectToNum(rez);
    i++;
  endwhile
  r = fliplr(r);

  % conversie cifre in caractere
  for i=1:length(r)
    % translatare in ASCII
    if r(i) >= 0 && r(i) <= 9
      r(i) = "0" + r(i);
    elseif r(i) >= 10
      r(i) = "A" + r(i) - 10;
    endif
  endfor
  r=char(r);   % conversie in char
endfunction

% suma cu numere mari
function [ r ] = add(a, b)
  T = 0;
  lenA = length(a);
  lenB = length(b);
  
  if (lenA < lenB)
    for i = 1 : lenB - lenA
      a = [0 a];
      lenA++;
    endfor
  else 
    for i = 1 : lenA - lenB
      b = [0 b];
      lenB++;
    endfor
  endif
  
  for i = lenA : -1 : 1
    a(i) += b(i) + T;
    T = fix(a(i) / 10);
    a(i) = mod(a(i), 10);
  endfor
  
  if T ~= 0
    a = [0 a];
    a(1)=T;
  endif
  
  r = a;
endfunction

% inmultire cu numere mari
function [ r ] = mult(a, b)
  T = 0;
  lenA = length(a);
  lenB = length(b);
  lenR = lenA + lenB - 1;

  r = zeros(1, lenR);
  for i = lenA : -1 : 1
    for j = lenB : -1 : 1
      r(i+j-1) += a(i) * b(j);
    endfor
  endfor
  
  for i = lenR : -1 : 1
    r(i) += T;
    T=fix(r(i) / 10);
    r(i) = mod(r(i), 10);  
  endfor
  
  if T ~= 0
    r = [0 r];
    r(1)=T;
  endif
endfunction

% ridicarea la putere cu numere mari
function [ r ] = pow(a, b) 
  r = 1;
  for i = 1 : b
    r = mult(r, a);
  endfor
endfunction

% impartirea cu rest cu numere mari
function [ q r ] = divQR(a, b)
  r = [];
  lenA = length(a);
  lenB = length(b);
  lenQ = lenA;
  lenR = 0;
  
  for i = 1:lenA
    lenR = length(r);
    lenR++;
    r(lenR) = a(i);
    q(i) = 0;   
    while cmp(b, r) ~= 1
      q(i)++;
      r = sub(r, b);
    endwhile
  endfor
  
  r = fixNum(r);
  q = fixNum(q);
endfunction

% diferenta cu numere mari
function [r] = sub(a, b)
  T = 0;
  lenA = length(a);
  lenB = length(b);
  
  for i = 1 : lenA - lenB
    b = [0 b];
    lenB++;
  endfor
  
  for i = lenA : -1 : 1
    a(i) =  a(i) - (b(i) + T);
    if a(i) < 0
      T = 1;
    else 
      T = 0;
    endif
    if T ~= 0
      a(i) += 10;
    endif
  endfor

  r = fixNum(a);
endfunction

% compara 2 numere mari
function [ r ] = cmp(a, b)
  a = fixNum(a);
  b = fixNum(b);
  
  lenA = length(a);
  lenB = length(b);
  
  if lenA < lenB
    r = -1;
    return;
  elseif lenB < lenA
    r = 1;
    return;
  endif

  for i = 1:lenA  
    if a(i) < b(i)
      r = -1;
      return;
    elseif a(i) > b(i)
      r = 1;
      return;
    endif
  endfor   
  
  r = 0;
endfunction

% elemina cifrele de la inceputul unui vector
% pentru a evita ca un numar sa inceapa cu 0
function [ r ] = fixNum(a)
   k=1;
  while a(k) == 0 && k < length(a)
    k++;
  endwhile
  r = a(k:length(a));
endfunction

%converteste un numar in vector ce cifre
function [ r ] = NumToVect(v)
  while v > 9
    r(1) = mod(v, 10);  % se extrag cifrele
    v = fix(v / 10);
    r = [0 r];      % se introduc cifrele intr-un vector
  endwhile
  r(1) = v;
endfunction

% converteste un vector de cifre la un numar
function [ r ] = VectToNum(n)
  len = length(n);
  r = 0;
  for i=0 : len-1
    r = r * 10 + n(i + 1);
  endfor
endfunction
