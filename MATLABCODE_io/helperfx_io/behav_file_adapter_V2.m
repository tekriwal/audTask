%V2; AT 3/28/20 - adding code to remove the first three trials as they are
%'practice'; see input cutfirst3trials

%AT V1 created on 2/15/20 in order to calculate the appropriate timings
%from our io task. The point of this function is to create something
%analogous to the mouse taskbase, wherein the timings of specific events
%are calculated all relative to the start of a given trial. This will make
%plotting rasters and psth's much simpler. 

%2/15/20 - Original code was copy and pasted from work I had previously done within
%the script 'psth_v1'. 

%2/15/20 - Note - since there's different versions of the task, specifically the
%changes from v1 to v2, and then v2 to v3 most importantly, this is a fx
%that will need to be changed. Hopefully, differerent versions of this fx
%will be able to compensate for the different versions of the task without
%messing anything up too much.

%AT 3/28/20 - index_errors added to output
function [taskbase_io, behavioral_matrix, index_errors] = behav_file_adapter_V2(rData, inputmatrix, cutfirst3trials, cutNearOEs)

trialsperblock = 9;
taskbase_io = struct();


% challenging to work with struct so putting relevant variables from Matlab behavioral output into a matrix so we can index out the 'f' or '0' trials
behavioral_matrix = zeros((length(rData)),19);
for i = 1:length(rData)
    
    if rData(i).Response == 1
        behavioral_matrix(i,1) = 1;
    elseif rData(i).Response == 2
        behavioral_matrix(i,1) = 2;
    end
    
    if rData(i).actual == 1
        behavioral_matrix(i,2) = 1;
    elseif rData(i).actual == 2
        behavioral_matrix(i,2) = 2;
    end
    behavioral_matrix(i,3) = rData(i).responsedelay;
    behavioral_matrix(i,4) = rData(i).rtime;
    behavioral_matrix(i,7) = rData(i).Opening;
    behavioral_matrix(i,8) = rData(i).Start_loop - rData(i).Writeread_UP1 - rData(i).Writeread_UP2;
    behavioral_matrix(i,9) = rData(i).Start_loop+rData(i).Hold_time;
    behavioral_matrix(i,10) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime;
    behavioral_matrix(i,11) = inputmatrix(i);
    behavioral_matrix(i,12) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime+rData(i).timeoffeedback;
    behavioral_matrix(i,13) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime_UPheld;
    behavioral_matrix(i,14) = rData(i).Writeread_UP1; 
    behavioral_matrix(i,15) = rData(i).Writeread_UP2; 
    behavioral_matrix(i,16) = rData(i).Writeread_response;
    behavioral_matrix(i,17) = rData(i).Start_loop+rData(i).Hold_time + rData(i).rtime - rData(i).Writeread_response; %this is for the adjusted time to when response was detected
    behavioral_matrix(i,18) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime - 0.0177; %this is for the adjusted time for when up position left; NOTE STILL NEEDS TO BE EDITTED FOLLOWING UPDATE TO TASK!
    % note above, the 0.0177 is a mean of how long the write-read functions
    % are taking
    
    if strcmp(rData(i).ERROR, 'GOOD')
        behavioral_matrix(i,19) = 0;
    elseif  strcmp(rData(i).ERROR, 'ERROR')
        behavioral_matrix(i,19) = 1;
    end
    behavioral_matrix(i,20) = rData(i).Stimbeepduration;
    behavioral_matrix(i,21) = rData(i).Wholetrial - (sum([rData(i).Start_loop,rData(i).Hold_time,rData(i).Postholdtime,rData(i).Writeuptime]));
    behavioral_matrix(i,22) = rData(i).Start_loop + rData(i).Stimbeepduration;
%     behavioral_matrix(i,21) = rData(i).Start_loop - rData(i).Writeread_UP1 - rData(i).Writeread_UP2; 




end
%
for i = 1:length(rData)
    
    if behavioral_matrix(i,1) == 0 %means that column 5 tell incorrect/correct, with a 3 meaning they errored
        behavioral_matrix(i,5) = 3;
    elseif behavioral_matrix(i,1) == 1 && behavioral_matrix(i,2) == 1 %shows a 1 if correct
        behavioral_matrix(i,5) = 1;
    elseif behavioral_matrix(i,1) == 2 && behavioral_matrix(i,2) == 2
        behavioral_matrix(i,5) = 1;
        
    elseif behavioral_matrix(i,1) == 1 && behavioral_matrix(i,2) == 2 %shows a 2 if incorrect
        behavioral_matrix(i,5) = 2;
    elseif behavioral_matrix(i,1) == 2 && behavioral_matrix(i,2) == 1
        behavioral_matrix(i,5) = 2;
        
    end
    
    if i <= trialsperblock || (i > trialsperblock*2 && i <= trialsperblock*3) || (i > trialsperblock*4 && i <= trialsperblock*5) || (i > trialsperblock*6 && i <= trialsperblock*7) || (i > trialsperblock*8 && i <= trialsperblock*9)
        behavioral_matrix(i,6) = 26; %26 is for SG because SG should look like 26
    else
        behavioral_matrix(i,6) = 12; %12 is for IS because IS should look like 12
    end

end
index_errors = behavioral_matrix(:,5)==3; %this says, if column five has a 3 in it because 3 means they error'ed on that trial


threshRxn = 0.10; %in case 11, there are rxn that ~ 0.05 seconds, this causes errors with TTL nav code. This threshold may be too relaxed, unsure
if cutNearOEs == 1
    for i = 1:length(rData)
        if rData(i).Postholdtime < threshRxn
            index_errors(i) = 1;
        end
    end
end


behavioral_matrix(index_errors,:) = []; %remove the whole row

% referencetimes_column = waitperiod_index_easilyscannable';

%AT 3/28/20 - removing the first three trials
if cutfirst3trials == 1
    behavioral_matrix(1:3,:) = []; %remove the whole row
end




%AT 2/16/20, going through below and double checking; looks good
taskbase_io.events.trialStart = behavioral_matrix(:,21);
taskbase_io.events.upPressed = behavioral_matrix(:,8);
taskbase_io.events.stimDelivered = behavioral_matrix(:,22);
taskbase_io.events.goCue = behavioral_matrix(:,9); %when was go cue given
taskbase_io.events.leftUP = behavioral_matrix(:,18);% when was the UP position left for response to begin, adjusted by using MEAN of writeread, need to upgrade task code (4/12/18 AT)
taskbase_io.events.submitsResponse = behavioral_matrix(:,17); %when response was registered, adjusted for writeread
taskbase_io.events.feedback = behavioral_matrix(:,12);%when feedback was given



taskbase_io.response = behavioral_matrix(:,1);
taskbase_io.actual = behavioral_matrix(:,2);
taskbase_io.error =  behavioral_matrix(:,19);
taskbase_io.stimbeepduration = behavioral_matrix(:,20);
taskbase_io.SGorIS = behavioral_matrix(:,6);

% % psth_matrix = behavioral_matrix;
% % taskbase_io.pushedUP = psth_matrix(:,20); %when was up pushed, corrected for double writeread
% % taskbase_io.gocue = psth_matrix(:,10); %when was go cue given
% % taskbase_io.leftUP = psth_matrix(:,19);% when was the UP position left for response to begin, adjusted by using MEAN of writeread, need to upgrade task code (4/12/18 AT)
% % taskbase_io.submitsResponds = psth_matrix(:,18); %when response was registered, adjusted for writeread
% % taskbase_io.feedback = psth_matrix(:,13);%when feedback was given
% % %need to save out taskbase as something



end