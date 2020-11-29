%% AT logistic regression V1

%need to create 3 column matrix for each trial that identifies whether ipsi
%or contra, SG or IS, and corr or incorr
function [] = ATlogistic_regression_V1()

% %AT adding below 11/17/20
% %to save out the breakpoints, use below code:
% b = dbstatus('-completenames');
% save buggybrkpnts b;  
% %to load in, use below:
load buggybrkpnts b
dbstop(b)

cutfirstthree = 1;


logisticIndexes = struct();
diffvectorstruct = struct();

% if nargin == 0
%
%     caseNumb = 1;
% end

digits(6) %sets vars so they contain 6 digits at most
p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);
% p = genpath('/Users/andytek/Desktop/git/audTask/IO/AT_lfp_code');
% addpath(p);

%% load in ephys data (masterspikestruct)
%below are all from tSNE code
% below input is important if not trying to run new clustering inputs
% newYinput = 0; %set to 1 to calculate new tsne input, or 0 if loading old


figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis');
filename2 = ('/masterspikestruct_V2');
load(fullfile(figuresdir, filename2), 'masterspikestruct_V2');

%%
for i = 1:length(masterspikestruct_V2.clustfileIndex)
    
    structLabel = masterspikestruct_V2.clustfileIndex{i};
    caseNumb =  str2double( structLabel(5:6) );
    spikeFile =  structLabel(8:13);
    clustname =  structLabel(15:20);
    
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
    
    
    [caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);
    
    
    [inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);
    
    surgerySide = caseInfo_table.("Target (R/L STN)");
    
    
    
    %% load in behavior data (taskbase_io)
    
    
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis', caseName);
    filename2 = strcat('taskbase_io_', caseName, spikeFile,'_', clustname,'_');
    
    load(fullfile(figuresdir, filename2), 'taskbase_io');
    
    %first, find SG trials w/ L responses
    SG_L_index = (taskbase_io.SGorIS == 26) & (taskbase_io.response == 1); %12 stands for IS here, so we're pulling out SG trials
    taskbase_SG_L.SGorIS = taskbase_io.SGorIS(SG_L_index);
    taskbase_SG_L.response = taskbase_io.response(SG_L_index);
    taskbase_SG_L.actual = taskbase_io.actual(SG_L_index);
    %below is what we'll actually concatonate
    taskbase_SG_L.corr = (taskbase_SG_L.response == taskbase_SG_L.actual);
    if strcmp('R', surgerySide)
        taskbase_SG_L.ipsi = logical(zeros(size(taskbase_SG_L.corr)));
    elseif ~strcmp('R', surgerySide)
        taskbase_SG_L.ipsi = logical(ones(size(taskbase_SG_L.corr)));
    end
    taskbase_SG_L.SG = logical(ones(size(taskbase_SG_L.corr)));
    
    
    
    
    %then, find SG trials w/ R responses
    SG_R_index = (taskbase_io.SGorIS == 26) & (taskbase_io.response == 2); %12 stands for IS here, so we're pulling out SG trials
    taskbase_SG_R.SGorIS = taskbase_io.SGorIS(SG_R_index);
    taskbase_SG_R.response = taskbase_io.response(SG_R_index);
    taskbase_SG_R.actual = taskbase_io.actual(SG_R_index);
    %below is what we'll actually concatonate
    taskbase_SG_R.corr = (taskbase_SG_R.response == taskbase_SG_R.actual);
    if strcmp('R', surgerySide)
        taskbase_SG_R.ipsi = logical(ones(size(taskbase_SG_R.corr)));
    elseif ~strcmp('R', surgerySide)
        taskbase_SG_R.ipsi = logical(zeros(size(taskbase_SG_R.corr)));
    end
    taskbase_SG_R.SG = logical(ones(size(taskbase_SG_R.corr)));
    
    
    
    
    %then, find IS trials w/ L responses
    IS_L_index = (taskbase_io.SGorIS == 12) & (taskbase_io.response == 1); %12 stands for IS here, so we're pulling out SG trials
    taskbase_IS_L.SGorIS = taskbase_io.SGorIS(IS_L_index);
    taskbase_IS_L.response = taskbase_io.response(IS_L_index);
    taskbase_IS_L.actual = taskbase_io.actual(IS_L_index);
    %below is what we'll actually concatonate
    taskbase_IS_L.corr = (taskbase_IS_L.response == taskbase_IS_L.actual);
    if strcmp('R', surgerySide)
        taskbase_IS_L.ipsi = logical(zeros(size(taskbase_IS_L.corr)));
    elseif ~strcmp('R', surgerySide)
        taskbase_IS_L.ipsi = logical(ones(size(taskbase_IS_L.corr)));
    end
    taskbase_IS_L.SG = logical(zeros(size(taskbase_IS_L.corr)));
    
    
    
    
    %then, find IS trials w/ R responses
    IS_R_index = (taskbase_io.SGorIS == 12) & (taskbase_io.response == 2); %12 stands for IS here, so we're pulling out SG trials
    taskbase_IS_R.SGorIS = taskbase_io.SGorIS(IS_R_index);
    taskbase_IS_R.response = taskbase_io.response(IS_R_index);
    taskbase_IS_R.actual = taskbase_io.actual(IS_R_index);
    %below is what we'll actually concatonate
    taskbase_IS_R.corr = (taskbase_IS_R.response == taskbase_IS_R.actual);
    if strcmp('R', surgerySide)
        taskbase_IS_R.ipsi = logical(ones(size(taskbase_IS_R.corr)));
    elseif ~strcmp('R', surgerySide)
        taskbase_IS_R.ipsi = logical(zeros(size(taskbase_IS_R.corr)));
    end
    taskbase_IS_R.SG = logical(zeros(size(taskbase_IS_R.corr)));
    
    
    
    corr_index = [taskbase_SG_L.corr; taskbase_SG_R.corr; taskbase_IS_L.corr; taskbase_IS_R.corr];
    ipsi_index = [taskbase_SG_L.ipsi; taskbase_SG_R.ipsi; taskbase_IS_L.ipsi; taskbase_IS_R.ipsi];
    SG_index = [taskbase_SG_L.SG; taskbase_SG_R.SG; taskbase_IS_L.SG; taskbase_IS_R.SG];
    
    filename33 = strcat(caseName, '_', spikeFile, '_', clustname);
    
    logisticIndexes.(filename33) = [SG_index, ipsi_index, corr_index];
    %below is the if we want to cut first three trials
    %     if cutfirstthree == 1
    %         logisticIndexes.(caseName)(1:3,:) = [];
    %     end
end

%% AT adding in a small snip of code to patch over a bug in the masterspike, once convinced its w/out cause, i will save over file info
% will prob need to adjust the below to include taskbase_io somehow
epoch_index = {'wholeTrial','priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};
subName2_index = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};

% i = 25;
% structLabel = masterspikestruct_V2.clustfileIndex{i};
%
%
% for k = 1:length(epoch_index)
%
%     epoch_index2 = epoch_index{k};
%     baseline = 'wholeTrial';
%
%     for kk = 1:length(subName2_index)
%         epoch2 = subName2_index{kk};
%
%         if strcmp(epoch2, 'SGandIS')
%
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(24) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
%         end
%         if strcmp(epoch2, 'SG')
%
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(24) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
%         end
%         if strcmp(epoch2, 'ipsi')
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(10) = [];
%         end
%         if strcmp(epoch2, 'contra')
%
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
%         end
%         if strcmp(epoch2, 'Incorrects')
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
%         end
%         if strcmp(epoch2, 'Corrects')
%
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(30) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(29) = [];
%         end
%         if strcmp(epoch2, 'SGcontra')
%
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(14) = [];
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(13) = [];
%         end
%         if strcmp(epoch2, 'SGipsi')
%             masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)(10) = [];
%         end
%     end
%
% end



%%


%%
% AT 7/19/20

%we want to take a intra-trial measure of FR change.

epoch_index = {'priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};
% subName2_index  = {'SGandIS';'SG';'IS';'L';'R'; 'Corrects'; 'Incorrects'; 'ipsi'; 'contra'; 'SGipsi'; 'SGcontra'; 'ISipsi'; 'IScontra'};
subName2_index = {'SGandIS'};

for i = 1:length(masterspikestruct_V2.clustfileIndex_wOut_case8or9)
    
    structLabel = masterspikestruct_V2.clustfileIndex_wOut_case8or9{i};
    % subName = 'FR'; %either 'FR' or 'spiketrain'
    %below gives summary data combining across SG/IS and L/R (aka 'all')
    
    for k = 1:length(epoch_index)
        
        epoch_index2 = epoch_index{k};
        baseline = 'wholeTrial';
        
        for kk = 1:length(subName2_index)
            epoch2 = subName2_index{kk};

            diffvector = (cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(epoch_index2).(epoch2)) - cell2mat(masterspikestruct_V2.FRstruct.(structLabel).(baseline).(epoch2)));
            
            filename2 = strcat('taskbase_io_', caseName, spikeFile,'_', clustname,'_');
            
            diffvectorstruct.(structLabel).(epoch_index2).(epoch2) = [diffvector', logisticIndexes.(structLabel)];
            
            
        end
    end
end


%%below is information from 'NeuralRegression_CNC', JT said that the
%%'model_notation is the most relevant part, just use x1 + x2 + x3
%% Run the linears models to predict firing rate in each epoch



epoch_index = {'priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};

for i = 1:length(masterspikestruct_V2.clustfileIndex_wOut_case8or9)
    
    structLabel = masterspikestruct_V2.clustfileIndex_wOut_case8or9{i};
 
    for k = 1:length(epoch_index)
        epoch_index2 = epoch_index{k};
        
        
        model_notation = 'y ~ x1 + x2 + x3'; % This is "Wilkinson notation"; see fitlm help menu

        predictor_mat = diffvectorstruct.(structLabel).(epoch_index2).SGandIS(:,2:4);
        firing_rate = diffvectorstruct.(structLabel).(epoch_index2).SGandIS(:,1);
        
        mdl{i, k} = fitlm(predictor_mat, firing_rate, model_notation);

    end
end


for ii = 1:length(masterspikestruct_V2.clustfileIndex_wOut_case8or9)
    for kk = 1:5
        pvaluemat(ii, kk) = num2cell(table2array(mdl{ii, kk}.Coefficients(:,4)),[1 2]);
        
%             if table2array(mdl{ii, kk}.Coefficients(1,4)) < 0.05
%                 strcat1 = 'intercept ';
%             else
%                 strcat1 = '';
%             end
%             

strcat1 = '';
           if table2array(mdl{ii, kk}.Coefficients(2,4)) < 0.05
                strcat2 = 'SGorIS ';
            else
                strcat2 = '';
            end
        
           if table2array(mdl{ii, kk}.Coefficients(3,4)) < 0.05
                strcat3 = 'ipsiorcont ';
            else
                strcat3 = '';
            end
        
            if table2array(mdl{ii, kk}.Coefficients(4,4)) < 0.05
                strcat4 = 'corrorinc ';
            else
                strcat4 = '';
            end
        
            pvaluemat_labeled{ii, kk} = strcat(strcat1, '_',strcat2,'_', strcat3,'_', strcat4);
                            
        
    end
end


%% AT 8/12/20
%adding below to check the whole -1 to 1 regression thing as a way to check
%the above pvaluemat_labeled. Change is going to be based on 'predictor_mat'
%% AT 8/18/20
% the below output is identical to the above, compare pvaluemat_labeled to
% pvaluemat_labeled2




epoch_index = {'priors', 'sensoryProcessing', 'movePrep', 'moveInit', 'periReward'};

for i = 1:length(masterspikestruct_V2.clustfileIndex_wOut_case8or9)
    
    structLabel = masterspikestruct_V2.clustfileIndex_wOut_case8or9{i};
 
    for k = 1:length(epoch_index)
        epoch_index2 = epoch_index{k};
        
        
        model_notation = 'y ~ x1 + x2 + x3'; % This is "Wilkinson notation"; see fitlm help menu

        predictor_mat = diffvectorstruct.(structLabel).(epoch_index2).SGandIS(:,2:4);
        [a,b] = size(predictor_mat);
        predictor_mat2 = zeros(size(predictor_mat));
        for aa = 1:a
            for bb = 1:b
                if predictor_mat(aa,bb) == 0
                    predictor_mat2(aa,bb) = -1;
                end
            end
        end
               
%         predictor_mat(predictor_mat==0) = -1;
        firing_rate = diffvectorstruct.(structLabel).(epoch_index2).SGandIS(:,1);
        
        mdl{i, k} = fitlm(predictor_mat2, firing_rate, model_notation);

    end
end


for ii = 1:length(masterspikestruct_V2.clustfileIndex_wOut_case8or9)
    for kk = 1:5
        pvaluemat(ii, kk) = num2cell(table2array(mdl{ii, kk}.Coefficients(:,4)),[1 2]);
        
%             if table2array(mdl{ii, kk}.Coefficients(1,4)) < 0.05
%                 strcat1 = 'intercept ';
%             else
%                 strcat1 = '';
%             end
%             

strcat1 = '';
           if table2array(mdl{ii, kk}.Coefficients(2,4)) < 0.05
                strcat2 = 'SGorIS ';
            else
                strcat2 = '';
            end
        
           if table2array(mdl{ii, kk}.Coefficients(3,4)) < 0.05
                strcat3 = 'ipsiorcont ';
            else
                strcat3 = '';
            end
        
            if table2array(mdl{ii, kk}.Coefficients(4,4)) < 0.05
                strcat4 = 'corrorinc ';
            else
                strcat4 = '';
            end
        
            pvaluemat_labeled2{ii, kk} = strcat(strcat1, '_',strcat2,'_', strcat3,'_', strcat4);
                            
        
    end
end






% %% below is from reference code 7/27/20
% reference = 0;
% if reference == 1
% % "accuracy" model: x1 = current choice; x2 = previous choice; x3 = reaction time;
% % x4 = trial type;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_current choice_previous reaction_time trial_type Accuracy_vector];
% 
% model_notation = 'y ~ x1 + x2 + x3 + x4 + x5 + x4*x5'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%     
%     mdl.accuracy{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);
%     
% end
% 
% clear predictor_mat model_notation;
% 
% % "full" model: x1 = current choice; x2 = previous choice; x3 = reaction time;
% % x4 = trial type;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_current choice_previous reaction_time trial_type];
% 
% model_notation = 'y ~ x1 + x2 + x3 + x4'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%     
%     mdl.full{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);
%     
% end
% 
% clear predictor_mat model_notation;
% 
% end



end
