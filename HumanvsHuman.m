function HumanvsHuman(speed)
%% Init
mapSize = [24 24];
% controlling random
rng('shuffle')
global global_map % the visible map
global_map = zeros(mapSize);
global player_dir_p1  % The desihuman direction
player_dir_p1 = randi(4); % the default start direction
global player_dir_p2  % The desihuman direction
player_dir_p2 = randi(4); % the default start direction
defP1=zeros(mapSize);
defP2=zeros(mapSize);
% Default position is at half of the map, ad equally far from the wall
defP2(floor(mapSize(1)/2),floor(mapSize(2)/3))=1;
defP1(floor(mapSize(1)/2),mapSize(2)-floor(mapSize(2)/3))=1;
P1_map=rot90(defP1);
P2_map=rot90(defP2);


% The pos of head
p1_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;
p2_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;
[p1_head_x,p1_head_y] = find(P1_map); 
p1_head_poses(1,:)=[p1_head_x,p1_head_y];
[p2_head_x,p2_head_y] = find(P2_map); 
p2_head_poses(1,:)=[p2_head_x,p2_head_y];

% Allocating memory
p1_moves=ones(1,mapSize(1)*mapSize(2)/2)*-1;
p2_moves=ones(1,mapSize(1)*mapSize(2)/2)*-1;
p1_moves(1) = 10;
p2_moves(1) = 10;
% Init figure
% Init figure
gamewindow = findall(0,'tag','gamewindow'); % Singeton behaviour
if isempty(gamewindow)
    gamewindow = figure('Name','TRON',...
                'Color', 'White',...
                'NumberTitle','Off',...
                'Menubar','none',...
                'Resize','on',...
                'Tag','gamewindow',...
                'KeyPressFcn',@player_clicked);
end
set(gca, 'visible', 'off')
p1_out = 0;
p2_out = 0;
p1_collide = 0;
p2_collide = 0;
RESULT = 0;
% Previous map in order to track the pos of the head
p1_map_prev = P1_map;
p2_map_prev = P2_map;
global_map = defP1 + defP2;
ii = 1;
endgame = 0;
%% game
while ~(p1_out || p2_out || p1_collide || p2_collide)
    % main loop of the game
    % main loop of the game
    % indexing the cycles
    
    % Displaying the game
    displaymap(P1_map,P2_map,mapSize,gamewindow,[p1_head_x,p1_head_y],[p2_head_x,p2_head_y]);   
    to_stop = 0.1+0.009*(50-5*speed);
    pause(to_stop)
    
    p1_moves(ii+1) = player_dir_p1;
    p2_moves(ii+1) = player_dir_p2;
    
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
    % P1
    [p1_temp,p1_out] = series2mat(defP1,p1_moves);
    P1_map=rot90(p1_temp);
    
    % The head of the player is the difference between the two maps
    [p1_head_x,p1_head_y] = find(P1_map-p1_map_prev);
    if length(p1_head_x) ~= 1 || length(p1_head_y) ~= 1
        p1_head_poses(ii+1,:) = [-10,-10];
    else
        p1_head_poses(ii+1,:)=[p1_head_x,p1_head_y];
    end
    p1_map_prev = P1_map;
    
    % P2
    [p2_temp,p2_out] = series2mat(defP2,p2_moves);
    P2_map=rot90(p2_temp);
    
    [p2_head_x,p2_head_y] = find(P2_map-p2_map_prev);
    if length(p2_head_x) ~= 1 || length(p2_head_y) ~= 1
        p2_head_poses(ii+1,:)=[-10,-10];
    else
         p2_head_poses(ii+1,:)=[p2_head_x,p2_head_y];
    end
    p2_map_prev = P2_map;
    
    global_map = p1_temp + p2_temp;
    global_map(global_map ~=0)=1;
    
    % checking collision
    [p1_collide,p1_type] = isCollide(P1_map,P2_map,[p1_head_x,p1_head_y]);
    [p2_collide,p2_type] = isCollide(P2_map,P1_map,[p2_head_x,p2_head_y]);
    
    ii = ii+1;
end

%% Evaluating result
% RESULT variable is 1 if the red wins
%                   -1 if the blue wins
if p2_out && ~p2_collide == 1
%     msgbox('Blue player hit the wall');
    RESULT =  RESULT + 1;
end
if p1_out && ~p1_collide == 1
%     msgbox('Red player hit the wall');
    RESULT = RESULT - 1;
end
if p2_collide == 1
%     msgbox('Blue player is dead');
    RESULT = RESULT + 1;
end
if p1_collide == 1
%     msgbox('Red player is dead');
    RESULT = RESULT - 1;
end
if RESULT == 0
    msgbox('It is a tie');
else
    if RESULT == 1
        msgbox('Player 1 wins','Game over');
    else
        msgbox('Player 2 wins','Game over');
    end
end
