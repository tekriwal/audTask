%AT 3/30/20; my intention is to have this fx serve as a L vs R preference
%analysis. Plan is to give pair of inputs as designated by L and R
%subfields.




%% CellPreference
%% Calculate preference for a cell using ROC analysis, across multiple
%% epochs. The preferences currently calulated are:
%% leftchoice_vs_rightchoice
%%
%% To add a preference calculation, add it to this file.
%%
%% USAGE: [preference, roc_p, activity_info] = CellPreference(raster_info, num_iter, analysis_to_perform, epochs)
%% EXAMPLE: [pref, p_values, activity_info] =...
%%          CellPreference(raster_info, 500, 'leftchoice_vs_rightchoice', {[1 2]; [2 3]; [888 -0.1 3]});
%%
%% INPUTS:  raster_info - structure created by batch_SC_raster_info
%%              containing spike times relative to trial events, and
%%              stimulus info
%%          num_iter - # of iterations to calculate significance
%%          analysis_to_perform - name of analysis to perform
%%          epochs - an N x 1 structure of the N task epochs in which to calculate preference,
%%              defined by the events in the TRIAL_EVENTS global variable.
%%              Allowable formats of each vector within the structure:
%%              [2 3] - Between events 2 and 3 (odor valve on to odor poke out)
%%              [999 2 0.5] - The 0.5 seconds after event 2 (999 flag specifies that there is a post-event interval)
%%              [888 -0.25 3] - The 0.25 seconds before event 3 (88 flag specifies that there is a pre-event interval)
%%              [888 -0.5 3 888 -0.25 3] - Between 0.5 and 0.25 seconds before event 3
%%
%% OUTPUTS: preference - structure of preference values
%%          roc_p - structure of significance (p) values for preference
%%          activity_info - structure of additional activity information
%%              .trial_spikes - spikes in each epoch of each trial
%%              .stim_params - info about the stimulus from
%%                  TrialClassification_Solo
%%              .current_globals - the global variables used by this file
%%                  (defined in GetSCGlobals.m)
%%
%% Next generation of CellSelectivity, written by GF.
%%
%% 8/7/2103 - GF
%%
%% UPDATES:
%% $ 8/29/13 GF - preference is now calculated by calling ROC_preference
%% $ instead of the CalculateROC subfunction (which is now removed)

function [preference, roc_p, activity_info] = CellPreference_io_V1(raster_info, num_iter, analysis_to_perform, epochs)








if nargin < 3 % analysis_name not specified
    analysis_to_perform = 'all';
end

% GetPhysioGlobals; % assign global variables
% global TRIAL_EVENTS;
% global MAX_MOVEMENT_TIME_TO_WATER; % max time from odorpokeout to waterpokein
% global MAX_MOVEMENT_TIME_TO_ODOR; % max time from waterpokeout to nextodorpokein

%% Deconstruct the raster_info structure


% % raster_info.ref_spike_times.R = ref_spike_times;
% % raster_info.trial_inds.R = trial_inds;
% %
% % raster_info.raster_events.trial_start.R = trialStart_times';
% % raster_info.raster_events.trial_event_times.R =  [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times];
% %
% % raster_info.stim_params = [];
% % raster_info.align_ind = 1; %I think this corresponds with trial_event_times?
% % raster_info.window = init_psth_window_event1;


num_stim = length(raster_info.raster_events.trial_start.L);
raster_events = raster_info.raster_events;
trial_inds = raster_info.trial_inds.L;

align_ind = raster_info.align_ind;

%% For backward compatibility for reaction time cells, assign NaN to the gotone time for each trial
% % if size(raster_events.L.trial_event_times{1}, 1) == 7 % this is a rxn time cell
% %     for stim_num = 1:num_stim
% %         raster_events.L.trial_event_times{stim_num}(8, :) = NaN;
% %         raster_events.R.trial_event_times{stim_num}(8, :) = NaN;
% %     end
% % end

%%% Calculate the number of spikes in each epoch for each stimulus type %%%

% for stim_num = 1:num_stim

%% L trials
ref_spike_times = raster_info.ref_spike_times.L;

if length(raster_info.raster_events.trial_start.L) > 0 % make sure there are some trials of this type
    
    num_current_trials = length(raster_events.trial_start.L);
    
    for trial_ind = 1:num_current_trials
        
        trial_spike_times = ref_spike_times(trial_inds == trial_ind);
%         trial_spike_times = ref_spike_times.L{stim_num}(trial_inds.L{stim_num} == trial_ind);

        for epoch_ind = 1:length(epochs)
            
            %% get epoch start and stop times
            
            e = epochs{epoch_ind}; % current epoch
            
            % subtract the time of the event the rasters are aligned to (odorpokein)
            align_time = raster_info.raster_events.trial_event_times.L(align_ind, trial_ind);
            
            if length(e) == 2 % epoch boundaries correspond to trial events
                
                epoch_start = raster_events.trial_event_times.L(e(1), trial_ind) - align_time;
                epoch_stop  = raster_events.trial_event_times.L(e(2), trial_ind) - align_time;
                
            elseif length(e) == 3 % one epoch boundaries does NOT correspond to a trial event
                
                if e(1) == 888 % start boundary is determined by a time relative to a trial event
                    
                    epoch_stop = raster_events.trial_event_times.L(e(3), trial_ind) - align_time;
                    epoch_start = epoch_stop + e(2);
                    
                elseif e(1) == 999 % stop boundary is determined by a time relative to a trial event
                    
                    epoch_start = raster_events.trial_event_times.L(e(2), trial_ind) - align_time;
                    epoch_stop = epoch_start + e(3);
                    
                else
                    error('Flags for epoch start/stop other than trial events must be 888 or 999\n');
                end
                
            elseif length(e) == 6 % both epoch boundaries do NOT correspond to trial events
                % format (e.g.): [888, time before event1, event1, 999, event2, time after event2]
                
                % get start boundary
                if e(1) == 888 % start boundary is determined by a time BEFORE a trial event
                    
                    tmp = raster_events.trial_event_times.L(e(3), trial_ind) - align_time;
                    epoch_start = tmp + e(2);
                    
                elseif e(1) == 999 % start boundary is determined by a time AFTER a trial event
                    
                    tmp = raster_events.trial_event_times.L(e(2), trial_ind) - align_time;
                    epoch_start = tmp + e(3);
                    
                end
                
                % get stop boundary
                if e(4) == 888 % stop boundary is determined by a time BEFORE a trial event
                    
                    tmp = raster_events.trial_event_times.L(e(6), trial_ind) - align_time;
                    epoch_stop = tmp + e(5);
                    
                elseif e(4) == 999 % stop boundary is determined by a time AFTER a trial event
                    
                    tmp = raster_events.trial_event_times.L(e(5), trial_ind) - align_time;
                    epoch_stop = tmp + e(6);
                    
                end
                
            else
                error('each epoch entry must be a vector of length 2, 3, or 6.\n');
            end
            
            
            
            %AT 3/30/20, I think that most of the above can be left
            %alone as long as we're inputted in the correct format
            
            
            
            
            
            %% now that we have the epoch start and stop times, get the
            %% firing rate during the epoch
            
            trial_spikes.L{epoch_ind}(trial_ind) = length(find((trial_spike_times > epoch_start) &...
                (trial_spike_times <= epoch_stop))) / (epoch_stop - epoch_start);
            
        end
        
    end
    
    num_trials.L = num_current_trials;
    
else % if no trials of this type
    
    for epoch_ind = 1:length(epochs)
        trial_spikes.L{epoch_ind} = [];
    end
    
    num_trials.L = 0;
    
end

%% R trials
ref_spike_times = raster_info.ref_spike_times.R;

if length(raster_info.raster_events.trial_start.R) > 0 % make sure there are some trials of this type
    
    num_current_trials = length(raster_events.trial_start.R);
    
    for trial_ind = 1:num_current_trials
        
          trial_spike_times = ref_spike_times(trial_inds == trial_ind);
%         trial_spike_times = ref_spike_times;
        
        for epoch_ind = 1:length(epochs)
            
            %% get epoch start and stop times
            
            e = epochs{epoch_ind}; % current epoch
            
            % subtract the time of the event the rasters are aligned to (odorpokein)
            align_time = raster_info.raster_events.trial_event_times.R(align_ind, trial_ind);
            
            if length(e) == 2 % epoch boundaries correspond to trial events
                
                epoch_start = raster_events.trial_event_times.R(e(1), trial_ind) - align_time;
                epoch_stop  = raster_events.trial_event_times.R(e(2), trial_ind) - align_time;
                
            elseif length(e) == 3 % one epoch boundaries does NOT correspond to a trial event
                
                if e(1) == 888 % start boundary is determined by a time relative to a trial event
                    
                    epoch_stop = raster_events.trial_event_times.R(e(3), trial_ind) - align_time;
                    epoch_start = epoch_stop + e(2);
                    
                elseif e(1) == 999 % stop boundary is determined by a time relative to a trial event
                    
                    epoch_start = raster_events.trial_event_times.R(e(2), trial_ind) - align_time;
                    epoch_stop = epoch_start + e(3);
                    
                else
                    error('Flags for epoch start/stop other than trial events must be 888 or 999\n');
                end
                
            elseif length(e) == 6 % both epoch boundaries do NOT correspond to trial events
                % format (e.g.): [888, time before event1, event1, 999, event2, time after event2]
                
                % get start boundary
                if e(1) == 888 % start boundary is determined by a time BEFORE a trial event
                    
                    tmp = raster_events.trial_event_times.R(e(3), trial_ind) - align_time;
                    epoch_start = tmp + e(2);
                    
                elseif e(1) == 999 % start boundary is determined by a time AFTER a trial event
                    
                    tmp = raster_events.trial_event_times.R(e(2), trial_ind) - align_time;
                    epoch_start = tmp + e(3);
                    
                end
                
                % get stop boundary
                if e(4) == 888 % stop boundary is determined by a time BEFORE a trial event
                    
                    tmp = raster_events.trial_event_times.R(e(6), trial_ind) - align_time;
                    epoch_stop = tmp + e(5);
                    
                elseif e(4) == 999 % stop boundary is determined by a time AFTER a trial event
                    
                    tmp = raster_events.trial_event_times.R(e(5), trial_ind) - align_time;
                    epoch_stop = tmp + e(6);
                    
                end
                
            else
                error('each epoch entry must be a vector of length 2, 3, or 6.\n');
            end
            
            
            %% now that we have the epoch start and stop times, get the
            %% firing rate during the epoch
            
            trial_spikes.R{epoch_ind}(trial_ind) = length(find((trial_spike_times > epoch_start) &...
                (trial_spike_times <= epoch_stop))) / (epoch_stop - epoch_start);
            
        end
        
    end
    
    num_trials.R = num_current_trials;
    
else % if no trials of this type
    
    for epoch_ind = 1:length(epochs)
        trial_spikes.R{epoch_ind} = [];
    end
    
    num_trials.R = 0;
    
end



%%% Calculate preference using ROC analysis %%%

%% Left choice vs. Right choice (all trial types): -1=L; 1=R

analysis_name = 'leftchoice_vs_rightchoice';

% only perform this analysis if specified
if (strcmpi(analysis_to_perform, analysis_name) || strcmpi(analysis_to_perform, 'all'))
    
    % initialize
    preference.(analysis_name) = NaN(1, length(epochs));
    roc_p.(analysis_name) = NaN(1, length(epochs));
    
    
    for epoch_ind = 1:length(epochs)
        
        L_num_trials = []; % initialize
        R_num_trials = []; % initialize
        L_spikes = []; % initialize
        R_spikes = []; % initialize
        
        % L trials
        %         for stim_num = 1:num_stim
        
        % only include certain trials, based on movement time
        r = raster_info.raster_events.trial_event_times.L;
        %             valid_trials =...
        %                 find(r(TRIAL_EVENTS.WaterPokeIn, :) - r(TRIAL_EVENTS.OdorPokeOut, :) <= MAX_MOVEMENT_TIME_TO_WATER);
        
        % GF 8/7/13 - How to deal with eliminating trials based on movement times?
        %             if (epoch_ind == 7 | epoch_ind == 8) % epochs related to reinitiation movement
        %                 valid_trials = find(r(7, :) - r(6, :) <= MAX_MOVEMENT_TIME_TO_ODOR);
        %             else % epochs related to movement towards water port
        %                 valid_trials = find(r(4, :) - r(3, :) <= MAX_MOVEMENT_TIME_TO_WATER);
        %             end
        
        
        L_num_trials = length(r);
        %             L_spikes = [L_spikes; trial_spikes.L{epoch_ind}(r)'];
        L_spikes = [L_spikes; trial_spikes.L{epoch_ind}];
        
        %         end
        
        % R trials
        %         for stim_num = 1:num_stim
        
        % only include certain trials, based on movement time
        r = raster_info.raster_events.trial_event_times.R;
        %             valid_trials =...
        %                 find(r(TRIAL_EVENTS.WaterPokeIn, :) - r(TRIAL_EVENTS.OdorPokeOut, :) <= MAX_MOVEMENT_TIME_TO_WATER);
        
        % GF 8/7/13 - How to deal with eliminating trials based on movement times?
        %             if (epoch_ind == 7 | epoch_ind == 8) % epochs related to reinitiation movement
        %                 valid_trials = find(r(7, :) - r(6, :) <= MAX_MOVEMENT_TIME_TO_ODOR);
        %             else % epochs related to movement towards water port
        %                 valid_trials = find(r(4, :) - r(3, :) <= MAX_MOVEMENT_TIME_TO_WATER);
        %             end
        
        
        R_num_trials = length(r);
        %             R_spikes = [R_spikes; trial_spikes.R{epoch_ind}(r)'];
        R_spikes = [R_spikes; trial_spikes.R{epoch_ind}];
        
        %         end
        
        
%         if length(R_spikes) < length(L_spikes)
%             L_spikes = L_spikes(1:length(R_spikes));
%         elseif length(R_spikes) > length(L_spikes)
%             R_spikes = R_spikes(1:length(L_spikes));
%         end
        [pref, rp] = ROC_preference(L_spikes', R_spikes', num_iter); % Calls new ROC function
        
        preference.(analysis_name)(epoch_ind) = pref;
        roc_p.(analysis_name)(epoch_ind) = rp;
        
    end
    
end


%% save additional information in activity_info structure
activity_info.trial_spikes = trial_spikes;
%activity_info.stim_params = stim_params;

% save the inputted variables
activity_info.num_iter = num_iter;
activity_info.epochs = epochs;

% % save the global variables that this file used
% global_struct = whos('global');
% for i = 1:length(global_struct)
%     if exist(global_struct(i).name)
%         current_globals.(global_struct(i).name) = eval(global_struct(i).name);
%     end
% end
% 
% activity_info.current_globals = current_globals;

return


