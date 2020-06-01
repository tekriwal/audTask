%V1 AT 4/27/20
%goal is to 1) generate metrics that will let us do some broad
%categorization of FR values. this helper fx is designed to 




function [] = FRanalysis_helperfx_V2(caseNumb, spikeFile, clust, saveFig)



if nargin == 0
    caseNumb = 3;
    spikeFile = 'spike2';
    clust = 1; %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
end



if clust == 1
%     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1;
    clustname = '_clust1_';
elseif clust == 2
%     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2;
    clustname = '_clust2_';
elseif clust == 3
%     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3;
    clustname = '_clust3_';
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

structLabel = strcat(caseName,'_',spikeFile,clustname(1:7));

p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);


%load in masterspikestruct file
figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); 
filename2 = ('/masterspikestruct_V2');
load(fullfile(figuresdir, filename2), 'masterspikestruct_V2');


%load in a given spiketrain dataset
figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis', caseName); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename2 = (['/spiketrainStrct_V2_', caseName, spikeFile, clustname]);
load(fullfile(figuresdir, filename2), 'spiketrainStrct_V2');




%below gives summary data combining across SG/IS and L/R (aka 'all')
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'SGandIS';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.L.(epochName).(subName), spiketrainStrct_V2.SG.R.(epochName).(subName), spiketrainStrct_V2.IS.L.(epochName).(subName), spiketrainStrct_V2.IS.R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));




%below gives summary data combining across SG
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'SG';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));








%below gives summary data combining across IS
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'IS';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.(subName2).L.(epochName).(subName), spiketrainStrct_V2.(subName2).R.(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));






%below gives summary data combining across Lefts
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'L';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));







%below gives summary data combining across Rights
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'R';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct_V2.SG.(subName2).(epochName).(subName), spiketrainStrct_V2.IS.(subName2).(epochName).(subName)]; 
masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2)));



% below is some work for saving out waveform features
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.Energy.median = median(spiketrainStrct_V2.waveRawFeat.Energy); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.Energy.vari = var(spiketrainStrct_V2.waveRawFeat.Energy); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.median = median(spiketrainStrct_V2.waveRawFeat.PtoPwidthMS); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.vari = var(spiketrainStrct_V2.waveRawFeat.PtoPwidthMS); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.Energy.median = median(spiketrainStrct_V2.waveNormFeat.Energy); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.Energy.vari = var(spiketrainStrct_V2.waveNormFeat.Energy); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.median = median(spiketrainStrct_V2.waveNormFeat.PtoPwidthMS); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.vari = var(spiketrainStrct_V2.waveNormFeat.PtoPwidthMS); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PosPeak.median = median(spiketrainStrct_V2.waveRawFeat.PosPeak); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PosPeak.vari = var(spiketrainStrct_V2.waveRawFeat.PosPeak); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PosPeak.median = median(spiketrainStrct_V2.waveNormFeat.PosPeak); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PosPeak.vari = var(spiketrainStrct_V2.waveNormFeat.PosPeak); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.NegPeak.median = median(spiketrainStrct_V2.waveRawFeat.NegPeak); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.NegPeak.vari = var(spiketrainStrct_V2.waveRawFeat.NegPeak); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.NegPeak.median = median(spiketrainStrct_V2.waveNormFeat.NegPeak); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.NegPeak.vari = var(spiketrainStrct_V2.waveNormFeat.NegPeak); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.FDmin.median = median(spiketrainStrct_V2.waveRawFeat.FDmin); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.FDmin.vari = var(spiketrainStrct_V2.waveRawFeat.FDmin); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmax.median = median(spiketrainStrct_V2.waveRawFeat.SDmax); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmax.vari = var(spiketrainStrct_V2.waveRawFeat.SDmax); 

masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmin.median = median(spiketrainStrct_V2.waveRawFeat.SDmin); 
masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmin.vari = var(spiketrainStrct_V2.waveRawFeat.SDmin); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.FDmin.median = median(spiketrainStrct_V2.waveNormFeat.FDmin); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.FDmin.vari = var(spiketrainStrct_V2.waveNormFeat.FDmin); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmax.median = median(spiketrainStrct_V2.waveNormFeat.SDmax); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmax.vari = var(spiketrainStrct_V2.waveNormFeat.SDmax); 

masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmin.median = median(spiketrainStrct_V2.waveNormFeat.SDmin); 
masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmin.vari = var(spiketrainStrct_V2.waveNormFeat.SDmin); 





if saveFig == 1
    %save out the masterspikestruct
    %load in masterspikestruct file
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
    filename2 = ('/masterspikestruct_V2');
    save(fullfile(figuresdir, filename2), 'masterspikestruct_V2');
end























end



