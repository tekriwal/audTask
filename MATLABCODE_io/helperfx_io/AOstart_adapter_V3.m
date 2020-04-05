%AT V2 created 3/29/20 - need to be able to calculcate the expected vs
%actual number of trials and see if they match. Kick out trials that are
%too short as ID'ed by behavior_file_adapter_V2 fx and account for OE
%trials

%AT V1 created on 2/15/20 in order to calculate the offset between alpha
%omega clock and the time of trial start.


function [taskbase_io] = AOstart_adapter_V3(taskbase_io, Ephys_struct, where, rData, index_errors)


switch where
    case 'trialStart'
        fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
end



TTLdata = Ephys_struct.ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same
waitperiod_index = zeros(2,length(TTLdata));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(TTLdata)-1)
    if TTLdata(i+1) - TTLdata(i) < 400 && TTLdata(i) - TTLdata(i-10) < 14000
        waitperiod_index(1,i) = 1;
        waitperiod_index(2,i) = TTLdata(i+fromwhere_relativetoendofwaitperiod);
    end
end


% little aside here to make the waitperiod_index more scannable by eye
waitperiod_index_easilyscannable = [];
for i = 1:length(waitperiod_index)
    if waitperiod_index(1,i) == 1
        appendme = waitperiod_index(2,i);
        waitperiod_index_easilyscannable = [waitperiod_index_easilyscannable appendme];
    end
end %this serves its purposes, generates exact TTL ID's for what we're calling successful wait periods



%%
%AT adding being on 3/29/20 in order to help filter through some of the
%crud getting labeled as end of the delay period
%Need to remove
%1) any pre-patient testing trials
%2) any super quick rxn times (gets ready as multiple trials
%3) Compare expected number of trials based off of the index_errors
%generated by the 'behave_file_adapter_V2' and compare to number of TTL's
%that have been identified.


for i = 1:(length(waitperiod_index_easilyscannable)-1)
    ddif(i,1) = waitperiod_index_easilyscannable(i)/44000;
end



for i = 1:(length(waitperiod_index_easilyscannable)-1)
    intertrialInterval_TTLnav(i) = (waitperiod_index_easilyscannable(i+1) - waitperiod_index_easilyscannable(i))/44000;
end

index_tooLong = intertrialInterval_TTLnav(:) > 30; %so this is saying that if the intertrialInterval is longer than 30 seconds, we dont want that TTL. It most likely is a trial that I ran PRIOR to the pt to check system, and it was included in the final output
index_tooShort = intertrialInterval_TTLnav(:) < 3.5; %so this is saying that if the intertrialInterval is shorter than 3.5 seconds, we should kick it out. this is likely from a trial wherein pt responded too quickly to be possible but not so quickly that controller picked up on the OE


%AT to account for the last trial needing a representation in the
%indexes...
index_tooLong = [index_tooLong;0];
index_tooShort = [index_tooShort;0];

index = index_tooLong + index_tooShort;
index = logical(index);

waitperiod_index_easilyscannable_cleaned = waitperiod_index_easilyscannable;
waitperiod_index_easilyscannable_cleaned(:,index) = []; %remove the whole row



offset=sum(index_tooLong);

for i = 1:(length(rData)-1)
    ddif(i+offset,3) = (rData(i+1).Wholetrial - rData(i).Wholetrial);
end

for i = 1:(length(rData)-1)
    ddif(i+offset,4) =rData(i).Start_loop + rData(i).Hold_time + rData(i).Postholdtime + rData(i).Writeuptime;
end

for i = 1:(length(rData)-1)
    ddif(i+offset,5) = rData(i).Start_loop + rData(i).Hold_time + rData(i).Postholdtime + rData(i).Writeuptime + rData(i).Writeread_response;
end


errorCount = zeros(length(rData),1);
for k = 1:length(rData)
    if (rData(k).actual == 'f')
        errorCount(k) = 1;
    end
end

%%%% JAT ADDED - 4/3/2020 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% completedTrials = length(rData) - sum(index);
completedTrials = length(rData) - sum(index_errors);
%%%% JAT ADDED - 4/3/2020 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if completedTrials ~= length(waitperiod_index_easilyscannable_cleaned)
    error('see AOstart_adapter_VX; Problem with TTL indexing compared to behavior')
    %Note check that the thresh's used in this fx are fx'ing as expected if
    %above error is thrown.
end

taskbase_io.trialStart_AO = waitperiod_index_easilyscannable_cleaned';




end