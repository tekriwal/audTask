%V1 AT 4/27/20
%goal is to 1) generate metrics that will let us do some broad
%categorization of FR values. this helper fx is designed to 




function [] = FRanalysis_helperfx_V1(caseNumb, spikeFile, clust, saveFig)



if nargin == 0
    caseNumb = 1;
    spikeFile = 'spike1';
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
filename2 = ('/masterspikestruct');
load(fullfile(figuresdir, filename2), 'masterspikestruct');


%load in a given spiketrain dataset
figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis', caseName); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename2 = (['/spiketrainStrct_', caseName, spikeFile, clustname]);
load(fullfile(figuresdir, filename2), 'spiketrainStrct');




%below gives summary data combining across SG/IS and L/R (aka 'all')
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'SGandIS';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.L.(epochName).(subName), spiketrainStrct.SG.R.(epochName).(subName), spiketrainStrct.IS.L.(epochName).(subName), spiketrainStrct.IS.R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));




%below gives summary data combining across SG
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'SG';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));








%below gives summary data combining across IS
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'IS';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.(subName2).L.(epochName).(subName), spiketrainStrct.(subName2).R.(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));






%below gives summary data combining across Lefts
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'L';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));







%below gives summary data combining across Rights
epochName = 'wholeTrial';
subName = 'FR'; %either 'FR' or 'spiketrain'
subName2 = 'R';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'priors';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'sensoryProcessing';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'movePrep';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'moveInit';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));

epochName = 'periReward';
masterspikestruct.FRstruct.(structLabel).(epochName).(subName2) = [spiketrainStrct.SG.(subName2).(epochName).(subName), spiketrainStrct.IS.(subName2).(epochName).(subName)]; 
masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2) = mean(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));
masterspikestruct.Median_ave.(structLabel).(epochName).(subName2) = median(cell2mat(masterspikestruct.FRstruct.(structLabel).(epochName).(subName2)));



% below is some work for saving out waveform features
masterspikestruct.FRstruct.(structLabel).waveRawFeat.Energy.median = median(spiketrainStrct.waveRawFeat.Energy); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.Energy.vari = var(spiketrainStrct.waveRawFeat.Energy); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.median = median(spiketrainStrct.waveRawFeat.PtoPwidthMS); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.vari = var(spiketrainStrct.waveRawFeat.PtoPwidthMS); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.Energy.median = median(spiketrainStrct.waveNormFeat.Energy); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.Energy.vari = var(spiketrainStrct.waveNormFeat.Energy); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.median = median(spiketrainStrct.waveNormFeat.PtoPwidthMS); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.vari = var(spiketrainStrct.waveNormFeat.PtoPwidthMS); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.PosPeak.median = median(spiketrainStrct.waveRawFeat.PosPeak); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.PosPeak.vari = var(spiketrainStrct.waveRawFeat.PosPeak); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.PosPeak.median = median(spiketrainStrct.waveNormFeat.PosPeak); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.PosPeak.vari = var(spiketrainStrct.waveNormFeat.PosPeak); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.NegPeak.median = median(spiketrainStrct.waveRawFeat.NegPeak); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.NegPeak.vari = var(spiketrainStrct.waveRawFeat.NegPeak); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.NegPeak.median = median(spiketrainStrct.waveNormFeat.NegPeak); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.NegPeak.vari = var(spiketrainStrct.waveNormFeat.NegPeak); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.FDmin.median = median(spiketrainStrct.waveRawFeat.FDmin); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.FDmin.vari = var(spiketrainStrct.waveRawFeat.FDmin); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmax.median = median(spiketrainStrct.waveRawFeat.SDmax); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmax.vari = var(spiketrainStrct.waveRawFeat.SDmax); 

masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmin.median = median(spiketrainStrct.waveRawFeat.SDmin); 
masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmin.vari = var(spiketrainStrct.waveRawFeat.SDmin); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.FDmin.median = median(spiketrainStrct.waveNormFeat.FDmin); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.FDmin.vari = var(spiketrainStrct.waveNormFeat.FDmin); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmax.median = median(spiketrainStrct.waveNormFeat.SDmax); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmax.vari = var(spiketrainStrct.waveNormFeat.SDmax); 

masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmin.median = median(spiketrainStrct.waveNormFeat.SDmin); 
masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmin.vari = var(spiketrainStrct.waveNormFeat.SDmin); 





if saveFig == 1
    %save out the masterspikestruct
    %load in masterspikestruct file
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
    filename2 = ('/masterspikestruct');
    save(fullfile(figuresdir, filename2), 'masterspikestruct');
end























end



