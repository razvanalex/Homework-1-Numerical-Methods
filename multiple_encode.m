function x = multiple_encode(str)
  n = length(str);
  x="";
  
  % codifica fiecare litera in cod morse
  for i=1:n
    sir = morse_encode(str(i));
    x = cstrcat(x, " " , sir);
  endfor
  
  % elimina primul spatiu din cuvat
  x = x(2:length(x));
endfunction