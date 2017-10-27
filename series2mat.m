function [mat,out] = series2mat(defpos,series)
% Calculates the matrix from the series of moves
% MOVES:
%   1 -> up
%   3 -> down
%   2 -> right
%   4 -> left
% In the matlab based matrix indexing
[act_row, act_col] = find(defpos); 
mat = defpos;
for ii = 2:find(series==-1,1)-1
    switch(series(ii))
        case 1
            act_row  = act_row + 1;
        case 2
            act_col = act_col + 1;
        case 3
            act_row = act_row - 1;
        case 4
            act_col = act_col - 1;
        otherwise
            errordlg('Invalid move')
    end
    out=isOut([act_row,act_col],size(defpos));
    if out == 1
        return;
    end
    mat(act_row,act_col) = mat(act_row,act_col)+1;
end
           