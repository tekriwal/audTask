%10/5/20 AT taking some of the organizing code from 



function [] = sevenparameter_waveform_classifier_V1()
%% below input is important if not trying to run new clustering inputs
% newYinput = 0; %set to 1 to calculate new tsne input, or 0 if loading old
filename2Yinput = ('/fantastic_tsne_May30_V1'); %'/fantastic_tsne6' is a good one too
filenameRamayyaComparisoninput = ('/Yinput_tsneramayya_replication_option3');
loadY = 1; %set to 1 if we want to use old 'Y', redundant with newYinput?
stopAtPubFigures = 1; %if set at 1, then throws an error when we get to figures that are to be included in pub
violinsON = 0; %set to 1 if we want to see the violin plots; AT 7/19/20

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
saveFig = 1;
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


cutIndex = [32, 29, 28, 27, 20]; %AT 9/11/20, so 32 is case 11 lead 2, 29 is case 9 lead 2, 28 is lead 1, and 27 is case 8 lead 1

for i = 1:length(cutIndex)
    k = cutIndex(i);
    
    input1_1(k) = [];
    
    input2_1(k) = [];
    
    input3_1(k) = [];
    
    input4_1(k) = [];
    
    input5_1(k) = [];
    
    input6_1(k) = [];
    
    input7_1(k) = [];
    
    input8_1(k) = [];
    
    input9_1(k) = [];
    
    input10_1(k) = [];
    
    input11_1(k) = [];
    
    input12_1(k) = [];
    
    input13_1(k) = [];
    
    input14_1(k) = [];

    masterspikestruct_V2.DA_or_GABA_TSNE(k) = [];

end





for k = 1:length(masterspikestruct_V2.DA_or_GABA_TSNE) 
    if strcmp(masterspikestruct_V2.DA_or_GABA_TSNE(k), 'GABA')
        masterspikestruct_V2.DA_or_GABA_TSNE(k) = {'ClusterA'};
    elseif strcmp(masterspikestruct_V2.DA_or_GABA_TSNE(k), 'DANn')
        masterspikestruct_V2.DA_or_GABA_TSNE(k) = {'ClusterB'};
    end
end



Variables_matrix = [input1_1; input3_1; input5_1; input7_1; input9_1; input11_1; input13_1];
Labels_vector = (masterspikestruct_V2.DA_or_GABA_TSNE);

Labels_table = cell2table(masterspikestruct_V2.DA_or_GABA_TSNE, 'VariableNames', {'Labels'});
Variables_table = table(input1_1', input3_1', input5_1', input7_1', input9_1', input11_1', input13_1','VariableNames',{'energy', 'peak to peak', 'first derivative min', 'second deriv min', 'second deriv max', 'positive peak', 'negative peak'});
All_table = [Labels_table Variables_table]; 

A = 1:33;
for i = 1:3
    trueTest(i) = randi(length(A));
end

% %10/7/20, so for the below, we have some manual work to do to sculpt the
% %All_table info into something more manageable.
% 
% Test_table = [All_table(19,:); All_table(10,:); All_table(4,:)];
% Training_table = All_table;
% Training_table(19,:) = [];
% Training_table(10,:) = [];
% Training_table(4,:) = [];
% 
% %AT 10/7/20
% writetable(Training_table,'Training_table.csv')
% writetable(Test_table,'Test_table.csv')
% writetable(All_table,'All_table.csv')

    
    
    
%AT so we can just go into the classification learner GUI and mess around,
%or do things like the below which are code based. The 

rng('default') % For reproducibility



% tendivisions_csv = cvpartition(Labels_vector,'kFold',10);
% 
% twodivisions_csv = cvpartition(Labels_vector,'kFold',2);
% 
% 










end


% 
% wavedata = 'waveNormFeat';
% 
% input1_2 = groupvar.(wavedata).EnergyMedian;
% 
% input2_2 = groupvar.(wavedata).EnergyVar;
% 
% input3_2 = groupvar.(wavedata).PtoPwidthMSMedian;
% 
% input4_2 = groupvar.(wavedata).PtoPwidthMSVar;
% 
% input5_2 = groupvar.(wavedata).FDminMedian;
% 
% input6_2 = groupvar.(wavedata).FDminVar;
% 
% input7_2 = groupvar.(wavedata).SDminMedian;
% 
% input8_2 = groupvar.(wavedata).SDminVar;
% 
% input9_2 = groupvar.(wavedata).SDmaxMedian;
% 
% input10_2 = groupvar.(wavedata).SDmaxVar;
% 
% input11_2 = groupvar.(wavedata).PosPeakMedian;
% 
% input12_2 = groupvar.(wavedata).PosPeakVar;
% 
% input13_2 = groupvar.(wavedata).NegPeakMedian;
% 
% input14_2 = groupvar.(wavedata).NegPeakVar







