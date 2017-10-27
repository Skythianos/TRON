function outs=nn_gen3(map,headPos)
% This function is a hand made deep network, containing one autoencoder
% layer in the top, and one hidden layer with 2 additional neurons
% (position of the head) and a softmax layer in the end.
load('gen3_nets.mat');
head_x = headPos(1);
head_y = headPos(2);

% first layer
y_encoder = Wenc * map;

% second layer input
y_encoder_extended = [y_encoder; head_x; head_y];

% Second and third layer 
outs = net_softmax(y_encoder_extended);

