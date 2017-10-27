function series = nextMove(defMap,series)
% Calculates the next move of the player
% Input and output:
%   series: a series of moves

% It operates with basic random algortitm, with the observation of the
% next tiles

% MOVES:
%   1 -> up
%   3 -> down
%   2 -> right
%   4 -> left
global global_map
glob_map = global_map;
guesses = [];
valid = 0; % indicator if the move is valid
series_temp=series;
while ~valid
    nextmove = randi(4);
    while abs(series(find(series==-1,1)-1)-nextmove) == 2
        % preventing going backward
        nextmove = randi(4);
    end    
    series_temp(find(series==-1,1))=nextmove;
    guesses = [guesses nextmove];
    % Tracing the guesses
    if length(unique(guesses))==3
        % if all of our 3 chanches are gone
        series = series_temp;
        return;
    end
    valid = isValid(defMap,series_temp,glob_map);
end
series = series_temp;