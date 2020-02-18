%4/30/19 NOTE: the first row is giving a logical output for which TTL marks
%the end of the wait period. Then, the second row is giving the time stamp
%(remember TTL sampling rate is 44000) relative to when the first TTL was
%detected.

% AT 4/29/19; I am reformatting this code so that it is improved/what we
% need for the LFP analysis from Zag


function [ioTask_index] = io_TTLnavigating_v2(ttlInfo)

fromwhere_relativetoendofwaitperiod = 0;%-17 should be the start of the trial
% fromwhere_relativetoendofwaitperiod = 0; %have 0 here will identify the
% first TTL after the delay epoch is completed




TTLdata = ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same
waitperiod_index = zeros(2,length(TTLdata));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(TTLdata)-1)
    if TTLdata(i+1) - TTLdata(i) < 400 && TTLdata(i) - TTLdata(i-10) < 14000
        waitperiod_index(1,i) = 1;
        waitperiod_index(2,i) = TTLdata(i+fromwhere_relativetoendofwaitperiod);
    end
end




%4/29/19 - so each element in TTLdata is when a TTL was sent, so we have a logical
%index in row 1 for the TTLs of interest, and then we have the actual
%timestamp in row 2. This timestamp is what we want for the LFP code, I
%beleive 


ioTask_index = waitperiod_index;


end