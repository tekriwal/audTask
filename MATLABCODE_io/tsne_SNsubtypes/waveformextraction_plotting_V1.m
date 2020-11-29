%AT 9/21/20 working on trying to extract the waveform features
function [] = waveformextraction_plotting_V1(caseNumb, spikeFile, clust, saveFig)


if nargin == 0
    caseNumb = 6;
    spikeFile = 'spike2';
    clust = 1; %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
    saveFig = 0;
end



if  caseNumb == 1
    caseName = 'case01';
elseif caseNumb == 2
    caseName = 'case02';
elseif caseNumb == 3
    caseName = 'case03';
elseif caseNumb == 4
    caseName = 'case04';
elseif caseNumb == 5
    caseName = 'case05';
elseif caseNumb == 6
    caseName = 'case06';
elseif caseNumb == 7
    caseName = 'case07';
elseif caseNumb == 8
    caseName = 'case08';
elseif caseNumb == 9
    caseName = 'case09';
elseif caseNumb == 10
    caseName = 'case10';
elseif caseNumb == 11
    caseName = 'case11';
elseif caseNumb == 12
    caseName = 'case12';
elseif caseNumb == 13
    caseName = 'case13';
end

%%


%4/27/20; epochInfo will be a four column matrix. First column is event for
%start of epoch, second column will be that offset (if any). Third column is event
%for end of epoch, fourth column will be that offset (if any)
epochInfo.epochs = {'upPressed_times', -.5, 'feedback_times', 0.5;...
    'upPressed_times', -.5, 'stimDelivered_times', 0;...
    'stimDelivered_times', 0, 'stimDelivered_times', 0.3;...
    'stimDelivered_times', 0.3, 'goCue_times', 0;...
    'goCue_times', 0, 'submitsResponse_times', 0;...
    'submitsResponse_times', 0, 'feedback_times', 0.5};

epochInfo.epochNames = {'wholeTrial';...
    'priors';...
    'sensoryProcessing';...
    'movePrep';...
    'moveInit';...
    'periReward'};

spiketrainStrct_V2.epochInfo = epochInfo;



digits(6) %sets vars so they contain 6 digits at most
p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);
% p = genpath('/Users/andytek/Desktop/git/audTask/IO/AT_lfp_code');
% addpath(p);


[caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);

[inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);

surgerySide = caseInfo_table.("Target (R/L STN)");

% AT 3/16/20; BClust were clustered at 2 SD and refined down as much as
% possible; while _V2 were clustered to 3SD and largely left unrefined.

% [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table, 'processed_spikes_BClust');
[Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V3(caseInfo_table, 'processed_spikes_V2');



%AT 2/14/20; below are input variables to original fx pulled out
if strcmp(spikeFile,'spike1')
    spk_file = spike1;
elseif strcmp(spikeFile,'spike2')
    spk_file = spike2;
elseif strcmp(spikeFile,'spike3')
    spk_file = spike3;
end


%%


if clust == 1
    spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1;
    waveformfeatures = spk_file.spikeDATA.features_clustIndex_1;
    waveform = spk_file.spikeDATA.waveform_clustIndex_1;
    
    clustname = '_clust1_';
elseif clust == 2
    spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2;
    waveformfeatures = spk_file.spikeDATA.features_clustIndex_2;
    waveform = spk_file.spikeDATA.waveform_clustIndex_2;
    
    clustname = '_clust2_';
elseif clust == 3
    spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3;
    waveformfeatures = spk_file.spikeDATA.features_clustIndex_3;
    waveform = spk_file.spikeDATA.waveform_clustIndex_3;
    
    clustname = '_clust3_';
end

spiketrainStrct_V2.waveformfeatures = waveformfeatures;
spiketrainStrct_V2.waveform = waveform;


if caseNumb == 4 && strcmp(spikeFile, 'spike1')
    waveform = waveform(:,5000:end);
end
% %for nn=20000:20200 used for case4spike1clust1 USE ME for pink cluster
% %for nn=6000:6200 used for case11spike1clust1
% %for nn=6000:6200 used for case1spike2clust2
% %for nn=11000:11200 used for case3spike2clust1
% %for nn=5000:5200 used for case2spike2clust1
% %for nn=20000:20200 used for case4spike2clust1 USE ME for green cluster
% 
% %now w/ the parameters above loaded in, lets do some plotting
% hFig = figure();
% for nn=20000:20200
%     line(1:57, waveform(:,nn))
%     hold on
% end


hFig = figure();

Waveform = mean(waveform, 2); %gives mean of each row w/ the 2
line(1:57, Waveform)
hold on

standardDev = std(waveform,0,2);

lowerDev = Waveform - (1*standardDev);
line(1:57, lowerDev)

hold on
higherDev = Waveform + (1*standardDev);
line(1:57, higherDev)


%     AT golden ratio calculation. Change the longerside input to what is desired
x0=10;
y0=10;
longersideInput = 500;
longerside=longersideInput;
shorterside = longerside*(61.803/100);
height = longerside;
width = shorterside;
set(hFig,'position',[x0,y0,width,height])









end
