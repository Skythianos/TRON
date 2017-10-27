function res = isOut(cords,mapSize)
% The function calculates whether the player hit the wall or not

res = 0;
if (any(cords>mapSize) ||... % up and right
        any(cords<1)) % down and left
    res=1;
end