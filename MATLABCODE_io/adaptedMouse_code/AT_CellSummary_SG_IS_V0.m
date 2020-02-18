%AT 1/23/20; changed around the colors for ticks a little bit, works well
%though

%2/14/19 - added the smoothing factor and number of trials to plot to the
%inputs

% 2/12/19 - included the adapter fx for valve output and reverted the trial
% classifier fx to its original state.
%10_29_18 - more adapting
% 10_8_18 AT; adapting Mario's fx

%% THIS FUNCTION USED TO MAKE EXAMPLE RASTER FOR FIGURE 3 OF MARIO'S SNR PAPER
%% DO NOT USE THIS FOR ANYTHING ELSE!!!!

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

% function fig_handle = CellSummary_choice_nochoice(behav_file, spk_file, align_ind1, window_event1, align_ind2, window_event2, align_ind3, window_event3)
function [h1, fig_handle] = AT_CellSummary_choice_nochoice_ex_resub_V6(behav_file, spk_file, align_ind1, window_event1, ymaxx, NUM_TRIALS_TO_PLOT, PSTH_SMOOTH_FACTOR, saveFigure)
%% define some constants
% figure('rend','painters','pos',[10 10 900 600])

%2/12/19 - below commented out because I have included it as an input to
%the fx itself.
% ymaxx = 140; % AT 10_29_18, ymaxx for plot
GetPhysioGlobals;

global TRIAL_EVENTS; % Numbers in saved raster_info corresponding to the trial events
global RESOLUTION;

% for rasters, psth plots all trials
% NUM_TRIALS_TO_PLOT = 100;
% PSTH_SMOOTH_FACTOR = 25;

%% set names of variables based on desired event alignments
switch align_ind1
    case 1
        align_event1_times = 'opi_times'; % OdorPokeIn
    case 2
        align_event1_times = 'ovo_times'; % OdorValveOn
    case 3
        align_event1_times = 'opo_times'; % OdorPokeOut
    case 4
        align_event1_times = 'wpi_times'; % WaterPokeIn
    case 8
        align_event1_times = 'gt_times'; % GoSignal
    otherwise
        error('align_ind1 must be 1, 2, 3, 4, or 8');
end

%AT 2/13/19 - changing below
% PSTH_SMOOTH_FACTOR = (window_event1(2) - window_event1(1)) * 15;

% odorportin_col = [1 0.5 1];%   hot pink
% % odorportin_col = [1 1 1];%   white
% 
% odorvalveon_col = [1 0 0];
% gotone_col = [ 0 1 0]; %  
% odorportout_col = [0 0.75 0.75];%  Turquoise
% waterportin_col = [1 0.5 1];%  Hot Pink
% watervalveon_col = [0 0 1];
% 
% L_COLOR = 0.5 * ones(1, 3);
% R_COLOR = zeros(1, 3);
% 
CHOICE_STYLE = '-';
NOCHOICE_STYLE = '--';





odorportin_col = [1 1 0];%   yellow
odorportin_col =  uisetcolor 

% odorportin_col = [1 1 1];%   white

odorvalveon_col = [.95    0.45    .1];%   orangey
gotone_col = [0 0.8 0.3]; %  
odorportout_col = [0 0 1];%   Navy Blue
waterportin_col = [1 1 1];%  white
watervalveon_col = [0 0 1];



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

load(spk_file);
load(behav_file);

%AT 2/12/19 - adding the following adapter code to below for the behavior
%file name:

if behav_file(50) ~= 'M' %AT adding 2/13/19 so the Marios file don't need to undergo any changes
taskbase = taskbase_valveadapter_V0(behav_file);
end

%spike_times = TS ./ 1000000; % time in seconds
spike_times = TS ./ 10000; % time in seconds


opi_ind = TRIAL_EVENTS.OdorPokeIn; 
ovo_ind = TRIAL_EVENTS.OdorValveOn; 
gt_ind = TRIAL_EVENTS.GoSignal; 
opo_ind = TRIAL_EVENTS.OdorPokeOut; 
wpi_ind = TRIAL_EVENTS.WaterPokeIn; 

%% Define the trial events of interest; these correspond to fields of taskbase structure.
% Get these from the GetPhysioGlobals definition, but rename some to be
% compatible with taskbase fieldnames.
% Note that these are not chronological, b/c GoSignal was added later.
trial_events = fieldnames(TRIAL_EVENTS);
trial_events{2} = 'DIO'; %DIO is OdorValveOn
trial_events{5} = 'WaterDeliv'; %WaterDeliv is WaterValveOn
trial_events{8} = 'cue'; %cue is GoSignal

no_plot_flag = 1;


%2/19/19 commented out trialclassification dispatcher because we weren't
%using the output
%AT 2/12/19 - because I have already adapted the taskbase output when I
%loaded it in using taskbase_valveadapter_V0, I think it is ok to use the
%original version of the trialclassification function

% num_trials_back = 0;
% [raster_events, stim_params] = TrialClassification_dispatcher(taskbase, trial_events, num_trials_back);
% [raster_events, stim_params] = TrialClassification_dispatcher_AT_V1(taskbase, trial_events, num_trials_back);


%% Determine whether to use the "Valve7A" or "Valve7B" field to determine
%% which are the choice and which are the no-choice trials.



if (range(taskbase.Valve7A ~= 0)) && (range(taskbase.Valve7B ~= 0))
    
    error('Both Valve7A and Valve7B have changing values for Valve7. No-choice blocks unclear.');
    
elseif (range(taskbase.Valve7A == 0)) && (range(taskbase.Valve7B == 0))
    
    error('Neither Valve7A nor Valve7B have changing values for Valve7. No-choice blocks unclear.');
    
elseif range(taskbase.Valve7A) ~= 0
    choice_trials = taskbase.Valve7A == 0.5;
    nochoice_trials_L = taskbase.Valve7A == 0;
    nochoice_trials_R = taskbase.Valve7A == 1;
    
elseif range(taskbase.Valve7A) == 0
    choice_trials = taskbase.Valve7B == 0.5;
    nochoice_trials_L = taskbase.Valve7B == 0;
    nochoice_trials_R = taskbase.Valve7B == 1;
end



%% ocassionally, the Valve7A/B field is 1 element longer than the choice
%% field. I'm not sure why this is. For now, assume that the last value
%% should be removed (along the lines of their usually (always?) being one
%% more element in the start field than in the other events)
if length(choice_trials) > length(taskbase.choice)
    warning('choice_trials is longer than taskbase.choice.');
    choice_trials = choice_trials(1:length(taskbase.choice));
    nochoice_trials_L = nochoice_trials_L(1:length(taskbase.choice));
    nochoice_trials_R = nochoice_trials_R(1:length(taskbase.choice));
end

%% Look at L, choice (active decision making) trials %%%
trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

% sort trials by odor sample time
[y, trials_to_plot] = sort(opo_times - ovo_times);

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

%% plot rasters aligned to first desired event

%%%%%%%%%%%%%%
ax_L_choice_event1_l = 0.07;
ax_L_choice_event1_w = 0.23;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_L_choice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_L_choice_event1_u = 1 - raster_u_buff - ax_L_choice_event1_h - .020;
%%%%%%%%%%%%%%

ax_L_choice_event1_pos = [ax_L_choice_event1_l ax_L_choice_event1_u ax_L_choice_event1_w ax_L_choice_event1_h];

h = axes('Position', ax_L_choice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Ipsi.'});
title('Stimulus guided');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ ovo_times; gt_times; opo_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


% now calculate psth
init_psth_window_event1 = window_event1 + [-((RESOLUTION/1000)/2) +((RESOLUTION/1000)/2)]; %b/c raster output has been padded
[ref_psth.L.choice.event1, junk, ref_psth_info.L.choice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% Look at L, no-choice trials %%%

trial_inds = find((taskbase.choice == 1) & (nochoice_trials_L == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

% sort trials by odor sample time
[y, trials_to_plot] = sort(opo_times - ovo_times); 

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

%% plot rasters aligned to first desired event

ax_L_nochoice_event1_l = ax_L_choice_event1_l + 0.25;
ax_L_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107; %AT 2/13/19 - where did this value come from? I think we want the above line to be uncommented. After investigating - maybe because 107 works well with the spacing for how things are plotted? 100 seems superior imo

ax_L_nochoice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_L_nochoice_event1_u = ax_L_choice_event1_u - inter_raster_space - ax_L_nochoice_event1_h;

ax_L_nochoice_event1_pos = [ax_L_nochoice_event1_l ax_L_choice_event1_u ax_L_nochoice_event1_w ax_L_choice_event1_h];

h = axes('Position', ax_L_nochoice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);
%     [ ovo_times; gt_times; opo_times]);

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
% ylabel({'Ipsiversive,'; 'IG'});
title('Internally specified');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
trial_inds = find((taskbase.choice == 1) & (nochoice_trials_L == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
        [ ovo_times; gt_times; opo_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);

% now calculate psth
[ref_psth.L.nochoice.event1, junk, ref_psth_info.L.nochoice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% Look at R, choice trials %%%

trial_inds = find((taskbase.choice == 2) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

% sort trials by odor sample time
[y, trials_to_plot] = sort(opo_times - ovo_times); 

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

%% plot rasters aligned to first desired event

ax_R_choice_event1_l = ax_L_choice_event1_l;
ax_R_choice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_R_choice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_R_choice_event1_u = ax_L_nochoice_event1_u - inter_raster_space - ax_L_choice_event1_h;

% ax_R_choice_event1_pos = [ax_R_choice_event1_l ax_R_choice_event1_u ax_R_choice_event1_w ax_L_choice_event1_h];
% % %AT 2/13/19 - for the below, this was how the code was written for Marios
% % %figures, but it ends up cutting off part of the raster. the above was
% % %commented off in the original code. I suspect screen resolution
% % %differences lead to different dimensions
% ax_R_choice_event1_pos = [ax_R_choice_event1_l 0.655 ax_R_choice_event1_w ax_L_choice_event1_h];
dimension_R = ax_L_choice_event1_pos(2) - ax_L_choice_event1_h;
ax_R_choice_event1_pos = [ax_R_choice_event1_l dimension_R ax_R_choice_event1_w ax_L_choice_event1_h];


h = axes('Position', ax_R_choice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);
%     [ ovo_times; gt_times; opo_times]);

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Contra.'});

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
trial_inds = find((taskbase.choice == 2) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ovo_times; gt_times; opo_times], no_plot_flag);

% now calculate psth
[ref_psth.R.choice.event1, junk, ref_psth_info.R.choice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);

%% Look at R, no-choice trials %%%

trial_inds = find((taskbase.choice == 2) & (nochoice_trials_R == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);

% sort trials by odor sample time
[y, trials_to_plot] = sort(opo_times - ovo_times); 

trial_start_times = trial_start_times(trials_to_plot);
opi_times = opi_times(trials_to_plot);
ovo_times = ovo_times(trials_to_plot);
gt_times = gt_times(trials_to_plot);
opo_times = opo_times(trials_to_plot);
wpi_times = wpi_times(trials_to_plot);
wvo_times = wvo_times(trials_to_plot);
%% plot rasters aligned to first desired event

ax_R_nochoice_event1_l = ax_L_choice_event1_l + 0.25;
ax_R_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107; AT 2/13/19 editted out
ax_R_nochoice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_R_nochoice_event1_u = ax_R_choice_event1_u - inter_raster_space - ax_R_nochoice_event1_h;

% ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l ax_R_choice_event1_u ax_R_nochoice_event1_w ax_R_nochoice_event1_h];
ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l dimension_R ax_R_nochoice_event1_w ax_R_nochoice_event1_h]; %2/13/19 AT editted from '0.655' to 'dimension_R'

h = axes('Position', ax_R_nochoice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);
%     [ ovo_times; gt_times; opo_times]);


% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
% ylabel({'Contraversive,'; 'IG'});

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
trial_inds = find((taskbase.choice == 2) & (nochoice_trials_R == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';
wvo_times = taskbase.WaterDeliv(trial_inds)';

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ ovo_times; gt_times; opo_times], no_plot_flag);

% now calculate psth
[ref_psth.R.nochoice.event1, junk, ref_psth_info.R.nochoice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


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

set(gca, 'YLim', [0 ymaxx], 'YTick', [0 ymaxx/2 ymaxx], 'YTickLabel', [0 ymaxx/2 ymaxx]);
%set(gca, 'YLim', [0 max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', []);

% make x = 0 line
xt = get(gca, 'xtick');
%l = line([xt(2) xt(2)], [0 max_y], 'Color', odorportout_col);
l = line([xt(2) xt(2)], [0 150], 'Color', [0 0 0], 'LineStyle', ':');

xlabel(['Time from odor valve open (s)']);
% xlabel(['Time from ' align_event1_times(1:(end - 6)) ' (s)']);
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
p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', CHOICE_STYLE);
% p3 = plot(ref_psth_info.R.choice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);
p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);

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

set(gca, 'YLim', [0 ymaxx], 'YTick', [], 'YTickLabel', []);
%set(gca, 'YLim', [0 max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', []);

% make x = 0 line
xt = get(gca, 'xtick');
% l = line([xt(2) xt(2)], [0 max_y], 'Color', odorportout_col);
l = line([xt(2) xt(2)], [0 150], 'Color', [0 0 0], 'LineStyle', ':');

% xlabel(['Time from odor valve open (s)']);
% xlabel(['Time from ' align_event1_times(1:(end - 6)) ' (s)']);
% ylabel('Firing rate (Hz)');


fig_name = [behav_file((max(findstr(behav_file, filesep)) + 1):(end - 4)), ', ',...
    spk_file((max(findstr(spk_file, filesep)) + 1):(end - 4))]; 

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