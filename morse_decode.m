function x = morse_decode(sir)
  % initializare cod morse
  m = morse();
  
  % traduce litera din codul morse in litere latine
  for i = sir
    % pentru caracterul . arborele se parcurge prin stanga
    if i == '.'
      if ~isempty(m{2})
        m = m{2};
      else 
        x = '*';  % daca nu exista caracterul
        return;
      endif
    % pentru caracterul - arborele se parcurge prin dreapta
    elseif i == '-'
      if ~isempty(m{3})
        m = m{3}; 
      else 
        x = '*'; % daca nu exista caracterul
        return;
      endif
    else 
        x = '*'; % daca nu exista caracterul
        return;
    endif
  endfor
  x=m{1}; % returneaza litera obtinuta
  endfunction