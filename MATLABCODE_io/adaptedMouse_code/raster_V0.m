%% raster.m
%% Makes a raster plot given spike and referencing event times. Plotting
%% window should be set up externally.
%%
%% USAGE: [ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times, event_times, window, secondary_event_times, no_plot_flag)
%% EXAMPLE: [spk_times, trials_of_spikes, h_raster] = raster(spk_times, TrialStart, WaterValveOn, [-2 2]);
%%
%% INPUTS:  spike_times - times of spikes (IN SECONDS)
%%          trial_start_times - 1xN vector of trial start stimes (IN SECONDS) (often
%%              saved as TrialStart from behavioral protocols); N = number
%%              of trials
%%          event_times - 1xN vector of times of events to reference spikes to (e.g.,
%%              WaterPokeIn), relative to trial start (IN SECONDS)
%%          window - 2x1 vector of times to rasterize spikes, relative to
%%              event_times ([START STOP]) (e.g., [-1 1])
%%          secondary_event_times - RxN secondary events to plot (e.g., water valve on)
%%              (R = # of secondary events to plot) (optional)
%%          no_plot_flag - if nonzero, the rasters are not plotted
%%
%% OUTPUTS: ref_spike_times - spike times referenced to trial event
%%          trial_inds - trials in which corresponding ref_spike_times
%%          occured
%%          plot_handles - graphics handle to raster plot; contains fields
%%              .spikes and .secondary_events (if any)
%%
%% Based on N. Uchida's raster2. Spikes are plotted with line fcn.
%% Output is used for PSTH.m.
%%
%% SEE ALSO: PSTH
%%
%% 3/20/06 - GF
% $ Update - plotted raster corresponds to inputted window, but the returned raster
% $ and event times is padded by 0.5 sec. on either side, so that this padded raster
% $ can be inputted to psth.m, where only the 'valid' part of the smoothed psth is plotted - 9/15/06 GF $
%
% $ Update - no longer excludes the last trial (which was a legacy bug - 2/20/14 GF $


function [ref_spike_times, trial_inds, plot_handles] =...
    raster(spike_times, trial_start_times, event_times, window, secondary_event_times, no_plot_flag)

GetPhysioGlobals;
global RESOLUTION;

TICK_LENGTH = 1; % length of tick marks for spikes
SPIKE_TICK_WIDTH = 0.5; % width of lines marking spikes
EVENT_TICK_WIDTH = 2; % width of lines marking secondary events (e.g., odor poke out)

if isempty(trial_start_times) % if there are no trials, return empty matrices
    ref_spike_times = [];
    trial_inds = [];
    plot_handles.spikes = [];
    plot_handles.secondary_events = [];
    return;
end

if nargin < 5
    secondary_event_times = [];
end

if nargin < 6
    no_plot_flag = 0; % default is to plot
end

%% expand the window on either side to account for smoothing performed by psth
%% plotting
window(1) = window(1) - ((RESOLUTION/1000)/2);
window(2) = window(2) + ((RESOLUTION/1000)/2);


% initialize
ref_spike_times = [];
trial_inds = [];

for trial_num = 1:length(trial_start_times)
    
    ref_time = trial_start_times(trial_num) + event_times(trial_num); % absolute time of event to reference spikes to
    
    if ~isnan(ref_time) % ref_time will be NaN if the particular event did not occur in this trial
        
        trial_spike_times = spike_times(find((spike_times >= (ref_time + window(1))) &...
            (spike_times <= (ref_time + window(2))))) - ref_time;
        
        ref_spike_times = [ref_spike_times; trial_spike_times(:)];
        trial_inds = [trial_inds; (ones(length(trial_spike_times), 1) * trial_num)];
                
    end
    
end

%% Calculate the optional secondary event times (e.g., water valve on) w/ r.t. the
%% reference time, in order to label the times in the raster
if size(secondary_event_times, 1) > 0

    for secondary_event_ind = 1:size(secondary_event_times, 1)

        ref_secondary_event_times(:, secondary_event_ind) = secondary_event_times(secondary_event_ind, :) - event_times;
        
    end
    
end


%% Plot the raster - note that trials are plotted "upside down" and then
%% relabeled, so that the first trial is on top

if no_plot_flag == 0 % do the plotting

    % spikes  (plot first, so secondary events are overlaid)
    plot_handle_spikes = line([ref_spike_times'; ref_spike_times'], [(-trial_inds' - (TICK_LENGTH / 2)); (-trial_inds' + (TICK_LENGTH / 2))],...
        'Color', [0 0 0], 'LineWidth', SPIKE_TICK_WIDTH);

    % secondary events
    if size(secondary_event_times, 1) > 0
        for secondary_event_ind = 1:size(ref_secondary_event_times, 2)

            plot_handle_sec_events(:, secondary_event_ind) =...
                line([ref_secondary_event_times(:, secondary_event_ind)'; ref_secondary_event_times(:, secondary_event_ind)'],...
                [(-(1:length(trial_start_times)) - (TICK_LENGTH / 2)); (-(1:length(trial_start_times)) + (TICK_LENGTH / 2))],...
                'Color', [0.7 0.7 0.7], 'LineWidth', EVENT_TICK_WIDTH);

        end
    end

    %% Note that only the initially inputted window range is displayed
    if length(event_times) > 2 % when <2, YTicks can't mark "middle" trial

        set(gca, 'YLim', [(-length(event_times) - 1) 0],...
            'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
            'YTick', [-length(event_times) -1],...
            'YTickLabel', [length(event_times) 1],...
            'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
            'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
            );

    elseif length(event_times) == 2

        set(gca, 'YLim', [(-length(event_times) - 1) 0],...
            'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
            'YTick', [-length(event_times) -1],...
            'YTickLabel', [length(event_times) 1],...
            'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
            'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
            );

    elseif length(event_times) == 1

        set(gca, 'YLim', [(-length(event_times) - 1) 0],...
            'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
            'YTick', [-1],...
            'YTickLabel', [1],...
            'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
            'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
            );

    end

    %% package plot handles for returning
    plot_handles.spikes = plot_handle_spikes;
    if size(secondary_event_times, 1) > 0
        plot_handles.secondary_events = plot_handle_sec_events;
    end

else % return empty structures for the plot handles
    
    plot_handles.spikes = [];
    plot_handles.secondary_events = [];
    
end

return