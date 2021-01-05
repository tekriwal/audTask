%% CellSummary
% Makes rasters/psths for a single cell, separately for different trial types
% (e.g., odor mixtures, L/R choice).
%
% USAGE: [fig_handle, raster_info] = CellSummary(behav_file, spk_file, align_ind, window,...
%      num_trials_back, trials_to_include)
% EXAMPLE: h = CellSummary_gt(behav_fname, spk_fname, 3, [-2 1], 0, [1:145]);
%
% INPUTS:  behav_file - path and filename of ratbase file
%          spk_file - path and filename of spike file
%          align_ind - which trial event to align rasters/psth to (indicated in 
%              GetPhysioGlobals_human.m):
            % TRIAL_EVENTS.pushedUP = 1;
            % TRIAL_EVENTS.gocue = 2;
            % TRIAL_EVENTS.leftUP = 3;
            % TRIAL_EVENTS.submitsResponds = 4;
            % TRIAL_EVENTS.feedback = 5;
%          window - 2x1 vector of times in which to rasterize spikes, relative to
%              event_times ([START STOP]) (e.g., [-1 1])
%          num_trials_back (OPTIONAL) - positive integer; how many trials in
%               the past to group contingencies by - useful for determining
%               whether activity depends on contingencies of previous trial
%               (Default: 0 (i.e., group by current trial))
%          trials_to_include - which behavioral trials to include in
%               analysis (OPTIONAL, default includes all trials)
%               Note: if using trials_to_include, you must include a value
%               for num_trials_back
%
% OUTPUTS: fig_handle - handle to figure of rasters, psths
%          raster_info - structure containing info capable of
%              reconstructing rasters
%
% Adapted from CellSummary for use w/ go tone data.  Differs in that trials are grouped by
% response (L/R), mixture ratio, and go tone
% delay.
%
% Original version: GF, 2007
% Major updates:
% $ 12/2012 and 4/2013 - adapted version of CellSummary_gt that John
% Thompson was using to general lab use; added num_trials_back to group trials according to
% contingencies on previous trials; note that trials_to_include has been
% removed (but should possibly be reincorporated in order to restrict
% analysis to specific trials (using a form of RestrictSession.m))

function [fig_handle, raster_info] = CellSummary(behav_file, spk_file, align_ind, window,...
    num_trials_back, trials_to_include)

%% Determine whether the optional inputs were entered

if nargin < 5 % if we want to look at the current trial
    num_trials_back = 0;
end


%% Get some global variables and set some constants

GetPhysioGlobals_human; % accesses global variables associated with physiology/behavior data
global RESOLUTION; % this is set to 1000 to plot spike times to 1 msec resolution
global TRIAL_EVENTS;

% minimum number of trials required to plot psth (otherwise the PSTHs are too noisy)
MIN_TRIAL_PLOTS = 6; 

% set the width of the gaussian used to smooth PSTHs
PSTH_SMOOTH_FACTOR = (window(2) - window(1)) * 5; 


%%% Load spike file, convert time time in seconds
load(spk_file);

%% determine the variable name in which timestamps are saved
spk_var_name = who('-file', spk_file);
if length(spk_var_name) ~= 1
    error('The spike file must contain exactly 1 variable (corresponding to the spike timestamps)');
end

raw_timestamps = eval(spk_var_name{1});

%% Figure out what unit the raw timestamps are in, and therefore what to
%% divide by in order to obtain spike times in seconds. Assume that
%% recording sessions are somewhere between 5 minutes and 500 minutes long.
if range(raw_timestamps) >= 3 * 10^8 % timestamps are in units of 1 microsecond (e.g., the .ntt file from nlx)
    spike_times = raw_timestamps / 10^6;
else % assume timestamps are in units of 100 microseconds (e.g., the output of mclust)
    spike_times = raw_timestamps / 10^4;
end


%%% Load behavioral file
load(behav_file);

if exist('trials_to_include') % don't include all trials
    taskbase = RestrictSession(taskbase, trials_to_include);
end


%% set up display figure
PresentationFigSetUp;
fig_handle = gcf;


%% Get times of events for each trial type

%% Define the trial events of interest; these correspond to fields of taskbase structure.
% Get these from the GetPhysioGlobals definition, but rename some to be
% compatible with taskbase fieldnames.
% Note that these are not chronological, b/c GoSignal was added later.
trial_events = fieldnames(TRIAL_EVENTS);
% trial_events{2} = 'DIO'; %DIO is OdorValveOn
% trial_events{5} = 'WaterDeliv'; %WaterDeliv is WaterValveOn
% trial_events{8} = 'cue'; %cue is GoSignal


[raster_events, stim_params] = TrialClassification_dispatcher(taskbase, trial_events, num_trials_back);

%% determine the total number of (performed) trials
num_stim = length(raster_events.L.trial_start);
total_num_trials = 0; % initialize
for stim_num = 1:num_stim
    total_num_trials = total_num_trials + length(raster_events.L.trial_start{stim_num}) + length(raster_events.R.trial_start{stim_num});
end


%% Raster display setup constants
raster_l = 0.12;
raster_w = 0.8;
raster_u_buff = 0.033;
total_rasters_h = 0.72; % fraction of total figure height to devote to rasters
intrastim_space = 0.005;
intrachoice_space = intrastim_space / 3;
available_rasters_h = total_rasters_h - (((num_stim - 1) * intrastim_space) + (num_stim * intrachoice_space)); 
textbuff = 0.04;


%% choice bar setup constants
choicebar_hor_buff = 0.01;
choicebar_w = 0.005;
choicebar_l = raster_l - (choicebar_hor_buff + choicebar_w);

raster_u = 1 - raster_u_buff; % initialize


%% Loop through the trial types, organizing by "lowest" to "highest"
%% mixture (e.g., 5 through 95, or -95 through 95, depending on the naming
%% convention used when running the behavioral protocol)

[tmp, display_order] = sort(stim_params.odor_names);

for i = 1:num_stim
    
    stim_num = display_order(i);
    
    % L trials
    
    % determine height of raster window
    num_trials = length(raster_events.L.trial_start{stim_num});
    raster_h = (num_trials / total_num_trials) * available_rasters_h;
    raster_u = raster_u - (raster_h + intrastim_space);
    
    trial_start_L = raster_events.L.trial_start{stim_num};
    align_event_time_L = raster_events.L.trial_events_time{stim_num}(align_ind, :);
    secondary_event_time_L = raster_events.L.trial_events_time{stim_num};
    
    raster_pos = [raster_l raster_u raster_w raster_h];
    
    if num_trials > 0 % make sure there are trials of this type
        
        % Label mixture ratio
        set(gcf, 'CurrentAxes', whole_fig); % re-reference whole figure
        text(raster_l - textbuff, raster_u + raster_h/2, num2str(stim_params.odor_names(stim_num)));

        axes('Position', raster_pos);
        
        [ref_spike_times.L{stim_num}, trial_inds.L{stim_num}, plot_handle] =...
            raster(spike_times, trial_start_L, align_event_time_L, window, secondary_event_time_L);
        
        set(gca, 'XTick', [], 'YTick', []);
        
        % Change colors of secondary event symbols
        for sec_event_ind = 1:size(SECONDARY_EVENTS_COLORS, 1)
            set(plot_handle.secondary_events(:, sec_event_ind), 'Color', SECONDARY_EVENTS_COLORS(sec_event_ind, :));
        end
        
        % On the first time through this loop, add the plot title
        if i == 1
            title(spk_file);
        end
        
        % make a color bar showing choice
        col = RASTER_COLORS.L;
        choicebar_pos = [choicebar_l raster_u choicebar_w raster_h];
        h = axes('Position', choicebar_pos);
        set(h, 'Color', col, 'XColor', col, 'YColor', col);
        set(h, 'YTick', [], 'XTick', []);
        
    else
        
        ref_spike_times.L{stim_num} = [];
        trial_inds.L{stim_num} = [];
        
    end
    
% R trials
    
    % determine height of raster window
    num_trials = length(raster_events.R.trial_start{stim_num});
    raster_h = (num_trials / total_num_trials) * available_rasters_h;
    raster_u = raster_u - (raster_h + intrachoice_space);
    
    trial_start_R = raster_events.R.trial_start{stim_num};
    align_event_time_R = raster_events.R.trial_events_time{stim_num}(align_ind, :);
    secondary_event_time_R = raster_events.R.trial_events_time{stim_num};
    
    raster_pos = [raster_l raster_u raster_w raster_h];
    
    if num_trials > 0 % make sure there are trials of this type
        
        % Label mixture ratio
        set(gcf, 'CurrentAxes', whole_fig); % re-reference whole figure
        text(raster_l - textbuff, raster_u + raster_h/2, num2str(stim_params.odor_names(stim_num)));

        axes('Position', raster_pos);
        
        [ref_spike_times.R{stim_num}, trial_inds.R{stim_num}, plot_handle] =...
            raster(spike_times, trial_start_R, align_event_time_R, window, secondary_event_time_R);
        
        set(gca, 'XTick', [], 'YTick', []);
        
        % Change colors of secondary event symbols
        for sec_event_ind = 1:size(SECONDARY_EVENTS_COLORS, 1)
            set(plot_handle.secondary_events(:, sec_event_ind), 'Color', SECONDARY_EVENTS_COLORS(sec_event_ind, :));
        end
        
        % make a color bar showing choice
        col = RASTER_COLORS.R;
        choicebar_pos = [choicebar_l raster_u choicebar_w raster_h];
        h = axes('Position', choicebar_pos);
        set(h, 'Color', col, 'XColor', col, 'YColor', col);
        set(h, 'YTick', [], 'XTick', []);
        
    else
        
        ref_spike_times.R{stim_num} = [];
        trial_inds.R{stim_num} = [];
        
    end
    
    
end

%% PSTHS

psth_l = raster_l;
psth_w = raster_w;
psth_h = 0.15;
psth_vertbuff = 0.01;
psth_u = raster_u - psth_h - psth_vertbuff;
psth_pos = [psth_l psth_u psth_w psth_h];

% h = axes('Position', psth_pos);
axes('Position', psth_pos);

hold on;

init_psth_window = window + [-((RESOLUTION/1000)/2) +((RESOLUTION/1000)/2)]; %b/c raster output has been padded

%% L & R Trials
for stim_num = 1:num_stim
    
    % L trials
    
    if max(trial_inds.L{stim_num}) >= MIN_TRIAL_PLOTS % make sure there are enough trials of this type to plot
        no_plot_flag = 0;
    else
        no_plot_flag = 1;
    end
    
    [ref_psth.L{stim_num}, plot_handle] = psth(ref_spike_times.L{stim_num}, trial_inds.L{stim_num},...
        init_psth_window, PSTH_SMOOTH_FACTOR, no_plot_flag);
    set(plot_handle, 'Color', RASTER_COLORS.L);
    
    
    % R trials
    
    if max(trial_inds.R{stim_num}) >= MIN_TRIAL_PLOTS % make sure there are enough trials of this type to plot
        no_plot_flag = 0;
    else
        no_plot_flag = 1;
    end
    
    [ref_psth.R{stim_num}, plot_handle] = psth(ref_spike_times.R{stim_num}, trial_inds.R{stim_num},...
        init_psth_window, PSTH_SMOOTH_FACTOR, no_plot_flag);
    set(plot_handle, 'Color', RASTER_COLORS.R);
    
    
    xlabel(['Time relative to ', trial_events{align_ind}, ' (s)']);
    ylabel('Firing rate (spks/s)');
    
end


%% package output structure

raster_info.ref_spike_times = ref_spike_times;
raster_info.trial_inds = trial_inds;
raster_info.raster_events = raster_events;
raster_info.stim_params = stim_params;
raster_info.align_ind = align_ind;
raster_info.window = window;

return