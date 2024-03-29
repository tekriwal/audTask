%1/20/20 - v1; below works to some extent, but it causes my laptop to really
%freak out with the processing demands


%% 1/20/20 there's some slight differences between pts that is making this is a little challenging. Use PT 6 for proof of principle 
%%1/8/20 - note, I think we need to have the 'Box' added to path for below to work
%% 12/1/19 working on getting the data correctly pulling in from excel sheet

caseNumb = 6;


p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/auditorytask/IO/MATLABCODE_io');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/auditorytask/IO/AT_lfp_code');
addpath(p);


[caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);


[inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);


[Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table);


%AT 1/8/20; adding below so we can do some analyses on the imported data
%now

fromwhere_relativetoendofwaitperiod = -17;%-17 should be the start of the trial
% fromwhere_relativetoendofwaitperiod = 0; %have 0 here will identify the
% first TTL after the delay epoch is completed


%select which spike file we want to look at
% rData = rsp_struct.ans;
rData = rsp_struct.rsp_master_v3;

%AT 1/19/20 - change spikeX to call up differnt spike files
spike_timestamp = spike1.spikeDATA.waveforms.posWaveInfo.posLocs;
% spike_timestamp = spikeDATA.waveforms.negWaveInfo.neglocs;

lasttrialwewant = length(rData);
trialsperblock = 9;

behavior_timestamp = Ephys_struct.ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same




figure(1)
% below plots the spikes as scatterplot
x = spike_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 50;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[1 1 1],...
              'LineWidth',1.5)          
hold on
% below plots the identified TTL accourding to whatever input set at top of
% script
x = behavior_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 10;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
              'MarkerFaceColor',[0 .2 .2],...
              'LineWidth',1.5)





ts = 44000;
spikestart = Ephys_struct.mer.timeStart;
spikeend = Ephys_struct.mer.timeEnd;
spiketime = spikeend-spikestart;
%should find that neuralrecordtime == spiketime
neuralrecordsamples = size(Ephys_struct.CSPK_01);
neuralrecordtime = neuralrecordsamples(2)/ts;
if floor(spiketime) == floor(neuralrecordtime) %not too accurate since using floor, should limit decim. places and use w/out floor
    disp('GOOD - comparisons of spike time start and end');
else 
    disp('ERROR - comparisons of spike time start and end');
end

% comparing TTLs now
ttlreecordtime = Ephys_struct.ttlInfo.ttl_up(end)/ts; %we expect this to be < neuralrecordtime
behaviorrecordtime = rData(lasttrialwewant).Wholetrial;
a = behaviorrecordtime*44000; %converting behavior data 'clock' to TTL sample number


%waitperiod_index: should spit out all the TTLs for when the full 'wait
%period' was executed; update 4/11/18; this should actually spit out the
%TTL that comes right after the 
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
%below plots spikes
x = spike_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 50;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
    'MarkerFaceColor',[1 1 1],...
    'LineWidth',1.5)
% xlim = ([1:neuralrecordsamples(2)]);
hold on
%below plots TTLs
x = behavior_timestamp;
y = zeros(1,length(x)); y(:)=2;
sz = 10;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
    'MarkerFaceColor',[0 .2 .2],...
    'LineWidth',1.5)

hold on
%below plots what should be identified as your reference TTL (should be the
%start of the trial)
x = waitperiod_index_easilyscannable;
y = zeros(1,length(x)); y(:)=2;
sz = 2;
scatter(x,y,sz,'MarkerEdgeColor',[1 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth',1.5)
% TTLDATA = ttlInfo.ttl_up; %this contains all timestamps
% TTLtotaltime = (TTLDATA(end)-TTLDATA(1))/44000;
% Behaviortotaltime = rData(lasttrialwewant).Wholetrial;
% diff = TTLtotaltime - Behaviortotaltime; %8 millisecond difference is believable I think
          
%%
%%
%%
a = 2+2;
%AT 1/20/20l so I know that I can get to the above spot



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
    behavioral_matrix(i,8) = rData(i).Start_loop;
    behavioral_matrix(i,9) = rData(i).Start_loop+rData(i).Hold_time;
    behavioral_matrix(i,10) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime;
    behavioral_matrix(i,11) = inputmatrix.input_matrix_rndm(i);
    behavioral_matrix(i,12) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime+rData(i).timeoffeedback;
    behavioral_matrix(i,13) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime_UPheld;
    behavioral_matrix(i,14) = rData(i).Writeread_UP1; 
    behavioral_matrix(i,15) = rData(i).Writeread_UP2; 
    behavioral_matrix(i,16) = rData(i).Writeread_response;
    behavioral_matrix(i,17) = rData(i).Start_loop+rData(i).Hold_time + rData(i).rtime - rData(i).Writeread_response; %this is for the adjusted time to when response was detected
    behavioral_matrix(i,18) = rData(i).Start_loop+rData(i).Hold_time+rData(i).Postholdtime - 0.0177; %this is for the adjusted time for when up position left; NOTE STILL NEEDS TO BE EDITTED FOLLOWING UPDATE TO TASK!
    % note above, the 0.0177 is a mean of how long the write-read functions
    % are taking
    behavioral_matrix(i,19) = rData(i).Start_loop - rData(i).Writeread_UP1 - rData(i).Writeread_UP2; 

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


taskbase = struct();
taskbase.pushedUP = psth_matrix(:,20); %when was up pushed, corrected for double writeread
taskbase.gocue = psth_matrix(:,10); %when was go cue given
taskbase.leftUP = psth_matrix(:,19);% when was the UP position left for response to begin, adjusted by using MEAN of writeread, need to upgrade task code (4/12/18 AT)
taskbase.submitsResponds = psth_matrix(:,18); %when response was registered, adjusted for writeread
taskbase.feedback = psth_matrix(:,13);%when feedback was given
%need to save out taskbase as something

% WITH THE ABOVE CELL, we have a matrix with our reference times, Response, actual, wait time, rtime, and whether it was correct (1) or incorrect (2), plus SG (26) or IS (12)

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
ipsi_condition = X(:,3)~=1; 
ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

contra_matrix = psth_matrix;
X = contra_matrix;
contra_condition = X(:,3)~=2; 
contra_matrix(contra_condition,:) = []; %remove the whole row


SG_ipsi_matrix = SG_matrix;
X = SG_ipsi_matrix;
ipsi_condition = X(:,3)~=1; 
SG_ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

SG_contra_matrix = SG_matrix;
X = SG_contra_matrix;
contra_condition = X(:,3)~=2; 
SG_contra_matrix(contra_condition,:) = []; %remove the whole row

IS_ipsi_matrix = IS_matrix;
X = IS_ipsi_matrix;
ipsi_condition = X(:,3)~=1; 
IS_ipsi_matrix(ipsi_condition,:) = []; %remove the whole row

IS_contra_matrix = IS_matrix;
X = IS_contra_matrix;
contra_condition = X(:,3)~=2; 
IS_contra_matrix(contra_condition,:) = []; %remove the whole row

% prepping for 'Raster'

%already have spike times as a seperarate variable but the times are in
%samples not seconds, and we need seconds

spike_seconds = spike_timestamp/44000; %proper format is 1xN
trialstart_seconds = (referencetimes_column/44000)'; %proper format is 1xN

% the below is for when we have highly alternating levels of firing
% throughout trial and we want to compare the first and second halves
% just the first halves
% trialstart_seconds = trialstart_seconds(1:35);
% behavioral_matrix = behavioral_matrix(1:35,:);
% SG_ipsi_matrix = SG_ipsi_matrix(1:12,:);
% SG_contra_matrix = SG_contra_matrix(1:10,:);
% IS_ipsi_matrix = IS_ipsi_matrix(1:7,:);
% IS_contra_matrix = IS_contra_matrix(1:9,:);
%just the second halves
% trialstart_seconds = trialstart_seconds(36:end);
% behavioral_matrix = behavioral_matrix(36:end,:);
% SG_ipsi_matrix = SG_ipsi_matrix(13:end,:);
% SG_contra_matrix = SG_contra_matrix(11:end,:);
% IS_ipsi_matrix = IS_ipsi_matrix(8:end,:);
% IS_contra_matrix = IS_contra_matrix(10:end,:);

INPUT_matrix = behavioral_matrix;
%use below if matrix is equal to the 'behavioral matrix'
Opening_vector = INPUT_matrix(:,7)';
Start_loop_vector = INPUT_matrix(:,8)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = INPUT_matrix(:,9)'; %this point is right after the go cue was given
Postholdtime_vector = INPUT_matrix(:,10)'; %post hold goes right up until a response was issued 
ADJUSTED_response_vector = INPUT_matrix(:,9)'+INPUT_matrix(:,4)'-INPUT_matrix(:,16)'; % adjust response is the time the response was detected, minus the time that the writeread took
feedback_vector = INPUT_matrix(:,12)'; %feedback goes up until the time when feedback was given
%AT 4/11/18; NOTE FOR BELOW: NEEDS A PIECE OF DATA FROM TASK STILL!
ADJUSTED_Postholdtime_vector = INPUT_matrix(:,10)'-mean(behavioral_matrix(:,16)); %this gives the time when the UP position was left BUT WE ARE USING THE AVERAGE TIME OF CONTROLLER SAMPLING AND INSTEAD SHOULD BE USING THE EXACT! JUST SAVE IT OUT!
%%
figure(10)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Start_loop_vector, [-1,1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
% figure(11)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, [-1,1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
% figure(12)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1,1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
% figure(13)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,feedback_vector, [-1,1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
% figure(14)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,ADJUSTED_response_vector, [-1,1]); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);

%% psth_session2_lead1pos_responsegiven_sf20
% figure(100)
% [ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, [-2,2],ADJUSTED_response_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
% figure(3)
% [ref_psth, plot_handle, psth_info] = psth(ref_spike_times, trial_inds, [-1, 1], 5);
smoothingfactor = 10;
bin_resolution = 2; %MILLISECONDS length for a given bin. This will determine how frequency is plotted!!!!!
windowsize = 2000; %how many MILLISECONDS long is window (gets split into half going back from point and half going forward)

%KEY INPUT RIGHT HERE!!!! Consult with lab book to know what number to put
%in here for what timepoint
timepointwanted = 18; %so this corresponds as follows: 9 is for the 'start loop' aka when up was pressed, 10 is the go beep, 11 is when response given
%18 should be adjusted time to response

% % little bit of t testing... NOTE - this is more or less a separate function from the rest of what is going on here - totally appropriate to pop it out sometime/now and generate that function 3/7/18
% 
% %want to count how many spikes come before our point of interest, and how
% %many after...
% 
% %variable 'ref spike times' has this info already...
% WinDow = 0.2; %I believe this is in seconds, not milliseconds, looks at this value for that time before the event AND for same time after event
% %with the above you can really go hunting for periods of significance, be
% %careful...
% 
% 
% %ref_spike_times
% after_spikes = ref_spike_times;
% after_spikes_mat = [];
% before_spikes = ref_spike_times;
% before_spikes_mat = [];
% 
% after_spikes(ref_spike_times<0)=0;
% after_spikes(ref_spike_times>WinDow)=0;
% 
% for i = 1:length(after_spikes)
%     if after_spikes(i) ~= 0
%         appendme = after_spikes(i);
%         after_spikes_mat = [after_spikes_mat appendme];
%     end
% end
% 
% before_spikes(ref_spike_times>0)=0;
% before_spikes(ref_spike_times< -WinDow)=0;
% 
% for i = 1:length(before_spikes)
%     if before_spikes(i) ~= 0
%         appendme = before_spikes(i);
%         before_spikes_mat = [before_spikes_mat appendme];
%     end
% end
% 
% % more for spikes AFTER event in question
% holder_after = 1;
% for i = 1:length(after_spikes_mat)-1
%     if after_spikes_mat(1, i) > after_spikes_mat(1, i+1)
%         appendme = (i+1);
%         holder_after = [holder_after appendme];
%     end
% end
% 
% %KEY - so 'holder' contains the START of each trial
% ttestmat_afterspikes = [];
% for i = 1:length(holder_after)-1
%     append = after_spikes_mat(holder_after(i) : holder_after(i+1)-1) ;
%     ttestmat_afterspikes(i, 1:length(append)) = append;
%     
% %     ttestmat_afterspikes = [ttestmat_afterspikes append];
% end
% 
% TTEST_GROUP_AFTERevent = ttestmat_afterspikes;
% TTEST_GROUP_AFTERevent(ttestmat_afterspikes>0) = 1;
% TTEST_GROUP_AFTERevent_input = sum(TTEST_GROUP_AFTERevent,2);
% 
% % more for spikes BEFORE event in question
% holder_before = 1;
% for i = 1:length(before_spikes_mat)-1
%     if before_spikes_mat(1, i) > before_spikes_mat(1, i+1)
%         appendme = (i+1);
%         holder_before = [holder_before appendme];
%     end
% end
% 
% %KEY - so 'holder' contains the START of each trial
% ttestmat_beforespikes = [];
% for i = 1:length(holder_before)-1
%     append = before_spikes_mat(holder_before(i) : holder_before(i+1)-1) ;
%     ttestmat_beforespikes(i, 1:length(append)) = append;
%     
% %     ttestmat_afterspikes = [ttestmat_afterspikes append];
% end
% 
% TTEST_GROUP_BEFOREevent = ttestmat_beforespikes;
% TTEST_GROUP_BEFOREevent(ttestmat_beforespikes<0) = 1;
% TTEST_GROUP_BEFOREevent_input = sum(TTEST_GROUP_BEFOREevent,2);
% 
% 
% [h,p] = ttest2(TTEST_GROUP_AFTERevent_input, TTEST_GROUP_BEFOREevent_input, 'Alpha', 0.05)
% so im going to try and plot some stuff...
%
KEYINPUT = SG_ipsi_matrix;
raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea

[m,n] = size(KEYINPUT);
for t = 1:m
    
%     zeropoint = timeinput(t);
    referencepoint = raster_struct.endofwaittime(t);
    zeropoint = round(referencepoint+(44000*KEYINPUT(t,timepointwanted)));
    
%     zeropoint= raster_struct.endofwaittime(t); 
    
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW_simple = linspace(windowstart, windowend, windowend-windowstart+1);%window_simple gives the range of windoW without the '1's
    windoW = windoW_simple;
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    %AT below is something we'd want to change
   spikeTTLtimestamps = spike1.spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
%                     disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW_simple(1):windoW_simple(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
%         for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            
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

numberspikes_binned_summed = sum(numberspikes_binned); %here we are taking the SUM of all the spikes for each bin of size 'bin resolution', so this is not really the measure we ultimately want to plot, we want FREQUENCY
numberoftrials=size(numberspikes_binned);
numberspikes_binned_ave = numberspikes_binned_summed/(numberoftrials(1));
numberspikes_binned_summed_freq = numberspikes_binned_ave*(1000/bin_resolution);
%would be a good place to insert something for calculating SD bands for
%plotting the PSTH

y_SGipsi = numberspikes_binned_summed_freq;
x = 1:length(numberspikes_binned);
x_milliseconds = x*bin_resolution;
% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y_SGipsi,smoothingfactor); %moving average every 6 

figure(10)
% p = plot(x_milliseconds,yyy,'-.k');
% 
% % plot(x,y)
% % xticks(p,[1 20 40 60 80 100 120 140 160 180 200])
% xticks(p,[1, 200])
% 
% % xticklabels(ax2,{'one','two','three'})
% xticklabels(p,{'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'});

x = x_milliseconds;
y = yyy;
p = plot(x,y,'-.k');
xticks([1 200 400 600 800 1000 1200 1400 1600 1800 2000])
xticklabels({'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'})
% xticks([1 20 40 60 80 100 120 140 160 180 200])
% xticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'})
xlabel('Time (milliseconds)')
ylabel('Firing rate (Hz)')

% xticks(1:200)
%so it auto plots with eleven total tick marks

% 
% a = [{-(windowsize/2)}, {-(windowsize/2)+((windowsize/2)*(1/5))}, {-(windowsize/2)+((windowsize/2)*(2/5))}, {-(windowsize/2)+((windowsize/2)*(3/5))}, {-(windowsize/2)+((windowsize/2)*(4/5))}, {0},{((windowsize/2)*(1/5))}, {((windowsize/2)*(2/5))}, {((windowsize/2)*(3/5))}, {((windowsize/2)*(4/5))}, {((windowsize/2)*(5/5))}];
% xticklabels = a;

set(p, 'LineWidth', 5);

hold on
%

KEYINPUT = SG_contra_matrix;


raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
% windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
% bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea

[m,n] = size(KEYINPUT);
for t = 1:m    
    referencepoint = raster_struct.endofwaittime(t);
    zeropoint = round(referencepoint+(44000*KEYINPUT(t,timepointwanted)));
    
%     zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW_simple = linspace(windowstart, windowend, windowend-windowstart+1);%window_simple gives the range of windoW without the '1's
    windoW = windoW_simple;
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spike1.spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
%                     disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW_simple(1):windoW_simple(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
%         for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            
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

numberspikes_binned_summed = sum(numberspikes_binned); %here we are taking the SUM of all the spikes for each bin of size 'bin resolution', so this is not really the measure we ultimately want to plot, we want FREQUENCY
numberoftrials=size(numberspikes_binned);
numberspikes_binned_ave = numberspikes_binned_summed/(numberoftrials(1));
numberspikes_binned_summed_freq = numberspikes_binned_ave*(1000/bin_resolution);
%would be a good place to insert something for calculating SD bands for
%plotting the PSTH

y_SGcontra = numberspikes_binned_summed_freq;
x = 1:length(numberspikes_binned);
x_milliseconds = x*bin_resolution;
% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y_SGcontra,smoothingfactor); %moving average every 6 


x = x_milliseconds;
y = yyy;
p = plot(x,y,'Color','k');
xticks([1 200 400 600 800 1000 1200 1400 1600 1800 2000])
xticklabels({'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'})
% xticks([1 20 40 60 80 100 120 140 160 180 200])
% xticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'})
xlabel('Time (milliseconds)')
ylabel('Firing rate (Hz)')
set(p, 'LineWidth', 5);

hold on
%

KEYINPUT = IS_ipsi_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
% windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
% bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea


[m,n] = size(KEYINPUT);
for t = 1:m    
    referencepoint = raster_struct.endofwaittime(t);
    zeropoint = round(referencepoint+(44000*KEYINPUT(t,timepointwanted)));
    
%     zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW_simple = linspace(windowstart, windowend, windowend-windowstart+1);%window_simple gives the range of windoW without the '1's
    windoW = windoW_simple;
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spike1.spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
%                     disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW_simple(1):windoW_simple(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
%         for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            
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

numberspikes_binned_summed = sum(numberspikes_binned); %here we are taking the SUM of all the spikes for each bin of size 'bin resolution', so this is not really the measure we ultimately want to plot, we want FREQUENCY
numberoftrials=size(numberspikes_binned);
numberspikes_binned_ave = numberspikes_binned_summed/(numberoftrials(1));
numberspikes_binned_summed_freq = numberspikes_binned_ave*(1000/bin_resolution);
%would be a good place to insert something for calculating SD bands for
%plotting the PSTH

y_ISipsi = numberspikes_binned_summed_freq;
x = 1:length(numberspikes_binned);
x_milliseconds = x*bin_resolution;
% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y_ISipsi,smoothingfactor); %moving average every 6 

figure(10)
x = x_milliseconds;
y = yyy;
p = plot(x,y,'-.','Color',[.5 .5 .5]);

xticks([1 200 400 600 800 1000 1200 1400 1600 1800 2000])
xticklabels({'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'})
% xticks([1 20 40 60 80 100 120 140 160 180 200])
% xticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'})
xlabel('Time (milliseconds)')
ylabel('Firing rate (Hz)')
set(p, 'LineWidth', 5);

hold on



KEYINPUT = IS_contra_matrix;

raster_struct = struct();
raster_struct.endofwaittime = KEYINPUT; %THIS IS THE KEY INPUT!!!!!
% windowsize = 2000; %how many MILLISECONDS long is window
numberspikes_total = zeros(length(KEYINPUT),1); %pre-allocating and populating with NaNs because... seems like a good idea
% bin_resolution = 10; %MILLISECONDS length for a given bin
numberspikes_binned = zeros(length(KEYINPUT),windowsize/bin_resolution); %pre-allocating and populating with NaNs because... seems like a good idea

[m,n] = size(KEYINPUT);
for t = 1:m    
    referencepoint = raster_struct.endofwaittime(t);
    zeropoint = round(referencepoint+(44000*KEYINPUT(t,timepointwanted)));
    
%     zeropoint = raster_struct.endofwaittime(t);
    windowstart = zeropoint - (44000*((windowsize/1000)/2)); %backwards 'windowsize/2' 
    windowend = zeropoint + (44000*((windowsize/1000)/2)); %forwards 'windowsize/2' 
    
    windoW_simple = linspace(windowstart, windowend, windowend-windowstart+1);%window_simple gives the range of windoW without the '1's
    windoW = windoW_simple;
    windoW_binary = linspace(windowstart, windowend, windowend-windowstart+1);
    spikeTTLtimestamps = spike1.spikeDATA.waveforms.allWavesInfo.alllocs;
    
    for i = windoW(1):windoW(end)
        if ismember(i, spikeTTLtimestamps(:))
            windoW(i-windowstart+1) = 1;
            for b = 1:windowsize/bin_resolution
%                 if i >= 1+(((windowsize/bin_resolution)*b)-windowsize/bin_resolution) && i <= (windowsize/bin_resolution)*b
                if i >= windowstart+(bin_resolution*44*(b-1)) && i <= windowstart+((bin_resolution)*44*b)
%                     disp('huzzah')
                    numberspikes_binned(t,b) = numberspikes_binned(t,b) + 1;
                end
            end
                       
        end
    end
        
        %so now, should have windoW having a '1' whenever there's a spike but
        %otherwise the timestamp number in the cell, so...
        for i = windoW_simple(1):windoW_simple(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
%         for i = windoW(1):windoW(end) %so this whole thing below where we're converting from window to window binary, only necessary as part of legacy code
            
            
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

numberspikes_binned_summed = sum(numberspikes_binned); %here we are taking the SUM of all the spikes for each bin of size 'bin resolution', so this is not really the measure we ultimately want to plot, we want FREQUENCY
numberoftrials=size(numberspikes_binned);
numberspikes_binned_ave = numberspikes_binned_summed/(numberoftrials(1));
numberspikes_binned_summed_freq = numberspikes_binned_ave*(1000/bin_resolution);
%would be a good place to insert something for calculating SD bands for
%plotting the PSTH

y_IScontra = numberspikes_binned_summed_freq;
x = 1:length(numberspikes_binned);
x_milliseconds = x*bin_resolution;
% figure(4)
% plot(x,y,'-o')
% 
% yy = smooth(y,10); %moving average every 10
% figure(5)
% plot(x,yy,'-o')

%below looks pretty good
yyy = smooth(y_IScontra,smoothingfactor); %moving average every 6 


x = x_milliseconds;
y = yyy;
p = plot(x,y,'Color',[.5 .5 .5]);
xticks([1 200 400 600 800 1000 1200 1400 1600 1800 2000])
xticklabels({'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'})
% xticks([1 20 40 60 80 100 120 140 160 180 200])
% xticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'})
xlabel('Time (milliseconds)')
ylabel('Firing rate (Hz)')
set(p, 'LineWidth', 5);

hold on


h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-.k');
h(2) = plot(NaN,NaN,'k');
h(3) = plot(NaN,NaN,'-.','Color',[.5 .5 .5]);
h(4) = plot(NaN,NaN,'Color',[.5 .5 .5]);
% h(3) = plot(NaN,NaN,'ok');
% legend(h, 'Participant 1','Participant 2','Participant 3','Combined');

legend(h,'SG - ipsi','SG - contra','IS - ipsi','IS - contra');

%
% y_PT4_1_2_top_11_SD3 = [y_IScontra;y_ISipsi;y_SGcontra;y_SGipsi];
% save('y_PT4_1_2_top_11_SD3')
%%

x_milliseconds = x*bin_resolution;
smoothingfactor = 50;

yyy1 = smooth(y_SGipsi,smoothingfactor); %moving average every 6 
yyy2 = smooth(y_SGcontra,smoothingfactor); %moving average every 6 
yyy3 = smooth(y_ISipsi,smoothingfactor); %moving average every 6 
yyy4 = smooth(y_IScontra,smoothingfactor); %moving average every 6 

figure(11)

p = plot(x,yyy1,'-.k');
set(p, 'LineWidth', 5);

hold on
p = plot(x,yyy2,'Color','k');
set(p, 'LineWidth', 5);

% hold on
% p = plot(x,yyy3,'-.','Color',[.5 .5 .5]);
% set(p, 'LineWidth', 5);
% 
% hold on
% p = plot(x,yyy4,'Color',[.5 .5 .5]);
% set(p, 'LineWidth', 5);

hold on


h = zeros(4, 1);
h(1) = plot(NaN,NaN,'-.k');
h(2) = plot(NaN,NaN,'k');
h(3) = plot(NaN,NaN,'-.','Color',[.5 .5 .5]);
h(4) = plot(NaN,NaN,'Color',[.5 .5 .5]);
% xticks([1 200 400 600 800 1000 1200 1400 1600 1800 2000])

xticklabels({'-1000','-800','-600','-400','-200','0','200','400','600','800','1000'})
% xticks([1 20 40 60 80 100 120 140 160 180 200])
% xticklabels({'-100','-80','-60','-40','-20','0','20','40','60','80','100'})
xlabel('Time (milliseconds)')
ylabel('Firing rate (Hz)')
legend(h,'SG - leftward movement','SG - rightward movement','IS - leftward movement','IS - rightward movement');
set(h, 'LineWidth', 3);


 xlim([0 2000])

