%V2 on 2/18/20; should only be seen on the 'audTask' repo

%AT 2/14/20; using this as a template to try and get a similar analysis out
%of the human data. V1 is the editted version, V0 is the straight from
%mouse version




%% THIS FUNCTION USED TO MAKE EXAMPLE RASTER FOR FIGURE 3 OF MARIO'S SNR PAPER

%% CellSummary_choice_nochoice
% Plots rasters and PSTHs, aligned to 2 events of interest, for trials
% grouped by choice (L vs. R) and block type (choice vs. no-choice).
% Similar to CellSummary, but geared towards choice/no-choice task for
% examining differences between "active" and "passive" decision making
% (i.e., Mario's task).
%
% USAGE: fig_handle = CellSummary_choice_nochoice(behav_file, spk_file, align_ind1, window_event1, num_trials_back)
% EXAMPLE: h = CellSummary_choice_nochoice(behav_fname, spk_fname, 1, [-0.4 1.2], 3, [-0.8 0.8]);
%
% INPUTS:  behav_file - path and filename of taskbase file
%          spk_file - path and filename of spike file
%          align_ind1 - which trial event to align first set of rasters/psth to (specified in 
%              GetPhysioGlobals.m):
%               OdorPokeIn = 1
%               OdorValveOn = 2
%               OdorPokeOut = 3
%               WaterPokeIn = 4
%               WaterValveOn = 5
%               WaterPokeOut = 6
%               NextOdorPokeIn = 7
%               GoSignal = 8
%          window_event1 - 2x1 vector of times in which to rasterize spikes, relative to
%              event_times ([START STOP]) (e.g., [-1 1]) - corresponds to align_ind1
%          align_ind2 - which trial event to align second set of rasters/psth to (specified in 
%          window_event2 - 2x1 vector of times in which to rasterize spikes, relative to
%              event_times ([START STOP]) (e.g., [-1 1]) - corresponds to align_ind2
%
% OUTPUTS: fig_handle - handle to figure of rasters, psths
%
% [other notes]
%
% SEE ALSO:
%
% 11/18/13 - GF
%

% function [h1, fig_handle] = AT_CellSummary_SG_IS_V1(behav_file, spk_file, align_ind1, window_event1, ymaxx, NUM_TRIALS_TO_PLOT, PSTH_SMOOTH_FACTOR, saveFigure)
function [h1, fig_handle] = AT_CellSummary_SG_IS_io_V1()

digits(6) %sets vars so they contain 6 digits at most


%below are some basic inputs we are going to want

caseNumb = 8;
spikeFile = 'spike1';

if caseNumb == 8 || 9
    SGonly = 1;
end

p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/auditorytask/IO/MATLABCODE_io');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/auditorytask/IO/AT_lfp_code');
addpath(p);


[caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);


[inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);


[Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table);


%AT 1/8/20; adding below so we can do some analyses on the imported data
%now

% fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
% fromwhere_relativetoendofwaitperiod = 0; %have 0 here will identify the
% first TTL after the delay epoch is completed


rData = rsp_struct.rsp_master_v3;%unpacking, AT
inputmatrix = inputmatrix.input_matrix_rndm;%unpacking, AT

lasttrialwewant = length(rData);
trialsperblock = 9;

behavior_timestamp = Ephys_struct.ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same



%AT 2/15/20, needed to do some processing on the behavior file rData in
%order have the timings reflect time from beginning of each individual
%trial. This is really important! To account for different versions of our
%task, we should use different versions of the below fx!
taskbase_io = behav_file_adapter_V1(rData,inputmatrix);
taskbase_io = AOstart_adapter_V1(taskbase_io, Ephys_struct, 'trialStart'); %this should add output field in taskbase struct which contains the start of each trial in the time of the alphaomega clock.


%AT 2/14/20; below are input variables to original fx pulled out
if strcmp(spikeFile,'spike1')
    spk_file = spike1;
elseif strcmp(spikeFile,'spike2')
    spk_file = spike2;
elseif strcmp(spikeFile,'spike3')
    spk_file = spike3;
end

align_ind1 = 4; %which part of the trial do we want to look at as our 'zero' point?
    %%[trialStart_times; upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

window_event1 = [-.2 1.3]; %window of time around align_ind1 that we want to look at
% ymaxx 
NUM_TRIALS_TO_PLOT = 10;
PSTH_SMOOTH_FACTOR = 50;
saveFigure = 0;






spike_timestamp = spk_file.spikeDATA.waveforms.posWaveInfo.posLocs;
% spike_timestamp = spk_file.spikeDATA.waveforms.negWaveInfo.negLocs;


%% define some constants
% figure('rend','painters','pos',[10 10 900 600])

GetPhysioGlobals_io_V1;

global TRIAL_EVENTS; % Numbers in saved raster_info corresponding to the trial events
global RESOLUTION;



%% set names of variables based on desired event alignments
%AT remember that whatever we set the below to, there's 'TRIAL_EVENTS' in
%the GetPhysio fx that should correspond
switch align_ind1
    case 1
        align_event1_times = 'trialStart_times'; % beginning of trial
    case 2
        align_event1_times = 'upPressed_times'; % this is the last TTL sent during the delay epoch
    case 3
        align_event1_times = 'stimDelivered_times'; % OdorPokeOut
    case 4
        align_event1_times = 'goCue_times'; % WaterPokeIn
    case 5
        align_event1_times = 'leftUP_times'; % GoSignal
    case 6
        align_event1_times = 'submitsResponse_times'; % GoSignal
    case 7
        align_event1_times = 'feedback_times'; % GoSignal        
    otherwise
        error('align_ind1 must be -17, 0, 3, 4, or 8');
end

% %     [trialStart_times; upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

    
% % %AT, note that below is pretty convenient if needing to select different
% % %colors.
% % odorportin_col =  uisetcolor;

% [1 0.5 1];%   hot pink
% [1 1 1];%   white
% [0 0.75 0.75];%  Turquoise
% waterportin_col = [1 0.5 1];%  Hot Pink
% 
% L_COLOR = 0.5 * ones(1, 3);
% R_COLOR = zeros(1, 3);

CHOICE_STYLE = '-';
NOCHOICE_STYLE = '--';

trialStart = [1 1 0];%   yellow
endDelayEpoch = [.95    0.45    .1];%   orangey
gotone_col = [0 0.8 0.3]; %  
% odorportout_col = [0 0 1];%   Navy Blue
% waterportin_col = [1 1 1];%  white
% watervalveon_col = [0 0 1];
upPressed_color = [1 1 0];%   yellow
stimDelivered_color = [.95    0.45    .1];%   orangey
goCue_color = [0 0.8 0.3]; %  
leftUP_color = [1 0.5 1];%   hot pink
submitsResponse_color = [0 0.75 0.75];%  Turquoise
feedback_color = [.3 0.7 1];%   ?
% %     [; upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);




% L_COLOR = 0.5 * ones(1, 3);
% R_COLOR = zeros(1, 3);
L_COLOR = [.2 .9 .9]; %cyanish
R_COLOR = [1 0 .5]; %magenta







STE_COLOR = 0.75 * ones(1, 3);

%% Raster display setup constants
raster_u_buff = 0.04;
total_rasters_h = 0.8; % fraction of total figure height to devote to rasters
inter_raster_space = 0.005;
available_rasters_h = total_rasters_h - (4 * inter_raster_space); 
textbuff = 0.04;

SHOW_GRIDS = 0;
PresentationFigSetUp_AT_V1;
fig_handle = fig;

%%% PLOT EXAMPLE RASTERS AND PSTHS %%%
 
% % % % load(spk_file);
% % % % load(behav_file);

%AT 2/12/19 - adding the following adapter code to below for the behavior
%file name:


%AT 2/14/19 'TS' comes from the spike file for mouse data, it is the only
%thing that is loaded in with the spike file. So for our human data, I
%think we just want to divide by the sampling frequency

spike_times = spike_timestamp./ (Ephys_struct.mer.sampFreqHz)  ; % time in seconds

% trialstart_ind = TRIAL_EVENTS.TrialStart;
% endDelayepoch_ind = TRIAL_EVENTS.EndDelayEpoch;

% % % % opi_ind = TRIAL_EVENTS.OdorPokeIn; 
% % % % ovo_ind = TRIAL_EVENTS.OdorValveOn; 
% % % % gt_ind = TRIAL_EVENTS.GoSignal; 
% % % % opo_ind = TRIAL_EVENTS.OdorPokeOut; 
% % % % wpi_ind = TRIAL_EVENTS.WaterPokeIn; 

%% Define the trial events of interest; these correspond to fields of taskbase structure.
% Get these from the GetPhysioGlobals definition, but rename some to be
% compatible with taskbase fieldnames.
% Note that these are not chronological, b/c GoSignal was added later.
% trial_events = fieldnames(TRIAL_EVENTS);

% % % % trial_events{2} = 'DIO'; %DIO is OdorValveOn
% % % % trial_events{5} = 'WaterDeliv'; %WaterDeliv is WaterValveOn
% % % % trial_events{8} = 'cue'; %cue is GoSignal

no_plot_flag = 1;


%2/19/19 commented out trialclassification dispatcher because we weren't
%using the output
%AT 2/12/19 - because I have already adapted the taskbase output when I
%loaded it in using taskbase_valveadapter_V0, I think it is ok to use the
%original version of the trialclassification function

% num_trials_back = 0;
% [raster_events, stim_params] = TrialClassification_dispatcher(taskbase, trial_events, num_trials_back);
% [raster_events, stim_params] = TrialClassification_dispatcher_AT_V1(taskbase, trial_events, num_trials_back);

% % % % 
% % % % Determine whether to use the "Valve7A" or "Valve7B" field to determine
% % % % which are the choice and which are the no-choice trials.
% % % % 
% % % % 
% % % % 
% % % % if (range(taskbase.Valve7A ~= 0)) && (range(taskbase.Valve7B ~= 0))
% % % %     
% % % %     error('Both Valve7A and Valve7B have changing values for Valve7. No-choice blocks unclear.');
% % % %     
% % % % elseif (range(taskbase.Valve7A == 0)) && (range(taskbase.Valve7B == 0))
% % % %     
% % % %     error('Neither Valve7A nor Valve7B have changing values for Valve7. No-choice blocks unclear.');
% % % %     
% % % % elseif range(taskbase.Valve7A) ~= 0
% % % %     choice_trials = taskbase.Valve7A == 0.5;
% % % %     nochoice_trials_L = taskbase.Valve7A == 0;
% % % %     nochoice_trials_R = taskbase.Valve7A == 1;
% % % %     
% % % % elseif range(taskbase.Valve7A) == 0
% % % %     choice_trials = taskbase.Valve7B == 0.5;
% % % %     nochoice_trials_L = taskbase.Valve7B == 0;
% % % %     nochoice_trials_R = taskbase.Valve7B == 1;
% % % % end

[choice_trials_L, choice_trials_R, nochoice_trials_L, nochoice_trials_R, choice_trials_L_corrects, choice_trials_R_corrects, nochoice_trials_L_corrects, nochoice_trials_R_corrects ] = io_taskindexing_AT_V2(rData, inputmatrix);

choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index
nochoice_trials = nochoice_trials_L + nochoice_trials_R; %AT making combined SG index

%2/17/19 the point of below is to let us easily plot the just SG trials
if SGonly == 1 
    nochoice_trials = choice_trials;
end
    
% % % % %% ocassionally, the Valve7A/B field is 1 element longer than the choice
% % % % %% field. I'm not sure why this is. For now, assume that the last value
% % % % %% should be removed (along the lines of their usually (always?) being one
% % % % %% more element in the start field than in the other events)
% % % % if length(choice_trials) > length(taskbase.choice)
% % % %     warning('choice_trials is longer than taskbase.choice.');
% % % %     choice_trials = choice_trials(1:length(taskbase.choice));
% % % %     nochoice_trials_L = nochoice_trials_L(1:length(taskbase.choice));
% % % %     nochoice_trials_R = nochoice_trials_R(1:length(taskbase.choice));
% % % % end

%% Look at L, choice (active decision making) trials %%%
% aka L choices made during SG
trial_inds = find((taskbase_io.response == 1) & (choice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event

%%%%%%%%%%%%%%
ax_L_choice_event1_l = 0.07;
ax_L_choice_event1_w = 0.23;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_L_choice_event1_h = (num_trials / length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_L_choice_event1_u = 1 - raster_u_buff - ax_L_choice_event1_h - .020;
%%%%%%%%%%%%%%

ax_L_choice_event1_pos = [ax_L_choice_event1_l ax_L_choice_event1_u ax_L_choice_event1_w ax_L_choice_event1_h];

h = axes('Position', ax_L_choice_event1_pos);

hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Ipsi.'});
title('Stimulus guided');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

trial_inds = find((taskbase_io.response == 1) & (choice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


%AT 2/17/20; editting below
% now calculate psth
init_psth_window_event1 = window_event1 + [-((RESOLUTION/1000)/2) +((RESOLUTION/1000)/2)]; %b/c raster output has been padded
[ref_psth.L.choice.event1, junk, ref_psth_info.L.choice.event1] =...
    psth_io_V1(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% Look at L, no-choice trials %%%
% aka L choices made during IS

trial_inds = find((taskbase_io.response == 1) & (nochoice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event

%%%%%%%%%%%%%%
ax_L_nochoice_event1_l = ax_L_choice_event1_l + 0.25;
ax_L_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_L_nochoice_event1_h = (num_trials /length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_L_nochoice_event1_u = ax_L_choice_event1_u - inter_raster_space - ax_L_nochoice_event1_h;

ax_L_nochoice_event1_pos = [ax_L_nochoice_event1_l ax_L_choice_event1_u ax_L_nochoice_event1_w ax_L_choice_event1_h];

h = axes('Position', ax_L_nochoice_event1_pos);

hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
%ylabel({'Ipsi.'});
title('Internally specified');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

trial_inds = find((taskbase_io.response == 1) & (nochoice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


% now calculate psth
[ref_psth.L.nochoice.event1, junk, ref_psth_info.L.nochoice.event1] =...
    psth_io_V1(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);



%% Look at R, choice (active decision making) trials %%%
% aka L choices made during SG
trial_inds = find((taskbase_io.response == 2) & (choice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event
ax_R_choice_event1_l = ax_L_choice_event1_l;
ax_R_choice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_R_choice_event1_h = (num_trials / length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_R_choice_event1_u = ax_L_nochoice_event1_u - inter_raster_space - ax_L_choice_event1_h;


dimension_R = ax_L_choice_event1_pos(2) - ax_L_choice_event1_h;
ax_R_choice_event1_pos = [ax_R_choice_event1_l dimension_R ax_R_choice_event1_w ax_L_choice_event1_h];


h = axes('Position', ax_R_choice_event1_pos);

hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Contra.'});
%title('Stimulus guided');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';
trial_inds = find((taskbase_io.response == 2) & (choice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


%AT 2/17/20; editting below
% now calculate psth
% now calculate psth
[ref_psth.R.choice.event1, junk, ref_psth_info.R.choice.event1] =...
    psth_io_V1(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% Look at R, no-choice trials %%%
% aka R choices made during IS
trial_inds = find((taskbase_io.response == 2) & (nochoice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event


ax_R_nochoice_event1_l = ax_L_choice_event1_l + 0.25;
ax_R_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107; AT 2/13/19 editted out
ax_R_nochoice_event1_h = (num_trials / length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_R_nochoice_event1_u = ax_R_choice_event1_u - inter_raster_space - ax_R_nochoice_event1_h;

% ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l ax_R_choice_event1_u ax_R_nochoice_event1_w ax_R_nochoice_event1_h];
ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l dimension_R ax_R_nochoice_event1_w ax_R_nochoice_event1_h]; %2/13/19 AT editted from '0.655' to 'dimension_R'

h = axes('Position', ax_R_nochoice_event1_pos);



hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
%ylabel({'Ipsi.'});
%title('Internally specified');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

trial_inds = find((taskbase_io.response == 2) & (nochoice_trials == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


% now calculate psth
[ref_psth.R.nochoice.event1, junk, ref_psth_info.R.nochoice.event1] =...
    psth_io_V1(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);




%% plot PSTHs

% plot psths aligned to event1

ax_psth_event1_vbuff = 0.0635; % account for legend
ax_psth_event1_l = ax_L_choice_event1_l;
ax_psth_event1_w = ax_L_choice_event1_w;
ax_psth_event1_h = ax_L_choice_event1_h*2;
ax_psth_event1_u = ax_R_nochoice_event1_u - ax_psth_event1_h/2 + ax_psth_event1_vbuff;

% ax_psth_event1_pos = [ax_psth_event1_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
ax_psth_event1_pos = [ax_psth_event1_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
event1_psth = axes('Position', ax_psth_event1_pos);

hold on;

% calculate and plot +/-ste first 

% left, choice trials
ste.upper = ref_psth_info.L.choice.event1.smooth_psth + ref_psth_info.L.choice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.L.choice.event1.smooth_psth - ref_psth_info.L.choice.event1.smooth_psth_ste;
% +/- ste in shading
s1 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s1, 'EdgeColor', 'none');

% right, choice trials
ste.upper = ref_psth_info.R.choice.event1.smooth_psth + ref_psth_info.R.choice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.R.choice.event1.smooth_psth - ref_psth_info.R.choice.event1.smooth_psth_ste;
% +/- ste in shading
s3 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s3, 'EdgeColor', 'none');


% plot the mean psths
p1 = plot(ref_psth_info.L.choice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', CHOICE_STYLE);
% p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', NOCHOICE_STYLE);
p3 = plot(ref_psth_info.R.choice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);
% p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', NOCHOICE_STYLE);

% touch up psths aligned to event1

set(gcf, 'CurrentAxes', event1_psth);

max_psth = max([max(get(p1, 'YData')) max(get(p3, 'YData'))]); %...
% max_psth = max([max(get(p1, 'YData')) max(get(p2, 'YData')) max(get(p3, 'YData')) max(get(p4, 'YData'))]); %...
%     max(get(p5, 'YData')) max(get(p6, 'YData')) max(get(p7, 'YData')) max(get(p8, 'YData'))...
%     max(get(p9, 'YData')) max(get(p10, 'YData')) max(get(p11, 'YData')) max(get(p12, 'YData'))]);
max_y = (ceil(max_psth / 10)) * 10;

plot_window_event1 = init_psth_window_event1 + [+((RESOLUTION/1000)/2) -((RESOLUTION/1000)/2)]; %b/c raster output has been padded


XTICKLABEL_BUFFER_SPACE = '   ';
set(gca, 'XTick', [0 (round(length(ref_psth_info.L.choice.event1.smooth_psth) *...
    (-plot_window_event1(1) / (plot_window_event1(2) - plot_window_event1(1)))))...
    length(ref_psth_info.L.choice.event1.smooth_psth)],...
    'XTickLabel',...
    {[XTICKLABEL_BUFFER_SPACE num2str(plot_window_event1(1))] 0 [num2str(plot_window_event1(2)) XTICKLABEL_BUFFER_SPACE]},...
    'XLim', [0 length(ref_psth_info.L.choice.event1.smooth_psth)]);

% set(gca, 'YLim', [0 ymaxx], 'YTick', [0 ymaxx/2 ymaxx], 'YTickLabel', [0 ymaxx/2 ymaxx]);
set(gca, 'YLim', [(max_y / 2) max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', [0 (max_y / 2) max_y]);

% make x = 0 line
xt = get(gca, 'xtick');
l = line([xt(2) xt(2)], [0 max_y], 'Color', [0 0 0]);
% l = line([xt(2) xt(2)], [0 150], 'Color', [0 0 0], 'LineStyle', ':');

% xlabel(['Time from odor valve open (s)']);
xlabel(['Time from ' align_event1_times(1:(end - 6)) ' (s)']);
ylabel('Firing rate (spikes/s)');


% fig_name = [behav_file((max(findstr(behav_file, filesep)) + 1):(end - 4)), ', ',...
%     spk_file((max(findstr(spk_file, filesep)) + 1):(end - 4))]; 

% set(gcf,'NumberTitle', 'off', 'Name', fig_name);


%% plot PSTHs

% plot psths aligned to event1

ax_psth_event1_vbuff = 0.0635; % account for legend
ax_psth_event1_l = ax_L_choice_event1_l + 0.25;
ax_psth_event1_w = ax_L_choice_event1_w;
ax_psth_event1_h = ax_L_choice_event1_h*2;
ax_psth_event1_u = ax_R_nochoice_event1_u - ax_psth_event1_h/2 + ax_psth_event1_vbuff;

% ax_psth_event1_pos = [ax_psth_event1_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
ax_psth_event1_pos = [ax_psth_event1_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
event1_psth = axes('Position', ax_psth_event1_pos);
% % % % % 
% % % % % % % % ax_psth_event1_vbuff = 0.0635; % this is set in above cell
% % % % % ax_psth_event1_l = ax_L_choice_event1_l + 0.25;
% % % % % ax_psth_event1_w = ax_L_choice_event1_w;
% % % % % % % % ax_psth_event1_h = 0.16; this is set in above cell
% % % % % ax_psth_event1_u = ax_R_nochoice_event1_u - ax_psth_event1_vbuff - ax_psth_event1_h;
% % % % % 
% % % % % % ax_psth_event1_pos = [ax_psth_event1_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
% % % % % % ax_psth_event1_pos = [ax_psth_event1_l 0.35 ax_psth_event1_w ax_psth_event1_h];
% % % % % ax_psth_event1_pos = [ax_psth_event1_l 0.6 ax_psth_event1_w .2];
% % % % % event1_psth = axes('Position', ax_psth_event1_pos);

hold on;

% calculate and plot +/-ste first 

% left, no-choice trials
ste.upper = ref_psth_info.L.nochoice.event1.smooth_psth + ref_psth_info.L.nochoice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.L.nochoice.event1.smooth_psth - ref_psth_info.L.nochoice.event1.smooth_psth_ste;
% +/- ste in shading
s2 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s2, 'EdgeColor', 'none');

% right, no-choice trials
ste.upper = ref_psth_info.R.nochoice.event1.smooth_psth + ref_psth_info.R.nochoice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.R.nochoice.event1.smooth_psth - ref_psth_info.R.nochoice.event1.smooth_psth_ste;
% +/- ste in shading
s4 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s4, 'EdgeColor', 'none');
% 
% plot the mean psths
% p1 = plot(ref_psth_info.L.choice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', CHOICE_STYLE);
p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', NOCHOICE_STYLE);
% p3 = plot(ref_psth_info.R.choice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);
p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', NOCHOICE_STYLE);

% touch up psths aligned to event1

set(gcf, 'CurrentAxes', event1_psth);

max_psth = max([max(get(p2, 'YData')) max(get(p4, 'YData'))]); %...
% max_psth = max([max(get(p1, 'YData')) max(get(p2, 'YData')) max(get(p3, 'YData')) max(get(p4, 'YData'))]); %...
%     max(get(p5, 'YData')) max(get(p6, 'YData')) max(get(p7, 'YData')) max(get(p8, 'YData'))...
%     max(get(p9, 'YData')) max(get(p10, 'YData')) max(get(p11, 'YData')) max(get(p12, 'YData'))]);
max_y = (ceil(max_psth / 10)) * 10;

plot_window_event1 = init_psth_window_event1 + [+((RESOLUTION/1000)/2) -((RESOLUTION/1000)/2)]; %b/c raster output has been padded


XTICKLABEL_BUFFER_SPACE = '   ';
set(gca, 'XTick', [0 (round(length(ref_psth_info.L.choice.event1.smooth_psth) *...
    (-plot_window_event1(1) / (plot_window_event1(2) - plot_window_event1(1)))))...
    length(ref_psth_info.L.choice.event1.smooth_psth)],...
    'XTickLabel',...
    {[XTICKLABEL_BUFFER_SPACE num2str(plot_window_event1(1))] 0 [num2str(plot_window_event1(2)) XTICKLABEL_BUFFER_SPACE]},...
    'XLim', [0 length(ref_psth_info.L.choice.event1.smooth_psth)]);

% set(gca, 'YLim', [0 ymaxx], 'YTick', [], 'YTickLabel', []);
set(gca, 'YLim', [(max_y / 2) max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', [0 (max_y / 2) max_y]);

% make x = 0 line
xt = get(gca, 'xtick');
l = line([xt(2) xt(2)], [0 max_y], 'Color', [0 0 0]);
% l = line([xt(2) xt(2)], [0 150], 'Color', [0 0 0], 'LineStyle', ':');

% xlabel(['Time from odor valve open (s)']);
% xlabel(['Time from ' align_event1_times(1:(end - 6)) ' (s)']);
% ylabel('Firing rate (Hz)');


fig_name = strcat([spk_file.spikeDATA.fileINFO.analyzDATE,'_', align_event1_times(1:6),spikeFile]);

set(gcf,'NumberTitle', 'off', 'Name', fig_name);

% % %AT added below 2.19.19
% set(gcf,'Units','inches');
% screenposition = get(gcf,'Position');
% set(gcf,...
%     'PaperPosition',[0 0 screenposition(3:4)],...
%     'PaperSize',[screenposition(3:4)]);

%%% Add a legend %%%

%% re-reference entire figure
% set(gcf, 'CurrentAxes', whole_fig, 'Units', 'Normalized');
% set(gcf, 'CurrentAxes', whole_fig, 'Units', 'Normalized', 'OuterPosition', [0, 0, .5, .5]);

% 
% legend_l = 0.25;
% legend_u = ax_psth_event1_u + ax_psth_event1_h + (ax_psth_event1_vbuff / 2);
ts = cell2mat(strcat(regexp(datestr(now), '-|:', 'split')));
ts = (regexprep(ts, ' ', '_'));

if saveFigure == 1
    savename = strcat('raster',ts,fig_name,'_AT.pdf');
    
    % print('-bestfit',savename,'-dpdf') %AT 10_29_18
    % print('-bestfit',savename,'-dpdf','-r0')
    
    saveas(gcf,savename)
end

% set(gcf, 'Position', get(0, 'Screensize'))
% saveas(gcf,'savename') 






return