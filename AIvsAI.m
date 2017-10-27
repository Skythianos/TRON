function [P1_map,P2_map,RESULT,p1_moves,p2_moves,p1_head_poses,p2_head_poses]=...
    AIvsAI(p1_alg,p2_alg,speed,display)
% The script plays the game itself
if nargin == 0
    % if no mode is given, don't show the game window
    display = 0;
end
% ALGORITHMS
   % 1 ->  random
   % 2 -> Simple selection
   % 3 -> NN gen 2.5
   % 4 -> NN gen 3
   % 5 -> NN gen 3 + rand
   % 6 -> NN gen 3b
   % 7 -> NN gen 3c
%% Init
mapSize = [24 24];
global global_map % the visible map
global_map = zeros(mapSize);
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
if display ~= 0 
    gamewindow = findall(0,'tag','gamewindow'); % Singeton behaviour
    if isempty(gamewindow)
        gamewindow = figure('Name','TRON',...
                    'Color', 'White',...
                    'NumberTitle','Off',...
                    'Menubar','none',...
                    'Resize','on',...
                    'Tag','gamewindow',...
                    'WindowKeyPressFcn',@player_clicked);
    end
    set(gca, 'visible', 'off') % making axes invisible
end
p1_out = 0;
p2_out = 0;
p1_collide = 0;
p2_collide = 0;
RESULT = 0;
% Previous map in order to track the pos of the head
p1_map_prev = P1_map;
p2_map_prev = P2_map;
global_map = defP1 + defP2;
load('NN_gen2_5');
global NN_gen2_5;
%% Game
endgame = 0;
ii = 1; % running index
% controlling random
rng('shuffle')
while ~(p1_out || p2_out || p1_collide || p2_collide)
    % main loop of the game
    
    % Displaying the game
    if display ~=0
        if isempty(gamewindow)
            break; % jumping out of loop
        end
        displaymap(P1_map,P2_map,mapSize,gamewindow,[p1_head_x,p1_head_y],[p2_head_x,p2_head_y]);
    end
    
    % first one is the red
    % if it is the first move, make it rand
    if ii == 1
        p1_moves = nextMove(defP1,p1_moves);
    else
        switch p1_alg
            case 1
                p1_moves = nextMove(defP1,p1_moves);
            case 2 
                p1_moves = nextMove_simple(defP1,p1_moves);
            case 3 
                p1_moves = nextMove_NN_map(p1_moves,P1_map+P2_map,defP1);
            case 4
                p1_moves = nextMove_NN_gen3(p1_moves,P1_map+P2_map,defP1,[p1_head_x,p1_head_y],[p2_head_x,p2_head_y]);
            case 5
                p1_moves = nextMove_NN_gen3_rand(p1_moves,P1_map+P2_map,defP1,[p1_head_x,p1_head_y]);
            case 6
                p1_moves = nextMove_NN_gen3b(p1_moves,P1_map+P2_map,defP1,[p1_head_x,p1_head_y]);
            case 7
                p1_moves = nextMove_NN_gen3c(p1_moves,P1_map+P2_map,defP1,[p1_head_x,p1_head_y]);
            otherwise
                errordlg('Something went wrong, sorry');
        end
    end
    
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
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
    
    % Blue player
    if ii == 1
        p2_moves = nextMove(defP2,p2_moves);
    else
        switch p2_alg
            case 1
                p2_moves = nextMove(defP2,p2_moves);
            case 2 
                p2_moves = nextMove_simple(defP2,p2_moves);
            case 3 
                p2_moves = nextMove_NN_map(p2_moves,P1_map+P2_map,defP2);
            case 4
                p2_moves = nextMove_NN_gen3(p2_moves,P1_map+P2_map,defP2,[p2_head_x,p2_head_y],[p1_head_x,p1_head_y]);
            case 5
                p2_moves = nextMove_NN_gen3_rand(p2_moves,P1_map+P2_map,defP2,[p2_head_x,p2_head_y]);
            case 6
                p2_moves = nextMove_NN_gen3b(p2_moves,P1_map+P2_map,defP2,[p2_head_x,p2_head_y]);
            case 7
                p2_moves = nextMove_NN_gen3b(p2_moves,P1_map+P2_map,defP2,[p2_head_x,p2_head_y]);
            otherwise
                errordlg('Something went wrong, sorry');
        end
    end
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
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
    % wait before the next loop
    if display ~= 0
        % speed
       to_stop = 0.1+0.009*(50-5*speed);
       pause(to_stop)
    end
ii = ii+1;
end

%% evaluating result
% Displaying the game
    if display ~=0
        displaymap(P1_map,P2_map,mapSize,gamewindow,[p1_head_x,p1_head_y],[p2_head_x,p2_head_y]);
    end
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
if (display);
    if RESULT == 0;
        msgbox('It is a tie');
    else
        if RESULT == 1;
            % P1 wins
            msgbox('Player 1 wins','Game over');
        else
            msgbox('Player 2 wins','Game over');
        end
    end
end
