function [res, type]  = isCollide(player,enemy,player_head)
% The function checks whether there is a collision or not
% Res contains the existence of the collision
% Tpye: 0 -> no collision
%       1 -> collision with eachother
%       2 -> collision with self

% First checks the self collision
res = 0;
type = 0;
temp_player = abs(player); % only positive values
if ismember(2,temp_player)
    res = 1;
    type = 2;
    return;
end

% Seconly check the collision with eachother
try 
if enemy(player_head(1),player_head(2)) == 1
    res = 1;
    type = 1;
end
catch
    res = 1;
    return;
end