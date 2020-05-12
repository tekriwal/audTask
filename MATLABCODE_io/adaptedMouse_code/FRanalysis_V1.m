%V1 AT 4/27/20
%goal is to 1) generate metrics that will let us do some broad
%categorization of values generated from 'FRanalysis_helperfx_V1'


saveFig = 1;

% function [] = FRanalysis_V1(caseNumb, spikeFile, clust, saveFig)


figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
filename2 = ('/masterspikestruct');
load(fullfile(figuresdir, filename2), 'masterspikestruct');
subName2_index = {'SGandIS';'SG';'IS';'L';'R'};

for i = 1:length(masterspikestruct.clustfileIndex)
    
    structLabel = masterspikestruct.clustfileIndex{i};
    
    % subName = 'FR'; %either 'FR' or 'spiketrain'
    %below gives summary data combining across SG/IS and L/R (aka 'all')
    for k = 1:length(subName2_index)
        subName2 = subName2_index{k};
        
        epochName = 'wholeTrial';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
        
        epochName = 'priors';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'sensoryProcessing';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'movePrep';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'moveInit';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'periReward';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct.Median_ave.(structLabel).(epochName).(subName2);
        
    end
    
    
    groupvar.waveRawFeat.EnergyMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.Energy.median;
    groupvar.waveRawFeat.EnergyVar(i) = masterspikestruct.Mean_ave.(structLabel).waveRawFeat.Energy.vari;

    groupvar.waveNormFeat.EnergyMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.Energy.median;
    groupvar.waveNormFeat.EnergyVar(i) = masterspikestruct.Mean_ave.(structLabel).waveNormFeat.Energy.vari;
    
    
    
    groupvar.waveRawFeat.PtoPwidthMSMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.median;
    groupvar.waveRawFeat.PtoPwidthMSVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.vari;
    
    groupvar.waveNormFeat.PtoPwidthMSMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.median;
    groupvar.waveNormFeat.PtoPwidthMSVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.vari; 


    groupvar.waveRawFeat.FDminMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.FDmin.median;
    groupvar.waveRawFeat.FDminVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.FDmin.vari;
    
    groupvar.waveNormFeat.FDminMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.FDmin.median;
    groupvar.waveNormFeat.FDminVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.FDmin.vari; 


    groupvar.waveRawFeat.SDminMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmin.median;
    groupvar.waveRawFeat.SDminVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmin.vari;
    
    groupvar.waveNormFeat.SDminMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmin.median;
    groupvar.waveNormFeat.SDminVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmin.vari; 

    
    groupvar.waveRawFeat.SDmaxMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmax.median;
    groupvar.waveRawFeat.SDmaxVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.SDmax.vari;
    
    groupvar.waveNormFeat.SDmaxMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmax.median;
    groupvar.waveNormFeat.SDmaxVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.SDmax.vari; 
    
    groupvar.waveRawFeat.PosPeakMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.PosPeak.median;
    groupvar.waveRawFeat.PosPeakVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.PosPeak.vari;
    
    groupvar.waveNormFeat.PosPeakMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.PosPeak.median;
    groupvar.waveNormFeat.PosPeakVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.PosPeak.vari; 
    
    groupvar.waveRawFeat.NegPeakMedian(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.NegPeak.median;
    groupvar.waveRawFeat.NegPeakVar(i) = masterspikestruct.FRstruct.(structLabel).waveRawFeat.NegPeak.vari;
    
    groupvar.waveNormFeat.NegPeakMedian(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.NegPeak.median;
    groupvar.waveNormFeat.NegPeakVar(i) = masterspikestruct.FRstruct.(structLabel).waveNormFeat.NegPeak.vari; 
    

end

%%
%little aside here to try out making a matrix for tsne


subName = 'SGandIS';
meanORmedian = 'Median_ave';

epochName = 'wholeTrial';
input1_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'priors';
input2_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'sensoryProcessing';
input3_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'movePrep';
input4_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'moveInit';
input5_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'periReward';
input6_SGandIS  = groupvar.(meanORmedian).(epochName).(subName);




subName = 'SG';
meanORmedian = 'Median_ave';

epochName = 'wholeTrial';
input1_SG  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'priors';
input2_SG  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'sensoryProcessing';
input3_SG  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'movePrep';
input4_SG  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'moveInit';
input5_SG  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'periReward';
input6_SG  = groupvar.(meanORmedian).(epochName).(subName);




subName = 'IS';
meanORmedian = 'Median_ave';

epochName = 'wholeTrial';
input1_IS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'priors';
input2_IS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'sensoryProcessing';
input3_IS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'movePrep';
input4_IS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'moveInit';
input5_IS  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'periReward';
input6_IS  = groupvar.(meanORmedian).(epochName).(subName);




subName = 'L';
meanORmedian = 'Median_ave';

epochName = 'wholeTrial';
input1_L  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'priors';
input2_L  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'sensoryProcessing';
input3_L  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'movePrep';
input4_L  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'moveInit';
input5_L  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'periReward';
input6_L  = groupvar.(meanORmedian).(epochName).(subName);




subName = 'R';
meanORmedian = 'Median_ave';

epochName = 'wholeTrial';
input1_R  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'priors';
input2_R  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'sensoryProcessing';
input3_R  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'movePrep';
input4_R  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'moveInit';
input5_R  = groupvar.(meanORmedian).(epochName).(subName);

epochName = 'periReward';
input6_R  = groupvar.(meanORmedian).(epochName).(subName);











wavedata = 'waveRawFeat';

input1_1 = groupvar.(wavedata).EnergyMedian;

input2_1 = groupvar.(wavedata).EnergyVar;

input3_1 = groupvar.(wavedata).PtoPwidthMSMedian;

input4_1 = groupvar.(wavedata).PtoPwidthMSVar;

input5_1 = groupvar.(wavedata).FDminMedian;

input6_1 = groupvar.(wavedata).FDminVar;

input7_1 = groupvar.(wavedata).SDminMedian;

input8_1 = groupvar.(wavedata).SDminVar;

input9_1 = groupvar.(wavedata).SDmaxMedian;

input10_1 = groupvar.(wavedata).SDmaxVar;

input11_1 = groupvar.(wavedata).PosPeakMedian;

input12_1 = groupvar.(wavedata).PosPeakVar;

input13_1 = groupvar.(wavedata).NegPeakMedian;

input14_1 = groupvar.(wavedata).NegPeakVar;



wavedata = 'waveNormFeat';

input1_2 = groupvar.(wavedata).EnergyMedian;

input2_2 = groupvar.(wavedata).EnergyVar;

input3_2 = groupvar.(wavedata).PtoPwidthMSMedian;

input4_2 = groupvar.(wavedata).PtoPwidthMSVar;

input5_2 = groupvar.(wavedata).FDminMedian;

input6_2 = groupvar.(wavedata).FDminVar;

input7_2 = groupvar.(wavedata).SDminMedian;

input8_2 = groupvar.(wavedata).SDminVar;

input9_2 = groupvar.(wavedata).SDmaxMedian;

input10_2 = groupvar.(wavedata).SDmaxVar;

input11_2 = groupvar.(wavedata).PosPeakMedian;

input12_2 = groupvar.(wavedata).PosPeakVar;

input13_2 = groupvar.(wavedata).NegPeakMedian;

input14_2 = groupvar.(wavedata).NegPeakVar;


%% ROC, preference
% 
% [pref, rp] = ROC_preference(L_spikes', R_spikes', num_iter); % Calls new ROC function
% 
% preference.(analysis_name)(epoch_ind) = pref;
% roc_p.(analysis_name)(epoch_ind) = rp;




FRindex = zeros(size(input1_SGandIS'));
for i = 1:length(FRindex)
    if input1_SGandIS(i) < 21
        FRindex(i) = 1;
    elseif input1_SGandIS(i) > 58
        FRindex(i) = 3;
    else
        FRindex(i) = 2;
    end
end

% % tsneInput = [input1', input2', input3', input4', input5', input6'];
% % 
% % tsneInput = [input1', input2', input3', input4', input5', input6', input7', input8', input9', input10'];
% % 
% % 
% % tsneInput = [input11', input12', input13'];
% % 
% % tsneInput = [input2', input4', input6'];
% % 
% % tsneInput = [input4', input5', input6'];%this is a good one
% % 
% % tsneInput = [input2', input3', input4'];%
% % 
% % tsneInput = [input2', input3', input4', input5', input6'];
% % 
% % tsneInput = [input4', input5', input6', input7', input8', input9', input10',input1', input2', input3', input12', input13']; %GREAT
% % 
% % tsneInput = [input1', input2', input3', input4', input5', input6', input7', input8', input9', input10'];
% 
% % [input1_1', input2_1', input3_1', input4_1', input5_1', input6_1', input7_1', input8_1', input9_1', input10_1', input11_1', input12_1', input13_1', input14_1'] 
% % [input1_1',  input3_1',  input5_1', input7_1', input9_1',  input11_1', input13_1'] 
% % [input1_2',  input3_2',  input5_2', input7_2', input9_2',  input11_2', input13_2'] 
% 
newinput = 0;
if newinput == 1
    % rng('default') % For reproducibility
%     tsneInput = [input1_SGandIS', input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1', ((input6_IS - input1_IS)'-(input6_SG - input1_SG)'), ((input3_IS - input1_IS)'- (input3_SG - input1_SG)')];
%     tsneInput = [input1_SGandIS', input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1'];
%     tsneInput = [input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1']; %this is great
%     tsneInput = [input1_1', input3_1', input5_1', input7_1', input9_1',input11_1', input12_1', input13_1', input14_1']; %this is great
%     
%     tsneInput = [input2_1', input4_1', input6_1',  input8_1',  input10_1', input12_1',  input14_1']; %this is great
    tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, one from examples
% % % %     tsneInput = [input1_1',input3_1',input5_1', input7_1',  input13_1']; %best so far, 'fantastic_tsne2'
end


loadY = 1;
if loadY == 1
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','tsne_SNsubtypes');
    filename2 = ('/fantastic_tsne5');
    load(fullfile(figuresdir, filename2), 'Y');
else
    Y = tsne(tsneInput);
end

%5/5/20; load in 'fantastic_tsne1.mat' or related mat file

% %AT 5/5/20 neurons that we want to cut out
Y(32,:) = [];
masterspikestruct.anatomLocation(32) = [];
masterspikestruct.clustfileIndex(32) = [];
FRindex(32) = [];

dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points

figure()
% Y = tsne(tsneInput);
gscatter(Y(:,1),Y(:,2),'k')
% c = cell2mat(masterspikestruct.clustfileIndex);
c = cell2mat(masterspikestruct.anatomLocation);
text(Y(:,1)+dx, Y(:,2)+dy, c);
title('tSNE')
set(gca, 'FontSize', 14, 'FontName', 'Georgia')




figure()

idx = dbscan(Y,100,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
gscatter(Y(:,1),Y(:,2),idx);
% c = cell2mat(masterspikestruct.clustfileIndex);
c = cell2mat(masterspikestruct.anatomLocation);
text(Y(:,1)+dx, Y(:,2)+dy, c);
title('DBSCAN Using Euclidean Distance Metric')
set(gca, 'FontSize', 14, 'FontName', 'Georgia')




figure()
kidx = kmeans(Y, 3, 'Distance', 'cityblock'); % The default distance metric is squared Euclidean distance
gscatter(Y(:,1),Y(:,2),kidx);
% c = cell2mat(masterspikestruct.clustfileIndex);
c = cell2mat(masterspikestruct.anatomLocation);
text(Y(:,1)+dx, Y(:,2)+dy, c);
title('K-Means Using Squared Euclidean Distance Metric')
set(gca, 'FontSize', 14, 'FontName', 'Georgia')
%%

subName1 = 'SG';
epochName1 = 'wholeTrial';
meanORmedian = 'Median_ave';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'wholeTrial';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end






subName1 = 'SG';
epochName1 = 'priors';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'priors';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end







subName1 = 'SG';
epochName1 = 'sensoryProcessing';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'sensoryProcessing';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end









subName1 = 'SG';
epochName1 = 'movePrep';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'movePrep';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end










subName1 = 'SG';
epochName1 = 'moveInit';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'moveInit';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end







subName1 = 'SG';
epochName1 = 'periReward';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'IS';
epochName2 = 'periReward';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end















subName1 = 'L';
epochName1 = 'wholeTrial';
meanORmedian = 'Median_ave';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'wholeTrial';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end






subName1 = 'L';
epochName1 = 'priors';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'priors';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end







subName1 = 'L';
epochName1 = 'sensoryProcessing';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'sensoryProcessing';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end









subName1 = 'L';
epochName1 = 'movePrep';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'movePrep';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end










subName1 = 'L';
epochName1 = 'moveInit';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'moveInit';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end







subName1 = 'L';
epochName1 = 'periReward';
input1  = groupvar.(meanORmedian).(epochName1).(subName1);

subName2 = 'R';
epochName2 = 'periReward';
input2  = groupvar.(meanORmedian).(epochName2).(subName2);

ylabeltext = 'Firing rate (Hz)';
titletext = strcat(subName1, {' '}, epochName1, {'   vs.   '},  subName2, {' '}, epochName2);

figure()
violin_jasperfabius( 1, input1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', 5, 'facecolor', [0.5 0.5 0.5])
hold on
violin_jasperfabius( 1, input2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', 5, 'facecolor', [0 0 0])
ylabel(ylabeltext)
title(titletext)

fig_name = cell2mat(titletext); 
set(gcf,'NumberTitle', 'off', 'Name', fig_name);
set(gca, 'FontSize', 8, 'FontName', 'Georgia')

figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename = (fig_name);
if saveFig == 1
    saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
end


















hx_input1 = lillietest(input1);
hx_input2 = lillietest(input2);
input2_lessthan_input1 = [];
input2_greaterthan_input1 = [];
if hx_input1 == 0 && hx_input2 == 0
    [h_ttest, p_ttest] = ttest2(input1, input2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    if h_ttest == 1
        input2_greaterthan_input1 = 1;
    end
    [h_ttest, p_ttest] = ttest2(input1, input2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    if h_ttest == 1
        input2_lessthan_input1 = 1;
    end
elseif hx_input1 == 1 || hx_input2 == 1
    %for ranksum....
    % H=0 indicates that
    %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
    %   level. H=1 indicates that the null hypothesis can be rejected at the
    %   5% level
    [p_ttest1, h_ttest1] = ranksum(input1, input2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    if h_ttest1 == 1
        input2_greaterthan_input1 = 1;
    end
    [p_ttest2, h_ttest2] = ranksum(input1, input2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    if h_ttest2 == 1
        input2_lessthan_input1 = 1;
    end
end
if input2_greaterthan_input1 == 1
    disp('input2_greaterthan_input1')
elseif input2_lessthan_input1 == 1
    disp('input2_lessthan_input1')
elseif isempty(input2_greaterthan_input1) && isempty(input2_lessthan_input1)
    disp('no differences')
end

%
% if nargin == 0
%     caseNumb = 1;
%     spikeFile = 'spike1';
%     clust = 1; %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
% end
%
%
%
% if clust == 1
% %     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1;
%     clustname = '_clust1_';
% elseif clust == 2
% %     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2;
%     clustname = '_clust2_';
% elseif clust == 3
% %     spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3;
%     clustname = '_clust3_';
% end
%
%
%
% if  caseNumb == 1
%     caseName = 'case01';
% elseif caseNumb == 2
%     caseName = 'case02';
% elseif caseNumb == 3
%     caseName = 'case03';
% elseif caseNumb == 4
%     caseName = 'case04';
% elseif caseNumb == 5
%     caseName = 'case05';
% elseif caseNumb == 6
%     caseName = 'case06';
% elseif caseNumb == 7
%     caseName = 'case07';
% elseif caseNumb == 8
%     caseName = 'case08';
% elseif caseNumb == 9
%     caseName = 'case09';
% elseif caseNumb == 10
%     caseName = 'case10';
% elseif caseNumb == 11
%     caseName = 'case11';
% elseif caseNumb == 12
%     caseName = 'case12';
% elseif caseNumb == 13
%     caseName = 'case13';
% end
%

p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);








%load in a given spiketrain dataset

% %below saves out the figure, hopefully
figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis', caseName); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
filename2 = (['/spiketrainStrct_', caseName, spikeFile, clustname]);
load(fullfile(figuresdir, filename2), 'spiketrainStrct');













%do some analysises























% end



