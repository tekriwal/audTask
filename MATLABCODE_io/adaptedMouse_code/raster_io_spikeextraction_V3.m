%Line 92/93 are key
%AT 4/26/20 - changed name to 'raster_io_spikeextraction_V1' and added
%ability to do some offsets

%AT 4/25/20; created the fx 'raster_io_burstAnalysis_V2' in order to
%generate a struct amenable to burst analysis. Trying to do the whole
%trial, so from event 2 (pushedUP) until feedback (event 7)




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


function [ref_spike_times, trial_inds, plot_handles, spikestruct] =...
    raster_io_spikeextraction_V3(NUM_TRIALS_TO_PLOT, spike_times, trial_start_times, epochInfo, window, secondary_event_times, waveformfeatures, waveform)




upPressed_times = secondary_event_times(2,:);
stimDelivered_times = secondary_event_times(3,:);
goCue_times = secondary_event_times(4,:);
leftUP_times = secondary_event_times(5,:);
submitsResponse_times = secondary_event_times(6,:);
feedback_times = secondary_event_times(7,:);















GetPhysioGlobals_io_V1;
global RESOLUTION;

TICK_LENGTH = 1; % length of tick marks for spikes
SPIKE_TICK_WIDTH = 0.2; % width of lines marking spikes
EVENT_TICK_WIDTH = 2; % width of lines marking secondary events (e.g., odor poke out)

if isempty(trial_start_times) % if there are no trials, return empty matrices
    ref_spike_times = [];
    trial_inds = [];
    plot_handles.spikes = [];
    plot_handles.secondary_events = [];
    return;
end

if nargin < 6
    secondary_event_times = [];
end

%AT 4/26/20; for burst struct purposes we do not want to plot things
% if nargin < 7
%     no_plot_flag = 0; % default is to plot
% end
no_plot_flag = 1;


%% expand the window on either side to account for smoothing performed by psth
%% plotting
window(1) = window(1) - ((RESOLUTION/1000)/2);
window(2) = window(2) + ((RESOLUTION/1000)/2);


% initialize
ref_spike_times = [];
trial_inds = [];
ref_spike_times_train = [];
ref_waveforms_times = [];



for epoch_ind = 1:length(epochInfo.epochs)
    ref_time1 = eval(epochInfo.epochs{epoch_ind, 1});    %this is the first event in the epoch
    ref_time1_offset = epochInfo.epochs{epoch_ind, 2};  %this is the offset for the above
    
    ref_time2 = eval(epochInfo.epochs{epoch_ind, 3});      %this is the first event in the epoch
    ref_time2_offset = epochInfo.epochs{epoch_ind, 4};  %this is the offset for the above
    
    epochTimes = zeros(length(trial_start_times), 2);
    for trial_num = 1:length(trial_start_times)
        %AT 4/26/20 editting below so that ref_time is now ref_time_start,
        %conveys start of epoch we're interested in (already was doing this),
        %and importantly adding ref_time_end
        ref_time_start = trial_start_times(trial_num) + ref_time1(trial_num) + (ref_time1_offset); % absolute time of event to reference spikes to
        ref_time_end = trial_start_times(trial_num) + ref_time2(trial_num) + (ref_time2_offset); % absolute time of event to reference spikes to
        
        %AT adding below 6/20 to save out info to be used in LFP analyses
        epochTimes(trial_num,1) = ref_time_start;
        epochTimes(trial_num,2) = ref_time_end;
        
        if ~isnan(ref_time_start) % ref_time will be NaN if the particular event did not occur in this trial
            
            %AT 4/26/20, note that I've editted the below so that it suits out
            %purpose of chopping out the times per trial from pushedUP until
            %feedback
            trial_spike_times = spike_times(find((spike_times >= (ref_time_start)) &...
                (spike_times <= ref_time_end))) - ref_time_start;
            
            ref_spike_times = [ref_spike_times; trial_spike_times(:)];
            ref_spike_times_train{trial_num} = trial_spike_times(:);
            ref_spike_times_FR{trial_num} = length(trial_spike_times)/((ref_time2(trial_num) + (ref_time2_offset)) - (ref_time1(trial_num) + (ref_time1_offset)));
            
            
            trial_inds = [trial_inds; (ones(length(trial_spike_times), 1) * trial_num)];
            
            trial_waveformfeatures = waveformfeatures((find((spike_times >= (ref_time_start)) &...
                (spike_times <= ref_time_end))),:);
            
            waveformfeatures_times{trial_num} = trial_waveformfeatures;

            
            trial_waveform = waveform(:, find((spike_times >= (ref_time_start)) &...
                (spike_times <= ref_time_end)));
            
            waveform_times{trial_num} = trial_waveform;            
            %             waveformfeatures_pertrial = waveformfeatures(find((spike_times >= (ref_time_start)) &...
            %                 (spike_times <= ref_time_end)));
            %
            %             ref_waveforms_times = [ref_waveforms_times; waveformfeatures_pertrial;
            %
            
            
        end
        
    end
    
    spikestruct.(epochInfo.epochNames{epoch_ind}).spiketrain = ref_spike_times_train;
    spikestruct.(epochInfo.epochNames{epoch_ind}).FR = ref_spike_times_FR;
    spikestruct.(epochInfo.epochNames{epoch_ind}).waveformfeatures_times = waveformfeatures_times;
    
    %AT added below output on 6/20
    spikestruct.(epochInfo.epochNames{epoch_ind}).epochTimes = epochTimes;
    
    
    
    
    % %% Calculate the optional secondary event times (e.g., water valve on) w/ r.t. the
    % %% reference time, in order to label the times in the raster
    % if size(secondary_event_times, 1) > 0
    %
    %     for secondary_event_ind = 1:size(secondary_event_times, 1)
    %
    %         ref_secondary_event_times(:, secondary_event_ind) = secondary_event_times(secondary_event_ind, :) - event_times;
    %
    %     end
    %
    % end
    
    
    %% Plot the raster - note that trials are plotted "upside down" and then
    %% relabeled, so that the first trial is on top
    
    if no_plot_flag == 0 % do the plotting
        
        
        if max(trial_inds) < NUM_TRIALS_TO_PLOT
            delta= NUM_TRIALS_TO_PLOT - max(trial_inds);
            
            addendum = zeros(delta, 1);
            ref_spike_times_added = [ref_spike_times; addendum];
            
            addendum = (max(trial_inds)+1):NUM_TRIALS_TO_PLOT;
            trial_inds_added = [trial_inds;addendum'];
            
            
            %         spike_times =
            
            addendum = zeros(delta, 1);
            trial_start_times_added = [trial_start_times; addendum];
            
            addendum = zeros(delta, 1);
            event_times_added = [event_times, addendum'];
            %         window
            
            addendum = zeros(7, delta);
            secondary_event_times_added = [secondary_event_times, addendum];
            
            
            addendum = zeros(delta, 7);
            ref_secondary_event_times_added = [ref_secondary_event_times; addendum];
            
        else
            
            ref_spike_times_added = ref_spike_times;
            
            trial_inds_added = trial_inds;
            
            %         spike_times =
            
            trial_start_times_added = trial_start_times;
            
            event_times_added = event_times;
            %         window
            
            secondary_event_times_added = secondary_event_times;
            
            ref_secondary_event_times_added = ref_secondary_event_times;
        end
        
        
        
        % spikes  (plot first, so secondary events are overlaid)
        plot_handle_spikes = line([ref_spike_times_added'; ref_spike_times_added'], [(-trial_inds_added' - (TICK_LENGTH / 2)); (-trial_inds_added' + (TICK_LENGTH / 2))],...
            'Color', [0 0 0], 'LineWidth', SPIKE_TICK_WIDTH);
        
        % secondary events
        if size(secondary_event_times_added, 1) > 0
            for secondary_event_ind = 1:size(ref_secondary_event_times_added, 2)
                
                plot_handle_sec_events(:, secondary_event_ind) =...
                    line([ref_secondary_event_times_added(:, secondary_event_ind)'; ref_secondary_event_times_added(:, secondary_event_ind)'],...
                    [(-(1:length(trial_start_times_added)) - (TICK_LENGTH / 2)); (-(1:length(trial_start_times_added)) + (TICK_LENGTH / 2))],...
                    'Color', [0.7 0.7 0.7], 'LineWidth', EVENT_TICK_WIDTH);
                
            end
        end
        
        %% Note that only the initially inputted window range is displayed
        if length(event_times_added) > 2 % when <2, YTicks can't mark "middle" trial
            
            set(gca, 'YLim', [(-length(event_times_added) - 1) 0],...
                'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
                'YTick', [-length(event_times_added) -1],...
                'YTickLabel', [length(event_times_added) 1],...
                'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
                'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
                );
            
        elseif length(event_times_added) == 2
            
            set(gca, 'YLim', [(-length(event_times_added) - 1) 0],...
                'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
                'YTick', [-length(event_times_added) -1],...
                'YTickLabel', [length(event_times_added) 1],...
                'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
                'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
                );
            
        elseif length(event_times_added) == 1
            
            set(gca, 'YLim', [(-length(event_times_added) - 1) 0],...
                'XLim', [(window(1) + ((RESOLUTION/1000)/2)) (window(2) - ((RESOLUTION/1000)/2))],...
                'YTick', [-1],...
                'YTickLabel', [1],...
                'XTick', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))],...
                'XTickLabel', [(window(1) + ((RESOLUTION/1000)/2)) 0 (window(2) - ((RESOLUTION/1000)/2))]...
                );
            
        end
        
        %% package plot handles for returning
        plot_handles.spikes = plot_handle_spikes;
        if size(secondary_event_times_added, 1) > 0
            plot_handles.secondary_events = plot_handle_sec_events;
        end
        
    else % return empty structures for the plot handles
        
        plot_handles.spikes = [];
        plot_handles.secondary_events = [];
        
    end
    
    
end
return