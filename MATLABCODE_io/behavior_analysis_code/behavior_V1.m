%V1 creating behavior analysis code based off of cellsumm_v4




% function [h1, fig_handle] = AT_CellSummary_SG_IS_V1(behav_file, spk_file, align_ind1, window_event1, ymaxx, NUM_TRIALS_TO_PLOT, PSTH_SMOOTH_FACTOR, saveFigure)
function [] = behavior_V1(caseNumb)

%3/22/20
%below are some basic inputs we are going to want; to figure out what the
%appropriate spike# and clust# is, refer to the datafiles on box,
%specifically the 'processed_spikes_V2' folder. If there's a .jpg file,
%means that there were more than 1 cluster after spike sorting
exclusionFilter = 2; %set to 1 if we want to exclude 5050's; set to 2 if we want to exclude 5050's AND hard trials

if exclusionFilter == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_nofilter.mat', 'behavior')
elseif exclusionFilter == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050s.mat', 'behavior')
elseif exclusionFilter == 2
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050snoHardSG.mat', 'behavior')
end

if nargin == 0
    caseNumb = 7;
    
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

[inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);

surgerySide = caseInfo_table.("Target (R/L STN)");


% % [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table, 'processed_spikes_BClust');
% [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V2(caseInfo_table, 'processed_spikes_V2');


%AT 1/8/20; adding below so we can do some analyses on the imported data
%now

% fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
% fromwhere_relativetoendofwaitperiod = 0; %have 0 here will identify the
% first TTL after the delay epoch is completed

if caseNumb == 3 || caseNumb == 2 || caseNumb == 1
    rData = rsp_struct.rsp_master_v1;%unpacking, AT
elseif caseNumb == 4
    rData = rsp_struct.rsp_master_v2;%unpacking, AT
else
    rData = rsp_struct.rsp_master_v3;%unpacking, AT
end

inputmatrix = inputmatrix.input_matrix_rndm;%unpacking, AT

lasttrialwewant = length(rData);
trialsperblock = 9;


%AT 2/15/20, needed to do some processing on the behavior file rData in
%order have the timings reflect time from beginning of each individual
%trial. This is really important! To account for different versions of our
%task, we should use different versions of the below fx!
if caseNumb == 4
    rData = Case04_behavior_adapter(rData);
end

if caseNumb == 3 || caseNumb == 2 || caseNumb == 1
    rData = Case03_behavior_adapter(rData);
end

[taskbase_io, ~, index_errors] = behav_file_adapter_V2(rData,inputmatrix, cutfirst3trials, cutNearOEs);




%
% GetPhysioGlobals_io_V1;
%
% global TRIAL_EVENTS; % Numbers in saved raster_info corresponding to the trial events
% global RESOLUTION;


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


CHOICE_STYLE = '-';
NOCHOICE_STYLE = '-';

% trialStart = [1 1 0];%   yellow
% endDelayEpoch = [.95    0.45    .1];%   orangey
% gotone_col = [0 0.8 0.3]; %
% odorportout_col = [0 0 1];%   Navy Blue
% waterportin_col = [1 1 1];%  white
% watervalveon_col = [0 0 1];

upPressed_color = [1 1 0];%   yellow
stimDelivered_color = [.95    0.45    .1];%   orangey
goCue_color = [0 0.8 0.3]; % mint green
leftUP_color = [1 0.5 1];%   hot pink
submitsResponse_color = [0 0.75 0.75];%  Turquoise
feedback_color = [.3 0.7 1];%  light blue
% %     [; upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);


% L_COLOR = 0.5 * ones(1, 3);
% R_COLOR = zeros(1, 3);
ipsi_COLOR = [.2 .9 .9]; %cyanish
contra_COLOR = [1 0 .5]; %magenta


STE_COLOR = 0.75 * ones(1, 3);


[choice_trials_L, choice_trials_R, nochoice_trials_L, nochoice_trials_R, choice_trials_L_corrects, choice_trials_R_corrects, nochoice_trials_L_corrects, nochoice_trials_R_corrects, errors ] = io_taskindexing_AT_V3(rData, inputmatrix, exclusionFilter);



choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index

%AT adding below 4/21/20, this removes the first three trials (which are
%always SG) from consideration for behavior. note that io_taskindexing_V3
%excludes the first three trials from consideration for counting errors
choice_trials(1:3) = 0;

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

behavior.(caseName).rxnTime.SG = submitsResponse_times - goCue_times;
behavior.(caseName).median_rxnTime.SG = median(submitsResponse_times - goCue_times);

behavior.(caseName).percCorr.SG = sum(SG_responses==SG_actual)/(length(trial_inds)+errors.SGerrors);
behavior.(caseName).errors.SG = errors.SGerrors;


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

behavior.(caseName).rxnTime.IS = submitsResponse_times - goCue_times;
behavior.(caseName).median_rxnTime.IS = median(submitsResponse_times - goCue_times);

behavior.(caseName).percCorr.IS = sum(IS_responses==IS_actual)/(length(trial_inds)+errors.ISerrors);
behavior.(caseName).errors.IS = errors.ISerrors;


if exclusionFilter == 0
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_nofilter.mat', 'behavior')
elseif exclusionFilter == 1
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050s.mat', 'behavior')
elseif exclusionFilter == 2
    save('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050snoHardSG.mat', 'behavior')
end

% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

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
%%
%%


% %% Look at R, choice (active decision making) trials %%%
% % aka L choices made during SG
% trial_inds = find((taskbase_io.response == 2) & (choice_trials == 1));
% trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% % trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
%
%
% % trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
% upPressed_times = taskbase_io.events.upPressed(trial_inds)';
% stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
% goCue_times = taskbase_io.events.goCue(trial_inds)';
% leftUP_times = taskbase_io.events.leftUP(trial_inds)';
% submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
% feedback_times = taskbase_io.events.feedback(trial_inds)';
%
%
%
% % % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % % gt_times = taskbase.cue(trial_inds)';
% % % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % % wvo_times = taskbase.WaterDeliv(trial_inds)';
%
% % %% only plot a certain number of trials in the raster (but psth should be
% % %% average of all trials)
% % if length(trial_start_times) > NUM_TRIALS_TO_PLOT
% %     if strcmp(raster_plotting, 'default')
% %         r = randperm(length(trial_start_times));
% %         trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
% %     elseif strcmp(raster_plotting, 'inOrder')
% %         trials_to_plot = (1:NUM_TRIALS_TO_PLOT);
% %     end
% % else
% %     trials_to_plot = 1:length(trial_start_times);
% % end
% %
% % % trialStart_times = trialStart_times(trials_to_plot);
% % upPressed_times = upPressed_times(trials_to_plot);
% % stimDelivered_times = stimDelivered_times(trials_to_plot);
% % goCue_times = goCue_times(trials_to_plot);
% % leftUP_times = leftUP_times(trials_to_plot);
% % submitsResponse_times = submitsResponse_times(trials_to_plot);
% % feedback_times = feedback_times(trials_to_plot);
% %
% %
% % % sort trials by rxn
% % if strcmp(raster_plotting, 'default')
% %     [y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);
% % end
% %
% %
% % % trialStart_times = trialStart_times(trials_to_plot);
% % upPressed_times = upPressed_times(trials_to_plot);
% % stimDelivered_times = stimDelivered_times(trials_to_plot);
% % goCue_times = goCue_times(trials_to_plot);
% % leftUP_times = leftUP_times(trials_to_plot);
% % submitsResponse_times = submitsResponse_times(trials_to_plot);
% % feedback_times = feedback_times(trials_to_plot);
%
% %%
% %%
% %%
% %%
% %%
% %%
%
%
% %% Look at R, no-choice trials %%%
% % aka R choices made during IS
% trial_inds = find((taskbase_io.response == 2) & (nochoice_trials == 1));
% trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% % trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
%
%
% % trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
% upPressed_times = taskbase_io.events.upPressed(trial_inds)';
% stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
% goCue_times = taskbase_io.events.goCue(trial_inds)';
% leftUP_times = taskbase_io.events.leftUP(trial_inds)';
% submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
% feedback_times = taskbase_io.events.feedback(trial_inds)';
%
%
%
% % % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % % gt_times = taskbase.cue(trial_inds)';
% % % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % % wvo_times = taskbase.WaterDeliv(trial_inds)';
%
% % %% only plot a certain number of trials in the raster (but psth should be
% % %% average of all trials)
% % if length(trial_start_times) > NUM_TRIALS_TO_PLOT
% %     if strcmp(raster_plotting, 'default')
% %         r = randperm(length(trial_start_times));
% %         trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
% %     elseif strcmp(raster_plotting, 'inOrder')
% %         trials_to_plot = (1:NUM_TRIALS_TO_PLOT);
% %     end
% % else
% %     trials_to_plot = 1:length(trial_start_times);
% % end
% %
% % % trialStart_times = trialStart_times(trials_to_plot);
% % upPressed_times = upPressed_times(trials_to_plot);
% % stimDelivered_times = stimDelivered_times(trials_to_plot);
% % goCue_times = goCue_times(trials_to_plot);
% % leftUP_times = leftUP_times(trials_to_plot);
% % submitsResponse_times = submitsResponse_times(trials_to_plot);
% % feedback_times = feedback_times(trials_to_plot);
% %
% %
% % % sort trials by rxn
% % if strcmp(raster_plotting, 'default')
% %     [y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);
% % end
% %
% %
% % % trialStart_times = trialStart_times(trials_to_plot);
% % upPressed_times = upPressed_times(trials_to_plot);
% % stimDelivered_times = stimDelivered_times(trials_to_plot);
% % goCue_times = goCue_times(trials_to_plot);
% % leftUP_times = leftUP_times(trials_to_plot);
% % submitsResponse_times = submitsResponse_times(trials_to_plot);
% % feedback_times = feedback_times(trials_to_plot);
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
% %%
% %%
% %%
% % AT 4/20/20 - do some plotting
%
%
%
%
%
%
%
% if strcmp(surgerySide, 'L')
%     p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', ipsi_COLOR, 'LineStyle', NOCHOICE_STYLE);
%
% elseif strcmp(surgerySide, 'R')
%     p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', contra_COLOR, 'LineStyle', NOCHOICE_STYLE);
% end
%
% %title('Stimulus guided');
% %
% % p1 = plot(ref_psth_info.L.choice.event1.smooth_psth, 'Color', ipsi_COLOR, 'LineStyle', CHOICE_STYLE);
% % % p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', NOCHOICE_STYLE);
%
% if strcmp(surgerySide, 'L')
%     p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', contra_COLOR, 'LineStyle', NOCHOICE_STYLE);
%
% elseif strcmp(surgerySide, 'R')
%     p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', ipsi_COLOR, 'LineStyle', NOCHOICE_STYLE);
% end%title('Stimulus guided');
% %
% % p3 = plot(ref_psth_info.R.choice.event1.smooth_psth, 'Color', contra_COLOR, 'LineStyle', CHOICE_STYLE);
% % % p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', NOCHOICE_STYLE);
%
%
% % touch up psths aligned to event1
% % legend([p2 p4],{'Left', 'Right'}, 'Location', 'SouthEast');
%
%
% % touch up psths aligned to event1
%
% set(gcf, 'CurrentAxes', event1_psth);
%
% % max_psth = max([max(get(p2, 'YData')) max(get(p4, 'YData'))]); %...
% % max_psth = max([max(get(p1, 'YData')) max(get(p2, 'YData')) max(get(p3, 'YData')) max(get(p4, 'YData'))]); %...
% %     max(get(p5, 'YData')) max(get(p6, 'YData')) max(get(p7, 'YData')) max(get(p8, 'YData'))...
% %     max(get(p9, 'YData')) max(get(p10, 'YData')) max(get(p11, 'YData')) max(get(p12, 'YData'))]);
% max_y = ((ceil(max_psth / 10)) * 10)+10;
%
%
% if strcmp(surgerySide, 'L')
%     legend([p2 p4],{'Ipsi (L)', 'Contra (R)'}, 'Location', locat);
%
% elseif strcmp(surgerySide, 'R')
%     legend([p2 p4],{'Contra (L)', 'Ipsi (R)'}, 'Location', locat);
% end%title('Stimulus guided');
%
% fig_name = strcat([spk_file.spikeDATA.fileINFO.analyzDATE,'_', align_event1_times(1:6),spikeFile]);
%
% set(gcf,'NumberTitle', 'off', 'Name', fig_name);
%
% % % %AT added below 2.19.19
% % set(gcf,'Units','inches');
% % screenposition = get(gcf,'Position');
% % set(gcf,...
% %     'PaperPosition',[0 0 screenposition(3:4)],...
% %     'PaperSize',[screenposition(3:4)]);
%
% %%% Add a legend %%%
%
% %% re-reference entire figure
% % set(gcf, 'CurrentAxes', whole_fig, 'Units', 'Normalized');
% % set(gcf, 'CurrentAxes', whole_fig, 'Units', 'Normalized', 'OuterPosition', [0, 0, .5, .5]);
%
% %
% % legend_l = 0.25;
% % legend_u = ax_psth_event1_u + ax_psth_event1_h + (ax_psth_event1_vbuff / 2);
% ts = cell2mat(strcat(regexp(datestr(now), '-|:', 'split')));
% ts = (regexprep(ts, ' ', '_'));
%
% if saveFigure == 1
%     savename = strcat('raster',ts,fig_name,'_AT.pdf');
%
%     % print('-bestfit',savename,'-dpdf') %AT 10_29_18
%     % print('-bestfit',savename,'-dpdf','-r0')
%
%     saveas(gcf,savename)
% end
%
% % set(gcf, 'Position', get(0, 'Screensize'))
% % saveas(gcf,'savename')
%
%
%
% %% AT 3/30/20; adding in the next part
%
% % IS_raster_info.L.ref_spike_times = ref_spike_times;
% % IS_raster_info.L.trial_inds = trial_inds;
% %
% % IS_raster_info.L.raster_events.trial_start = trialStart_times';
% % IS_raster_info.L.raster_events.trial_event_times =  [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times];
% %
% % IS_raster_info.L.stim_params = [];
% % IS_raster_info.L.align_ind = 1; %I think this corresponds with trial_event_times?
% % IS_raster_info.L.window = init_psth_window_event1;
%
%
% IS_raster_info;
% SG_raster_info;
%
% num_iter = 500;
% analysis_to_perform = 'leftchoice_vs_rightchoice';
% if caseNumb == 1 || caseNumb == 2 || caseNumb == 3
%     epochs = {[2 3];[2 4];[2 5]; [888 -1 2 888 0.1 2 ];[888 -0.1 5 999 1 5]};
% else
%     epochs = {[2 3];[2 4];[2 5]; [888 -1 2 888 0.1 2 ];[888 -0.1 5 999 1 5];[2 7];[4 7];[888 -0.1 7 999 1 7];};
% end
%
%
%
%
% %below saves out the figure, hopefully
% figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','rasterPsth', caseName); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
% filename = (['/rasterPsth_' caseName, spikeFile, clustname, align_event1_times(1:8)]);
% if saveFig == 1
%     saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
% end
%
% %below saves out the variables pertaining to preference
% filename2 = (['/prefVariables_' caseName, spikeFile, clustname, align_event1_times(1:8)]);
% if saveFig == 1
%     save(fullfile(figuresdir, filename2), 'preference', 'roc_p', 'activity_info');
% end

return