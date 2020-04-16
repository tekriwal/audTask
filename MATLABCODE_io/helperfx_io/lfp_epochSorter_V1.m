%AT created 3/26/20; goal is to have fx that parses out the relevant epochs
%based on however the inputs were sorted

%this fx calls 'lfp_bandpowers_V1'


function [struct] = lfp_epochSorter_V1(struct, trial_inds, trial_start_times, taskbase_io, align_event1_times, align_event2_times, Ephys_struct, LFPSamplerate, LFP_file)




    
    struct.timing.trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
    struct.timing.upPressed_times = taskbase_io.events.upPressed(trial_inds)';
    struct.timing.stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
    struct.timing.goCue_times = taskbase_io.events.goCue(trial_inds)';
    struct.timing.leftUP_times = taskbase_io.events.leftUP(trial_inds)';
    struct.timing.submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
    struct.timing.feedback_times = taskbase_io.events.feedback(trial_inds)';
    
    
    struct.ref_LFP_epoch = [];
    struct.trial_inds = [];
    
    event_times1 = struct.timing.(align_event1_times);
    event_times2 = struct.timing.(align_event2_times);
    
    for trial_num = 1:length(trial_start_times)
        
        
        ref_time_start = trial_start_times(trial_num) + event_times1(trial_num); % absolute time of event to reference spikes to
        ref_time_end = trial_start_times(trial_num) + event_times2(trial_num); % absolute time of event to reference spikes to
        
        if ~isnan(ref_time_start) % ref_time will be NaN if the particular event did not occur in this trial
            
            trial_LFP_epoch = LFP_file(round(ref_time_start*LFPSamplerate):round(ref_time_end*LFPSamplerate));
            
            struct.ref_LFP_epoch = [struct.ref_LFP_epoch; trial_LFP_epoch(:)];
            struct.trial_inds = [struct.trial_inds; (ones(length(trial_LFP_epoch), 1) * trial_num)];
            
            %AT updated the bandpowers fx to V2 on 4/7/20
            [struct] = lfp_bandpowers_V2(struct, trial_num, trial_LFP_epoch, LFPSamplerate);

            
        end
        
    end
    






end