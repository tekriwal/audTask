fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
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
