%% TrialClassification_dispatcher
% Behavioral trials collected with the Dispatcher system are classified
% according to stimulus, choice, and correct/error with respect to
% the current trial (by default), or any number of trials in the past.
%
% USAGE: [raster_events, stim_params] = TrialClassification_dispatcher(taskbase, trial_events, num_trials_back)
% EXAMPLE: [raster_events, stim_params] = TrialClassification_Solo_gt(tb1, te);
%
% INPUTS:  taskbase - the structure created by disp2taskbase, containing
%              timing of task events
%          trial_events - structure w/ the names of the trial events to
%              find the timings of (corresponding to fieldnames of taskbase structure)
%          num_trials_back (OPTIONAL) - the number of trials in the past
%              by which to classify trials - useful for looking at
%              retrospective encoding. This must be a positive number.
%
%
% OUTPUTS: raster_events - for each type of trial (e.g., 'L pure odor
%              A'), contains the trial start time (relative to the session start) and
%              the timing of all task events (OdorPokeIn, OdorValveOn ('DIO'),
%              OdorPokeOut, WaterPokeIn, and WaterValveOn ('WaterDeliv')). The cell
%              number corresponds to the stimulus number (e.g., the second stim may be
%              80% odor A).
%          stim_params - contains fields:
%              odor_names: % what the odors were called in the protocol GUI (e.g., '-80', or '20')
%              reward_side: 1 - reward at L; 2 - reward at R; 1.5 - reward at L and R (50-50)
%
%
% SEE ALSO: TrialClassification_[xx], written for the solo system.
%
% 11/30/12 - GF
% Original TrialClassification written 5/19/08 - GF

function [raster_events, stim_params] = TrialClassification_dispatcher(taskbase, trial_events, num_trials_back)

if nargin < 3 % if we want to look at the current trial
    num_trials_back = 0;
end

if num_trials_back < 0
    error('num_trials_back must be >= 0');
end

% if the taskbase does not have fields for any of the trial events, set the
% values for those fields to NaN
for trial_events_ind = 1:length(trial_events)
    fname = trial_events{trial_events_ind};
    if ~isfield(taskbase, fname)
        taskbase.(fname) = NaN * ones(size(taskbase.start));
    end
end
%% Hack for forced-free protocol
% IF YOU'RE USING ANY PROTOCOL OTHER THAN FORCED-FREE, PLEASE IGNORE THIS
% SECTION OF CODE! MJL
% Check to see if using ForcedFree protocol

[pathstr, name, ext] = fileparts(taskbase.expid);
protocol_check = strfind(name, 'ForcedFree');

if isempty(protocol_check)
    protocol_check = 0;
end

if protocol_check >0;
    
    % Determines if session completed in top or bottom box
    % The probability at Valve7, the 50/50 valve,changes depending on whether
    % the animal is in a forced choice portion of the task or free choice
    % portion of the task.
    
    if range(taskbase.Valve7A) == 1
        nochoice = taskbase.Valve7A; % probability of reward at Valve 7 in top box
    elseif range(taskbase.Valve7A) == 0
        nochoice = taskbase.Valve7B; % probability of reward at Valve 7 in bottom box
    end
    
    
%     %AT 5/28/19 - putting below in here in case I have continued problems
%     %with the classifier pertaining to the FR comparisons
%     if range(taskbase.Valve7A) > 0 && range(taskbase.Valve7B) == 0
%         nochoice = taskbase.Valve7A; % probability of reward at Valve 7 in top box
%     elseif range(taskbase.Valve7B) > 0 && range(taskbase.Valve7A) == 0
%         nochoice = taskbase.Valve7B; % probability of reward at Valve 7 in bottom box
%     elseif range(taskbase.Valve7B) == 0 && range(taskbase.Valve7A) == 0 
%         nochoice = [];
%    %         error('ERROR')
%     end    
    
    
    % Add additional fields to taskbase.stimID so that 50/50 trials during the
    % forced choice portion of the task may be differentiated from 50/50 trials
    % during the no choice portion of the task. Also box dependent
    if any(taskbase.stimID == 1)
        taskbase.stimID(nochoice == 1) = 8;
        taskbase.stimID(nochoice == 0) = 9;
    elseif any(taskbase.stimID == 8)
        taskbase.stimID(nochoice == 1) = 15;
        taskbase.stimID(nochoice == 0) = 16;
    end
    
    % Adds additional odor fields to taskbase.odor_params.odors
    taskbase.odor_params.odors = cell2mat(taskbase.odor_params.odors);
    if any(taskbase.stimID ==1)
        taskbase.odor_params.odors(1,8:end) = 0;
        taskbase.odor_params.odors(1,10:end) = nan;
    elseif any(taskbase.stimID == 8)
        taskbase.odor_params.odors(1,1:7) = 0;
        taskbase.odor_params.odors(1,1:7) = nan;
        taskbase.odor_params.odors(1,15:16) = 0;
    end
    
    % Determine which odor mixtures were used in the session.
    % Note that this is where we'd also want to start grouping trials by delay length,
    % but the current version of this code doesn't do that. See
    % TrialClassification_Solo_gt_mixratio.m for the most recent version of
    % the code to do that.
    
    stim_ids = unique(taskbase.stimID);
    
    taskbase.odor_params.L_prob = [taskbase.odor_params.L_prob, 0, 1];
    taskbase.odor_params.R_prob = [taskbase.odor_params.R_prob, 1, 0];
    taskbase.odor_params.L_prob(1,14) = .5;
    taskbase.odor_params.R_prob(1,14) = .5;
    
    % get the names (entered into the protocol GUI) corresponding to these stim_ids
    stim_params.odor_names = taskbase.odor_params.odors(stim_ids);  % removed cell2mat -MJL
    stim_params.reward_side = taskbase.odor_params.L_prob(stim_ids) + (2 *taskbase.odor_params.R_prob(stim_ids));
    
elseif protocol_check == 0;
    
    %% Determine which odor mixtures were used in the session.
    %% Note that this is where we'd also want to start grouping trials by delay length,
    %% but the current version of this code doesn't do that. See
    %% TrialClassification_Solo_gt_mixratio.m for the most recent version of
    %% the code to do that.
    
    stim_ids = unique(taskbase.stimID);
    
    % get the names (entered into the protocol GUI) corresponding to these stim_ids
    stim_params.odor_names = cell2mat(taskbase.odor_params.odors(stim_ids));
    stim_params.reward_side = taskbase.odor_params.L_prob(stim_ids) + (2 *taskbase.odor_params.R_prob(stim_ids));
end
%% For each stimulus, deconstruct the trial

stim_ind = 0; % initialize

for i = 1:length(stim_ids)
    
    current_stim = stim_ids(i); % which stim_id we're using at this pass through the loop
    stim_ind = stim_ind + 1; % a counter (necessary because stim_ids may not be [1:n])
    
    % Trials in which rat went L
    
    contingencies =...
        (taskbase.stimID == current_stim) &...
        (taskbase.choice == 1);
    
    %% Find the times corresponding to the num_trials_back trial (in the FUTURE).
    %% Therefore, the activity will be referenced to those times, and/but grouped by what
    %% the stimulus and choice was on the num_trials_back trial in the PAST.
    %% Note that if you want to reference to the CURRENT trial (the normal
    %% case), num_trials_back = 0.
    contingencies = find(contingencies) + num_trials_back;

    if ~isempty(contingencies) % verify that there are some trials of this type

        % make sure we don't try to get the times of the (non-existent)
        % trial after the last trial
        if contingencies(end) > length(taskbase.start_nlx)
            contingencies = contingencies(1:max(find(contingencies <= length(taskbase.start_nlx))));
        end

    end

    if ~isempty(contingencies) > 0 % AGAIN make sure there are some trials of this type
                                  % (after possibly eliminating trials from the end)

        % find trial start
        raster_events.L.trial_start{stim_ind} = taskbase.start_nlx(contingencies);

        % find times of trial events
        for trial_events_ind = 1:length(trial_events)
            event_times = getfield(taskbase, trial_events{trial_events_ind});
            raster_events.L.trial_events_time{stim_ind}(trial_events_ind, :) = event_times(contingencies);
        end
        
    else % if there are no trials of this type
        
        raster_events.L.trial_start{stim_ind} = [];
        raster_events.L.trial_events_time{stim_ind} = ones(length(trial_events), 0);

    end
    
    
    % Trials in which rat went R
    
    contingencies =...
        (taskbase.stimID == current_stim) &...
        (taskbase.choice == 2);
    
    %% Find the times corresponding to the num_trials_back trial (in the FUTURE).
    %% Therefore, the activity will be referenced to those times, and/but grouped by what
    %% the stimulus and choice was on the num_trials_back trial in the PAST.
    %% Note that if you want to reference to the CURRENT trial (the normal
    %% case), num_trials_back = 0.
    contingencies = find(contingencies) + num_trials_back;

    if ~isempty(contingencies) % verify that there are some trials of this type

        % make sure we don't try to get the times of the (non-existent)
        % trial after the last trial
        if contingencies(end) > length(taskbase.start_nlx)
            contingencies = contingencies(1:max(find(contingencies <= length(taskbase.start_nlx))));
        end

    end

    if ~isempty(contingencies) > 0 % AGAIN make sure there are some trials of this type
                                  % (after possibly eliminating trials from the end)

        % find trial start
        raster_events.R.trial_start{stim_ind} = taskbase.start_nlx(contingencies);

        % find times of trial events
        for trial_events_ind = 1:length(trial_events)
            event_times = getfield(taskbase, trial_events{trial_events_ind});
            raster_events.R.trial_events_time{stim_ind}(trial_events_ind, :) = event_times(contingencies);
        end
        
    else % if there are no trials of this type
        
        raster_events.R.trial_start{stim_ind} = [];
        raster_events.R.trial_events_time{stim_ind} = ones(length(trial_events), 0);

    end
        
end

return
