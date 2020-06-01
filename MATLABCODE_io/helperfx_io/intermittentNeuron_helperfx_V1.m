% AT 5/11/20; we need to cut certain portions of given neuron's spike
% trains due to issues w/ intermittent firing




% % {'case01_spike1_clust1';
% %     'case01_spike1_clust2';
% %     'case01_spike2_clust1';
% %     'case01_spike2_clust2';
% %     'case01_spike2_clust3';
% %     'case01_spike3_clust1';
% %     'case01_spike3_clust2';
% %     'case02_spike1_clust1';
% %     'case02_spike2_clust1';
% %     'case02_spike2_clust2';
%     'case02_spike3_clust1';
%     'case03_spike1_clust1';
% %     'case03_spike2_clust1';
% %     'case03_spike2_clust2';
% %     'case03_spike3_clust1';
%     'case04_spike1_clust1';
% %     'case04_spike2_clust1';
% %     'case04_spike3_clust1';
% %     'case04_spike3_clust2';
%     'case05_spike1_clust1';
% %     'case05_spike2_clust1';
% %     'case05_spike3_clust1';
% %     'case06_spike1_clust1';
% %     'case06_spike2_clust1';
%     'case07_spike1_clust1';
%     'case07_spike2_clust1';
%     'case08_spike1_clust1';
%     'case09_spike1_clust1';
% %     'case09_spike2_clust1';
% %     'case10_spike1_clust1';
% %     'case11_spike1_clust1';
% %     'case12_spike1_clust1';
%     'case12_spike1_clust2';
% %     'case13_spike1_clust1';
% %     'case13_spike1_clust2';
% %     'case13_spike2_clust1';
% %     'case13_spike2_clust2'};




function [output]  = intermittentNeuron_helperfx_V1(input, structLabel)


% 
% epochName = 'wholeTrial';
% subName2 = 'SGandIS';



if strcmp(structLabel, 'case02_spike3_clust1')
    
    input((end-22):end) = 0; % cuts out last two blocks
    input(1:22) = 0; % cuts out first two blocks 
    
%     output = input(round(length(input)/2,0):end); % cuts out first half of recording
    
elseif strcmp(structLabel, 'case03_spike1_clust1')
    
    input(1:18) = 0; % cuts out first two blocks of trials
    
    
elseif strcmp(structLabel, 'case04_spike1_clust1')
    
    input(1:27) = 0; % cuts out first two blocks of trials
    
    
elseif strcmp(structLabel, 'case05_spike1_clust1')
    
    input(1:22) = 0; % cuts out first block of trials
    
    
elseif strcmp(structLabel, 'case07_spike1_clust1')
    
    input(1:40) = 0; % cuts out first two blocks of trials
    
    
elseif strcmp(structLabel, 'case07_spike2_clust1')
    
    input((end-18):end) = 0; % cuts out last two blocks
    
    
elseif strcmp(structLabel, 'case08_spike1_clust1')
    
    input((end-35):end) = 0; % cuts out last two blocks
    
    
elseif strcmp(structLabel, 'case09_spike1_clust1')
    
    input((end-45):end) = 0; % cuts out last two blocks
    
    
elseif strcmp(structLabel, 'case11_spike2_clust1')
        
    input(28:54) = 0; % cuts out 3rd and 4th

elseif strcmp(structLabel, 'case12_spike1_clust2')
        
    input((end-18):end) = 0; % cuts out last two blocks
            
end
    

    
output = input;













%     masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)



end