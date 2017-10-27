function HumanvsAI(ai_alg,speed)
% The script starts the game where a human player plays versus the AI

%% Init
mapSize = [24 24];
global global_map % the visible map
global player_dir_p1  % The desihuman direction
 player_dir_p1 = randi(4); % the default start direction
% player_dir = 4;
global_map = zeros(mapSize);
defHuman=zeros(mapSize);
defAI=zeros(mapSize);

% Default position is at half of the map, ad equally far from the wall
defAI(floor(mapSize(1)/2),floor(mapSize(2)/3))=1;
defHuman(floor(mapSize(1)/2),mapSize(2)-floor(mapSize(2)/3))=1;
HUMAN_map=rot90(defHuman);
AI_map=rot90(defAI);

% Indicating the starting pos
human_moves=ones(1,128)*-1;
AI_moves=ones(1,128)*-1;
human_moves(1) = 10;
AI_moves(1) = 10;
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
        
% The pos of head
human_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;
AI_head_poses=ones(mapSize(1)*mapSize(2)/2,2)*-1;
[human_head_x,human_head_y] = find(HUMAN_map); 
human_head_poses(1,:)=[human_head_x,human_head_y];
[AI_head_x,AI_head_y] = find(AI_map); 
AI_head_poses(1,:)=[AI_head_x,AI_head_y];

% Previous map in order to track the pos of the head
human_map_prev = HUMAN_map;
AI_map_prev = AI_map;
global_map = defHuman + defAI;

human_out = 0;
AI_out = 0;
human_collide = 0;
AI_collide = 0;
RESULT = 0;
load('NN_gen2_5');
global NN_gen2_5;
%% Game
endgame = 0;
ii = 1; % running index
rng('shuffle');
while ~(human_out || AI_out || human_collide || AI_collide)
    % main loop of the game
    % indexing the cycles
    % Displaying the game
    displaymap(HUMAN_map,AI_map,mapSize,gamewindow,[human_head_x,human_head_y],[AI_head_x,AI_head_y])
    to_stop = 0.1+0.009*(50-5*speed);
    pause(to_stop)
    % first one is the human
    human_moves(ii+1) = player_dir_p1;
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
    [human_temp,human_out] = series2mat(defHuman,human_moves);
    HUMAN_map=rot90(human_temp);
    
    % The head of the player is the difference between the two maps
    [human_head_x,human_head_y] = find(HUMAN_map-human_map_prev);
    if length(human_head_x) ~= 1 || length(human_head_y) ~= 1
        human_head_poses(ii+1,:) = [-10,-10];
    else
        human_head_poses(ii+1,:)=[human_head_x,human_head_y];
    end
    human_map_prev = HUMAN_map;
    
    % AI player
    if ii == 1
        AI_moves = nextMove(defAI,AI_moves);
    else
        switch ai_alg
            case 1
                AI_moves = nextMove(defAI,AI_moves);
            case 2 
                AI_moves = nextMove_simple(defAI,AI_moves);
            case 3 
                AI_moves = nextMove_NN_map(AI_moves,HUMAN_map+AI_map,defAI);
            case 4
                AI_moves = nextMove_NN_gen3(AI_moves,HUMAN_map+AI_map,defAI,[AI_head_x,AI_head_y]);
            case 5
                AI_moves = nextMove_NN_gen3_rand(AI_moves,HUMAN_map+AI_map,defAI,[AI_head_x,AI_head_y]);
            case 6
                AI_moves = nextMove_NN_gen3b(AI_moves,HUMAN_map+AI_map,defAI,[AI_head_x,AI_head_y]);
            case 7
                AI_moves = nextMove_NN_gen3b(AI_moves,HUMAN_map+AI_map,defAI,[AI_head_x,AI_head_y]);
            otherwise
                errordlg('Something went wrong, sorry');
        end
    end
    % Transforming it to matrix
    % We have to rotate by 90° in order to display it
    [AI_temp,AI_out] = series2mat(defAI,AI_moves);
    AI_map=rot90(AI_temp);
    
    % The head of the player is the difference between the two maps
    [AI_head_x,AI_head_y] = find(AI_map-AI_map_prev);
    if length(AI_head_x) ~= 1 || length(AI_head_y) ~= 1
        AI_head_poses(ii+1,:) = [-10,-10];
    else
        AI_head_poses(ii+1,:)=[AI_head_x,AI_head_y];
    end
    AI_map_prev = AI_map;
    
    global_map = human_temp + AI_temp;
    global_map(global_map ~=0)=1;
    
    % wait before the next loop
    [human_collide,human_type] = isCollide(HUMAN_map,AI_map,[human_head_x,human_head_y]);
    [AI_collide,AI_type] = isCollide(AI_map,HUMAN_map,[AI_head_x,AI_head_y]);
    
ii = ii+1;
end

%% evaluating result
% RESULT variable is 1 if the human wins
%                   -1 if the AI wins
if AI_out == 1
    %msgbox('AI player hit the wall');
    RESULT = RESULT + 1;
end
if human_out == 1
    %msgbox('human player hit the wall');
    RESULT = RESULT - 1;
end
if AI_collide == 1
    %msgbox('AI player is dead');
    RESULT = RESULT + 1;
end
if human_collide == 1
    %msgbox('human player is dead');
    RESULT = RESULT - 1;
end

if RESULT == 0
    msgbox('It is a tie');
else
    if RESULT == 1
        msgbox('Human wins','Game over');
    else
        msgbox('AI wins','Game over');
    end
end
