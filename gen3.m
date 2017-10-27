% This is the 3rd generation network
% Upgrading the 2.5 with the head position to the 2nd layer

% The script uses a softmax layer to guess the next move from the data
% INPUT: actul map
% Output 3 softmax layer, which is the best solution
%% Init
nr_train = 1000;
results = results(1:nr_train,:);
red_moves = p1_moves(:,1:nr_train);
blue_moves = p2_moves(:,1:nr_train);
red_map = p1_map;
blue_map = p2_map;
red_heads = p1_head_pos;


mapSize = [24 24];
defRed=zeros(mapSize);
defRed(floor(mapSize(1)/2),mapSize(2)-floor(mapSize(2)/3))=1;
defBlue=zeros(mapSize);
defRed(floor(mapSize(1)/2),mapSize(2)-floor(mapSize(2)/3))=1;
results(results==-1) = 0;
%% Training data making
% Constucts an mapSize matrix for the 1000 first move and 1000 second move
% and so on...
% First cycle is to prepare data
% Finding the first -1, and trowing away thoose results

ends = zeros(1,nr_train);
for ii = 1:nr_train
    ends(ii) = find(red_moves(:,ii)==-1,1)-1;
end

temp_temp_red = red_moves;
temp_temp_blue = blue_moves;
temp_read_head_pos = red_heads;
nrs = sum(ends); % all of the different stepps
steps_red = [];
steps_blue = [];
heads_red = [];
for jj = 1:nr_train
    temp_moves_red = zeros(mapSize(1)*mapSize(2)/2,ends(jj));
    temp_moves_blue = zeros(mapSize(1)*mapSize(2)/2,ends(jj));
%     temp_poses_red = zeros(mapSize(1)*mapSize(2)/2,2*ends(jj));
    temp_poses_red = zeros(1,2*ends(jj));
    for ii = 1:ends(jj) % all the valid moves
        temp_move_red = temp_temp_red(:,ii);        
        temp_move_red(ii+1:end,:) = -1;
        temp_moves_red(:,ii) = temp_move_red;
        
        temp_move_blue = temp_temp_blue(:,ii);
        temp_move_blue(ii+1:end,:) = -1;
        temp_moves_blue(:,ii) = temp_move_blue;
        
%         temp_pos_red = temp_read_head_pos(:,2*ii-1:2*ii);
%         temp_pos_red(ii+1:end,:) = -1;
%         temp_poses_red(:,2*ii-1:2*ii) = temp_pos_red;
        
    end
    steps_red = [steps_red temp_moves_red];
    steps_blue = [steps_blue temp_moves_blue];
    heads_red = [heads_red temp_poses_red];
end
% setting up the heads;
temp_head = temp_read_head_pos(:);
temp_head(temp_head==-1)=[];
temp_head = temp_head';
        
    
% Creating the maps itself
MAPS_red = zeros(mapSize(1)*mapSize(2),nrs);
MAPS_blue = zeros(mapSize(1)*mapSize(2),nrs);
for ii = 1:nrs
    try
        mat = series2mat(defRed,steps_red(:,ii));
    catch
        err = steps_red(:,ii);
        err(find(steps_red(:,ii)==-1,1)-1) = -1;
        mat = series2mat(defRed,err);
    end
    MAPS_red(:,ii) = mat(:);
    try
    mat = series2mat(defBlue,steps_blue(:,ii));
    catch
        err = steps_blue(:,ii);
        err(find(steps_blue(:,ii)==-1,1)-1) = -1;
        mat = series2mat(defRed,steps_red(:,ii));
    end
    MAPS_blue(:,ii) = mat(:);
end
% MOVES_TO_TRAIN = steps_red;
% MOVES_TO_TRAIN(1,:) = [];
% Supervised learning actions
OUTS = zeros(4,nrs);
mov_class_temp = temp_temp_red;
mov_class_temp(mov_class_temp ==-1) = [];
mov_class_temp(1)=[]; % deleting the first elemnt, in order to fix the shift
mov_class_temp(mov_class_temp==10) = randi(4); % creating artifical elements for the last step
mov_class_temp(end+1) = randi(4); % adding one more
for ii = 1:nrs
    OUTS(mov_class_temp(ii),ii) = 1;
end
MAPS_TO_TRAIN = MAPS_red + MAPS_blue;
HEAD_X = temp_head(1:2:length(temp_head));% the training y cord
HEAD_Y = temp_head(2:2:length(temp_head)); % the training y cord
%% Creating network
% Firstly an autoencoder layer
% After that a softmax based one

% Solve a Pattern Recognition Problem with a Neural Network

x_autoenc = MAPS_TO_TRAIN;
t = OUTS;
% 128 hidden layers
autoenc = trainAutoencoder(x_autoenc,128,'MaxEpochs',100,...
    'L2WeightRegularization',0.00001,...
    'SparsityProportion',0.5,'SparsityRegularization',1,...
    'LossFunction','msesparse',...
    'TrainingAlgorithm','trainscg');

Wenc = autoenc.EncoderWeights;
Wdec = autoenc.DecoderWeights;

x_softmax = encode(autoenc,x_autoenc); % data to the input of patternnet
x_softmax_extended_ = [x_softmax; HEAD_X; HEAD_Y];

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 32;
net_softmax = patternnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net_softmax.divideFcn = 'dividerand';  % Divide data randomly
net_softmax.divideMode = 'sample';  % Divide up every sample
net_softmax.divideParam.trainRatio = 70/100;
net_softmax.divideParam.valRatio = 15/100;
net_softmax.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net_softmax.performFcn = 'crossentropy';  % Cross-Entropy
net_softmax.trainParam.max_fail= 10;

net_softmax.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net_softmax,tr] = train(net_softmax,x_softmax_extended_,t);

% % View the Network
% deepnet = stack(autoenc,net_softmax);
% view(deepnet);

