function displaymap(redPos,bluePos,mapSize,mapHandle,red_head,blue_head)

% The funcion displays the game map with two plyer
% INPUT:
%       RedPos,GreenPos: n-by-n matrix of the players' position

% The display based on different colored polygoncell (patch())

% Main grid
% One rectangle is in patch
% X=[0 1 1 0] Y = [0 0 1 1]
% Repeat this over mapSize(1)*mapSize(2) times
% Colormap is picked after the orignial TRON color
figure(mapHandle);
% X cords
X_rect = [0:mapSize(1)-1;...
         1:mapSize(1);...
         1:mapSize(1);...
         0:mapSize(1)-1];
X=repmat(X_rect,mapSize(2),1);

% Y cords
Y_rect = [zeros(2,mapSize(1)); ones(2,mapSize(1))];
for ii = 0:mapSize(2)-1
   Y(ii*4+1:ii*4+4,:) = Y_rect(:,:) + ii;
end

% Colormap
C = 0;
Color=[0 0 36/250];
% Display
patch(X,Y,C,'FaceColor',Color);

% Red player
% Getting the non-zero elements
[x_red,y_red]=find(redPos);
pos=[x_red y_red];
[X_red, Y_red] = drawrectangle(pos);
patch(X_red,Y_red,1,'FaceColor',[255/255 220/250 0]);

% Head
[X_red_head, Y_red_head] = drawrectangle(red_head);
patch(X_red_head,Y_red_head,1,'FaceColor',[160/250 150/250 10/250]);

% Blue player
% Getting the non-zero elements
[x_blue,y_blue]=find(bluePos);
pos=[x_blue y_blue];
[X_blue, Y_blue] = drawrectangle(pos);
patch(X_blue,Y_blue,1,'FaceColor',[36/250 146/255 255/255]);

% Head
[X_blue_head, Y_blue_head] = drawrectangle(blue_head);
patch(X_blue_head,Y_blue_head,1,'FaceColor',[0.02 0.02 220/250]);
end


function [X_one, Y_one] = drawrectangle(pos)
% The subfunction draws on single rectangle in the gamegrid to the
% pos-th cell
X_one=[];
Y_one=[];
for ii = 1:size(pos,1)
    X_temp = [pos(ii,1)-1; pos(ii,1); pos(ii,1); pos(ii,1)-1];
    Y_temp = [pos(ii,2)-1; pos(ii,2)-1; pos(ii,2); pos(ii,2)];
    X_one = cat(2,X_one,X_temp);
    Y_one = cat(2,Y_one,Y_temp);
end
clear X_temp Y_temp

end



