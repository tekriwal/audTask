%% CellSummary_choice_nochoice
% Plots rasters and PSTHs, aligned to 2 events of interest, for trials
% grouped by choice (L vs. R) and block type (choice vs. no-choice).
% Similar to CellSummary, but geared towards choice/no-choice task for
% examining differences between "active" and "passive" decision making
% (i.e., Mario's task).
%
% USAGE: fig_handle = CellSummary_choice_nochoice(behav_file, spk_file, align_ind1, window_event1,...
%   align_ind2, window_event2)
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

function fig_handle = CellSummary_choice_nochoice(behav_file, spk_file, align_ind1, window_event1,...
   align_ind2, window_event2)

%% define some constants

GetPhysioGlobals;

global TRIAL_EVENTS; % Numbers in saved raster_info corresponding to the trial events
global RESOLUTION;


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

switch align_ind2
    case 1
        align_event2_times = 'opi_times'; % OdorPokeIn
    case 2
        align_event2_times = 'ovo_times'; % OdorValveOn
    case 3
        align_event2_times = 'opo_times'; % OdorPokeOut
    case 4
        align_event2_times = 'wpi_times'; % WaterPokeIn
    case 8
        align_event2_times = 'gt_times'; % GoSignal
    otherwise
        error('align_ind2 must be 1, 2, 3, 4, or 8');
end

PSTH_SMOOTH_FACTOR = (window_event1(2) - window_event1(1)) * 15;

odorportin_col = [1 1 0];
odorvalveon_col = [1 0 0];
gotone_col = [0 .75 0];
odorportout_col = [0 1 1];
waterportin_col = [0 0 1];

L_COLOR = 0.5 * ones(1, 3);
R_COLOR = zeros(1, 3);

CHOICE_STYLE = '-';
NOCHOICE_STYLE = '--';

STE_COLOR = 0.75 * ones(1, 3);

%% Raster display setup constants
raster_u_buff = 0.04;
total_rasters_h = 0.8; % fraction of total figure height to devote to rasters
inter_raster_space = 0.005;
available_rasters_h = total_rasters_h - (4 * inter_raster_space); 
textbuff = 0.04;

PresentationFigSetUp;
fig_handle = fig;

%%% PLOT EXAMPLE RASTERS AND PSTHS %%%

load(spk_file);
load(behav_file);

%spike_times = TS ./ 1000000; % time in seconds
spike_times = TS ./ 10000; % time in seconds


opi_ind = TRIAL_EVENTS.OdorPokeIn; 
ovo_ind = TRIAL_EVENTS.OdorValveOn; 
gt_ind = TRIAL_EVENTS.GoSignal; 
opo_ind = TRIAL_EVENTS.OdorPokeOut; 
wpi_ind = TRIAL_EVENTS.WaterPokeIn; 

no_plot_flag = 1;

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

%%% Look at L, choice (active decision making) trials %%%

trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';

%% sort trials by go signal reaction time
[y, s] = sort(opo_times - gt_times); 
trial_start_times = trial_start_times(s);
opi_times = opi_times(s);
ovo_times = ovo_times(s);
gt_times = gt_times(s);
opo_times = opo_times(s);
wpi_times = wpi_times(s);


%% plot rasters aligned to first desired event

%%%%%%%%%%%%%%
ax_L_choice_event1_l = 0.1;
ax_L_choice_event1_w = 0.4;
num_trials = length(trial_inds);
ax_L_choice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_L_choice_event1_u = 1 - raster_u_buff - ax_L_choice_event1_h;
%%%%%%%%%%%%%%

ax_L_choice_event1_pos = [ax_L_choice_event1_l ax_L_choice_event1_u ax_L_choice_event1_w ax_L_choice_event1_h];

h = axes('Position', ax_L_choice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Ipsi.,'; 'choice'});

% now calculate psth
init_psth_window_event1 = window_event1 + [-((RESOLUTION/1000)/2) +((RESOLUTION/1000)/2)]; %b/c raster output has been padded
[ref_psth.L.choice.event1, junk, ref_psth_info.L.choice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% plot rasters aligned to second desired event

ax_L_choice_event2_hbuff = 0.02;
ax_L_choice_event2_l = ax_L_choice_event1_l + ax_L_choice_event1_w + ax_L_choice_event2_hbuff;

ax_L_choice_event2_pos = [ax_L_choice_event2_l ax_L_choice_event1_u ax_L_choice_event1_w ax_L_choice_event1_h];
h = axes('Position', ax_L_choice_event2_pos);
hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event2_times), window_event2,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);

% now calculate psth
init_psth_window_event2 = window_event2 + [-((RESOLUTION/1000)/2) +((RESOLUTION/1000)/2)]; %b/c raster output has been padded
[ref_psth.L.choice.event2, junk, ref_psth_info.L.choice.event2] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event2, PSTH_SMOOTH_FACTOR, no_plot_flag);


%%% Look at L, no-choice trials %%%

trial_inds = find((taskbase.choice == 1) & (nochoice_trials_L == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';

%% sort trials by go signal reaction time
[y, s] = sort(opo_times - gt_times); 
trial_start_times = trial_start_times(s);
opi_times = opi_times(s);
ovo_times = ovo_times(s);
gt_times = gt_times(s);
opo_times = opo_times(s);
wpi_times = wpi_times(s);

%% plot rasters aligned to first desired event

ax_L_nochoice_event1_l = ax_L_choice_event1_l;
ax_L_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = length(trial_inds);
ax_L_nochoice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_L_nochoice_event1_u = ax_L_choice_event1_u - inter_raster_space - ax_L_nochoice_event1_h;

ax_L_nochoice_event1_pos = [ax_L_nochoice_event1_l ax_L_nochoice_event1_u ax_L_nochoice_event1_w ax_L_nochoice_event1_h];

h = axes('Position', ax_L_nochoice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Ipsi.,'; 'no-choice'});

% now calculate psth
[ref_psth.L.nochoice.event1, junk, ref_psth_info.L.nochoice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% plot rasters aligned to second desired event

ax_L_nochoice_event2_l = ax_L_choice_event2_l;

ax_L_nochoice_event2_pos = [ax_L_nochoice_event2_l ax_L_nochoice_event1_u ax_L_nochoice_event1_w ax_L_nochoice_event1_h];
h = axes('Position', ax_L_nochoice_event2_pos);
hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event2_times), window_event2,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);

% now calculate psth
[ref_psth.L.nochoice.event2, junk, ref_psth_info.L.nochoice.event2] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event2, PSTH_SMOOTH_FACTOR, no_plot_flag);


%%% Look at R, choice trials %%%

trial_inds = find((taskbase.choice == 2) & (choice_trials == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';

%% sort trials by go signal reaction time
[y, s] = sort(opo_times - gt_times); 
trial_start_times = trial_start_times(s);
opi_times = opi_times(s);
ovo_times = ovo_times(s);
gt_times = gt_times(s);
opo_times = opo_times(s);
wpi_times = wpi_times(s);

%% plot rasters aligned to first desired event

ax_R_choice_event1_l = ax_L_choice_event1_l;
ax_R_choice_event1_w = ax_L_choice_event1_w;
num_trials = length(trial_inds);
ax_R_choice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_R_choice_event1_u = ax_L_nochoice_event1_u - inter_raster_space - ax_R_choice_event1_h;

ax_R_choice_event1_pos = [ax_R_choice_event1_l ax_R_choice_event1_u ax_R_choice_event1_w ax_R_choice_event1_h];

h = axes('Position', ax_R_choice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Contra.,'; 'choice'});

% now calculate psth
[ref_psth.R.choice.event1, junk, ref_psth_info.R.choice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% plot rasters aligned to second desired event

ax_R_choice_event2_l = ax_L_choice_event2_l;

ax_R_choice_event2_pos = [ax_R_choice_event2_l ax_R_choice_event1_u ax_R_choice_event1_w ax_R_choice_event1_h];
h = axes('Position', ax_R_choice_event2_pos);
hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event2_times), window_event2,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);

% now calculate psth
[ref_psth.R.choice.event2, junk, ref_psth_info.R.choice.event2] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event2, PSTH_SMOOTH_FACTOR, no_plot_flag);


%%% Look at R, no-choice trials %%%

trial_inds = find((taskbase.choice == 2) & (nochoice_trials_R == 1));
trial_start_times = taskbase.start_nlx(trial_inds)';
opi_times = taskbase.OdorPokeIn(trial_inds)';
ovo_times = taskbase.DIO(trial_inds)';
gt_times = taskbase.cue(trial_inds)';
opo_times = taskbase.OdorPokeOut(trial_inds)';
wpi_times = taskbase.WaterPokeIn(trial_inds)';

%% sort trials by go signal reaction time
[y, s] = sort(opo_times - gt_times); 
trial_start_times = trial_start_times(s);
opi_times = opi_times(s);
ovo_times = ovo_times(s);
gt_times = gt_times(s);
opo_times = opo_times(s);
wpi_times = wpi_times(s);

%% plot rasters aligned to first desired event

ax_R_nochoice_event1_l = ax_L_choice_event1_l;
ax_R_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = length(trial_inds);
ax_R_nochoice_event1_h = (num_trials / length(taskbase.stimID)) * available_rasters_h;
ax_R_nochoice_event1_u = ax_R_choice_event1_u - inter_raster_space - ax_R_nochoice_event1_h;

% if ax_R_nochoice_event1_h ~= 0
ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l ax_R_nochoice_event1_u ax_R_nochoice_event1_w ax_R_nochoice_event1_h];
% elseif ax_R_nochoice_event1_h == 0
% ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l ax_R_nochoice_event1_u ax_R_nochoice_event1_w ax_L_nochoice_event1_h];        
% end        
        
        

h = axes('Position', ax_R_nochoice_event1_pos);

hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Contra.,'; 'no-choice'});

% now calculate psth
[ref_psth.R.nochoice.event1, junk, ref_psth_info.R.nochoice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% plot rasters aligned to second desired event

ax_R_nochoice_event2_l = ax_L_choice_event2_l;

ax_R_nochoice_event2_pos = [ax_R_nochoice_event2_l ax_R_nochoice_event1_u ax_R_nochoice_event1_w ax_R_nochoice_event1_h];
h = axes('Position', ax_R_nochoice_event2_pos);
hold on;

[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event2_times), window_event2,...
    [opi_times; ovo_times; gt_times; opo_times; wpi_times]);

% Change colors of secondary event symbols
set(plot_handle.secondary_events(:, 1), 'Color', odorportin_col);
set(plot_handle.secondary_events(:, 2), 'Color', odorvalveon_col);
set(plot_handle.secondary_events(:, 3), 'Color', gotone_col);
set(plot_handle.secondary_events(:, 4), 'Color', odorportout_col);
set(plot_handle.secondary_events(:, 5), 'Color', waterportin_col);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);

% now calculate psth
[ref_psth.R.nochoice.event2, junk, ref_psth_info.R.nochoice.event2] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event2, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% plot PSTHs

% plot psths aligned to event1

ax_psth_event1_vbuff = 0.06; % account for legend
ax_psth_event1_l = ax_L_choice_event1_l;
ax_psth_event1_w = ax_L_choice_event1_w;
ax_psth_event1_h = 0.18;
ax_psth_event1_u = ax_R_nochoice_event1_u - ax_psth_event1_vbuff - ax_psth_event1_h;

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

% left, no-choice trials
ste.upper = ref_psth_info.L.nochoice.event1.smooth_psth + ref_psth_info.L.nochoice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.L.nochoice.event1.smooth_psth - ref_psth_info.L.nochoice.event1.smooth_psth_ste;
% +/- ste in shading
s2 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s2, 'EdgeColor', 'none');

% right, choice trials
ste.upper = ref_psth_info.R.choice.event1.smooth_psth + ref_psth_info.R.choice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.R.choice.event1.smooth_psth - ref_psth_info.R.choice.event1.smooth_psth_ste;
% +/- ste in shading
s3 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s3, 'EdgeColor', 'none');

% right, no-choice trials
ste.upper = ref_psth_info.R.nochoice.event1.smooth_psth + ref_psth_info.R.nochoice.event1.smooth_psth_ste;
ste.lower = ref_psth_info.R.nochoice.event1.smooth_psth - ref_psth_info.R.nochoice.event1.smooth_psth_ste;
% +/- ste in shading
s4 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s4, 'EdgeColor', 'none');
% 
% plot the mean psths
p1 = plot(ref_psth_info.L.choice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', CHOICE_STYLE);
p2 = plot(ref_psth_info.L.nochoice.event1.smooth_psth, 'Color', L_COLOR, 'LineStyle', NOCHOICE_STYLE);
p3 = plot(ref_psth_info.R.choice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);
p4 = plot(ref_psth_info.R.nochoice.event1.smooth_psth, 'Color', R_COLOR, 'LineStyle', NOCHOICE_STYLE);

% plot psths aligned to event2

ax_psth_event2_l = ax_L_choice_event2_l;

ax_psth_event2_pos = [ax_psth_event2_l ax_psth_event1_u ax_psth_event1_w ax_psth_event1_h];
event2_psth = axes('Position', ax_psth_event2_pos);
hold on;

% calculate and plot +/-ste first 

% left, choice trials
ste.upper = ref_psth_info.L.choice.event2.smooth_psth + ref_psth_info.L.choice.event2.smooth_psth_ste;
ste.lower = ref_psth_info.L.choice.event2.smooth_psth - ref_psth_info.L.choice.event2.smooth_psth_ste;
% +/- ste in shading
s5 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s5, 'EdgeColor', 'none');

% left, no-choice trials
ste.upper = ref_psth_info.L.nochoice.event2.smooth_psth + ref_psth_info.L.nochoice.event2.smooth_psth_ste;
ste.lower = ref_psth_info.L.nochoice.event2.smooth_psth - ref_psth_info.L.nochoice.event2.smooth_psth_ste;
% +/- ste in shading
s6 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s6, 'EdgeColor', 'none');

% right, choice trials
ste.upper = ref_psth_info.R.choice.event2.smooth_psth + ref_psth_info.R.choice.event2.smooth_psth_ste;
ste.lower = ref_psth_info.R.choice.event2.smooth_psth - ref_psth_info.R.choice.event2.smooth_psth_ste;
% +/- ste in shading
s7 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s7, 'EdgeColor', 'none');

% right, no-choice trials
ste.upper = ref_psth_info.R.nochoice.event2.smooth_psth + ref_psth_info.R.nochoice.event2.smooth_psth_ste;
ste.lower = ref_psth_info.R.nochoice.event2.smooth_psth - ref_psth_info.R.nochoice.event2.smooth_psth_ste;
% +/- ste in shading
s8 = patch([1:length(ste.upper) length(ste.upper):-1:1], [ste.upper fliplr(ste.lower)], STE_COLOR);
set(s8, 'EdgeColor', 'none');
% 
% plot the mean psths
p5 = plot(ref_psth_info.L.choice.event2.smooth_psth, 'Color', L_COLOR, 'LineStyle', CHOICE_STYLE);
p6 = plot(ref_psth_info.L.nochoice.event2.smooth_psth, 'Color', L_COLOR, 'LineStyle', NOCHOICE_STYLE);
p7 = plot(ref_psth_info.R.choice.event2.smooth_psth, 'Color', R_COLOR, 'LineStyle', CHOICE_STYLE);
p8 = plot(ref_psth_info.R.nochoice.event2.smooth_psth, 'Color', R_COLOR, 'LineStyle', NOCHOICE_STYLE);


% touch up psths aligned to event1

set(gcf, 'CurrentAxes', event1_psth);

max_psth = max([max(get(p1, 'YData')) max(get(p2, 'YData')) max(get(p3, 'YData')) max(get(p4, 'YData'))...
    max(get(p5, 'YData')) max(get(p6, 'YData')) max(get(p7, 'YData')) max(get(p8, 'YData'))]);
max_y = (ceil(max_psth / 10)) * 10;

plot_window_event1 = init_psth_window_event1 + [+((RESOLUTION/1000)/2) -((RESOLUTION/1000)/2)]; %b/c raster output has been padded


XTICKLABEL_BUFFER_SPACE = '   ';
set(gca, 'XTick', [0 (round(length(ref_psth_info.L.choice.event1.smooth_psth) *...
    (-plot_window_event1(1) / (plot_window_event1(2) - plot_window_event1(1)))))...
    length(ref_psth_info.L.choice.event1.smooth_psth)],...
    'XTickLabel',...
    {[XTICKLABEL_BUFFER_SPACE num2str(plot_window_event1(1))] 0 [num2str(plot_window_event1(2)) XTICKLABEL_BUFFER_SPACE]},...
    'XLim', [0 length(ref_psth_info.L.choice.event1.smooth_psth)]);

set(gca, 'YLim', [0 max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', [0 (max_y / 2) max_y]);
%set(gca, 'YLim', [0 max_y], 'YTick', [0 (max_y / 2) max_y], 'YTickLabel', []);

% make x = 0 line
xt = get(gca, 'xtick');
%l = line([xt(2) xt(2)], [0 max_y], 'Color', odorportout_col);
l = line([xt(2) xt(2)], [0 max_y], 'Color', [0 0 0], 'LineStyle', ':');

xlabel(['Time from ' align_event1_times(1:(end - 6)) ' (s)']);
ylabel('Firing rate (Hz)');

% touch up psths aligned to event2

set(gcf, 'CurrentAxes', event2_psth);

plot_window_event2 = init_psth_window_event2 + [+((RESOLUTION/1000)/2) -((RESOLUTION/1000)/2)]; %b/c raster output has been padded


XTICKLABEL_BUFFER_SPACE = '   ';
set(gca, 'XTick', [0 (round(length(ref_psth_info.L.choice.event2.smooth_psth) *...
    (-plot_window_event2(1) / (plot_window_event2(2) - plot_window_event2(1)))))...
    length(ref_psth_info.L.choice.event2.smooth_psth)],...
    'XTickLabel',...
    {[XTICKLABEL_BUFFER_SPACE num2str(plot_window_event2(1))] 0 [num2str(plot_window_event2(2)) XTICKLABEL_BUFFER_SPACE]},...
    'XLim', [0 length(ref_psth_info.L.choice.event2.smooth_psth)]);

set(gca, 'YLim', [0 max_y], 'YTick', [], 'YTickLabel', []);

% make x = 0 line
xt = get(gca, 'xtick');
%l = line([xt(2) xt(2)], [0 max_y], 'Color', odorportout_col);
l = line([xt(2) xt(2)], [0 max_y], 'Color', [0 0 0], 'LineStyle', ':');

xlabel(['Time from ' align_event2_times(1:(end - 6)) ' (s)']);

fig_name = [behav_file((max(findstr(behav_file, filesep)) + 1):(end - 4)), ', ',...
    spk_file((max(findstr(spk_file, filesep)) + 1):(end - 4))]; 

set(gcf,'NumberTitle', 'off', 'Name', fig_name);

%%% Add a legend %%%

%% re-reference entire figure
set(gcf, 'CurrentAxes', whole_fig);

legend_l = 0.5;
%legend_u = 1 - (raster_u_buff / 2);
legend_u = ax_psth_event1_u + ax_psth_event1_h + (ax_psth_event1_vbuff / 2);

legend_string = 'Ipsi - gray; Contra - black; Choice - solid; No-choice - dashed';
text(legend_l, legend_u, legend_string, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Middle');


return