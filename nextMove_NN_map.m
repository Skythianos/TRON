function series = nextMove_NN_map(series,map,defMap)
% Calculated the next move based on the neural network
% Input and output:
%   series: a series of moves

% It operates with basic random algortitm, with the observation of the
% next tiles
global NN_gen2_5
% MOVES:
%   1 -> up
%   3 -> down
%   4 -> right
%   2 -> left

probs = NN_gen2_5(map(:));
guesses = [];
valid = 0; % indicator if the move is valid
series_temp=series;

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
    valid = isValid(defMap,series_temp);
    if valid == 0
      probs(nextmove) =  probs(nextmove) -inf;
    end
end
series = series_temp;