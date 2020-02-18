%% psth.m
%% Plots and returns a psth. Plotting window should be set up externally.
%%
%% USAGE: [ref_psth, plot_handle, psth_info] = psth(ref_spike_times, trial_inds, window, smoothing_factor, no_plot_flag)
%% EXAMPLE: L_psth = psth(spk_times, trials_of_spikes, raster_window)
%%
%% INPUTS:  ref_spike_times - spike times referenced to trial event (output
%%              from raster.m)
%%          trial_inds - trials in which corresponding ref_spike_times
%%              occured (output from raster.m)
%%          window - 2x1 vector of times to rasterize spikes, relative to
%%              event_times ([START STOP]) (e.g., [-1 1]) - must be same as
%%              window inputted to raster.m
%%          smoothing_factor - width of gaussian smoother for plotted psth,
%%              in msec (default = 50)
%%          no_plot_flag - if nonzero, the rasters are not plotted
%%          total_num_trials - the total number of trials: useful if there
%%              are trials that have no spikes, particularly at the end of the
%%              session (OPTIONAL)
%%
%% OUTPUTS: ref_psth - unsmoothed psth
%%          plot_handle - graphics handle to psth plot
%%          psth_info - structure w/ other useful output:
%%              .ste - standard error of the mean
%%
%% Many of the inputs to this function are the outputs of raster.m.
%% If there are no spikes for a particular trial, this is faithfully
%% registered AS LONG AS ITS NOT THE LAST TRIAL (b/c this file doesn't
%% 'know' how many trials there are, unless explicitly told (by inputting
%% total_num_trials).
%%
%% SEE ALSO: RASTER
%%
%% 3/20/06 - GF
%
% $ Update - smoothing function uses 'valid' shape parameter,
% $ and only the valid part of the smoothed psth is plotted.
% $ Generally, the referenced spike times should already be padded to account
% $ for only the valid part of the smoothed psth being plotted - 9/15/06 GF $
%
% $ Update - Spike times outside of desired window are ignored - 12/27/07 GF $
%
% $ Update - total_num_trials input added; useful when plotting restricted $
% $ subsets of trials, but needing to keep track of numbers of trials -    $
% $ 1/23/08 GF                                                             $
%
% $ Update - Returns standard error of the mean of psth - 2/3/08 GF $
%
% $ Update - In info structure, returns a more useful standard error
%   of the mean of the psth: Each trial is smoothed w/ the gaussian filter,
%   then the ste is calculated across trials - 12/11/10 GF $

function [ref_psth, plot_handle, psth_info] = psth(ref_spike_times, trial_inds, window, smoothing_factor, no_plot_flag, total_num_trials)

%GetSCGlobals;
GetPhysioGlobals;
global RESOLUTION;

if nargin < 4
    
    smoothing_factor = 50; % default
    
end

if nargin < 5
    
    no_plot_flag = 0; % default is to plot
    
end

if nargin < 6
    
    total_num_trials = max(trial_inds);
    
end

%% create a raster where each row is a trial and each column corresponds to a msec
%% within that trial, throughout the window
raster_binary = zeros(max(trial_inds), ((window(2) - window(1)) * RESOLUTION));

for trial_num = 1:max(trial_inds)
    
    trial_spk_times = round((ref_spike_times(find(trial_inds == trial_num)) - window(1)) * RESOLUTION);
 
    raster_binary(trial_num, trial_spk_times((trial_spk_times > 0) & (trial_spk_times <= size(raster_binary, 2)))) = 1; % get rid of spike times outside desired window

end

%% add non-spiking trials to end (note that trial order doesn't matter for psth)
if total_num_trials > size(raster_binary, 1)
    
    raster_binary = [raster_binary; zeros((total_num_trials - size(raster_binary, 1)), size(raster_binary, 2))];
    
end

% calculate the psth (mean of raster)
ref_psth = mean(raster_binary, 1) * RESOLUTION;

% calculate the smoothed psth
smoothing_filter = fspecial('gaussian', [1 RESOLUTION], smoothing_factor); % IF THIS LINE IS CHANGED, THE PADDING IN RASTER.M AND PSTH.M MUST ALSO BE CHANGED
psth_plot = conv2(ref_psth, smoothing_filter, 'valid');
psth_info.smooth_psth = psth_plot;

% calculate the standard error of the mean of the unsmoothed psth
psth_info.ref_psth_ste = (std(raster_binary, [], 1) * RESOLUTION) / sqrt(size(raster_binary, 1));

% calculate the standard error of the mean of the smoothed psth - first
% smooth the binary raster, then get ste across trials
smoothed_raster_binary = zeros(size(raster_binary, 1), (size(raster_binary, 2) - length(smoothing_filter) + 1)); 
for trial_num = 1:size(raster_binary, 1)
    smoothed_raster_binary(trial_num, :) = conv2(raster_binary(trial_num, :), smoothing_filter, 'valid');
end
psth_info.smooth_psth_ste = (std(smoothed_raster_binary, [], 1) * RESOLUTION) / sqrt(size(smoothed_raster_binary, 1));

%% Plot results, if desired

if no_plot_flag == 0 % do the plotting

    plot_handle = plot(psth_plot);

    plot_window = window + [+((RESOLUTION/1000)/2) -((RESOLUTION/1000)/2)]; %b/c raster output has been padded

    set(gca, 'XTick', [0 round(length(psth_plot) * (-plot_window(1) / (plot_window(2) - plot_window(1)))) length(psth_plot)],...
        'XTickLabel', [plot_window(1) 0 plot_window(2)],...
        'XLim', [0 length(psth_plot)]);

else % return empty structures for the plot handles
    
    plot_handle = [];
    
end


return