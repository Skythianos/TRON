function series = nextMove_NN_gen3(series,map,defMap,headPos,enemyHead)
% Calculated the next move based on the neural network
% Input and output:
%   series: a series of moves

% It operates with basic random algortitm, with the observation of the
% next tiles
% MOVES:
%   1 -> up
%   3 -> down
%   4 -> right
%   2 -> left
global global_map
glob_map = global_map;
probs = nn_gen3(map(:),headPos);
guesses = [];
valid = 0; % indicator if the move is valid
series_temp=series;

% Extended map, where the tiles aruond enemy head is considert to be
% forbidden

ext_map = map;
if enemyHead(1) - 1 > 0
    back = enemyHead(1)-1;
    ext_map(back,enemyHead(2)) = 1;
end
if enemyHead(1) + 1 < max(size(glob_map))
    forward = enemyHead(1)+1;
    ext_map(forward,enemyHead(2)) = 1;
end

if enemyHead(2) - 1 > 0
    left = enemyHead(2)-1;
    ext_map(enemyHead(1),left) = 1;
end

if enemyHead(2) + 1 < max(size(glob_map))
    right = enemyHead(2)+1;
    ext_map(enemyHead(1),right) = 1;
end
ext_map = rot90(ext_map,3);
while ~valid
    [~,nextmove] = max(probs);
    if abs(series(find(series==-1,1)-1) - nextmove) == 2;
       probs(nextmove) =  probs(nextmove) -inf;
       [~,nextmove] = max(probs);
    end
    series_temp(find(series==-1,1))=nextmove;
    guesses = [guesses nextmove];
    % Tracing the guesses
    if length(unique(guesses))==3
        % if all of our 3 chanches are gone
        break;
    end
    valid = isValid(defMap,series_temp,ext_map);
    if valid == 0
      probs(nextmove) =  probs(nextmove) -inf;
    else
        series = series_temp;
        return;
    end
end

while ~valid
    [~,nextmove] = max(probs);
    if abs(series(find(series==-1,1)-1) - nextmove) == 2;
       probs(nextmove) =  probs(nextmove) -inf;
       [~,nextmove] = max(probs);
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
    if valid == 0
      probs(nextmove) =  probs(nextmove) -inf;
    end
end
series = series_temp;