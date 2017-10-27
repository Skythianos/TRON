function [RED_map,BLUE_map,RESULT,red_moves,blue_moves,red_head_poses,blue_head_poses]=NNvsAI(mode)
% The RED player uses neural network to decide the next move
% The script plays the game itself
if nargin == 0
    % if no mode is given, don't show the game window
    mode = 0;
end
%% Init
mapSize = [24 24];
global global_map % the visible map
global_map = zeros(mapSize);
defRed=zeros(mapSize);
defBlue=zeros(mapSize);
% Default position is at half of the map, ad equally far from the wall
defBlue(floor(mapSize(1)/2),floor(mapSize(2)/3))=1;
defRed(floor(mapSize(1)/2),mapSize(2)-floor(mapSize(2)/3))=1;
RED_map=rot90(defRed);
% The pos of head
red_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;
blue_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;

[red_head_x,red_head_y] = find(RED_map); 
red_head_poses(1,:)=[red_head_x,red_head_y];

BLUE_map=rot90(defBlue);
[blue_head_x,blue_head_y] = find(BLUE_map); 
blue_head_poses(1,:)=[blue_head_x,blue_head_y];
% Allocating memorya
red_moves=ones(1,mapSize(1)*mapSize(2)/2)*-1;
blue_moves=ones(1,mapSize(1)*mapSize(2)/2)*-1;
red_moves(1) = 10;
blue_moves(1) = 10;
% Init figure
if mode ~= 0 
    gamewindow=figure('Name','TRON',...
            'Color', 'White',...
            'NumberTitle','Off',...
            'Menubar','none',...
            'Resize','on');
     set(gca, 'visible', 'off')
end
red_out = 0;
blue_out = 0;
red_collide = 0;
blue_collide = 0;
RESULT = 0;
% Previous map in order to track the pos of the head
red_map_prev = RED_map;
blue_map_prev = BLUE_map;
global_map = defRed + defBlue;
%% Game
endgame = 0;
ii = 1; % running index
while ~(red_out || blue_out || red_collide || blue_collide)
    % main loop of the game
    
    % Displaying the game
    if mode ~=0
        displaymap(RED_map,BLUE_map,mapSize,gamewindow,[red_head_x,red_head_y],[blue_head_x,blue_head_y]);
    end
    
    % first one is the red
    % if it is the first move, make it rand
    if ii == 1
        red_moves = nextMove(defRed,red_moves);
    else
        red_moves = nextMove_NN_gen3_rand(red_moves,RED_map+BLUE_map,defRed,[red_head_x,red_head_y]);
    end
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
    [red_temp,red_out] = series2mat(defRed,red_moves);
    RED_map=rot90(red_temp);
    [red_collide,red_type] = isCollide(RED_map,BLUE_map);
    
    % The head of the player is the difference between the two maps
    [red_head_x,red_head_y] = find(RED_map-red_map_prev);
    if length(red_head_x) ~= 1 || length(red_head_y) ~= 1
        red_head_poses(ii+1,:) = [-10,-10];
    else
        red_head_poses(ii+1,:)=[red_head_x,red_head_y];
    end
    if ii ~= 1
        global_map = red_temp + blue_temp;
        global_map(global_map ~=0)=1;
    end
    
    % Blue player
    if ii == 1
        blue_moves = nextMove(defBlue,blue_moves);
    else
        % gen2
        % blue_moves = nextMove_NN_map(blue_moves,RED_map+BLUE_map,defBlue);
        % gen3
        blue_moves = nextMove_NN_gen3_rand(blue_moves,RED_map+BLUE_map,defBlue,[blue_head_x,blue_head_y]);
    end
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
    [blue_temp,blue_out] = series2mat(defBlue,blue_moves);
    BLUE_map=rot90(blue_temp);
    [blue_collide,blue_type] = isCollide(BLUE_map,red_map_prev);
    
    [blue_head_x,blue_head_y] = find(BLUE_map-blue_map_prev);
    if length(blue_head_x) ~= 1 || length(blue_head_y) ~= 1
        blue_head_poses(ii+1,:)=[-10,-10];
    else
        blue_head_poses(ii+1,:)=[blue_head_x,blue_head_y];
    end
    blue_map_prev = BLUE_map;
    red_map_prev = RED_map;
    global_map = red_temp + blue_temp;
    global_map(global_map ~=0)=1;
    
    % wait before the next loop
    if mode ~= 0
        pause(0.1)
    end
ii = ii+1;
end

%% evaluating result
% RESULT variable is 1 if the red wins
%                   -1 if the blue wins
if blue_out == 1
%     msgbox('Blue player hit the wall');
    RESULT =  1;
end
if red_out == 1
%     msgbox('Red player hit the wall');
    RESULT = 0;
end
if blue_collide == 1
%     msgbox('Blue player is dead');
    RESULT = 1;
end
if red_collide == 1
%     msgbox('Red player is dead');
    RESULT = 0;
end