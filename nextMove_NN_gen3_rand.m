function series = nextMove_NN_gen3_rand(series,map,defMap,headPos)
% Calculated the next move based on the neural network
% It uses not only the output of the neural network. The final move will be
% decieded randomly
% Input and output:
%   series: a series of moves

% It operates with basic random algortitm, with the observation of the
% next tiles
% MOVES:
%   1 -> up
%   3 -> down
%   4 -> right
%   2 -> left

probs = nn_gen3(map(:),headPos);
guesses = [];
valid = 0; % indicator if the move is valid
series_temp=series;
probs_cum = cumsum(probs); 
% Alrogithm for next move:
% Making a cummulated sum from the probabilites outputted by NN
% generating an uniformly distributed rand
% The next move will be the fist element smaller than the rand
% If there is too much invalid move, we give back control the original
% algoritm
ii = 0;
while ~valid
    ii = ii + 1;
    if ii > 5 || max(probs) > 0.7
        series_temp = nextMove_NN_gen3(series,map,defMap,headPos);
        break;
    end
    nextmove = find(probs_cum>rand,1); 
    if abs(series(find(series==-1,1)-1) - nextmove) == 2;
       nextmove = find(probs_cum>rand,1); 
    end
    series_temp(find(series==-1,1))=nextmove;
    guesses = [guesses nextmove];
    % Tracing the guesses
    if length(unique(guesses))==3
        % if all of our 3 chanches are gone
        series = series_temp;
        return;
    end
    valid = isValid(defMap,series_temp);
    if valid == 0
      continue; % next iteration
    end
end
series = series_temp;