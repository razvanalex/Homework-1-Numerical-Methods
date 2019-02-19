function [] = joc()
  isRunning = 1;
  gover = 0;
  stat = [0 0 0];     % [X_wins  draws  O_wins]
  
  while isRunning
    B = initBoard();
    DisplayMenu();
    [p c] = chooseXO();     % choose X or O
    drawBoard(B);
    
    while ~gover
      % X's turn    
      [B fquit]= InsertX(B, p, c);  
      drawBoard(B);
      
       % test for game over
      [gover stat] = gameOver(B, stat, p, c);           
      if  gover ~= 0
        gover = 0;
        break;
      endif
      
      % test for user's quit comant
      if  fquit
        dispStatistics(stat);
        return;
      endif    
      
      % O's turn 
      [B fquit] = InsertO(B, p, c);
      drawBoard(B);
      
       % test for game over
      [gover stat] = gameOver(B, stat, p, c);           
      if  gover ~= 0
        gover = 0;
        break;
      endif
      
      % test for user's quit comant
      if  fquit
        dispStatistics(stat);
        return;
      endif  
    endwhile
    dispStatistics(stat);
    isRunning = again();
  endwhile
endfunction

% display game title and how to play
function [] = DisplayMenu()
  printf("---------------------------------------------------\n");
  printf("##### #  ###    ##### #### ###    ##### ####  ###\n");
  printf("  #   #  #        #   #  # #        #   #  #  #_\n");
  printf("  #   #  #        #   #### #        #   #  #  #\n");
  printf("  #   #  ###      #   #  # ###      #   ####  ###\n"); 
  printf("---------------------------------------------------\n\n");
  printf("Cum se joaca: \n");
  printf("Utilizatorul poate introduce mutarea ");
  printf("prin apasarea unei taste numerice (1-9) ");
  printf("urmata de tasta ENTER sau poate sa iasa ");
  printf("din joc introducand q/Q urmata de tasta ENTER.\n");
  printf("Corespondenta mutare-numar este urmatoare: \n");
  printf("+---+---+---+\n");
  printf("| 7 | 8 | 9 |\n");
  printf("+---+---+---+\n");
  printf("| 4 | 5 | 6 |\n");
  printf("+---+---+---+\n");
  printf("| 1 | 2 | 3 |\n");
  printf("+---+---+---+\n\n");
endfunction

% choose between X and O
function [p c] = chooseXO()
  p=' ';
  printf("Nota: Cand jucatorul X este CPU, a doua mutare ");
  printf("dureaza pana la 20 secunde. Are nevoie de timp de gandire.\n\n");
  while ((p ~= 'X' && p ~= 'x') && (p ~= 'O' && p ~= 'o')) || ~length(p)
    prompt = "Alege [X/O]: ";
    p = input(prompt,'s');
    if p == 'x'
      p = 'X';
    elseif p == 'o'
      p = 'O';
    endif
  endwhile
  c = switchPlayer(p);
endfunction

% Insert X on board B
function [B, fquit] = InsertX(B, p, c)  % insert X
  if p == 'X'     % if human player is X
    [B fquit] = playerMove(B, p);
  else             % if CPU player is X
    B =CpuMove(B, c);
    fquit = 0;
  endif
endfunction

% Insert O on board B
function [B fquit] = InsertO(B, p, c)  % insert O
  if p == 'O'     % if human player is O
    [B fquit] = playerMove(B, p);
  else              % if CPU player is O
     B =CpuMove(B, c);    
     fquit = 0;
  endif
endfunction

% get player's input
function [B, fquit] = playerMove(B, xo)
    move = 0;
    i = j = 1;
    fquit = 0;
    while (move < 1) || (move > 9) || B(i, j) ~= ' ' || length(move) ~= 1
      prompt = "Introduce urmatoarea mutare [1-9]: ";
      move = input(prompt, 's');
      if ~(move >= '1' && move <= '9') && ~(move ~= 'Q' || move ~= 'q')
        continue;
      endif
      if move >= '1' && move <= '9'
        move = move - '0';
      endif
      if move == 'Q' || move == 'q'
        fquit = 1;
        return;
      endif
      i = 3 - fix((move - 1)/3);
      j = mod(move-1, 3) + 1;
    endwhile 
    B(i,j) = xo;
endfunction

% compute score for wining choise 
% (for minimax algorithm)
function [ s ] = score(board, depth, player)
  opponent = switchPlayer(player);
  if checkWin(board, player) ~= 0
    s = 10 - depth;
  elseif checkWin(board, opponent) ~= 0
    s = depth - 10;
  else 
    s = 0;
  endif
endfunction

% fix speed for first move of computer 
% which take up to 15 mins
function [c] = fixSpeed(B, cpu)
  corners = [1 3 7 9];
  edges = [2 4 6 8];
  if cpu == "X"
    rndindex = floor(1 + 4 * rand(1));
    c = corners(rndindex);
  elseif cpu == "O"
    if B(2,2) == 'X'     % X in center
      rndindex = floor(1 + 4 * rand(1));
      c = corners(rndindex);
    elseif  sum(B(corners)) == 'X' + 3 * ' '     % X on corners
      c = 5;
    elseif  sum(B(edges)) == 'X' + 3 * ' '       % X on edge
      [x y] = find(B == 'X');
      if x == 1
        y--;
      elseif x == 3
        y++;
      elseif y == 1
        x--;
      elseif y == 3
        x++;
      endif
      c = x + 3 * (3 - y);
    endif 
  endif
endfunction

% Switch player, so:
% X => O and O => X
function [rez] = switchPlayer(player)
      if player == 'X'
        rez = 'O';
      else rez = 'X';
      endif
endfunction

% minimax algorithm imprementation
function [s c] = minimax(board, depth, cPlayer, cpu)
    %check for end of possible game and compute score
    if score(board, depth, cpu) ~= 0
      s = score(board, depth, cpu);
      return;
    elseif gameOver(board, [0 0 0], switchPlayer(cpu), cpu) == 1
      s = 0;
      return;
    endif
  
    depth += 1;
    scores = [];
    moves = find(board == ' ');
    
    % check all free "boxes" remained
    for j = 1:length(moves)
      i = moves(j);
      possibleBoard = board;
      newPlayer = switchPlayer(cPlayer);
      x = mod(i - 1, 3) + 1;
      y = fix((i - 1) / 3) + 1;   
      possibleBoard(x, y) = cPlayer;
      
      % create a new possible game and check it
      newScore = minimax(possibleBoard, depth, newPlayer, cpu);
      
      % store all scores
      scores = [scores newScore];
    endfor
    
    % choose best move for CPU
    if cPlayer == cpu
        [max_val max_index] = max(scores');
        c = moves(max_index);
        c = 9 - (2- fix((c - 1)/3)) - (mod(c-1, 3) * 3);
        s = max_val;
        return;
    else
        [min_val min_index] = min(scores');
        c = moves(min_index);
        c = 9 - (2- fix((c - 1)/3)) - (mod(c-1, 3) * 3);
        s = min_val;
        return;
    endif
endfunction

% CPU's move implementation
function [B] = CpuMove(B, xo)
    move = 0;
    i = j = 1;
    while (move < 1) || (move > 9) || B(i, j) ~= ' '
      printf("Thinking...\n");
      fflush(stdout);
      if sum(sum(B ~= ' ')) <= 1
        move = fixSpeed(B, xo);
      else 
      % generate choise here
      [s move] = minimax(B, 0, xo, xo); 
      endif
      
      % if game crashes (I don't think it will)
      % you can press Ctrl+C to force exit
      pause(0.01);
      i = 3 - fix((move - 1)/3);
      j = mod(move-1, 3) + 1;
    endwhile 
    B(i,j) = xo;
endfunction

% Initialise board with empty cells
function [B] = initBoard()
  B(1:3, 1:3) = " ";
  clc;
endfunction

% Display board on CLI
function [] = drawBoard(B)
  clc
  printf("+---+---+---+\n");
  printf("| %c | %c | %c |\n", B(1,1), B(1,2), B(1,3));
  printf("+---+---+---+\n");
  printf("| %c | %c | %c |\n", B(2,1), B(2,2), B(2,3));
  printf("+---+---+---+\n");
  printf("| %c | %c | %c |\n", B(3,1), B(3,2), B(3,3));
  printf("+---+---+---+\n");
  
  % force printf to stdout
  fflush (stdout);
endfunction

% display statistics
function [] = dispStatistics(stat)
  printf("You: %d  Draws: %d  CPU: %d\n", stat(1), stat(2), stat(3));
endfunction

% check if user wants to try again
function [r] = again()
  in = ' ';
  while ((in ~= 'Y' && in ~= 'y') && (in ~= 'N' && in ~= 'n')) || ~length(in)
    prompt = "Do you want to play again? [Y/N]: ";
    in = input(prompt,'s');
  endwhile
  
  if in == 'Y' || in == 'y'
    r = 1;
  elseif in == 'N' || in == 'n'
    r = 0;
  endif
endfunction

% check win conditions
function [r] = checkWin(B, xo)
  XO=[xo xo xo];

  if (strcmp(B(1,:), XO) || strcmp(B(2,:), XO) || strcmp(B(3,:), XO) ||          % lines
      strcmp(B(:,1), XO') || strcmp(B(:,2), XO') || strcmp(B(:,3), XO') ||         % columns
      strcmp(diag(B), XO') || strcmp(diag(fliplr(B)), XO'))         % diagonals
      if xo == 'X'
        r = 1;      % X wins
      elseif xo == 'O'
        r = -1;     % O wins
      endif
    return;
  endif
  r = 0;
endfunction

% check if game is over
function [g stat] = gameOver(B, stat, p, c)
  g = 0;
  
  if (checkWin(B, p) ~= 0)        % check if X wins
    g = 1;
    stat(1)++;
    return; 
  elseif (checkWin(B, c) ~= 0)        % check if O wins
    g = 1;
    stat(3)++;
    return;
  endif
  
  % check if it's draw
  A = B(:,:) != ' ';
  if sum(sum(A(:,:))) == 9
    g = 1;
    stat(2)++;
  endif
endfunction