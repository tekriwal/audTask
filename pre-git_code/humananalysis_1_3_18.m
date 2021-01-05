%as of 1/22/18, adding some self-checks
% as of 1/1/18, adding a cell to work on PSTH
%as of 12/31/17 at 430PM, updating this for PT3 aka session1

%README: file for analysis of data from November 27th
%remember, need to load in the rData, relevant spike, and AbvTarg/BlwTarg
%files

% smoothingfactor = 15;
fromwhere_relativetoendofwaitperiod = -17;%this should be the start of the trial


%to do this automatically, lets find the last TTL and go backwards by the
%number of TTLs over the finished trial we are interested in

%then look through what is left for those with the ten consecutive TTLs
%indicating completed wait period, are directly followed by a single TTL that is closer to the
%last of the ten than the ten are to one another.THEN a double
%DOUBLES: seem to be separated by 366 or 367, i.e. <400

%then use the behavioral output to determine whether, from what's left,
%whether they are IS or SG
%load in spike file, behavior file, and total neural recording file
load('rData_PT4.mat')
load('AbvTrgt_60_00893.mat')
load('spkData_a60_00893_1_clzD_negative.mat')

rData = rData_PT4;
%lasttrialwewant = length(rData)-1;
lasttrialwewant = length(rData);
trialsperblock = 9;
% good first step, plots the data on one long axis so you can scroll through it

% spike_timestamp = spikeDATA.waveforms.posWaveInfo.posLocs;
spike_timestamp = spikeDATA.waveforms.negWaveInfo.neglocs;

behavior_timestamp = ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same

figure(1)
x = spike_timestamp;
y = zeros(1,length(x)); y(:)=2;

sz = 50;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[1 1 1],...
              'LineWidth',1.5)          
% xlim = ([1:neuralrecordsamples(2)]);

hold on

x = behavior_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 10;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
              'MarkerFaceColor',[0 .2 .2],...
              'LineWidth',1.5)
% xlim = ([1:neuralrecordsamples(2)/20]);
%
% figure(1)
% subplot(3,1,1)
% plot(CSPK_01)
% subplot(3,1,2)
% plot(CSPK_02)
% subplot(3,1,3)
% plot(CSPK_03)
%
ts = 44000;
spikestart = mer.timeStart;
spikeend = mer.timeEnd;
spiketime = spikeend-spikestart;
%should find that neuralrecordtime == spiketime
neuralrecordsamples = size(CSPK_01);
neuralrecordtime = neuralrecordsamples(2)/ts;
if floor(spiketime) == floor(neuralrecordtime) %not too accurate since using floor, should limit decim. places and use w/out floor
    disp('GOOD - comparisons of spike time start and end');
else 
    disp('ERROR - comparisons of spike time start and end');
end

% comparing TTLs now
ttlreecordtime = ttlInfo.ttl_up(end)/ts; %we expect this to be < neuralrecordtime
behaviorrecordtime = rData(lasttrialwewant).Wholetrial;
a = behaviorrecordtime*44000; %converting behavior data 'clock' to TTL sample number


%so we need to sort out 1) what is the TTL that corresponds to the last
%'wholetrial' behavioral time point and 2) what is the TTL first fired when
%the task was initiated

%to begin to cut the TTL file, we need to find the TTL that corresponds to
%the last 'wholetrial'time point from the behavioral data and work
%backwards from that because that signals a full trial was completed.

% b = ttlInfo.ttl_up(end)-a; %'b' should be about the start of the first TTL we are interested in
% c = b-440; %giving it a little buffer (hundred of a second) for wiggle room; difference should be <400 samples
% 
% %now, 'c' should represent the sample# for when the TTLs begin
% %corresponding to behavioral output
% 
% e = find(ttlInfo.ttl_up>c); %note,PT3 had no issues with errors in code when running, so, e should just be linear 
%newTTLstart = e(1); %must be a better way to do this, but works


% newTTLstart = ttlInfo.ttl_up(1);
% f = ttlInfo.ttl_up;
% cutTTL = zeros(1,(length(f)-newTTLstart)+1); 
% for i = 1:((length(f)-newTTLstart)+1)
%     cutTTL(i) = f(i+(newTTLstart-1));
% end

cutTTL = ttlInfo.ttl_up;
% good followup on the first step, plots the data on one long axis so you can scroll through it (compare to figure 1 generated above)

% spike_timestamp = spikeDATA.waveforms.posWaveInfo.posLocs;
spike_timestamp = spikeDATA.waveforms.negWaveInfo.neglocs;


behavior_timestamp = cutTTL; %.ttl_dn is just 2200 samples after this, otherwise same

figure(2)
x = spike_timestamp;
y = zeros(1,length(x)); y(:)=2;

sz = 50;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[1 1 1],...
              'LineWidth',1.5)          
% xlim = ([1:neuralrecordsamples(2)]);

hold on

x = behavior_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 10;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
              'MarkerFaceColor',[0 .2 .2],...
              'LineWidth',1.5)
% xlim = ([1:neuralrecordsamples(2)/20]);


% *%so now, 'cutTTL' has the cut portions of ttlInfo.ttl_up*
%

%waitperiod_index: should spit out all the TTLs for when the full 'wait
%period' was executed - for PT3 there were 5 error trials out of 81, so
%should spit out 76 (GOOD, this is true, 1/1/18)
waitperiod_index = zeros(2,length(cutTTL));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(cutTTL)-1)
    if cutTTL(i+1) - cutTTL(i) < 400 && cutTTL(i) - cutTTL(i-10) < 28000
        waitperiod_index(1,i) = 1;
        waitperiod_index(2,i) = cutTTL(i+fromwhere_relativetoendofwaitperiod);
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

%
redundancy_index = zeros(2,length(rData));
for i = 1:length(rData) 
    
    %following gives the 'corrects' in ROW 1
    if rData(i).Response == 1 && rData(i).actual == 1
        redundancy_index(1,i) = 1;
    elseif rData(i).Response == 2 && rData(i).actual == 2
        redundancy_index(1,i) = 1;
    end
    number_correct = sum(redundancy_index(1,:));
    
    %following gives the 'incorrects' in ROW 2
    if rData(i).Response == 1 && rData(i).actual == 2
        redundancy_index(2,i) = 1;
    elseif rData(i).Response == 2 && rData(i).actual == 1
        redundancy_index(2,i) = 1;
    end    
    number_incorrect = sum(redundancy_index(2,:));
    
end



%does the sum from # of successful wait periods in TTLs equal sum from behavior as I've coded?
if sum(waitperiod_index(1,:)) ~= (sum(redundancy_index(1,:))+sum(redundancy_index(2,:))) 
    disp('ERROR WITH CALC1');
elseif sum(waitperiod_index(1,:)) == (sum(redundancy_index(1,:))+sum(redundancy_index(2,:)))
    disp('NO ERROR WITH CALC1')
end


figure(3)
x = spike_timestamp;
y = zeros(1,length(x)); y(:)=2;

sz = 50;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[1 1 1],...
    'LineWidth',1.5)
% xlim = ([1:neuralrecordsamples(2)]);

hold on

x = behavior_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 10;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
    'MarkerFaceColor',[0 .2 .2],...
    'LineWidth',1.5)

hold on

x = waitperiod_index_easilyscannable;
y = zeros(1,length(x)); y(:)=2;

sz = 2;
scatter(x,y,sz,'MarkerEdgeColor',[1 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth',1.5)

% so this isn't really working out. I think the best thing to do is just take a t=0 and convert the two to the same timescale, i.e. getnlxtimes

TTLDATA = cutTTL; %this contains all timestamps
TTLtotaltime = (TTLDATA(end)-TTLDATA(1))/44000;
Behaviortotaltime = rData(lasttrialwewant).Wholetrial;

diff = TTLtotaltime - Behaviortotaltime; %8 millisecond difference is believable I think

%waitperiod_index_easilyscannable gives timestamp for when the wait period
%ended, let's say we want to graph all the behavior/spike data for 0.2
%seconds before and 0.2 seconds after

%we want to work with 1) TTL data 2) spike data
%1) basically taken care of
%2) not taken care of, so lets below:

lastspike = spikeDATA.waveforms.allWavesInfo.alllocs(end);
%so I'm 99% sure spike data and TTL are all on same clock

% challenging to work with struct so putting relevant variables from Matlab behavioral output into a matrix so we can index out the 'f' or '0' trials
behavioral_matrix = zeros((length(rData)),10);

%
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
    behavioral_matrix(i,8) = rData(i).Start_loop;
    behavioral_matrix(i,9) = rData(i).Start_loop+rData(i).Hold_time;
    behavioral_matrix(i,10) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime;
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

    
condition = behavioral_matrix(:,5)==3; %this says, if column five has a 3 in it because 3 means they error'ed on that trial
behavioral_matrix(condition,:) = []; %remove the whole row

referencetimes_column = waitperiod_index_easilyscannable';

psth_matrix =[referencetimes_column, behavioral_matrix];

% WITH THE ABOVE CELL, we have a matrix with our reference times, Response,
% actual, wait time, rtime, and whether it was correct (1) or incorrect
% (2), plus SG (26) or IS (12)
%

% organizing...

SG_matrix = psth_matrix;
X = SG_matrix;
SG_condition = X(:,7)~=26; 
SG_matrix(SG_condition,:) = []; %remove the whole row

IS_matrix = psth_matrix;
X = IS_matrix;
IS_condition = X(:,7)~=12; 
IS_matrix(IS_condition,:) = []; %remove the whole row

correct_matrix = psth_matrix;
X = correct_matrix;
correct_condition = X(:,6)~=1; 
correct_matrix(correct_condition,:) = []; %remove the whole row

incorrect_matrix = psth_matrix;
X = incorrect_matrix;
incorrect_condition = X(:,6)~=2; 
incorrect_matrix(incorrect_condition,:) = []; %remove the whole row

ipsi_matrix = psth_matrix;
X = ipsi_matrix;
ipsi_condition = X(:,2)~=1; 
ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

contra_matrix = psth_matrix;
X = contra_matrix;
contra_condition = X(:,2)~=2; 
contra_matrix(contra_condition,:) = []; %remove the whole row


SG_ipsi_matrix = SG_matrix;
X = SG_ipsi_matrix;
ipsi_condition = X(:,2)~=1; 
SG_ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

SG_contra_matrix = SG_matrix;
X = SG_contra_matrix;
contra_condition = X(:,2)~=2; 
SG_contra_matrix(contra_condition,:) = []; %remove the whole row

IS_ipsi_matrix = IS_matrix;
X = IS_ipsi_matrix;
ipsi_condition = X(:,2)~=1; 
IS_ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

IS_contra_matrix = IS_matrix;
X = IS_contra_matrix;
contra_condition = X(:,2)~=2; 
IS_contra_matrix(contra_condition,:) = []; %remove the whole row

% prepping for 'Raster'

%already have spike times as a seperarate variable but the times are in
%samples not seconds, and we need seconds

spike_seconds = spike_timestamp/44000; %proper format is 1xN
trialstart_seconds = (referencetimes_column/44000)'; %proper format is 1xN

%above we did this:
%     behavioral_matrix(i,7) = rData(i).Opening;
%     behavioral_matrix(i,8) = rData(i).Start_loop;
%     behavioral_matrix(i,9) = rData(i).Start_loop+rData(i).Hold_time;
%     behavioral_matrix(i,10) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime;
%we need these to be the 'event_times' in raster; need to be in 1xN

Opening_vector = behavioral_matrix(:,7)';
Start_loop_vector = behavioral_matrix(:,8)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = behavioral_matrix(:,9)'; %this point is right after the go cue was given
Postholdtime_vector = behavioral_matrix(:,10)'; %post hold goes right up until a response was issued 

%% psth_session2_lead1pos_responsegiven_sf20

[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);

%%
[ref_psth, plot_handle, psth_info] = psth(ref_spike_times, trial_inds, [-1, 1], 50);

%% so im going to try and plot some stuff...

KEYINPUT = SG_ipsi_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea


for t = 1:length(KEYINPUT)
    zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW = linspace(windowstart, windowend, windowend-windowstart+1);
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
                    disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            if windoW(i-windowstart+1) == 1
                windoW_binary(i-windowstart+1) = 1;
            elseif windoW(i-windowstart+1) ~= 1
                windoW_binary(i-windowstart+1) = NaN;
            end       
            
        end
    
    numberspikes_total(t,1) = sum(windoW_binary(:) == 1);
    
end

% now, adding PSTH
%more or less copying axes from figure above, and modifying so it is a bar
%plot

numberspikes_binned_summed = sum(numberspikes_binned);
y = numberspikes_binned_summed;
x = 1:length(numberspikes_binned);

% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y,smoothingfactor); %moving average every 6 

figure(10)
p = plot(x,yyy,'-.k');
set(p, 'LineWidth', 5);

hold on



KEYINPUT = SG_contra_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea


for t = 1:length(KEYINPUT)
    zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW = linspace(windowstart, windowend, windowend-windowstart+1);
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
                    disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            if windoW(i-windowstart+1) == 1
                windoW_binary(i-windowstart+1) = 1;
            elseif windoW(i-windowstart+1) ~= 1
                windoW_binary(i-windowstart+1) = NaN;
            end       
            
        end
    
    numberspikes_total(t,1) = sum(windoW_binary(:) == 1);
    
end

% now, adding PSTH
%more or less copying axes from figure above, and modifying so it is a bar
%plot

numberspikes_binned_summed = sum(numberspikes_binned);
y = numberspikes_binned_summed;
x = 1:length(numberspikes_binned);

% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y,smoothingfactor); %moving average every 6 

p = plot(x,yyy,'k');
set(p, 'LineWidth', 5);

hold on
%

KEYINPUT = IS_ipsi_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea


for t = 1:length(KEYINPUT)
    zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW = linspace(windowstart, windowend, windowend-windowstart+1);
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
                    disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            if windoW(i-windowstart+1) == 1
                windoW_binary(i-windowstart+1) = 1;
            elseif windoW(i-windowstart+1) ~= 1
                windoW_binary(i-windowstart+1) = NaN;
            end       
            
        end
    
    numberspikes_total(t,1) = sum(windoW_binary(:) == 1);
    
end

% now, adding PSTH
%more or less copying axes from figure above, and modifying so it is a bar
%plot

numberspikes_binned_summed = sum(numberspikes_binned);
y = numberspikes_binned_summed;
x = 1:length(numberspikes_binned);

% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y,smoothingfactor); %moving average every 6 

figure(10)
p = plot(x,yyy,'-.','Color',[.5 .5 .5]);
set(p, 'LineWidth', 5);

hold on



KEYINPUT = IS_contra_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea


for t = 1:length(KEYINPUT)
    zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW = linspace(windowstart, windowend, windowend-windowstart+1);
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
                    disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            if windoW(i-windowstart+1) == 1
                windoW_binary(i-windowstart+1) = 1;
            elseif windoW(i-windowstart+1) ~= 1
                windoW_binary(i-windowstart+1) = NaN;
            end       
            
        end
    
    numberspikes_total(t,1) = sum(windoW_binary(:) == 1);
    
end

% now, adding PSTH
%more or less copying axes from figure above, and modifying so it is a bar
%plot

numberspikes_binned_summed = sum(numberspikes_binned);
y = numberspikes_binned_summed;
x = 1:length(numberspikes_binned);

% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y,smoothingfactor); %moving average every 6 

p = plot(x,yyy,'Color',[.5 .5 .5]);
set(p, 'LineWidth', 5);

hold on






% from past code I wrote, pretty janky but...

%set(p, 'LineWidth', 1);
% ylim([0 1])
% yticks([0 0.5 1])
ylabel('Number spikes (ave. large moving window)');
% xticks([-1000 -800 -600 -400 -200 0 200 400 600 800 1000])
xlabel('Time (milliseconds)')


h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-.k');
h(2) = plot(NaN,NaN,'k');
h(3) = plot(NaN,NaN,'-.','Color',[.5 .5 .5]);
h(4) = plot(NaN,NaN,'Color',[.5 .5 .5]);
% h(3) = plot(NaN,NaN,'ok');
% legend(h, 'Participant 1','Participant 2','Participant 3','Combined');

legend(h,'SG - ipsi','SG - contra','IS - ipsi','IS - contra');
