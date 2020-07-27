%V1 4/23/20

%post for case 2, 4, 6, 7, 8, 10, 11, 13 (these are listed as
%'1'/'2'/'3'/'4'

% behavior_postIO_V1(2)
% behavior_postIO_V1(4)
% behavior_postIO_V1(6)
% behavior_postIO_V1(7)
% behavior_postIO_V1(8)
% behavior_postIO_V1(10)
% behavior_postIO_V1(11)
% behavior_postIO_V1(13)


% function [h1, fig_handle] = AT_CellSummary_SG_IS_V1(behav_file, spk_file, align_ind1, window_event1, ymaxx, NUM_TRIALS_TO_PLOT, PSTH_SMOOTH_FACTOR, saveFigure)
function [] = behavior_postIO_V1(caseNumb)

%3/22/20
%below are some basic inputs we are going to want; to figure out what the
%appropriate spike# and clust# is, refer to the datafiles on box,
%specifically the 'processed_spikes_V2' folder. If there's a .jpg file,
%means that there were more than 1 cluster after spike sorting
exclusionFilter = 0; %set to 1 if we want to exclude 5050's; set to 2 if we want to exclude 5050's AND hard trials'
%AT 3/30/20 - we want to keep the cutNearOEs to '1', always.
cutNearOEs = 0; %point of this input is to remove trials in which rxn is essentially zero; means that pt had already initiate movement before go tone could have been heard

% 4/21/20; keep cutfirst3trials to 0, however I am excluding the first
% three trials regardless - just doing so in a different manner than with
% the below input to helper fxs
cutfirst3trials = 0; %set to 1 to cut first three trials of session

%below variable determines whether we sort out the 'easy', 'hard', or
%concat both types of trials
% inputSetting = 'easy';
% inputSetting = 'hard';
inputSetting = 'concat';


if exclusionFilter == 0 && strcmp('concat', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_concat.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('concat', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_concat.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('concat', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_concat.mat', 'postIO_behavior')

elseif exclusionFilter == 0 && strcmp('easy', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_easy.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('easy', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_easy.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('easy', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_easy.mat', 'postIO_behavior')

elseif exclusionFilter == 0 && strcmp('hard', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_hard.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('hard', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_hard.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('hard', inputSetting)
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_hard.mat', 'postIO_behavior')
end





if nargin == 0
%post for case 2, 4, 6, 7, 8, 10, 11, 13 (these are listed as
%'1'/'2'/'3'/'4'
    caseNumb = 2;
    
end


% if caseNumb == 13
%     locat = 'SouthWest';
% else
%     locat = 'NorthWest';
% end



%for most of behavior plots, we're going to want to exclude case 8 and 9
%since we focus on spaghetti plots
if caseNumb == 8 || caseNumb == 9
    SGonly = 1;
else
    SGonly = 0;
end



digits(6) %sets vars so they contain 6 digits at most
p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);



[caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);

[inputmatrix1, rsp_struct1, inputmatrix2, rsp_struct2, inputmatrix3, rsp_struct3, inputmatrix4, rsp_struct4] = import_behavior_postIO_auditoryTask_V1(caseInfo_table);

surgerySide = caseInfo_table.("Target (R/L STN)");





%4/23/20; here is where we need to decide on selecting either the 'easy',
%'hard', or concat the postio sessions
if strcmp(inputSetting, 'concat')
    
    [rData_ON] = mergeStructs(rsp_struct1.rsp_master_v4,rsp_struct2.rsp_master_v4);
    [rData_OFF] = mergeStructs(rsp_struct3.rsp_master_v4,rsp_struct4.rsp_master_v4);
    
    inputmatrix_ON = [inputmatrix1.input_matrix_rndm1; inputmatrix2.input_matrix_rndm2];
    inputmatrix_OFF = [inputmatrix3.input_matrix_rndm3; inputmatrix4.input_matrix_rndm4];
    
    
elseif strcmp(inputSetting, 'easy')
    [rData_ON] = rsp_struct1.rsp_master_v4;
    [rData_OFF] = rsp_struct4.rsp_master_v4;
    
    inputmatrix_ON = inputmatrix1.input_matrix_rndm1;
    inputmatrix_OFF = inputmatrix4.input_matrix_rndm4;
    
elseif strcmp(inputSetting, 'hard')
    [rData_ON] = rsp_struct2.rsp_master_v4;
    [rData_OFF] = rsp_struct3.rsp_master_v4;
    
    inputmatrix_ON = inputmatrix2.input_matrix_rndm2;
    inputmatrix_OFF = inputmatrix3.input_matrix_rndm3;
    
end






%AT here we need to sort out how to deal with the ON and OFF sections

ONorOFF = 'ON';
rData = rData_ON;
inputmatrix = inputmatrix_ON;



[taskbase_io, ~, index_errors] = behav_file_adapter_V2(rData,inputmatrix, cutfirst3trials, cutNearOEs);



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



[choice_trials_L, choice_trials_R, nochoice_trials_L, nochoice_trials_R, choice_trials_L_corrects, choice_trials_R_corrects, nochoice_trials_L_corrects, nochoice_trials_R_corrects, errors ] = io_taskindexing_AT_V3(rData, inputmatrix, exclusionFilter);

choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index

%AT adding below 4/21/20, this removes the first three trials (which are
%always SG) from consideration for behavior. note that io_taskindexing_V3
%excludes the first three trials from consideration for counting errors
if cutfirst3trials == 1
    choice_trials(1:3) = 0;
end

nochoice_trials = nochoice_trials_L + nochoice_trials_R; %AT making combined SG index

%2/17/19 the point of below is to let us easily plot the just SG trials
if SGonly == 1
    nochoice_trials = choice_trials;
end



%% Look at SG trials %%%
trial_inds = find(choice_trials == 1);
% trial_inds = find((taskbase_io.response == 1) & (choice_trials == 1));

trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


% trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';


SG_responses =  taskbase_io.response(trial_inds)';
SG_actual =  taskbase_io.actual(trial_inds)';

postIO_behavior.(caseName).(ONorOFF).rxnTime.SG = submitsResponse_times - goCue_times;
postIO_behavior.(caseName).(ONorOFF).median_rxnTime.SG = median(submitsResponse_times - goCue_times);

postIO_behavior.(caseName).(ONorOFF).percCorr.SG = sum(SG_responses==SG_actual)/(length(trial_inds)+errors.SGerrors);
postIO_behavior.(caseName).(ONorOFF).errors.SG = errors.SGerrors;

%% Look at IS

trial_inds = find(nochoice_trials == 1);
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


% trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';

IS_responses =  taskbase_io.response(trial_inds)';
IS_actual =  taskbase_io.actual(trial_inds)';

postIO_behavior.(caseName).(ONorOFF).rxnTime.IS = submitsResponse_times - goCue_times;
postIO_behavior.(caseName).(ONorOFF).median_rxnTime.IS = median(submitsResponse_times - goCue_times);

postIO_behavior.(caseName).(ONorOFF).percCorr.IS = sum(IS_responses==IS_actual)/(length(trial_inds)+errors.ISerrors);
postIO_behavior.(caseName).(ONorOFF).errors.IS = errors.ISerrors;


















ONorOFF = 'OFF';
rData = rData_OFF;
inputmatrix = inputmatrix_OFF;



[taskbase_io, ~, index_errors] = behav_file_adapter_V2(rData,inputmatrix, cutfirst3trials, cutNearOEs);



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



[choice_trials_L, choice_trials_R, nochoice_trials_L, nochoice_trials_R, choice_trials_L_corrects, choice_trials_R_corrects, nochoice_trials_L_corrects, nochoice_trials_R_corrects, errors ] = io_taskindexing_AT_V3(rData, inputmatrix, exclusionFilter);

choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index

%AT adding below 4/21/20, this removes the first three trials (which are
%always SG) from consideration for behavior. note that io_taskindexing_V3
%excludes the first three trials from consideration for counting errors
if cutfirst3trials == 1
    choice_trials(1:3) = 0;
end

nochoice_trials = nochoice_trials_L + nochoice_trials_R; %AT making combined SG index

%2/17/19 the point of below is to let us easily plot the just SG trials
if SGonly == 1
    nochoice_trials = choice_trials;
end



%% Look at SG trials %%%
trial_inds = find(choice_trials == 1);
% trial_inds = find((taskbase_io.response == 1) & (choice_trials == 1));

trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


% trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';


SG_responses =  taskbase_io.response(trial_inds)';
SG_actual =  taskbase_io.actual(trial_inds)';

postIO_behavior.(caseName).(ONorOFF).rxnTime.SG = submitsResponse_times - goCue_times;
postIO_behavior.(caseName).(ONorOFF).median_rxnTime.SG = median(submitsResponse_times - goCue_times);

postIO_behavior.(caseName).(ONorOFF).percCorr.SG = sum(SG_responses==SG_actual)/(length(trial_inds)+errors.SGerrors);
postIO_behavior.(caseName).(ONorOFF).errors.SG = errors.SGerrors;

%% Look at IS

trial_inds = find(nochoice_trials == 1);
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


% trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';

IS_responses =  taskbase_io.response(trial_inds)';
IS_actual =  taskbase_io.actual(trial_inds)';

postIO_behavior.(caseName).(ONorOFF).rxnTime.IS = submitsResponse_times - goCue_times;
postIO_behavior.(caseName).(ONorOFF).median_rxnTime.IS = median(submitsResponse_times - goCue_times);

postIO_behavior.(caseName).(ONorOFF).percCorr.IS = sum(IS_responses==IS_actual)/(length(trial_inds)+errors.ISerrors);
postIO_behavior.(caseName).(ONorOFF).errors.IS = errors.ISerrors;










if exclusionFilter == 0 && strcmp('concat', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_concat.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('concat', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_concat.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('concat', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_concat.mat', 'postIO_behavior')

elseif exclusionFilter == 0 && strcmp('easy', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_easy.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('easy', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_easy.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('easy', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_easy.mat', 'postIO_behavior')

elseif exclusionFilter == 0 && strcmp('hard', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter_hard.mat', 'postIO_behavior')
elseif exclusionFilter == 1 && strcmp('hard', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s_hard.mat', 'postIO_behavior')
elseif exclusionFilter == 2 && strcmp('hard', inputSetting)
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG_hard.mat', 'postIO_behavior')
end




return