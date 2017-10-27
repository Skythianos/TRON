function isValid = isValid(defMap,series,glob_map)
% the function constructs the map from the series and checks wheter the
% move is valid or not
if nargin == 2
    global global_map;
    glob_map = global_map;
end
[mat,out] = series2mat(defMap,series);
if out == 1
    % if the move is out of the map jump out
    isValid = 0;
    return;
end

% Original number of ones
a = unique(glob_map);
instances_before = histc(glob_map(:),a);
temp_map = glob_map + mat;
a = unique(temp_map);
instances_after = histc(temp_map(:),a);
% if the istances of zeros after the move not exactly one less than befor,
% it is an invalid move

if instances_after(1)+1 ~= instances_before(1)
    isValid = 0;
else
    isValid = 1;
end