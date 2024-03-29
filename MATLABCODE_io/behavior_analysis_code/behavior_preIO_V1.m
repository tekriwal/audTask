%V1 6/28/20; building off of the postio behavior code

%pre for case 

%...2, 4, 6, 7, 8, 10, 11, 13 (these are listed as
%'1'/'2'/'3'/'4'

% behavior_preIO_V1(106)
% behavior_preIO_V1(11)
% behavior_preIO_V1(12)
% behavior_preIO_V1(108)
% 


% function [h1, fig_handle] = AT_CellSummary_SG_IS_V1(behav_file, spk_file, align_ind1, window_event1, ymaxx, NUM_TRIALS_TO_PLOT, PSTH_SMOOTH_FACTOR, saveFigure)
function [] = behavior_preIO_V1(caseNumb)

%3/22/20
%below are some basic inputs we are going to want; to figure out what the
%appropriate spike# and clust# is, refer to the datafiles on box,
%specifically the 'processed_spikes_V2' folder. If there's a .jpg file,
%means that there were more than 1 cluster after spike sorting
exclusionFilter = 0; %set to 1 if we want to exclude 5050's; set to 2 if we want to exclude 5050's AND hard trials'

%below variable determines whether we sort out the 'easy', 'hard', or
%concat both types of trials
% inputSetting = 'easy';
% inputSetting = 'hard';
% inputSetting = 'concat';


if exclusionFilter == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_nofilter.mat', 'preIO_behavior')
elseif exclusionFilter == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_no5050s.mat', 'preIO_behavior')
elseif exclusionFilter == 2
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_no5050snoHardSG.mat', 'preIO_behavior')
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


%AT 3/30/20 - we want to keep the cutNearOEs to '1', always.
cutNearOEs = 1; %point of this input is to remove trials in which rxn is essentially zero; means that pt had already initiate movement before go tone could have been heard

% 4/21/20; keep cutfirst3trials to 0, however I am excluding the first
% three trials regardless - just doing so in a different manner than with
% the below input to helper fxs
cutfirst3trials = 0; %set to 1 to cut first three trials of session

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

[inputmatrix, rsp_struct] = import_behavior_preIO_auditoryTask_V1(caseInfo_table);

surgerySide = caseInfo_table.("Target (R/L STN)");


input_matrix = inputmatrix.input_matrix_rndm1;

rData = rsp_struct.rsp_master_v4;

% %4/23/20; here is where we need to decide on selecting either the 'easy',
% %'hard', or concat the preIO sessions
% if strcmp(inputSetting, 'concat')
%     
%     [rData_ON] = mergeStructs(rsp_struct1.rsp_master_v4,rsp_struct2.rsp_master_v4);
%     [rData_OFF] = mergeStructs(rsp_struct3.rsp_master_v4,rsp_struct4.rsp_master_v4);
%     
%     inputmatrix_ON = [inputmatrix1.input_matrix_rndm1; inputmatrix2.input_matrix_rndm2];
%     inputmatrix_OFF = [inputmatrix3.input_matrix_rndm3; inputmatrix4.input_matrix_rndm4];
%     
%     
% elseif strcmp(inputSetting, 'easy')
%     [rData_ON] = rsp_struct1.rsp_master_v4;
%     [rData_OFF] = rsp_struct4.rsp_master_v4;
%     
%     inputmatrix_ON = inputmatrix1.input_matrix_rndm1;
%     inputmatrix_OFF = inputmatrix4.input_matrix_rndm4;
%     
% elseif strcmp(inputSetting, 'hard')
%     [rData_ON] = rsp_struct2.rsp_master_v4;
%     [rData_OFF] = rsp_struct3.rsp_master_v4;
%     
%     inputmatrix_ON = inputmatrix2.input_matrix_rndm2;
%     inputmatrix_OFF = inputmatrix3.input_matrix_rndm3;
%     
% end

[taskbase_io, ~, index_errors, index_errorsPtHeard] = behav_file_adapter_V2(rData,input_matrix, cutfirst3trials, cutNearOEs);




% 
% %AT here we need to sort out how to deal with the ON and OFF sections
% 
% ONorOFF = 'ON';
% rData = rData_ON;
% inputmatrix = inputmatrix_ON;
% 
% 
% 
% [taskbase_io, ~, index_errors] = behav_file_adapter_V2(rData,inputmatrix, cutfirst3trials, cutNearOEs);
% 
% 

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
elseif caseNumb == 106
    caseName = 'case106';
elseif caseNumb == 108
    caseName = 'case108';
end



[choice_trials_L, choice_trials_R, nochoice_trials_L, nochoice_trials_R, choice_trials_L_corrects, choice_trials_R_corrects, nochoice_trials_L_corrects, nochoice_trials_R_corrects, errors ] = io_taskindexing_AT_V4(rData, input_matrix, exclusionFilter, index_errorsPtHeard);

choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index

%AT adding below 4/21/20, this removes the first three trials (which are
%always SG) from consideration for behavior. note that io_taskindexing_V3
%excludes the first three trials from consideration for counting errors
% choice_trials(1:3) = 0;

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

preIO_behavior.(caseName).rxnTime.SG = submitsResponse_times - goCue_times;
preIO_behavior.(caseName).mean_rxnTime.SG = mean(submitsResponse_times - goCue_times);

preIO_behavior.(caseName).rxnTime_wholetrial.SG = feedback_times - upPressed_times;
preIO_behavior.(caseName).mean_rxnTime_wholetrial.SG = mean(feedback_times - upPressed_times);

preIO_behavior.(caseName).rxnTime_leftUPtillFeedback.SG = feedback_times - leftUP_times;
preIO_behavior.(caseName).mean_rxnTime_leftUPtillFeedback.SG = mean(feedback_times - leftUP_times);


preIO_behavior.(caseName).percCorr.SG = sum(SG_responses==SG_actual)/(length(trial_inds)+errors.SGerrors);
preIO_behavior.(caseName).errors.SG = errors.SGerrors;
preIO_behavior.(caseName).errors_errorsPtHeard.SG = errors.SGerrors_errorsPtHeard;

preIO_behavior.(caseName).percerrors.SG = errors.SGerrors/(length(trial_inds)+errors.SGerrors);
preIO_behavior.(caseName).percerrors_errorsPtHeard.SG = errors.SGerrors_errorsPtHeard/(length(trial_inds)+errors.SGerrors);


% %% only plot a certain number of trials in the raster (but psth should be
% %% average of all trials)
% if length(trial_start_times) > NUM_TRIALS_TO_PLOT
%     if strcmp(raster_plotting, 'default')
%         r = randperm(length(trial_start_times));
%         trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
%     elseif strcmp(raster_plotting, 'inOrder')
%         trials_to_plot = (1:NUM_TRIALS_TO_PLOT);
%     end
% else
%     trials_to_plot = 1:length(trial_start_times);
% end
%
% % trialStart_times = trialStart_times(trials_to_plot);
% upPressed_times = upPressed_times(trials_to_plot);
% stimDelivered_times = stimDelivered_times(trials_to_plot);
% goCue_times = goCue_times(trials_to_plot);
% leftUP_times = leftUP_times(trials_to_plot);
% submitsResponse_times = submitsResponse_times(trials_to_plot);
% feedback_times = feedback_times(trials_to_plot);
%
%
% % sort trials by rxn
% if strcmp(raster_plotting, 'default')
%     [y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);
% end
%
% % trialStart_times = trialStart_times(trials_to_plot);
% upPressed_times = upPressed_times(trials_to_plot);
% stimDelivered_times = stimDelivered_times(trials_to_plot);
% goCue_times = goCue_times(trials_to_plot);
% leftUP_times = leftUP_times(trials_to_plot);
% submitsResponse_times = submitsResponse_times(trials_to_plot);
% feedback_times = feedback_times(trials_to_plot);

%%
%%
%%
%%

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

preIO_behavior.(caseName).rxnTime.IS = submitsResponse_times - goCue_times;
preIO_behavior.(caseName).mean_rxnTime.IS = mean(submitsResponse_times - goCue_times);

preIO_behavior.(caseName).rxnTime_wholetrial.IS = feedback_times - upPressed_times;
preIO_behavior.(caseName).mean_rxnTime_wholetrial.IS = mean(feedback_times - upPressed_times);

preIO_behavior.(caseName).rxnTime_leftUPtillFeedback.IS = feedback_times - leftUP_times;
preIO_behavior.(caseName).mean_rxnTime_leftUPtillFeedback.IS = mean(feedback_times - leftUP_times);

preIO_behavior.(caseName).percCorr.IS = sum(IS_responses==IS_actual)/(length(trial_inds)+errors.ISerrors);
preIO_behavior.(caseName).errors.IS = errors.ISerrors;
preIO_behavior.(caseName).errors_errorsPtHeard.IS = errors.ISerrors_errorsPtHeard;

preIO_behavior.(caseName).percerrors.IS = errors.ISerrors/(length(trial_inds)+errors.ISerrors);
preIO_behavior.(caseName).percerrors_errorsPtHeard.IS = errors.ISerrors_errorsPtHeard/(length(trial_inds)+errors.ISerrors);





if exclusionFilter == 0
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_nofilter.mat', 'preIO_behavior')
elseif exclusionFilter == 1
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_no5050s.mat', 'preIO_behavior')
elseif exclusionFilter == 2
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_preIO/behavior_struct_preIO_no5050snoHardSG.mat', 'preIO_behavior')
end



return