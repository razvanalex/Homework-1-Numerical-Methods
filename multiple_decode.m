function x = multiple_decode(sir)
  str = strsplit(sir); % extrage cuvinte
  n = length(str);
  x="";
  
  % aplica morse pentru fiecare cuvant
  for i = 1:n
    sir = morse_decode(str(1,i){1});
    x = cstrcat(x, sir);
  endfor
endfunction