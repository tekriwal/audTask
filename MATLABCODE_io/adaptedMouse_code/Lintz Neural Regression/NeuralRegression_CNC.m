 % NeuralRegression_CNC
% Multiple linear regression of firing rate during choice/no-choice task on several behavioral variables:
% -Choice on current trial: -1 = left; 0 = no choice; 1 = right
% -Choice on some previous trial (as above)
% -Trial type: -1 = no-choice; 1 = choice
% -Reaction time: 0 = shortest reaction times; 1 = longest reaction times
% -Difficulty: 1 = easiest trials (95/5), 0.33 = easy trials (80/20), -0.33 = hard trials (60/40), -1 = hardest trials (50/50) 
%
% USAGE: [mdl, firing_rate] = NeuralRegression_CNC(behav_file, spk_file, epochs, start_event_bound, stop_event_bound, num_trials_back);
% EXAMPLE: lin_models = NeuralRegression_CNC(bhavior_fname, timestamps_fname, {[2 8], [2 3]}, 0, 8, 1);
%
% INPUTS:  behav_file - path and filename of taskbase file
%          spk_file - path and filename of spike file
%          epochs - an N x 1 structure of the N task epochs in which to calculate regression,
%              defined by the events in the TRIAL_EVENTS global variable.
%              Examples of allowable formats of each vector within the structure:
%              [2 3] - Between events 2 and 3 (odor valve on to odor port exit)
%              [999 2 0.5] - The 0.5 seconds after event 2 (999 flag specifies that there is a post-event interval)
%              [888 -0.25 3] - The 0.25 seconds before event 3 (88 flag specifies that there is a pre-event interval)
%              [888 -0.5 3 888 -0.25 3] - Between 0.5 and 0.25 seconds before event 3
%          start_event_bound (OPTIONAL) - events before which the epoch should be discarded; set to zero to disregard
%          stop_event_bound (OPTIONAL) - events after which the epoch should be discarded; set to zero to disregard
%          num_trials_back (OPTIONAL) - choice on how many trials back to use as a predictor (default = 1)  
%
% OUTPUTS: mdl - a structure of linear models predicting each epochs firing rate
%              .full - uses current choice (x1), previous choice (x2), and trial type (x3)
%                   as predictor variables: firing_rate = (beta_current_choice * current_choice) +...
%                   (beta_previous_choice * previous_choice) + (beta_trial_type * trial type) + intercept
%                   Sign of beta depends on sign of predictor variables (see above).
%                   E.g., a negative beta_current_choice indicates preference for leftward choices.
%              .choice_only - uses current choice (x1) and previous choice (x2);
%                   excludes no-choice trials (equation otherwise as for the full model)
%           firing_rate - trials x epochs matrix of firing rates; useful
%               for determining how many non-NaNs are in each epoch
%
% Dependencies: GetPhysioGlobals
%
% The linear models contained in mdl are objects of the class LinearModel.
% Let's say "my_model" is one such object. Typing my_model in the command
% line displays some useful information (estimates of the coefficients
% (i.e., betas), their p values, etc.). Some useful methods for extracting
% the relevant information from the my_model object are:
% betas = my_model.Coefficients.Estimate;
% betas_pvals = my_model.Coefficients.pValue;
% betas_confidence_intervals = my_model.coefCI;
% See http://www.mathworks.com/help/stats/linearmodel-class.html for more.
%
% This function uses fitlm, which is Mathworks' suggested replacement for LinearModel.fit
% (which has been previously used in the lab). Note that trials with NaN
% firing rates (i.e., unperformed) are ignored by the regression analysis,
% so these trials do not need to be manually removed.
%
% Note that discrimination difficulty is NOT included as a predictor
% variable in this version of the code.
%
% SEE ALSO: NeuralRegressionBins_v1_04_0 (written by John Thompson)
%
% First written: 8/4/14 - GF
%
% $ Updated 10/6/14 GF - allows a single start_event_bound and stop_event_bound,
% $ corresponding to events before or after which the epoch should be discarded.
% $ Note that only 1 value of each is permitted, since this feature is intended for
% $ use when sliding bins are entered as epochs (to get the timecourse of the beta values).
% $ Do not attempt to use this feature if you're examining multiple disparate epochs.
%
% $ Updated 1/8/15 GF - added new model (full_with_reaction_time) that
% includes 2 predictor variables in addition to those in the "full" model:
% reaction_time on left trials and reaction_time on right trials. Reaction
% time is calculated as Go Signal to WaterPokeIn. Times are normalized to a
% min of -1 and a max of 1, separately for left and right trials. Left trial reaction
% times are set to 0 for right trials, and vice versa. 
%
% $ Updated 1/23/15 ML - added two new models (current_choice_only, and 
% current_choice_and_type.
%
% $ Updated 7/7/15 ML - added 'trials_to_include' 


function [mdl, firing_rate] = NeuralRegression_CNC(behav_file, spk_file, epochs, start_event_bound, stop_event_bound, num_trials_back, trials_to_include);

GetPhysioGlobals;
global MAX_MOVEMENT_TIME_TO_WATER;
global TRIAL_EVENTS;

if nargin < 4
    start_event_bound = 0; % default is to not use
end
if nargin < 5
    stop_event_bound = 0; % default is to not use
end
if nargin < 6
    num_trials_back = 1; % default is to look at previous trial
end

%% Load the behavior file
load(behav_file);

if exist('trials_to_include') % don't include all trials
    taskbase = RestrictSession(taskbase, trials_to_include);
end

% replace some fieldnames with those from the TRIAL_EVENTS structure
taskbase.OdorValveOn = taskbase.DIO;
taskbase = rmfield(taskbase, 'DIO');
taskbase.GoSignal = taskbase.cue;
taskbase = rmfield(taskbase, 'cue');


%% Load spike file, convert time time in seconds
load(spk_file);

% determine the variable name in which timestamps are saved
spk_var_name = who('-file', spk_file);
if length(spk_var_name) ~= 1
    error('The spike file must contain exactly 1 variable (corresponding to the spike timestamps)');
end

raw_timestamps = eval(spk_var_name{1});

% Figure out what unit the raw timestamps are in, and therefore what to
% divide by in order to obtain spike times in seconds. Assume that
% recording sessions are somewhere between 5 minutes and 500 minutes long.
if range(raw_timestamps) >= 3 * 10^8 % timestamps are in units of 1 microsecond (e.g., the .ntt file from nlx)
    spike_times = raw_timestamps / 10^6;
else % assume timestamps are in units of 100 microseconds (e.g., the output of mclust)
    spike_times = raw_timestamps / 10^4;
end

%% determine whether each trial was a "choice" or "no-choice" trial, using
% the Valve7A/B fields of taskbase

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

% Ocassionally, the Valve7A/B field is 1 element longer than the choice
% field. I'm not sure why this is. For now, assume that the last value
% should be removed (along the lines of their usually (always?) being one
% more element in the start field than in the other events). (ML comment
% from CellSummary_choice_nochoice.m).
if length(choice_trials) > length(taskbase.choice)
    warning('choice_trials is longer than taskbase.choice.');
    choice_trials = choice_trials(1:length(taskbase.choice));
    nochoice_trials_L = nochoice_trials_L(1:length(taskbase.choice));
    nochoice_trials_R = nochoice_trials_R(1:length(taskbase.choice));
end

trial_type = 999 * ones(size(taskbase.choice));

trial_type(choice_trials) = 1; % choice trials
trial_type(nochoice_trials_L) = -1; % no choice trials
trial_type(nochoice_trials_R) = -1; % no choice trials

if ~isempty(find((trial_type == 999), 1)) % make sure all trials are accounted for
    error('Some trials were neither ''choice'' nor ''no-choice''');
end

%% Find the choices on each (current) trial, including out-earlies in which
% a side was chosen quickly enough

tmp = taskbase.choice;
OE_choice_index = taskbase.AfterFOE - taskbase.OdorPokeOut < MAX_MOVEMENT_TIME_TO_WATER;
tmp(OE_choice_index) = taskbase.SideAFOE(OE_choice_index);

% find choice for SG (choice) trials
choice_current = 999 * ones(size(tmp)); % assign a flag value
choice_current(tmp == 1) = -1; % L
choice_current(tmp == 2) = 1; % R

% Should these be zeros or NaNs? It seems that NaNs in the predictor matrix
% cause fitlm to ignore the entire row, which is not what we want.
choice_current(tmp == 3) = 0; % "misses" are classified as no choice
choice_current(isnan(tmp)) = 0; % no choice
% choice_current(tmp == 3) = NaN; % "misses" are classified as no choice
% choice_current(isnan(tmp)) = NaN; % no choice

% remove choices in which movement time was too slow
slow_trial_inds = find((taskbase.WaterPokeIn - taskbase.OdorPokeOut) > MAX_MOVEMENT_TIME_TO_WATER);
choice_current(slow_trial_inds) = NaN;

if ~isempty(find((choice_current == 999), 1)) % make sure all original values were 1, 2, 3, or NaN
    error('Some values of taskbase.choice or taskbase.SideAFOE were other than 1, 2, 3, or NaN');
end

% find choice for SG (choice) trials
choice_SG_current = 999 * ones(size(tmp)); % assign a flag value
choice_SG_current(tmp == 1 & choice_trials == 1) = -1; % L
choice_SG_current(tmp == 2 & choice_trials == 1) = 1; % R

% Should these be zeros or NaNs? It seems that NaNs in the predictor matrix
% cause fitlm to ignore the entire row, which is not what we want.
choice_SG_current(tmp == 3 & choice_trials == 1) = 0; % "misses" are classified as no choice
choice_SG_current(isnan(tmp) & choice_trials == 1) = 0; % no choice
% choice_current(tmp == 3) = NaN; % "misses" are classified as no choice
% choice_current(isnan(tmp)) = NaN; % no choice

% remove choices in which movement time was too slow
slow_trial_inds = find((taskbase.WaterPokeIn - taskbase.OdorPokeOut) > MAX_MOVEMENT_TIME_TO_WATER);
choice_SG_current(slow_trial_inds) = NaN;
% choice_SG_current(choice_SG_current == 999) = NaN;

% if ~isempty(find((choice_SG_current == 999), 1)) % make sure all original values were 1, 2, 3, or NaN
%     error('Some values of taskbase.choice or taskbase.SideAFOE were other than 1, 2, 3, or NaN');
% end

% find choice for IS (choice) trials
choice_IS_current = 999 * ones(size(tmp)); % assign a flag value
choice_IS_current(tmp == 1 & (nochoice_trials_L == 1 | nochoice_trials_R == 1)) = -1; % L
choice_IS_current(tmp == 2 & (nochoice_trials_L == 1 | nochoice_trials_R == 1)) = 1; % R

% Should these be zeros or NaNs? It seems that NaNs in the predictor matrix
% cause fitlm to ignore the entire row, which is not what we want.
choice_IS_current(tmp == 3 & (nochoice_trials_L == 1 | nochoice_trials_R == 1)) = 0; % "misses" are classified as no choice
choice_IS_current(isnan(tmp) & (nochoice_trials_L == 1 | nochoice_trials_R == 1)) = 0; % no choice
% choice_current(tmp == 3) = NaN; % "misses" are classified as no choice
% choice_current(isnan(tmp)) = NaN; % no choice

% remove choices in which movement time was too slow
slow_trial_inds = find((taskbase.WaterPokeIn - taskbase.OdorPokeOut) > MAX_MOVEMENT_TIME_TO_WATER);
choice_IS_current(slow_trial_inds) = NaN;
% choice_IS_current(choice_IS_current == 999) = NaN;

% if ~isempty(find((choice_IS_current == 999), 1)) % make sure all original values were 1, 2, 3, or NaN
%     error('Some values of taskbase.choice or taskbase.SideAFOE were other than 1, 2, 3, or NaN');
% end

%% find the previous choices by shifting the current choice vector
% appropriately, and inserting zeros when there was no previous trial in which
% to have a choice
choice_previous = [zeros(num_trials_back, 1); choice_current(1:(end - num_trials_back))];
choice_SG_previous = [zeros(num_trials_back, 1); choice_SG_current(1:(end - num_trials_back))];
choice_IS_previous = [zeros(num_trials_back, 1); choice_IS_current(1:(end - num_trials_back))];
%choice_previous = [nan(num_trials_back, 1); choice_current(1:(end - num_trials_back))];

%% Reaction time calculation disregarding direction and normalizing values, incomplete trials are set to '0'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find the time between go signal and water poke in (a measure of reaction speed)
reaction_time = taskbase.WaterPokeIn - taskbase.GoSignal;

% remove reaction times for trials with reaction that is too slow (using 
reaction_time(slow_trial_inds) = NaN;

% normalize the reaction times to scale from 0 to 1
reaction_time = Rescale(reaction_time, [0 1]);

% set reaction time for incomplete trials to zero
reaction_time(isnan(reaction_time)) = 0;

% create trial type specific reaction vectors
reaction_time_SG = reaction_time;
reaction_time_IS = reaction_time;

reaction_time_SG(choice_SG_current == 999) = 999;
reaction_time_IS(choice_IS_current == 999) = 999;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Difficulty 
% Odorants
% Pulls odorant concentration from 'taskbase' variable
stimID = taskbase.stimID;
odors = cell2mat(taskbase.odor_params.odors(unique(stimID)));
ods = abs(cell2mat(taskbase.odor_params.odors(stimID)))';

% Find trials where animal sampled odorant 
trial_difficulty = NaN(length(ods), 1);
trial_difficulty(ods == 95,1) = 1;
trial_difficulty(ods == 80,1) = 0.33;
trial_difficulty(ods == 60,1) = -0.33;
trial_difficulty(ods == 50,1) = -1;
trial_difficulty(isnan(taskbase.OdorSampDur), 1) = 0;

% create trial type specific difficulty vectors
trial_difficulty_SG = trial_difficulty;
trial_difficulty_IS = trial_difficulty;

trial_difficulty_SG(choice_SG_current == 999) = 999;
trial_difficulty_IS(choice_IS_current == 999) = 999;

%% Accuracy

[Accuracy_vector] = Accuracy_regression_short(behav_file, spk_file);

%% Find the firing rate for each trial in each desired epoch (which is what we are trying to predict)

trial_starts = taskbase.start_nlx(1:length(taskbase.choice)); % often there's an extra start time relative to number of event times

firing_rate = nan(length(trial_starts), length(epochs));


event_names = fieldnames(TRIAL_EVENTS);

for epoch_ind = 1:length(epochs)

    %% get epoch start and stop times

    e = epochs{epoch_ind}; % current epoch

    if length(e) == 2 % epoch boundaries correspond to trial events

        epoch_start = trial_starts + taskbase.(event_names{e(1)});
        epoch_stop = trial_starts + taskbase.(event_names{e(2)});
        
    elseif length(e) == 3 % one epoch boundary does NOT correspond to a trial event

        if e(1) == 888 % start boundary is determined by a time relative to a trial event

            epoch_stop = trial_starts + taskbase.(event_names{e(3)});
            epoch_start = epoch_stop + e(2);

        elseif e(1) == 999 % stop boundary is determined by a time relative to a trial event

            epoch_start = trial_starts + taskbase.(event_names{e(2)});
            epoch_stop = epoch_start + e(3);

        else
            error('Flags for epoch start/stop other than trial events must be 888 or 999\n');
        end

    elseif length(e) == 6 % both epoch boundaries do NOT correspond to trial events
            % format (e.g.): [888, time before event1, event1, 999, event2, time after event2] 

        % get start boundary    
        if e(1) == 888 % start boundary is determined by a time BEFORE a trial event

            tmp = trial_starts + taskbase.(event_names{e(3)});
            epoch_start = tmp + e(2);

        elseif e(1) == 999 % start boundary is determined by a time AFTER a trial event

            tmp = trial_starts + taskbase.(event_names{e(2)});
            epoch_start = tmp + e(3);

        end

        % get stop boundary    
        if e(4) == 888 % stop boundary is determined by a time BEFORE a trial event

            tmp = trial_starts + taskbase.(event_names{e(6)});
            epoch_stop = tmp + e(5);

        elseif e(4) == 999 % stop boundary is determined by a time AFTER a trial event

            tmp = trial_starts + taskbase.(event_names{e(5)});
            epoch_stop = tmp + e(6);

        end

    else
        error('each epoch entry must be a vector of length 2, 3, or 6.\n');
    end
    
    % also find the "start event" boundary (events before which we should
    % discard the epoch) and the "stop event" boundary (events after which we should
    % discard the epoch)
    if start_event_bound ~= 0
        epoch_start_bound = trial_starts + taskbase.(event_names{start_event_bound});
    else
        epoch_start_bound = -Inf * ones(length(trial_starts), 1); % if no start_event_bound is desired, set to negative infinity
    end
    
    if stop_event_bound ~= 0
        epoch_stop_bound = trial_starts + taskbase.(event_names{stop_event_bound});
    else
        epoch_stop_bound = Inf * ones(length(trial_starts), 1); % if no start_event_bound is desired, set to positive infinity
    end

    % now that we have the epoch start and stop times, make sure these times are not
    % outside of the desired range (i.e., before or after an event boundary), and if
    % not, get the firing rate during the epoch
    
    for trial_num = 1:length(trial_starts)
    
        start = epoch_start(trial_num);
        stop = epoch_stop(trial_num);

        start_bound = epoch_start_bound(trial_num);
        stop_bound = epoch_stop_bound(trial_num);
        
        % is this epoch start before the start boundary, or is the epoch stop after the stop boundary?
        if (start < start_bound) || (stop > stop_bound)
            firing_rate(trial_num, epoch_ind) = NaN; % disregard this trial
        else
            firing_rate(trial_num, epoch_ind) = sum((spike_times >= start) & (spike_times < stop)) ./ (stop - start);
        end
        
    end

end

% create trial type specific firing rate vectors
firing_rate_SG = firing_rate;
firing_rate_IS = firing_rate;

firing_rate_SG(choice_SG_current == 999) = 999;
firing_rate_IS(choice_IS_current == 999) = 999;

% remove rows of trial type specific vectors
% SG variables
choice_SG_current(any(choice_SG_current == 999, 2),:) = [];
choice_SG_previous(any(choice_SG_previous == 999, 2),:) = [];
reaction_time_SG(any(reaction_time_SG == 999, 2),:) = [];
trial_difficulty_SG(any(trial_difficulty_SG == 999, 2),:) = [];
firing_rate_SG(any(firing_rate_SG == 999, 2),:) = [];

% IS variables
choice_IS_current(any(choice_IS_current == 999, 2),:) = [];
choice_IS_previous(any(choice_IS_previous == 999, 2),:) = [];
reaction_time_IS(any(reaction_time_IS == 999, 2),:) = [];
trial_difficulty_IS(any(trial_difficulty_IS == 999, 2),:) = [];
firing_rate_IS(any(firing_rate_IS == 999, 2),:) = [];

% sometimes choice previous is longer than choice current, when this is the
% case, truncate choice previous
if length(choice_SG_previous) > length(choice_SG_current)
    choice_SG_previous = choice_SG_previous(1:length(choice_SG_current));
else
end

if length(choice_IS_previous) > length(choice_IS_current)
    choice_IS_previous = choice_IS_previous(1:length(choice_IS_current));
else
end

if length(choice_previous) > length(choice_current)
    choice_previous = choice_previous(1:length(choice_current));
else
end

%% Run the linears models to predict firing rate in each epoch

% "accuracy" model: x1 = current choice; x2 = previous choice; x3 = reaction time; 
% x4 = trial type;

% predictors: current choice, previous choice, trial type
predictor_mat = [choice_current choice_previous reaction_time trial_type Accuracy_vector];
    
model_notation = 'y ~ x1 + x2 + x3 + x4 + x5 + x4*x5'; % This is "Wilkinson notation"; see fitlm help menu

for epoch_ind = 1:length(epochs)
        
    mdl.accuracy{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);

end

clear predictor_mat model_notation;

% "full" model: x1 = current choice; x2 = previous choice; x3 = reaction time; 
% x4 = trial type;

% predictors: current choice, previous choice, trial type
predictor_mat = [choice_current choice_previous reaction_time trial_type];
    
model_notation = 'y ~ x1 + x2 + x3 + x4'; % This is "Wilkinson notation"; see fitlm help menu

for epoch_ind = 1:length(epochs)
        
    mdl.full{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);

end

clear predictor_mat model_notation;

% % "SG" model: x1 = current SG choice; x2 = previous SG choice; x3 = reaction time SG; 
% % x4 = trial difficulty SG;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_SG_current choice_SG_previous reaction_time_SG trial_difficulty_SG];
%     
% model_notation = 'y ~ x1 + x2 + x3 + x4'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.SG{epoch_ind} = fitlm(predictor_mat, firing_rate_SG(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;
% 
% % "IS" model: x1 = current IS choice; x2 = previous IS choice; x3 = reaction time IS; 
% % x4 = trial difficulty IS;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_IS_current choice_IS_previous reaction_time_IS trial_difficulty_IS];
%     
% model_notation = 'y ~ x1 + x2 + x3 + x4'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.IS{epoch_ind} = fitlm(predictor_mat, firing_rate_IS(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;
% 
% % "IScc" model: x1 = current IS choice; x2 = previous IS choice; x3 = reaction time IS; 
% % x4 = trial difficulty IS;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_IS_current reaction_time_IS]; % trial_difficulty_IS];
%     
% model_notation = 'y ~ x1 + x2';% + x3'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.IScc{epoch_ind} = fitlm(predictor_mat, firing_rate_IS(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;
% 
% % "ISpc" model: x1 = current IS choice; x2 = previous IS choice; x3 = reaction time IS; 
% % x4 = trial difficulty IS;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_IS_previous reaction_time_IS]; % trial_difficulty_IS];
%     
% model_notation = 'y ~ x1 + x2';% + x3'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.ISpc{epoch_ind} = fitlm(predictor_mat, firing_rate_IS(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % "full" model: x1 = current choice; x2 = previous choice; x3 = reaction time; 
% % x4 = trial difficulty; x5 = trial type;
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_current choice_previous trial_type reaction_time trial_difficulty];
%     
% model_notation = 'y ~ x1 + x2 + x3 + x4 + x5'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.full{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;
% % "full" model: x1 = current choice; x2 = previous choice; x3 = trial type
% 
% % predictors: current choice, previous choice, trial type
% predictor_mat = [choice_current choice_previous trial_type];
%     
% model_notation = 'y ~ x1 + x2 + x3'; % This is "Wilkinson notation"; see fitlm help menu
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.full{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation;
% 
% % "choice only" model (only choice trials are included as predictors): x1 = current choice; x2 = previous choice
% 
% % predictors: current choice, previous choice
% predictor_mat = [choice_current(choice_trials) choice_previous(choice_trials)];
% 
% model_notation = 'y ~ x1 + x2';
% 
% for epoch_ind = 1:length(epochs)
%     
%     mdl.choice_only{epoch_ind} = fitlm(predictor_mat, firing_rate(choice_trials, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation
% 
% % "full_with_reaction_time" model: x1 = current choice; x2 = previous choice; x3 = trial type;
% % x4 = reaction time for left trials; x5 = reaction time for right trials
% 
% % predictors: current choice, previous choice, trial type, reaction time for left trials, reaction time for right trials
% predictor_mat = [choice_current choice_previous trial_type reaction_time];
% 
% model_notation = 'y ~ x1 + x2 + x3 + x4';
% 
% for epoch_ind = 1:length(epochs)
%         
%     mdl.full_with_reaction_time{epoch_ind} = fitlm(predictor_mat, firing_rate(:, epoch_ind), model_notation);
% 
% end
% 
% clear predictor_mat model_notation
% 

return


