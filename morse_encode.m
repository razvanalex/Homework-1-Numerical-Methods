function x = morse_encode(c)
  m = morse(); 
  [aux str x] = DivEtImp(m, c, "", "");
endfunction

% parcurgere arbore prin Divide et Impera
function [ morse, str, rez ] = DivEtImp(m, ch, s, rez)
  morse = m;
  str = s; 
  if isempty(m)
     str = '*';
    return;
  else
    % parcurge cele 2 ramuri recursiv
    [ m1 str rez ] = DivEtImp(m{2}, ch, strcat(s,'.'), rez);
    [ m2 str rez ] = DivEtImp(m{3}, ch, strcat(s,'-'), rez);
    
    % cautare caracter si generarea sirului morse
    if ~isempty(m1)
      if strcmp(m1{1}, upper(ch))
         rez = strcat(s, '.');      
        return;
      endif
    endif
    
    % cautare caracter si generarea sirului morse
    if ~isempty(m2)
      if strcmp(m2{1}, upper(ch))
        rez = strcat(s, '-');
        return;
      endif
    endif
    
  endif
  
  % rezultat gol => *
  if isempty(rez)
    rez = "*";
  endif 
endfunction