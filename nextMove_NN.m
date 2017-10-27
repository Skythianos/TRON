function series = nextMove_NN(defMap,series)
% Calculated the next move based on the neural network
% Input and output:
%   series: a series of moves

global NN_gen2_5
% MOVES:
%   1 -> up
%   3 -> down
%   4 -> right
%   2 -> lef
global global_map
glob_map = global_map;
guesses = [];
valid = 0; % indicator if the move is valid
temp_series = series;
temp_series(1)=[];
probs = net(temp_series');
while ~valid
    % controlling random
    [~,nextmove] = max(probs);
    if abs(series(find(series==-1,1)-1) - nextmove) == 2;
       probs(nextmove) =  probs(nextmove) -inf;
       [~,nextmove] = max(probs);
    end
    temp_series(find(series==-1,1)-1)=nextmove;
    guesses = [guesses nextmove];
    % Tracing the guesses
    if length(unique(guesses))==3
        % if all of our 3 chanches are gone
        series = temp_series;
        return;
    end
    to_valid = temp_series;
    to_valid =[10 temp_series];
    valid = isValid(defMap,to_valid,glob_map);
    if valid == 0
       probs(nextmove) =  probs(nextmove) -inf;
    end
end
series = to_valid;