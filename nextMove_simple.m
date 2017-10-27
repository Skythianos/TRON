function series = nextMove(defMap,series)
% Calculates the next move of the player
% Input and output:
%   series: a series of moves

% It operates with basic simple selection algortitm, with the observation 
% of the next tiles

% MOVES:
%   1 -> up
%   3 -> down
%   2 -> right
%   4 -> left

% The serie is up, right, down, left (1,2,3,4)

valid = 0; % indicator if the move is valid
simple_moves = 1:4;
series_temp=series;
for ii = 1:4
    nextmove = simple_moves(ii);  
    series_temp(find(series==-1,1))=nextmove;
    valid = isValid(defMap,series_temp);
    if valid == 1
        % if it is a valid move, break the loop
        break;
    end       
end
series = series_temp;