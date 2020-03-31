%AT V1 created on 2/15/20 in order to calculate the offset between alpha
%omega clock and the time of trial start. 


function [taskbase_io] = Case04_AOstart_adapter(taskbase_io, Ephys_struct, where)


switch where
    case 'trialStart'
        fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
end



TTLdata = Ephys_struct.ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same
waitperiod_index = zeros(2,length(TTLdata));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(TTLdata)-1)
    if TTLdata(i+1) - TTLdata(i) < 400 && TTLdata(i) - TTLdata(i-10) < (14000+14000)
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



taskbase_io.trialStart_AO = waitperiod_index_easilyscannable';




end