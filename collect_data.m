function collect_data(nr_meas,PathName,FileName,p1_alg,p2_alg)
% The scipt collects data for the neural network
mapSize = [24 24];
% nr_meas=1000
% allocating memory
p1_map=zeros(nr_meas,mapSize(1)*mapSize(2));
p2_map=zeros(nr_meas,mapSize(1)*mapSize(2));
p1_head_pos = zeros(mapSize(1)*mapSize(2)/2,2*nr_meas);

results=zeros(nr_meas,1);

p1_moves=zeros(mapSize(1)*mapSize(2)/2,nr_meas);
p2_moves=zeros(mapSize(1)*mapSize(2)/2,nr_meas); 
p2_head_pos = zeros(mapSize(1)*mapSize(2)/2,2*nr_meas);

h = waitbar(0,'Please wait for the simulation to finish','Name','Please wait',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for ii = 1 : nr_meas
    [p1_temp,p2_temp,results(ii),p1_moves(:,ii),p2_moves(:,ii),p1_head_pos_temp,p2_head_pos_temp]...
        = AIvsAI(p1_alg,p2_alg,10,0);
    p1_map(ii,:)=p1_temp(:);
    p2_map(ii,:)=p2_temp(:);
    p1_head_pos(:,2*ii-1:2*ii) = p1_head_pos_temp;
    p2_head_pos(:,2*ii-1:2*ii) = p2_head_pos_temp;
    if getappdata(h,'canceling')
        break
    end
    waitbar(ii / nr_meas);
end
delete(h);
to_save = fullfile(PathName,FileName);
msgbox('Simulation is finished','Done');
save(to_save,...
    'p1_map','p2_map','results',...
   'p1_moves','p2_moves','p1_head_pos','p2_head_pos');
