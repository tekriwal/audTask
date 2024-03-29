%AT V1 created on 2/15/20 in order to calculate the offset between alpha
%omega clock and the time of trial start.


function [taskbase_io] = AOstart_adapter_V3(taskbase_io, Ephys_struct, where, rData, index_errors, caseNumb, cutNearOEs)


switch where
    case 'trialStart'
        fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
end

if caseNumb == 1 || caseNumb == 2 || caseNumb == 3 || caseNumb == 4
    delaytime = 12500;
else
    delaytime = 0;
end

TTLdata = Ephys_struct.ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same
waitperiod_index = zeros(2,length(TTLdata));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(TTLdata)-1)
    if TTLdata(i+1) - TTLdata(i) < 400 && TTLdata(i) - TTLdata(i-10) < (14000+delaytime) %(14000+11670)
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


%AT 4/2/20; the below code is for the manual curation of cases that
%include things like trials (as detected by TTL sequences) preceding the
%actual trials conducted with pts

if caseNumb == 1
    waitperiod_index_easilyscannable(1:13) = []; %first 13 trials were me doing pre-testing for case01
    waitperiod_index_easilyscannable(39) = []; %deleting this element because of weird coincidence in timing/TTL nav code
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable(1:69); %case01 didn't finish the last block, so its easier to cut out last 3 trials
    %     waitperiod_index_easilyscannable = waitperiod_index_easilyscannable(1:(end-5)); %case01 cut last 5 trials
    
    
elseif caseNumb == 2
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 2, there's nothing that needs to be done here
elseif caseNumb == 3
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 3, there's nothing that needs to be done here
elseif caseNumb == 4
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 4, there's nothing that needs to be done here
elseif caseNumb == 5
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 5, there's nothing that needs to be done here
elseif caseNumb == 6
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 6, there's nothing that needs to be done here
elseif caseNumb == 7
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 7, there's nothing that needs to be done here
elseif caseNumb == 8
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 8, there's nothing that needs to be done here
elseif caseNumb == 9
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 9, there's nothing that needs to be done here
elseif caseNumb == 10
    waitperiod_index_easilyscannable(1:5) = []; %for case 10 there's two small segments where I tested code out prior to pt testing
elseif caseNumb == 11
    waitperiod_index_easilyscannable(12) = []; %deleting this element because it was a pre-pt test trial
    waitperiod_index_easilyscannable(8) = []; %deleting this element because of weird coincidence in timing/TTL nav code
    waitperiod_index_easilyscannable(7) = []; %deleting this element because of weird coincidence in timing/TTL nav code
    waitperiod_index_easilyscannable(6) = []; %deleting this element because of weird coincidence in timing/TTL nav code
    waitperiod_index_easilyscannable(1) = []; %deleting this element because of weird coincidence in timing/TTL nav code
elseif caseNumb == 12
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 9, there's nothing that needs to be done here
elseif caseNumb == 13
    waitperiod_index_easilyscannable = waitperiod_index_easilyscannable; %for case 9, there's nothing that needs to be done here
    
end

%%
%AT adding being on 3/29/20 in order to help filter through some of the
%crud getting labeled as end of the delay period
%Need to remove
%1) any pre-patient testing trials
%2) any super quick rxn times (gets ready as multiple trials
%3) Compare expected number of trials based off of the index_errors
%generated by the 'behave_file_adapter_V2' and compare to number of TTL's
%that have been identified.


for i = 1:(length(waitperiod_index_easilyscannable))
    TTLtimes_seconds(i,1) = waitperiod_index_easilyscannable(i)/44000;
end

%AT 4/2/20 the below 'dur' code is checking how long from the start of the first
%trial until the start of the last trial.
dur_rData = sum([rData(1:end-1).Start_loop])+sum([rData(1:end-1).Hold_time])+sum([rData(1:end-1).Postholdtime])+sum([rData(1:end-1).Writeuptime]);
dur_TTL = TTLtimes_seconds(end) - TTLtimes_seconds(1);

% if caseNumb < 13
if abs(dur_rData - dur_TTL) > 2 || dur_TTL < dur_rData %we expect there to be some offset because tictocs aren't timing EVERYthing, likewise the TTL start to finish should be slightly longer than the output from rData for the same reason
    error('mismatch in length of time (dur) measured by rData v TTLs')
end
% end

for i = 1:(length(waitperiod_index_easilyscannable)-1)
    intertrialInterval_TTLnav(i) = (waitperiod_index_easilyscannable(i+1) - waitperiod_index_easilyscannable(i))/44000;
end
intertrialInterval_TTLnav = intertrialInterval_TTLnav';

if caseNumb == 1
    index_tooLong = [];
else
    index_tooLong = intertrialInterval_TTLnav(:) > 35; %so this is saying that if the intertrialInterval is longer than 30 seconds, we dont want that TTL. It most likely is a trial that I ran PRIOR to the pt to check system, and it was included in the final output
end

index_tooShort = intertrialInterval_TTLnav(:) < 3.5; %so this is saying that if the intertrialInterval is shorter than 3.5 seconds, we should kick it out. this is likely from a trial wherein pt responded too quickly to be possible but not so quickly that controller picked up on the OE

if sum(index_tooLong) > 0
    if index_tooLong(1) ~= 1
        error('error in Case03_AOstart_adapter_V2; check that too long error makes sense')
    end
end

%AT to account for the last trial needing a representation in the
%indexes...
index_tooLong = [index_tooLong;0];
index_tooShort = [index_tooShort;0];

index = index_tooLong + index_tooShort;
index = logical(index);

waitperiod_index_easilyscannable_cleaned = waitperiod_index_easilyscannable;
waitperiod_index_easilyscannable_cleaned(:,index) = []; %remove the whole row
%for the above variable, it should now (cleanly) represent

%AT 4/2/20 Should be zero for case01, case02, case03
offset=sum(index_tooLong);


for i = 1:(length(rData))
    rDatatime_seconds(i+offset,1) =rData(i).Start_loop + rData(i).Hold_time + rData(i).Postholdtime + rData(i).Writeuptime;
end


for i = 1:(length(rData)-1)
    intertrialInterval_rData(i+offset,1) = ((rData(i+1).Wholetrial - rDatatime_seconds(i+1)) - (rData(i).Wholetrial - rDatatime_seconds(i)));
end



%The below code is dedicated to accounting for the presence of 'error'
%trials; for each error trial in rData, we should find one less trial start
%as identified by the TTL nav code. So I've manually inputted 'errorLoc' w/
%location of the errors (aka out earlies) for each of the relevant cases
%below.
if caseNumb == 1
    
    errorLoc = 43;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 3; %theres an error on trial 2 AND 3, see adjust code below
    intertrialInterval_rData(errorLoc-2,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1) + rDatatime_seconds(errorLoc-2,1);
    intertrialInterval_rData(errorLoc,:) = [];
    intertrialInterval_rData(errorLoc-1,:) = [];
    
    
elseif caseNumb == 2
    errorLoc = 62;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc = 40;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc =  27;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc = 12;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc = 3;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 3
    
    errorLoc = 71;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc = 67;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc =  33;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    errorLoc = 2;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 4
    
    errorLoc = 67;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 49;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 47;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 3; %theres an error on trial 2 AND 3, see adjust code below
    intertrialInterval_rData(errorLoc-2,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1) + rDatatime_seconds(errorLoc-2,1);
    intertrialInterval_rData(errorLoc,:) = [];
    intertrialInterval_rData(errorLoc-1,:) = [];
    
elseif caseNumb == 5
    disp('No error trials in this case (case05)')
elseif caseNumb == 6
    
    errorLoc = 79;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 40;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 7
    
    errorLoc = 96;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 88;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 84;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 81;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 75;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 68;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 44;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 42;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 35;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 33;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 16;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 14;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
elseif caseNumb == 8
    
    errorLoc = 61;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 57;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 52; %note there's an error on 52 and 51
    intertrialInterval_rData(errorLoc-2,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1) + rDatatime_seconds(errorLoc-2,1);
    intertrialInterval_rData(errorLoc,:) = [];
    intertrialInterval_rData(errorLoc-1,:) = [];
    
    
    errorLoc = 37;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 32;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 26;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 11;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 6;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
elseif caseNumb == 9
    
    errorLoc = 30;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 13;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 10
    
    errorLoc = 72;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 62;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 58;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 45;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 43;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 35;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 30;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 25;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 17;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 11;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 5;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 11
    errorLoc = 49;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 47;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 27;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 22;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 3;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
elseif caseNumb == 12
    
    errorLoc = 21;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 19;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 9;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    %4/2/20; The below needs to be corrected because of the splicing
    %together of first and second part of recordings. Best thing to do is
    %just to move the TTL marker to the 'right' spot that corresponds with
    %output from rData. This preserves all downstream code and requires
    %the below change.
    
    spliceError = intertrialInterval_rData(33) - intertrialInterval_TTLnav(33);
    waitperiod_index_easilyscannable_cleaned(34) = waitperiod_index_easilyscannable_cleaned(34) + round(spliceError*44000);
    intertrialInterval_TTLnav(33) = (waitperiod_index_easilyscannable_cleaned(34) - waitperiod_index_easilyscannable_cleaned(33))/44000;
    
elseif caseNumb == 13
    
    %errorLoc = 81;
    intertrialInterval_rData(end) = intertrialInterval_rData(end) - 3.55; %AT 4/8/20; this is necessary because of error on last trial; it is not a true error but had to cut due to weird timing of
    
    errorLoc = 76;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 57;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    errorLoc = 28; %note there's an error on 28 and 27
    intertrialInterval_rData(errorLoc-2,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1) + rDatatime_seconds(errorLoc-2,1);
    intertrialInterval_rData(errorLoc,:) = [];
    intertrialInterval_rData(errorLoc-1,:) = [];
    
    
    errorLoc = 10;
    intertrialInterval_rData(errorLoc-1,1) = rDatatime_seconds(errorLoc,1) + rDatatime_seconds(errorLoc-1,1);
    intertrialInterval_rData(errorLoc,:) = [];
    
    
    %For case13 it looks like TTL's don't include the first trial. So I
    %changed the rData file to reflect trial 1 as an error. This should
    %mean that for all my analyses to date, we're throwing out error
    %trials.
    intertrialInterval_rData(1,:) = [];
    
    
    spliceError = intertrialInterval_rData(24) - intertrialInterval_TTLnav(24);
    waitperiod_index_easilyscannable_cleaned(25) = waitperiod_index_easilyscannable_cleaned(25) + round(spliceError*44000);
    intertrialInterval_TTLnav(24) = (waitperiod_index_easilyscannable_cleaned(25) - waitperiod_index_easilyscannable_cleaned(24))/44000;
    
    waitperiod_index_easilyscannable_cleaned(end) = [];
end


sidebysideComparison = [intertrialInterval_TTLnav, intertrialInterval_rData];

for k = 1:length(sidebysideComparison)
    if abs(sidebysideComparison(k,1) - sidebysideComparison(k,2)) > 0.1
        error('mismatch in indexing')
    end
end

errorCount = zeros(length(rData),1);
for k = 1:length(rData)
    if (rData(k).actual == 'f')
        errorCount(k) = 1;
    end
end

%AT adding below on 4/4/20 to account for the 'nearOE' that occur; there is
%no place in the code aside from below where I've dedicated space to
%cutting out the trials that passed the waitdelay epoch but were really
%initiated too quickly. We cut these out of behavior in the important
%behavior
if cutNearOEs == 1
    if caseNumb == 1
        waitperiod_index_easilyscannable_cleaned(66) = [];
        waitperiod_index_easilyscannable_cleaned(60) = [];
        waitperiod_index_easilyscannable_cleaned(41) = [];
        waitperiod_index_easilyscannable_cleaned(40) = [];
        waitperiod_index_easilyscannable_cleaned(29) = [];
    elseif caseNumb == 11
        waitperiod_index_easilyscannable_cleaned(8) = [];
        waitperiod_index_easilyscannable_cleaned(5) = [];
    end
    % completedTrials = length(rData) - sum(index) - sum(errorCount);%note, need to check this works out
    completedTrials = length(rData) - sum(index_errors); %4/4/20; index_errors include both the 'too shorts' as ID'ed by behavior import as well as trials where they truly went OE
    
    if completedTrials ~= length(waitperiod_index_easilyscannable_cleaned)
        error('see AOstart_adapter_VX; Problem with TTL indexing compared to behavior')
        %Note check that the thresh's used in this fx are fx'ing as expected if
        %above error is thrown.
    end
    
    taskbase_io.trialStart_AO = waitperiod_index_easilyscannable_cleaned';
    
    
    
    
    
end