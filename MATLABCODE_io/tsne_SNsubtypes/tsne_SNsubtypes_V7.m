%V7, adding in the permutation test
%PUT BREAKPOINT AT line 1276.
%

%V6, 7/19/20; AT added some subfxs and added a diff way to look at
%mean/medians

%V5, 6/24/20, adding on localization from imaging analysis on top of tsne
%V1 AT 5/5/20; built this code on top of what I had written for
%AT_FRanalyses. I've saved out some promising 'Y' from tsneoutput in a
%folder on box. At present, #5 or #6 is pretty good

function [] = tsne_SNsubtypes_V7()
% %AT adding below 11/17/20
% %to save out the breakpoints, use below code:
% b = dbstatus('-completenames');
% save buggybrkpnts b;  
% %to load in, use below:

% load buggybrkpnts b
% dbstop(b)


% below input is important if not trying to run new clustering inputs
% newYinput = 0; %set to 1 to calculate new tsne input, or 0 if loading old
filename2Yinput = ('/fantastic_tsne_May30_V1'); %'/fantastic_tsne6' is a good one too
filenameRamayyaComparisoninput = ('/Yinput_tsneramayya_replication_option3');
loadY = 1; %set to 1 if we want to use old 'Y', redundant with newYinput?
stopAtPubFigures = 0; %if set at 1, then throws an error when we get to figures that are to be included in pub
violinsON = 1; %set to 1 if we want to see the violin plots; AT 7/19/20

%6/24/20, for below, set to 0 if interested in the tsne plots themselves
%and validation, but set to 1 if interested in SG vs IS findings.
cutSGorIS = 1; %set to 1 when we want to cut out cases 8 and 9 since they are only SG
cutcase5 = 1; %9/15/20, set this to 1 to cut case5spike1lead1 because FR activity is very erratic secondary to removing trials as part of the smoothing
%9/11/20, for the below, I think indexSTNmanual = 1 is ideal?
indexSTNmanual = 1; %this input is pretty important, if set to 0 then the STN stay in, otherwise they get cut one way or another

%7/23/20, so for below, I think we can keep set to '0'since the fx
%intermitt neuron is already apart of
%'spiketrainexaction_AnalysisStruct_V6'
checkFRdistribution = 0; %this is for checking that the FR distributions are mono-peaked

combinedBaseline = 0; %AT 9/14/20, I think we want to keep things uncombined.
multiplecomparisons = 1; %AT 9/14/20 added this to the fx
saveFig = 0;
% function [] = FRanalysis_V1(caseNumb, spikeFile, clust, saveFig)
caselabelON = 1; %set to '1' if we want the caseID's on the scatter

markersize = 35;
fontsize = 18;


figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
filename2 = ('/masterspikestruct_V2');
load(fullfile(figuresdir, filename2), 'masterspikestruct_V2');

%AT adding below 9/11/20, this is JT's input
filename22 = ('ai_io_plotting09032020d');
load(fullfile(figuresdir, filename22), 'datCell');

%% AT adding in a small snip of code to patch over a bug in the masterspike, once convinced its w/out cause, i will save over file info
epoch_index = {'wholeTrial','priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};
subName2_index = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};

i = 25;
structLabel = masterspikestruct_V2.clustfileIndex{i};


for k = 1:length(epoch_index)
    
    epoch_index2 = epoch_index{k};
    baseline = 'wholeTrial';
    
    for kk = 1:length(subName2_index)
        epoch2 = subName2_index{kk};
     
        if strcmp(epoch2, 'SGandIS')
            
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(24) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
        end
        if strcmp(epoch2, 'SG')
            
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(24) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
        end
        if strcmp(epoch2, 'ipsi')
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(10) = [];
        end
        if strcmp(epoch2, 'contra')
            
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
        end
        if strcmp(epoch2, 'Incorrects')
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
        end
        if strcmp(epoch2, 'Corrects')
            
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(30) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(29) = [];
        end
        if strcmp(epoch2, 'SGcontra')
            
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
        end
        if strcmp(epoch2, 'SGipsi')
            masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(10) = [];
        end
    end

end



%%
subName2_index = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};

for i = 1:length(masterspikestruct_V2.clustfileIndex)
    
    structLabel = masterspikestruct_V2.clustfileIndex{i};
    
    % subName = 'FR'; %either 'FR' or 'spiketrain'
    %below gives summary data combining across SG/IS and L/R (aka 'all')
    for k = 1:length(subName2_index)
        subName2 = subName2_index{k};
        
        epochName = 'wholeTrial';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        
        epochName = 'priors';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'sensoryProcessing';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'movePrep';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'moveInit';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        epochName = 'periReward';
        % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        groupvar.Mean_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Mean_ave.(structLabel).(epochName).(subName2);
        groupvar.Median_ave.(epochName).(subName2)(i) = masterspikestruct_V2.Median_ave.(structLabel).(epochName).(subName2);
        
        %         epochName = 'periReward';
        %         % groupvar.FRstruct.(epochName).(subName2)(i) = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        %         groupvar.FRstruct.(epochName).(subName2){i} = masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2);
        
    end
    
    
    groupvar.waveRawFeat.EnergyMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.Energy.median;
    groupvar.waveRawFeat.EnergyVar(i) = masterspikestruct_V2.Mean_ave.(structLabel).waveRawFeat.Energy.vari;
    
    groupvar.waveNormFeat.EnergyMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.Energy.median;
    groupvar.waveNormFeat.EnergyVar(i) = masterspikestruct_V2.Mean_ave.(structLabel).waveNormFeat.Energy.vari;
    
    groupvar.waveRawFeat.PtoPwidthMSMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.median;
    groupvar.waveRawFeat.PtoPwidthMSVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PtoPwidthMS.vari;
    
    groupvar.waveNormFeat.PtoPwidthMSMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.median;
    groupvar.waveNormFeat.PtoPwidthMSVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PtoPwidthMS.vari;
    
    groupvar.waveRawFeat.FDminMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.FDmin.median;
    groupvar.waveRawFeat.FDminVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.FDmin.vari;
    
    groupvar.waveNormFeat.FDminMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.FDmin.median;
    groupvar.waveNormFeat.FDminVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.FDmin.vari;
    
    groupvar.waveRawFeat.SDminMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmin.median;
    groupvar.waveRawFeat.SDminVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmin.vari;
    
    groupvar.waveNormFeat.SDminMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmin.median;
    groupvar.waveNormFeat.SDminVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmin.vari;
    
    groupvar.waveRawFeat.SDmaxMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmax.median;
    groupvar.waveRawFeat.SDmaxVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.SDmax.vari;
    
    groupvar.waveNormFeat.SDmaxMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmax.median;
    groupvar.waveNormFeat.SDmaxVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.SDmax.vari;
    
    groupvar.waveRawFeat.PosPeakMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PosPeak.median;
    groupvar.waveRawFeat.PosPeakVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.PosPeak.vari;
    
    groupvar.waveNormFeat.PosPeakMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PosPeak.median;
    groupvar.waveNormFeat.PosPeakVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.PosPeak.vari;
    
    groupvar.waveRawFeat.NegPeakMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.NegPeak.median;
    groupvar.waveRawFeat.NegPeakVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveRawFeat.NegPeak.vari;
    
    groupvar.waveNormFeat.NegPeakMedian(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.NegPeak.median;
    groupvar.waveNormFeat.NegPeakVar(i) = masterspikestruct_V2.FRstruct.(structLabel).waveNormFeat.NegPeak.vari;
    
end


%%
% AT 7/19/20

%we want to take a intra-trial measure of FR change.

epoch_index = {'wholeTrial','priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};
subName2_index = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};

for i = 1:length(masterspikestruct_V2.clustfileIndex)
    
    structLabel = masterspikestruct_V2.clustfileIndex{i};
    
    % subName = 'FR'; %either 'FR' or 'spiketrain'
    %below gives summary data combining across SG/IS and L/R (aka 'all')
    for k = 1:length(epoch_index)
        
        epoch_index2 = epoch_index{k};
        baseline = 'wholeTrial';
        
        for kk = 1:length(subName2_index)
            epoch2 = subName2_index{kk};
            
            groupvar.intraTrialFR_mean.(epoch_index2).(epoch2)(i) = mean(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)) - cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)));
            groupvar.intraTrialFR_median.(epoch_index2).(epoch2)(i) = median(cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)) - cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)));

%             groupvar.intraTrialpercFR_mean.(epoch_index2).(epoch2)(i) = mean( (cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2))   -   cell2mat( masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)) )./  cell2mat (masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)  )   )  *100;
%             groupvar.intraTrialpercFR_median.(epoch_index2).(epoch2)(i) = median(((cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2))   -   cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)))./cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2))))*100;
                
%             diffvector = (cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)) - cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)));
%             FR_as_perc = diffvector/  (cell2mat (masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)));
%             
            groupvar.intraTrialpercFR_mean.(epoch_index2).(epoch2)(i) = mean( (cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2))   -   cell2mat( masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)) )./  cell2mat (masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)  )   )  *100;
            groupvar.intraTrialpercFR_median.(epoch_index2).(epoch2)(i) = median(((cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2))   -   cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)))./cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2))))*100;
            
%             load(fullfile(figuresdir, filename2), 'masterspikestruct_V2');

            
%             %AT trying to add something to make the processing w/ removing
%             %STN values a little easier
            groupvar.intraTrialFR_mean.(baseline).(epoch2)(i) = 1;
            groupvar.intraTrialFR_median.(baseline).(epoch2)(i) = 1;
            
            groupvar.intraTrialpercFR_mean.(baseline).(epoch2)(i) = 1;
            groupvar.intraTrialpercFR_median.(baseline).(epoch2)(i) = 1;
            
        end
    end
end




%%
%little aside here to try out making a matrix for tsne


subName = 'SGandIS';
meanORmedian = 'Mean_ave';

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
meanORmedian = 'Mean_ave';

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
meanORmedian = 'Mean_ave';

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


%AT
subName = 'L';
meanORmedian = 'Mean_ave';

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
meanORmedian = 'Mean_ave';

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

%

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

%%
%%
%% Need to figure out which cells have intermittent firing and which do not

%% below is what im working on 5/11/20
%%
%%

if checkFRdistribution == 1
    FRindex_casebycase = zeros(size(masterspikestruct_V2.clustfileIndex));
    Peaksindex_casebycase = ones(size(masterspikestruct_V2.clustfileIndex));
    cutIntermits = 0;
    
    for i = 1:length(masterspikestruct_V2.clustfileIndex)
        
        structLabel = masterspikestruct_V2.clustfileIndex{i};
        epochName = 'wholeTrial';
        subName2 = 'SGandIS';
        
        %     for k = 1:length(subName2_index)
        %     subName2 = subName2_index{k};
        
        individ_trialInfo = cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epochName).(subName2));
        
        %%Below fx is what accounts for intermittent neurons
        if cutIntermits == 1
            individ_trialInfo  = intermittentNeuron_helperfx_V1(individ_trialInfo, structLabel);
        end
        
        individ_trialInfo(individ_trialInfo==0) = [];
        
        FRindex_wholeTrialstdFR = zeros(size(individ_trialInfo'));
        %     FRindex_individ_trialInfo = zeros(size(individ_trialInfo'));
        
        std_input1 = std(individ_trialInfo); %1 means nonpara, 0 means normally distrib
        mean_input1 = mean(individ_trialInfo);
        stdMultiplier = 1;
        
        
        pd = fitdist(individ_trialInfo','Kernel', 'Bandwidth', 7);
        
        x_values = 1:1:150;
        y = pdf(pd,x_values);
        plot(x_values,y,'LineWidth',2)
        
        %     findpeaks(individ_trialInfo,'MinPeakDistance',6)
        %     pks = findpeaks(y,'MinPeakDistance',(std_input1*stdMultiplier));
        [pks,locs] = findpeaks(y,'MinPeakDistance',(std_input1*2));
        
        if length(pks) > 1 && max(pks)/10 < min(pks)
            structLabel
            disp('bi modal?')
            maxpeak = max(pks);
            
            numbpeaks = 0;
            for kk = 1:length(pks)
                if pks(kk) > 0.01
                    numbpeaks = numbpeaks+1;
                end
            end
            
            
            
            Peaksindex_casebycase(i) = sum(numbpeaks);
            histogram(individ_trialInfo, 'BinWidth',3)
            
            
        end
        
        
        
        %     %below is for case by case evaluation
        %     for m = 1:length(FRindex_wholeTrialstdFR)
        %
        %         input1 = individ_trialInfo(m);
        %
        %         if input1 > (mean_input1 + (stdMultiplier*std_input1))
        %             FRindex_wholeTrialstdFR(m) = 1; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
        %
        %         elseif input1 < (mean_input1 - (stdMultiplier*std_input1))
        %             FRindex_wholeTrialstdFR(m) = -1; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
        %
        %         end
        %     end
        %
        %
        %
        %     if sum(abs(FRindex_wholeTrialstdFR)) > 3
        %         FRindex_casebycase(i) = 1;
        %     end
        
        
        
        
        
        
        %     end
    end
    
end






if loadY == 1
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','tsne_SNsubtypes');
    %     filename2 = ('/fantastic_tsne5'); %'/fantastic_tsne6' is a good one too
    load(fullfile(figuresdir, filename2Yinput), 'Y');
else
    tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
    tsneInput = [input3_1',input3_2',input4_1',input4_2',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
    Y = tsne(tsneInput);
end


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

dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points

%AT 5/7/20; below is replicating Ramayya's analysis on our neurons
% tsneInput = [input3_1', input4_1', input3_2', input4_2'];
% tsneInput = [input1_1', input3_1', input3_2'];%quite good
inputFR = input1_SGandIS;
inputWvWdth = input3_1;

FRindex_Ramayya = zeros(size(inputFR'));
for i = 1:length(FRindex_Ramayya)
    if inputFR(i) < 15 && inputWvWdth(i) > 0.8 %Ramayya used .8 for waveform duration,
        FRindex_Ramayya(i) = 1; %Dopa
    elseif inputFR(i) > 15 && inputWvWdth(i) < 0.8
        FRindex_Ramayya(i) = 2; %Gaba
    else
        FRindex_Ramayya(i) = 3; %Misc
    end
end



% below is for indexing out the neurons we don't want to deal with

medianormean_index = {'Mean_ave';'Median_ave';'intraTrialFR_mean';'intraTrialFR_median';'intraTrialpercFR_mean';'intraTrialpercFR_median'};

if indexSTNmanual == 1
    %     STNindex = [32, 28, 20, 8];
    cutIndex = [32, 28];
    if cutSGorIS == 1
        cutIndex = [32, 29, 28, 27]; %AT 9/11/20, so 32 is case 11 lead 2, 29 is case 9 lead 2, 28 is lead 1, and 27 is case 8 lead 1
        if cutcase5 == 1 %9/15/20 note that 20 below is case 5 spike1lead1
            cutIndex = [32, 29, 28, 27, 20]; %AT 9/11/20, so 32 is case 11 lead 2, 29 is case 9 lead 2, 28 is lead 1, and 27 is case 8 lead 1
        end
    
    end
    for i = 1:length(cutIndex)
        k = cutIndex(i);
        
 
        %AT 7/20/20;  adding below for multiple types of 'means or medians'
        for mm = 1:length(medianormean_index)
            meanORmedian = medianormean_index{mm};
                   
            subName = 'SGandIS';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'SG';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'IS';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'L';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'R';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'Corrects';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            
            subName = 'Incorrects';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'ipsi';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            
            subName = 'contra';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'SGipsi';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            
            subName = 'SGcontra';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            subName = 'ISipsi';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
            
            subName = 'IScontra';
            %         meanORmedian = 'Mean_ave';
            epochName = 'wholeTrial';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'priors';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'sensoryProcessing';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'movePrep';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'moveInit';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            epochName = 'periReward';
            groupvar.(meanORmedian).(epochName).(subName)(k) = [];
            
        end
        
        masterspikestruct_V2.surgerySide_LorR(k) = [];
        masterspikestruct_V2.anatomLocation(k) = [];
        masterspikestruct_V2.clustfileIndex(k) = [];
        masterspikestruct_V2.DA_or_GABA_TSNE(k) = [];
        masterspikestruct_V2.imagingLocation(k) = [];
        
        FRindex(k) = [];
        FRindex_Ramayya(k) = [];
        inputFR(k) = [];
        inputWvWdth(k) = [];
        
    end
end





%remove STN neurons for this part
if indexSTNmanual == 2
    
    cutIndex = ~strcmp(masterspikestruct_V2.SNr_or_STN_IMAGING, 'STN');
    
    inputFR_noSTN = inputFR(cutIndex);
    inputWvWdth_noSTN = inputWvWdth(cutIndex);
    FRindex_Ramayya_noSTN = FRindex_Ramayya(cutIndex);
    %     c = cell2mat(masterspikestruct_V2.clustfileIndex(STNindex));
    h = gscatter(inputFR_noSTN, inputWvWdth_noSTN, FRindex_Ramayya_noSTN);
    %     text(inputFR_noSTN+dx, inputWvWdth_noSTN(:,2)+dy, c);
    h(1).MarkerSize = markersize;
    h(2).MarkerSize = markersize;
else
    
    %     c = cell2mat(masterspikestruct_V2.clustfileIndex);
    h = gscatter(inputFR, inputWvWdth, FRindex_Ramayya);
    h(1).MarkerSize = markersize;
    h(2).MarkerSize = markersize;
    
    
    %     text(inputFR+dx, inputWvWdth(:,2)+dy, c);
    
end




line([15,15], [0, 1], 'Color',[.5 .5 .5],'LineStyle','--')
line([0, 120],[0.8,0.8], 'Color',[.5 .5 .5],'LineStyle','--')

xlabel('Baseline FR')
ylabel('Wavewidth (ms)')
legend('Gaba', 'Unclassified', 'Dopa')
title('Thresholding cluster approach')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')


%AT 7/16/20, seeing what a DBSCAN clustering approach does to the above output
figure()
% kidx = kmeans([inputFR', inputWvWdth'], 2); % The default distance metric is squared Euclidean distance
idx = dbscan([inputFR', inputWvWdth'],21,1); %
h = gscatter(inputFR',inputWvWdth',idx);

% %     h = gscatter(inputFR, inputWvWdth, FRindex_Ramayya);
% h(1).MarkerSize = markersize;
% h(2).MarkerSize = markersize;

title('Ramayya thresh comparison, DBSCAN supp?')

xlabel('Baseline FR')
ylabel('Wavewidth (ms)')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')
ylim([0 .8])

%AT 7/16/20, seeing what a clustering approach does to the above output
figure()
kidx = kmeans([inputFR', inputWvWdth'], 2, 'MaxIter', 1000, 'Replicates', 5); % The default distance metric is squared Euclidean distance
h = gscatter(inputFR',inputWvWdth',kidx);

% %     h = gscatter(inputFR, inputWvWdth, FRindex_Ramayya);
% h(1).MarkerSize = markersize;
% h(2).MarkerSize = markersize;

title('Ramayya thresh comparison, K-Means supp?')

xlabel('Baseline FR')
ylabel('Wavewidth (ms)')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')
ylim([0 .8])


figure()

tsneInput = [input1_SGandIS', input3_1'];

Y_ramayya_comparison = tsne(tsneInput);
c = cell2mat(masterspikestruct_V2.clustfileIndex);

% % AT 9/14/20 I dont think we need the below
% STNindex = ~strcmp(masterspikestruct_V2.SNr_or_STN_IMAGING, 'STN');

if loadY == 1
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Manuscript','Figures','Figures_rawfiles', 'Supplemental', 'Ramayya_clustering_supp');
    %     filename2 = ('/fantastic_tsne5'); %'/fantastic_tsne6' is a good one too
    load(fullfile(figuresdir, filenameRamayyaComparisoninput), 'Y_noSTN_ramayya_comparison');
    if cutSGorIS == 1
        Y_noSTN_ramayya_comparison(28,:) = [];%deletes case9 lead2 (member case9lead1 and case11lead1 are both already gone)
        Y_noSTN_ramayya_comparison(27,:) = [];%deletes case8 lead1
        if cutcase5 == 1
         Y_noSTN_ramayya_comparison(20,:) = [];%deletes case5lead1clust1
        end
        if indexSTNmanual == 2
            FRindex_Ramayya_noSTN(28,:) = [];%deletes case9 lead2 (member case9lead1 and case11lead1 are both already gone)
            FRindex_Ramayya_noSTN(27,:) = [];%deletes case8 lead1
        end
    end
    
    if indexSTNmanual == 1
        FRindex_Ramayya_noSTN = FRindex_Ramayya;
    end
    %     Y_noSTN_ramayya_comparison = Y_ramayya_comparison(any(STNindex,2),:); %indexes across multiple columns in Y
    c = cell2mat(masterspikestruct_V2.clustfileIndex);
    h = gscatter(Y_noSTN_ramayya_comparison(:,1),Y_noSTN_ramayya_comparison(:,2),FRindex_Ramayya_noSTN);
    h(1).MarkerSize = markersize;
    h(1).MarkerFaceColor = [1 1 1];
    h(1).MarkerEdgeColor = [0 0 0];
    h(1).LineWidth = .001;
    
    h(2).MarkerSize = markersize;
    h(2).MarkerFaceColor = [.5 .5 .5];
    h(2).MarkerEdgeColor = [.5 .5 .5];
    h(2).LineWidth = .1;
elseif  loadY ~= 1 && indexSTNmanual == 2
    Y_noSTN_ramayya_comparison = Y_ramayya_comparison(any(cutIndex,2),:); %indexes across multiple columns in Y
    FRindex_Ramayya_noSTN = FRindex_Ramayya(cutIndex);
    c = cell2mat(masterspikestruct_V2.clustfileIndex(cutIndex));
    h = gscatter(Y_noSTN_ramayya_comparison(:,1),Y_noSTN_ramayya_comparison(:,2),FRindex_Ramayya_noSTN);
    h(1).MarkerSize = markersize;
    h(2).MarkerSize = markersize;
    % c = cell2mat(masterspikestruct_V2.clustfileIndex);
    text(Y_noSTN_ramayya_comparison(:,1)+dx, Y_noSTN_ramayya_comparison(:,2)+dy, c);
elseif  loadY ~= 1 && indexSTNmanual == 1
    Y_noSTN_ramayya_comparison = Y_ramayya_comparison(any(cutIndex,2),:); %indexes across multiple columns in Y
    c = cell2mat(masterspikestruct_V2.clustfileIndex);
    h = gscatter(Y_noSTN_ramayya_comparison(:,1),Y_noSTN_ramayya_comparison(:,2),FRindex_Ramayya);
    h(1).MarkerSize = markersize;
    h(2).MarkerSize = markersize;
    % c = cell2mat(masterspikestruct_V2.clustfileIndex);
    
    %     %6/1/20, below we'll want commented out for actual fig, nice to see the labels though for processing
    %     text(Y_noSTN_ramayya_comparison(:,1)+dx, Y_noSTN_ramayya_comparison(:,2)+dy, c);
else
    
    h =  gscatter(Y_ramayya_comparison(:,1),Y_ramayya_comparison(:,2),FRindex_Ramayya);
    h(1).MarkerSize = markersize;
    h(2).MarkerSize = markersize;
    %     %6/1/20, below we'll want commented out for actual fig, nice to see the
    %     %labels though for processing
    if caselabelON == 1
        text(Y_ramayya_comparison(:,1)+dx, Y_ramayya_comparison(:,2)+dy, c);
    end
    
end

title('tSNE using same inputs as Ramayya''s strategy (possible supp figure)')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')


%quantification that tSNE doesn't do much with the two inputs of wavelength
%and ave FR

figure()

if strcmp(filename2Yinput,'/fantastic_tsne2')
    idx = dbscan(Y_ramayya_comparison,80,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne3')
    idx = dbscan(Y_ramayya_comparison,145,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne4')
    idx = dbscan(Y_ramayya_comparison,45,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne5')
    idx = dbscan(Y_ramayya_comparison,100,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne6')
    idx = dbscan(Y_ramayya_comparison,100,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filenameRamayyaComparisoninput,'/Yinput_tsneramayya_replication_option3')
    idx = dbscan(Y_noSTN_ramayya_comparison,380,1); %
end


h = gscatter(Y_noSTN_ramayya_comparison(:,1),Y_noSTN_ramayya_comparison(:,2),idx);
h(1).MarkerSize = markersize;
h(1).MarkerFaceColor = [1 1 1];
h(1).MarkerEdgeColor = [0 0 0];
h(1).LineWidth = .001;

h(2).MarkerSize = markersize;
h(2).MarkerFaceColor = [.5 .5 .5];
h(2).MarkerEdgeColor = [.5 .5 .5];
h(2).LineWidth = .1;
% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_noSTN_ramayya_comparison(:,1)+dx, Y_noSTN_ramayya_comparison(:,2)+dy, c);
end
title('Ramayya comparison, DBSCAN (supp)')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')



figure()
kidx = kmeans(Y_noSTN_ramayya_comparison, 2, 'MaxIter', 1000, 'Replicates', 5); % The default distance metric is squared Euclidean distance
h = gscatter(Y_noSTN_ramayya_comparison(:,1),Y_noSTN_ramayya_comparison(:,2),kidx);
h(1).MarkerSize = markersize;
h(1).MarkerFaceColor = [1 1 1];
h(1).MarkerEdgeColor = [0 0 0];
h(1).LineWidth = .001;

h(2).MarkerSize = markersize;
h(2).MarkerFaceColor = [.5 .5 .5];
h(2).MarkerEdgeColor = [.5 .5 .5];
h(2).LineWidth = .1;
% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_noSTN_ramayya_comparison(:,1)+dx, Y_noSTN_ramayya_comparison(:,2)+dy, c);
end
title('Ramayya comparison, K-Means (supp)')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')





%5/5/20, we can mess with the below as needed, different input strings give
%slightly different performances.

% if newYinput == 1
%     % rng('default') % For reproducibility
%     %     tsneInput = [input1_SGandIS', input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1', ((input6_IS - input1_IS)'-(input6_SG - input1_SG)'), ((input3_IS - input1_IS)'- (input3_SG - input1_SG)')];
%     %     tsneInput = [input1_SGandIS', input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1'];
%     %     tsneInput = [input1_1', input3_1', input5_1', input11_1', input12_1', input13_1', input14_1']; %this is great
%     %     tsneInput = [input1_1', input3_1', input5_1', input7_1', input9_1',input11_1', input12_1', input13_1', input14_1']; %this is great
%     %
%     %     tsneInput = [input2_1', input4_1', input6_1',  input8_1',  input10_1', input12_1',  input14_1']; %this is great
%     tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
%     % % % %     tsneInput = [input1_1',input3_1',input5_1', input7_1',  input13_1']; %best so far, 'fantastic_tsne2'
% end


% if loadY == 1
%     figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','tsne_SNsubtypes');
%     %     filename2 = ('/fantastic_tsne5'); %'/fantastic_tsne6' is a good one too
%     load(fullfile(figuresdir, filename2Yinput), 'Y');
% else
%     tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
%     tsneInput = [input3_1',input3_2',input4_1',input4_2',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
%     Y = tsne(tsneInput);
% end

%5/5/20; load in 'fantastic_tsne1.mat' or related mat file

% %AT 5/5/20 neurons that we want to cut out
% Y(32,:) = [];

%     tsneInput = [input3_1',input3_2',input4_1',input4_2',input5_1', input7_1',  input9_1', input11_1',  input13_1']; %this is great, created fantastic_tsne4 and 6, I think
%
%     %as of night's work, this one works great:
%     tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1'];
%     Y = tsne(tsneInput);

%AT 9/14/20
cutindex = 1:38;
cutindex(cutIndex) = [];


if indexSTNmanual ~= 0
    Y_indexOfKeepers = Y(cutindex,:); %indexes across multiple columns in Y

elseif indexSTNmanual == 0
    Y_indexOfKeepers = Y;
end


%remember that we've cut out #'s 28 and 32, so #30 below is #29
groups_tSNE_determined = ones(size(inputFR'));
for i = 1:length(groups_tSNE_determined)
    if strcmp(masterspikestruct_V2.DA_or_GABA_TSNE(i), 'DANn')
        groups_tSNE_determined(i) = 2;
    end
end

% %remember that we've cut out #'s 28 and 32, so #30 below is #29
% groups_tSNE_determined(6) = 2; %2's are dopamine
% groups_tSNE_determined(7) = 2;
% groups_tSNE_determined(16) = 2;
% groups_tSNE_determined(29) = 2;



% AT 6/1/20 - don't need to do below because we're cutting out the two
% trials ID'ed on IO notes and JT's processing as being STN. Those are case
% 9 lead 1 (#28) and case 11 lead 2 (#32)
% groupsAsOfJune1st(8) = 3; %3's are STN
% groupsAsOfJune1st(20) = 3; %3's are STN
% groupsAsOfJune1st(28) = 3; %3's are STN
% groupsAsOfJune1st(32) = 3; %3's are STN

% for i = 1:length(groupsAsOfJune1st)
%     if inputFR(i) < 15 && inputWvWdth(i) > 0.7 %Ramayya used .8 for waveform duration,
%         groupsAsOfJune1st(i) = 1; %Dopa
%     elseif inputFR(i) > 15 && inputWvWdth(i) < 0.7
%         groupsAsOfJune1st(i) = 2; %Gaba
%     else
%         groupsAsOfJune1st(i) = 3; %Misc
%     end
% end
% tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1'];
%
%
% tsneInput = [input1_1',input2_1', input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1'];
%

%below is the fantastictsne inputs for March 30th V1
% tsneInput = [input1_1',input3_1',input5_1', input7_1',  input9_1', input11_1',  input13_1'];
% Y = tsne(tsneInput);
% Y_noSTN = Y;

%AT 9/14/20 - below is what we want for publication, I think, at least as
%of now
figure()
% Y = tsne(tsneInput);
h = gscatter(Y_indexOfKeepers(:,1),Y_indexOfKeepers(:,2));
h(1).MarkerSize = markersize;

% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_indexOfKeepers(:,1)+dx, Y_indexOfKeepers(:,2)+dy, c);
end
title('Clustering output for publication, 9/14/20')
set(gca, 'FontSize', fontsize, 'FontName', 'Helvetica Neue')
ylim([-800 800])
xlim([-800 400])
xticks([-800, -600, -400, -200, 0, 200, 400])
% xticks([-800,-400, 0, 400, 800])
yticks([-800, -600, -400, -200, 0, 200, 400, 600, 800])

box('off')
%AT golden ratio calculation. Change the longerside input to what is
%desired
x0=10;
y0=10;
longersideInput = 600;
longerside=longersideInput;
shorterside = longerside*(61.803/100);
height = longerside;
width = longerside*.8;
set(gcf,'position',[x0,y0,width,height])




figure()
% Y = tsne(tsneInput);
h = gscatter(Y_indexOfKeepers(:,1),Y_indexOfKeepers(:,2),groups_tSNE_determined);
h(1).MarkerSize = markersize;
h(2).MarkerSize = markersize;
% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_indexOfKeepers(:,1)+dx, Y_indexOfKeepers(:,2)+dy, c);
end
title('tSNE')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')

%validation of tsne
figure()

if strcmp(filename2Yinput,'/fantastic_tsne2')
    idx = dbscan(Y,80,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne3')
    idx = dbscan(Y,145,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne4')
    idx = dbscan(Y,45,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne5')
    idx = dbscan(Y,100,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne6')
    idx = dbscan(Y,100,1); % The default distance metric is Euclidean distance %80 for 2, 45 for 3
    
elseif strcmp(filename2Yinput,'/fantastic_tsne_May30_V1')
    idx = dbscan(Y_indexOfKeepers,300,1); % for this one, from 300 until 204 gives just 2 clusters
end

h = gscatter(Y_indexOfKeepers(:,1),Y_indexOfKeepers(:,2),idx);
h(1).MarkerSize = markersize;
h(2).MarkerSize = markersize;
% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_indexOfKeepers(:,1)+dx, Y_indexOfKeepers(:,2)+dy, c);
end
title('DBSCAN Using Euclidean Distance Metric')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')



figure()
kidx = kmeans(Y_indexOfKeepers, 2, 'MaxIter', 5000, 'Replicates', 10); % The default distance metric is squared Euclidean distance
h = gscatter(Y_indexOfKeepers(:,1),Y_indexOfKeepers(:,2),kidx);
h(1).MarkerSize = markersize;
h(2).MarkerSize = markersize;
% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_indexOfKeepers(:,1)+dx, Y_indexOfKeepers(:,2)+dy, c);
end
title('K-Means Using Squared Euclidean Distance Metric')
set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')

%below is for imaging locations
%remember that we've cut out #'s 28 and 32, so #30 below is #29
groups_imaging_determined = ones(size(inputFR'));
for i = 1:length(groups_imaging_determined)
    if strcmp(masterspikestruct_V2.imagingLocation(i), 'LPV')
        groups_imaging_determined(i) = 2;
    elseif strcmp(masterspikestruct_V2.imagingLocation(i), 'MAD')
        groups_imaging_determined(i) = 3;
    end
end

figure()
% Y = tsne(tsneInput);
h = gscatter(Y_indexOfKeepers(:,1),Y_indexOfKeepers(:,2),groups_imaging_determined);
h(1).MarkerSize = markersize;
h(2).MarkerSize = markersize;
h(3).MarkerSize = markersize;

% c = cell2mat(masterspikestruct_V2.clustfileIndex);
c = cell2mat(masterspikestruct_V2.clustfileIndex);
if caselabelON == 1
    text(Y_indexOfKeepers(:,1)+dx, Y_indexOfKeepers(:,2)+dy, c);
end
title('tSNE w/ imaging Locations')
legend('LAD', 'LPV', 'MAD','Location','northwest')

set(gca, 'FontSize', fontsize, 'FontName', 'Georgia')
box('off')

%% AT 6/11/20; it is going to be necessary to do some broader comparisons before getting into cluster1 vs cluster2 differences
% looks good!
close all

szz = 50;
figure()
%below is basic analysis demonstrating that SG and IS
% subplot(1, 2, 1)
subName1 = 'SG';
epochName1 = 'wholeTrial';
SNrsubtype1 = 'All neurons';
subName2 = 'IS';
epochName2 = epochName1;

epochName = 'wholeTrial';
baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
baselineFR1  = 0;
baselineFR2  = 0;

meanORmedian = 'Mean_ave';
inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
% logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
% inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
% logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
% inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
[pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');

[pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
[pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

% ylabeltext = 'Firing rate (Hz)';
%stats
hx_sg = lillietest(inputinfo1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(inputinfo2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(inputinfo1, inputinfo2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(inputinfo1, inputinfo2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(inputinfo1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(inputinfo1));
xaxis_onPairedSG(:) = .75;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(inputinfo2));
xaxis_onPairedIS(:) = 1.25;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),inputinfo1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
hold on
scatter(xaxis_onPairedIS(:),inputinfo2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)

hold on
for j = 1:length(inputinfo2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [inputinfo1(j)' inputinfo2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(.75, mean(inputinfo1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.25, mean(inputinfo2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([.75 1.25], [mean(inputinfo1)  mean(inputinfo2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [.75 1.25]);

xticklabels({'SG', 'IS'});
ylabel({'Absolute FR'}); %, 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({'2td p = '}, num2str(p_ttest_paired));
else
    str = strcat({'2td p = '}, num2str(p_ttest_nonparapaired));
end
title(strcat('GABA,',str));
titletext = strcat(SNrsubtype1, {', baseline (wholeTrial FR) compar.'}, {' '}, str);
title(titletext)

%     ylim([y1lim_abs y2lim_abs])
xlim([ 0.6 1.4])
%










szz = 50;
figure()
%below is basic analysis demonstrating that SG and IS
% subplot(1, 2, 1)
subName1 = 'ipsi';
epochName1 = 'wholeTrial';
SNrsubtype1 = 'All neurons';
subName2 = 'contra';
epochName2 = epochName1;

epochName = 'wholeTrial';
baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
baselineFR1  = 0;
baselineFR2  = 0;

meanORmedian = 'Mean_ave';
inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
% logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
% inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
% logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
% inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
[pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');

[pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
[pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

% ylabeltext = 'Firing rate (Hz)';
%stats
hx_sg = lillietest(inputinfo1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(inputinfo2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(inputinfo1, inputinfo2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(inputinfo1, inputinfo2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(inputinfo1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(inputinfo1));
xaxis_onPairedSG(:) = .75;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(inputinfo2));
xaxis_onPairedIS(:) = 1.25;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),inputinfo1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
hold on
scatter(xaxis_onPairedIS(:),inputinfo2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)

hold on
for j = 1:length(inputinfo2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [inputinfo1(j)' inputinfo2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(.75, mean(inputinfo1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.25, mean(inputinfo2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([.75 1.25], [mean(inputinfo1)  mean(inputinfo2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [.75 1.25]);

xticklabels({'ipsi', 'contra'});
ylabel({'Absolute FR'}); %, 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({'2td p = '}, num2str(p_ttest_paired));
else
    str = strcat({'2td p = '}, num2str(p_ttest_nonparapaired));
end
title(strcat('GABA,',str));
titletext = strcat(SNrsubtype1, {', baseline (wholeTrial FR) compar.'}, {' '}, str);
title(titletext)

%     ylim([y1lim_abs y2lim_abs])
xlim([ 0.6 1.4])















szz = 50;
figure()
%below is basic analysis demonstrating that SG and IS
% subplot(1, 2, 1)
subName1 = 'Corrects';
epochName1 = 'wholeTrial';
SNrsubtype1 = 'All neurons';
subName2 = 'Incorrects';
epochName2 = epochName1;

epochName = 'wholeTrial';
baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
baselineFR1  = 0;
baselineFR2  = 0;

meanORmedian = 'Mean_ave';
inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
% logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
% inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
% logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
% inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
[pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');

[pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
[pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

% ylabeltext = 'Firing rate (Hz)';
%stats
hx_sg = lillietest(inputinfo1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(inputinfo2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(inputinfo1, inputinfo2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(inputinfo1, inputinfo2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(inputinfo1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(inputinfo1));
xaxis_onPairedSG(:) = .75;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(inputinfo2));
xaxis_onPairedIS(:) = 1.25;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),inputinfo1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
hold on
scatter(xaxis_onPairedIS(:),inputinfo2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)

hold on
for j = 1:length(inputinfo2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [inputinfo1(j)' inputinfo2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(.75, mean(inputinfo1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.25, mean(inputinfo2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([.75 1.25], [mean(inputinfo1)  mean(inputinfo2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [.75 1.25]);

xticklabels({'corr', 'inc'});
ylabel({'Absolute FR'}); %, 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({'2td p = '}, num2str(p_ttest_paired));
else
    str = strcat({'2td p = '}, num2str(p_ttest_nonparapaired));
end
title(strcat('GABA,',str));
titletext = strcat(SNrsubtype1, {', baseline (wholeTrial FR) compar.'}, {' '}, str);
title(titletext)

%     ylim([y1lim_abs y2lim_abs])
xlim([ 0.6 1.4])




szz = 50;
figure()
%below is basic analysis demonstrating that SG and IS
% subplot(1, 2, 1)
subName1 = 'SGipsi';
epochName1 = 'wholeTrial';
SNrsubtype1 = 'All neurons';
subName2 = 'ISipsi';
epochName2 = epochName1;

epochName = 'wholeTrial';
baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
baselineFR1  = 0;
baselineFR2  = 0;

meanORmedian = 'Mean_ave';
inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
% logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
% inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
% logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
% inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
[pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');

[pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
[pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

% ylabeltext = 'Firing rate (Hz)';
%stats
hx_sg = lillietest(inputinfo1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(inputinfo2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(inputinfo1, inputinfo2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(inputinfo1, inputinfo2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(inputinfo1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(inputinfo1));
xaxis_onPairedSG(:) = .75;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(inputinfo2));
xaxis_onPairedIS(:) = 1.25;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),inputinfo1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
hold on
scatter(xaxis_onPairedIS(:),inputinfo2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)

hold on
for j = 1:length(inputinfo2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [inputinfo1(j)' inputinfo2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(.75, mean(inputinfo1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.25, mean(inputinfo2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([.75 1.25], [mean(inputinfo1)  mean(inputinfo2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [.75 1.25]);

xticklabels({'SGipsi', 'ISipsi'});
ylabel({'Absolute FR'}); %, 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({'2td p = '}, num2str(p_ttest_paired));
else
    str = strcat({'2td p = '}, num2str(p_ttest_nonparapaired));
end
title(strcat('GABA,',str));
titletext = strcat(SNrsubtype1, {', baseline (wholeTrial FR) compar.'}, {' '}, str);
title(titletext)

%     ylim([y1lim_abs y2lim_abs])
xlim([ 0.6 1.4])




szz = 50;
figure()
%below is basic analysis demonstrating that SG and IS
% subplot(1, 2, 1)
subName1 = 'SGcontra';
epochName1 = 'wholeTrial';
SNrsubtype1 = 'All neurons';
subName2 = 'IScontra';
epochName2 = epochName1;

epochName = 'wholeTrial';
baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
baselineFR1  = 0;
baselineFR2  = 0;

meanORmedian = 'Mean_ave';
inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
% logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
% inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
% logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
% inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
[pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');

[pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
[pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

% ylabeltext = 'Firing rate (Hz)';
%stats
hx_sg = lillietest(inputinfo1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(inputinfo2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(inputinfo1, inputinfo2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(inputinfo1, inputinfo2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(inputinfo1, inputinfo2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(inputinfo1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(inputinfo1));
xaxis_onPairedSG(:) = .75;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(inputinfo2));
xaxis_onPairedIS(:) = 1.25;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),inputinfo1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
hold on
scatter(xaxis_onPairedIS(:),inputinfo2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)

hold on
for j = 1:length(inputinfo2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [inputinfo1(j)' inputinfo2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(.75, mean(inputinfo1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.25, mean(inputinfo2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([.75 1.25], [mean(inputinfo1)  mean(inputinfo2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [.75 1.25]);

xticklabels({'SGcontra', 'IScontra'});
ylabel({'Absolute FR'}); %, 'FontSize', 14);

set(gca, 'FontSize', 12, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({'2td p = '}, num2str(p_ttest_paired));
else
    str = strcat({'2td p = '}, num2str(p_ttest_nonparapaired));
end
title(strcat('GABA,',str));
titletext = strcat(SNrsubtype1, {', baseline (wholeTrial FR) compar.'}, {' '}, str);
title(titletext)

%     ylim([y1lim_abs y2lim_abs])
xlim([ 0.6 1.4])

%%
%AT 7/14/20, basic plotting stuffs, this is for ALL neurons. We'll also
%prob want to do the binary classification for each epoch as well!
if violinsON == 1
    

    kWidth = 5;
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'priors';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
 
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'sensoryProcessing';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    if stopAtPubFigures == 1
        %     f = figure('Position',[500 500 400 300]);
        pause(2)
    end
 
    
    
   
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'movePrep';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'moveInit';
    
    epochName = 'moveInit';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    if stopAtPubFigures == 1
        %     f = figure('Position',[500 500 400 300]);
        pause(2)
    end
    
    %7/16/20 below is example of spaghetti plot we want to use w/ ephy data
    figure()
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'moveInit'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = 1;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.05;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(1, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.05, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([1 1.05], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [1 1.05]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    ylim([-20 120]);
    xlim([.95 1.1]);
    
    
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'periReward';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, subName1,{'; '}, epochName1, {'   vs  '}, epochName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    if stopAtPubFigures == 1
        %     f = figure('Position',[500 500 400 300]);
        pause(2)
    end
    
    
    
    
    
    %%
    %%
    %AT 7/17/20, below is going to be the paired plots for the above
    
    
    %ALL neurons, not indexing for GABA/DA
    subplotting = 1;
    kWidth = .5;
    figure()
    if subplotting == 1
        subplot(1, 5, 1)
    else
        figure()
    end
    subplot(1, 5, 1)
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'priors';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;

    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'priors'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    % ylim([-20 120]);
    xlim([ 0.6 1.4])
    
    
    if subplotting == 1
        subplot(1, 5, 2)
    else
        figure()
    end
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'sensoryProcessing';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'sensoryProcessing'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    % ylim([-20 120]);
    xlim([ 0.6 1.4])
    
    
    if subplotting == 1
        subplot(1, 5, 3)
    else
        figure()
    end
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'movePrep';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'movePrep'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    % ylim([-20 120]);
    xlim([ 0.6 1.4])
    
    
    if subplotting == 1
        subplot(1, 5, 4)
    else
        figure()
    end
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'moveInit';
    
    epochName = 'moveInit';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'moveInit'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    % ylim([-20 120]);
    xlim([ 0.6 1.4])


    if subplotting == 1
        subplot(1, 5, 5)
    else
        figure()
    end
    subName1 = 'SGandIS';
    epochName1 = 'wholeTrial';
    SNrsubtype1 = 'All neurons';
    subName2 = 'SGandIS';
    epochName2 = 'periReward';
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    xTickLabels = {'WholeTrial', 'periReward'};
    % xTickLabels = ([epochName1; epochName2]);
    yLabel = 'Firing rate (Hz)';
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input1);
    
    
    %stats
    hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
    hx_is = lillietest(input2);
    
    [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
    
    [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
    [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
    %
    
    xmin = -0.1;
    xmax = 0.1;
    n = length(input1);
    x1 = xmin+rand(1,n)*(xmax-xmin);
    x1 = 0;
    
    xaxis_onPairedSG = 1:(length(input1));
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, median(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, median(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', 10, 'FontName', 'Georgia')
    
    if hx_sg == 0 && hx_is == 0
        str = strcat({' 2tailed p = '}, num2str(p_ttest_paired));
    else
        str = strcat({' 2tailed p = '}, num2str(p_ttest_nonparapaired));
    end
    title(strcat('GABA,',str));
    titletext = strcat(epochName1, {'   vs  '}, epochName2, str);
    title(titletext)
    
    % ylim([-20 120]);
    xlim([ 0.6 1.4])
    
    
    
    
    
    
    
    %%
    %%
    %AT 7/17/20 below is where we start to get into SG vs. IS
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SG';
    epochName1 = 'priors';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{'; '}, subName1, {'   vs  '}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SG';
    epochName1 = 'sensoryProcessing';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{'; '}, subName1, {'   vs  '}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SG';
    epochName1 = 'movePrep';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{'; '}, subName1, {'   vs  '}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);

    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SG';
    epochName1 = 'moveInit';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'movePrep';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{'; '}, subName1, {'   vs  '}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    figure()
    % subplot(1, 2, 1)
    subName1 = 'SG';
    epochName1 = 'periReward';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    baselineFR1  = 0;
    baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    inputinfo1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    % inputinfo1 = input1;%(logicalinput1) - baselineFR1(logicalinput1);
    
    inputinfo2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    % inputinfo2 = input2(logicalinput2) - baselineFR2(logicalinput2);
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{'; '}, subName1, {'   vs  '}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    %ylim([-30 30]); xlim([ 0.8 1.2]) ;
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    
    %% AT 6/11/20, lets look at some deltas since the FR differences themselves were a little underwhelming
    %ALL neurons, not indexing for GABA/DA
    subplotting = 1;
    kWidth = .5;
    figure()
    if subplotting == 1
        subplot(1, 5, 1)
    else
        figure()
    end
    subplot(1, 5, 1)
    subName1 = 'SG';
    epochName1 = 'priors';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(epochName1,{' - wTrial; '}, subName1, {'v'}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    if subplotting == 1
        ylim([-20 20]); xlim([ 0.6 1.4]) ;
    else
        %ylim([-20 20]); xlim([ 0.8 1.2]) ;
    end
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    if subplotting == 1
        subplot(1, 5, 2)
    else
        figure()
    end
    subName1 = 'SG';
    epochName1 = 'sensoryProcessing';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(epochName1,{' - wTrial; '}, subName1, {'v'}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    if subplotting == 1
        ylim([-20 20]); xlim([ 0.6 1.4]) ;
    else
        %ylim([-20 20]); xlim([ 0.8 1.2]) ;
    end
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 3)
    else
        figure()
    end
    subName1 = 'SG';
    epochName1 = 'movePrep';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(epochName1,{' - wTrial; '}, subName1, {'v'}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    if subplotting == 1
        ylim([-20 20]); xlim([ 0.6 1.4]) ;
    else
        %ylim([-20 20]); xlim([ 0.8 1.2]) ;
    end
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 4)
    else
        figure()
    end
    subName1 = 'SG';
    epochName1 = 'moveInit';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(epochName1,{' - wTrial; '}, subName1, {'v'}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    if subplotting == 1
        ylim([-20 20]); xlim([ 0.6 1.4]) ;
    else
        %ylim([-20 20]); xlim([ 0.8 1.2]) ;
    end
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2, 'paired');
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 5)
    else
        figure()
    end
    subName1 = 'SG';
    epochName1 = 'periReward';
    SNrsubtype1 = 'All neurons';
    subName2 = 'IS';
    epochName2 = epochName1;
    
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2));
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = groupvar.(meanORmedian).(epochName2).(subName2);
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    ylabeltext = 'Firing rate (Hz)';
    titletext = strcat(epochName1,{' - wTrial; '}, subName1, {'v'}, subName2);
    
    violin_jasperfabius( 1, inputinfo1, 'withmdn', 1, 'side', 'left', 'Kernelwidth', kWidth, 'facecolor', [0.5 0.5 0.5])
    hold on
    violin_jasperfabius( 1, inputinfo2, 'withmdn', 1, 'side', 'right', 'Kernelwidth', kWidth, 'facecolor', [0 0 0])
    ylabel(ylabeltext)
    title(titletext)
    if subplotting == 1
        ylim([-20 20]); xlim([ 0.6 1.4]) ;
    else
        %ylim([-20 20]); xlim([ 0.8 1.2]) ;
    end
    fig_name = cell2mat(titletext);
    set(gcf,'NumberTitle', 'off', 'Name', fig_name);
    set(gca, 'FontSize', 8, 'FontName', 'Georgia')
    box('off')
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(inputinfo1,inputinfo2,'paired');
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(inputinfo1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(inputinfo2);
    
    
    
    
end
%%
%%

%%
%8/27/20 - so for below, I'm not sure if the helper fx is helping. Maybe
%its supposed to be the v1 version? I am not sure.
epoch_index = {'priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};
subName2_index = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};



%7/22/20, note that meanORmedian can be several things:
%Mean_ave, Median_ave, intraTrialFR_mean, intraTrialFR_median, intraTrialpercFR_mean, intraTrialpercFR_median

skip = 0;
if skip ~= 1
    
    
    
%should saveout the below as a comparison w/ 'intraTrialpercFR_mean'
% meanORmedian = 'Mean_ave';
meanORmedian = 'intraTrialFR_mean';


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'SGcontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'SGcontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'SGcontra';
% spaghett_ioclo_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)



SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'ISipsi';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'ISipsi';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'ISipsi';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'ISipsi';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'ISipsi';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SGipsi';
subName2 = 'ISipsi';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)



SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SGcontra';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SGcontra';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SGcontra';
subName2 = 'IScontra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)



SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)
























%should saveout the below as a comparison w/ 'intraTrialpercFR_mean'
meanORmedian = 'intraTrialFR_mean';
meanORmedian = 'Mean_ave';

SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

end




%%
%AT 7/22/20 the below is to serve as a way to correct for multiple
%comparisons. It assumes the tests are independent, I think its fair to say
%the hypotheses are independent, but not sure about the results.


%% below is for intratrialpercFR - doesnt look great
%%ll neurons
%sensoryProcess 
x = 0.019613    ;% SGvIS
y = 0.088924    ;% ipsivcontr
z = 0.87098     ;% corrvinco
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%nope


%movePrep 
x = 0.028027    ;
y = 0.5902    ;
z = 0.20277     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%nope

%moveInit 
x = 0.020527    ;
y = 0.97954    ;
z = 0.42662     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%nope



%% below is for intratrialFR,lookin pretty good! 

%all neurons
%sensoryProcess 
x = 0.023495    ;% SGvIS
y = 0.19091    ;% ipsivcontr
z = 0.84413     ;% corrvinco
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%nope


%movePrep 
x = 0.01484    ;
y = 0.44948    ;
z = 0.45706     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%woo! move Prep remains sig, if only barely 0.0445

%moveInit 
x = 0.0074595    ;
y = 0.73885    ;
z = 0.407     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%woo! p = 0.0224


%Cluster1
%moveprep - this is the only comparison that yielded sig differences
x = 0.0019188    ;
y = 0.71738    ;
z = 0.23432     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%woo! p = 0.00576


%Cluster2
%priors  
x = 0.018798    ;
y = 0.085289    ;
z = 0.16505     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%just misses it, p = 0.0564

%corr v incor
x = 0.0025092    ;
y = 0.42043    ;
z = 0.71125     ;
pvalues = [x,y,z]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
alpha = 0.05;
plotting = false;
[c_pvalues, c_alpha, h, extra] = fdr_BH(pvalues, alpha, plotting);
%woo! 0.0075




%%




%%
%AT 7/22/20; so the below cell has some very nice results that fit well
%into our framework. At present, this is prob the best option we have.

meanORmedian = 'intraTrialpercFR_mean';

SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'SG';
subName2 = 'IS';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'ipsi';
subName2 = 'contra';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'All neurons'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)


SNrsubtype1 = 'cluster1'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

SNrsubtype1 = 'cluster2'; %contributes to title of plots
subName1 = 'Corrects';
subName2 = 'Incorrects';
% spaghett_io_helperfx_V1(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2)
spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedBaseline, multiplecomparisons, saveFig)

%% 9/11/20 STOP HERE!

%%
%%

[h,p,k,DANn_prefSGwholeTrial, DANn_rpSGwholeTrial,GABA_prefSGwholeTrial,GABA_rpSGwholeTrial] = binaryClassifier_ioAnalysis_V1('wholeTrial', 'SGipsi', 'SGcontra', masterspikestruct_V2);

[h,p,k,DANn_prefSGpriors, DANn_rpSGpriors,GABA_prefSGpriors,GABA_rpSGpriors] = binaryClassifier_ioAnalysis_V1('priors', 'SGipsi', 'SGcontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('sensoryProcessing', 'SGipsi', 'SGcontra', masterspikestruct_V2);

[h,p,k,DANn_prefSGmovePrep,DANn_rpSGmovePrep, GABA_prefSGmovePrep, GABA_rpSGmovePrep] = binaryClassifier_ioAnalysis_V1('movePrep', 'SGipsi', 'SGcontra', masterspikestruct_V2);

[h,p,k,DANn_prefSGmoveInit, DANn_rpSGmoveInit,GABA_prefSGmoveInit,GABA_rpSGmoveInit] = binaryClassifier_ioAnalysis_V1('moveInit', 'SGipsi', 'SGcontra', masterspikestruct_V2);

[h,p,k,DANn_prefSGperiReward, DANn_rpSGperiReward,GABA_prefSGperiReward,GABA_rpSGperiReward] = binaryClassifier_ioAnalysis_V1('periReward', 'SGipsi', 'SGcontra', masterspikestruct_V2);



[h,p,k,DANn_prefISwholeTrial, DANn_rpISwholeTrial,GABA_prefISwholeTrial,GABA_rpISwholeTrial] = binaryClassifier_ioAnalysis_V1('wholeTrial', 'ISipsi', 'IScontra', masterspikestruct_V2);

[h,p,k,DANn_prefISpriors, DANn_rpISpriors,GABA_prefISpriors,GABA_rpISpriors] = binaryClassifier_ioAnalysis_V1('priors', 'ISipsi', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('sensoryProcessing', 'ISipsi', 'IScontra', masterspikestruct_V2);

[h,p,k,DANn_prefISmovePrep, DANn_rpISmovePrep,GABA_prefISmovePrep,GABA_rpISmovePrep] = binaryClassifier_ioAnalysis_V1('movePrep', 'ISipsi', 'IScontra', masterspikestruct_V2);

[h,p,k,DANn_prefISmoveInit, DANn_rpISmoveInit, GABA_prefISmoveInit, GABA_rpISmoveInit] = binaryClassifier_ioAnalysis_V1('moveInit', 'ISipsi', 'IScontra', masterspikestruct_V2);

[h,p,k,DANn_prefISperiReward, DANn_rpISperiReward, GABA_prefISperiReward, GABA_rpISperiReward] = binaryClassifier_ioAnalysis_V1('periReward', 'ISipsi', 'IScontra', masterspikestruct_V2);




[xd, yd, delta, deltaCI] = shifthd_AT( GABA_prefSGwholeTrial, 'GABA_pref, SG pref', GABA_prefISwholeTrial, 'GABA_pref, IS pref', 200, 1);
histoplots_preferences_V1(GABA_prefSGwholeTrial, GABA_rpSGwholeTrial, GABA_prefISwholeTrial, GABA_rpISwholeTrial )

[xd, yd, delta, deltaCI] = shifthd_AT( GABA_prefSGpriors, 'GABA_pref, SG pref', GABA_prefISpriors, 'GABA_pref, IS pref', 200, 1);
histoplots_preferences_V1(GABA_prefSGpriors, GABA_rpSGpriors, GABA_prefISpriors, GABA_rpISpriors )

[xd, yd, delta, deltaCI] = shifthd_AT( GABA_prefSGmovePrep, 'GABA_pref, SG pref', GABA_prefISmovePrep, 'GABA_pref, IS pref', 200, 1);
histoplots_preferences_V1(GABA_prefSGmovePrep, GABA_rpSGmovePrep, GABA_prefISmovePrep, GABA_rpISmovePrep )

[xd, yd, delta, deltaCI] = shifthd_AT( GABA_prefSGmoveInit, 'GABA_pref, SG pref', GABA_prefISmoveInit, 'GABA_pref, IS pref', 200, 1);
histoplots_preferences_V1(GABA_prefSGmoveInit, GABA_rpSGmoveInit, GABA_prefISmoveInit, GABA_rpISmoveInit )

[xd, yd, delta, deltaCI] = shifthd_AT( GABA_prefSGperiReward, 'GABA_pref, SG pref', GABA_prefISperiReward, 'GABA_pref, IS pref', 200, 1);
histoplots_preferences_V1(GABA_prefSGperiReward, GABA_rpSGperiReward, GABA_prefISperiReward, GABA_rpISperiReward )


[xd, yd, delta, deltaCI] = shifthd_AT( DANn_prefSGwholeTrial, 'DANn_pref, SG pref', DANn_prefISwholeTrial, 'DANn_pref, IS pref', 200, 1);
histoplots_preferences_V1(DANn_prefSGwholeTrial, DANn_rpSGwholeTrial, DANn_prefISwholeTrial, DANn_rpISwholeTrial )

[xd, yd, delta, deltaCI] = shifthd_AT( DANn_prefSGpriors, 'DANn_pref, SG pref', DANn_prefISpriors, 'DANn_pref, IS pref', 200, 1);
histoplots_preferences_V1(DANn_prefSGpriors, DANn_rpSGpriors, DANn_prefISpriors, DANn_rpISpriors )

[xd, yd, delta, deltaCI] = shifthd_AT( DANn_prefSGmovePrep, 'DANn_pref, SG pref', DANn_prefISmovePrep, 'DANn_pref, IS pref', 200, 1);
histoplots_preferences_V1(DANn_prefSGmovePrep, DANn_rpSGmovePrep, DANn_prefISmovePrep, DANn_rpISmovePrep )

[xd, yd, delta, deltaCI] = shifthd_AT( DANn_prefSGmoveInit, 'DANn_pref, SG pref', DANn_prefISmoveInit, 'DANn_pref, IS pref', 200, 1);
histoplots_preferences_V1(DANn_prefSGmoveInit, DANn_rpSGmoveInit, DANn_prefISmoveInit, DANn_rpISmoveInit )

[xd, yd, delta, deltaCI] = shifthd_AT( DANn_prefSGperiReward, 'DANn_pref, SG pref', DANn_prefISperiReward, 'DANn_pref, IS pref', 200, 1);
histoplots_preferences_V1(DANn_prefSGperiReward, DANn_rpSGperiReward, DANn_prefISperiReward, DANn_rpISperiReward )


%% AT adding below 6/8/20, %correct pref calc for above; also does plots

[h,p,k] = binaryClassifier_ioAnalysis_V1('periReward', 'Corrects', 'Incorrects', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('periReward', 'ipsi', 'contra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('movePrep', 'ipsi', 'contra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('moveInit', 'ipsi', 'contra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('priors', 'ipsi', 'contra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('sensoryProcessing', 'ipsi', 'contra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('wholeTrial', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('priors', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('sensoryProcessing', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('movePrep', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('moveInit', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('periReward', 'SGipsi', 'ISipsi', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('wholeTrial', 'SGcontra', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('priors', 'SGcontra', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('sensoryProcessing', 'SGcontra', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('movePrep', 'SGcontra', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('moveInit', 'SGcontra', 'IScontra', masterspikestruct_V2);

[h,p,k] = binaryClassifier_ioAnalysis_V1('periReward', 'SGcontra', 'IScontra', masterspikestruct_V2);

















%do some analysises




    function [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(stats_subfx1tailedinput1,stats_subfx1tailedinput2)
        
        
        
        hx_input1 = lillietest(stats_subfx1tailedinput1);
        hx_input2 = lillietest(stats_subfx1tailedinput2);
        input2_lessthan_input1 = [];
        input2_greaterthan_input1 = [];
        if hx_input1 == 0 && hx_input2 == 0
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_greaterthan_input1 = 1;
                outcome = 'input2_greaterthan_input1';
            end
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
            end
            pvalue = p_ttest;
            paraORnonpara = 'para';
        elseif hx_input1 == 1 || hx_input2 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest1, h_ttest1] = ranksum(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input2_greaterthan_input1 = 1;
                outcome = 'input2_greaterthan_input1';
                
            end
            [p_ttest1, h_ttest1] = ranksum(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
                
            end
            pvalue = p_ttest1;
            paraORnonpara = 'nonpara';
            
        end
        if input2_greaterthan_input1 == 1
            disp('input2_greaterthan_input1')
        elseif input2_lessthan_input1 == 1
            disp('input2_lessthan_input1')
        elseif isempty(input2_greaterthan_input1) && isempty(input2_lessthan_input1)
            disp('no differences')
        end
        
    end













    function [pvalue,paraORnonpara] = stats_subfx2tailed(input1_stats_subfx2tailed,input2_stats_subfx2tailed, pairedORnotpaired)
        
        
        hx_input1 = lillietest(input1_stats_subfx2tailed);
        hx_input2 = lillietest(input2_stats_subfx2tailed);
        input2_lessthan_input1 = [];
        input2_greaterthan_input1 = [];
        if hx_input1 == 0 && hx_input2 == 0
            [h_ttest1, p_ttest1] = ttest2(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            
            paraORnonpara = 'para';
            %below is paired
            [h_ttest11, p_ttest11] = ttest(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            if strcmp(pairedORnotpaired, 'notpaired')
                pvalue = p_ttest1;
            elseif strcmp(pairedORnotpaired, 'paired')
                pvalue = p_ttest11;
            end
        elseif hx_input1 == 1 || hx_input2 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest2, h_ttest2] = ranksum(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            
            pvalue = p_ttest2;
            paraORnonpara = 'nonpara';
            %below is paired
            [p_ttest22, h_ttest22] = signrank(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            if strcmp(pairedORnotpaired, 'notpaired')
                pvalue = p_ttest2;
            elseif strcmp(pairedORnotpaired, 'paired')
                pvalue = p_ttest22;
            end
        end
        
        
    end








    function [pvalue,outcome,paraORnonpara] = stats_subfx_compToZero(stats_subfx1tailedinput1)
        
        
        outcome = 'nodiffs';
        
        hx_input1 = lillietest(stats_subfx1tailedinput1);
        %         hx_input2 = lillietest(stats_subfx1tailedinput2);
        input1_diffthan_zero = [];
        if hx_input1 == 0
            [h_ttest, p_ttest] = ttest(stats_subfx1tailedinput1) ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input1_diffthan_zero = 1;
                outcome = 'input1_diffthan_zero';
            end
            pvalue = p_ttest;
            paraORnonpara = 'para';
        elseif hx_input1 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest1, h_ttest1] = signrank(stats_subfx1tailedinput1) ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input1_diffthan_zero = 1;
                outcome = 'input1_diffthan_zero';
                
            end
            pvalue = p_ttest1;
            paraORnonpara = 'nonpara';
            
        end
        if input1_diffthan_zero == 1
            disp('input1_diffthan_zero')
        elseif isempty(input1_diffthan_zero)
            disp('no differences')
        end
        
    end





end



