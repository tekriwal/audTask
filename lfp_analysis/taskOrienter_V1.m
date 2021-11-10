%READ ME, init 11/9/21, author: AT
%Goal of code is to orient others to the structure that data was organized
%in for spike processing

%Below is primary copy and pasted from .mat analysis script
%"tsne_SNsubtypes_V7" but I've done my best to cut the fat from that 




%need to add the below to path, will drop file into slack for convenience.
figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
filename2 = ('/masterspikestruct_V2');
load(fullfile(figuresdir, filename2), 'masterspikestruct_V2');



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
