%so already load in whatever file contains the accelerometer,EMG, TTL data


%data preprocessing


tot_len_acc = length(CACC_3___01___Sensor_1___X);
tot_time_acc = tot_len_acc/(CACC_3___01___Sensor_1___X_KHz*1000);




tot_len_TTL = CDIG_IN_1_Up(end);
tot_time_TTL = tot_len_TTL/(CDIG_IN_1_KHz*1000);


starttime_acc = CDIG_IN_1_TimeBegin;
starttime_TTL = CACC_3___01___Sensor_1___X_TimeBegin;


diff_tot_times = tot_time_acc - tot_time_TTL;
diff_starttimes_time = starttime_acc - starttime_TTL;

extratime_cutfromend_acc = diff_tot_times - diff_starttimes_time;
samplestocut = extratime_cutfromend_acc*CACC_3___01___Sensor_1___X_KHz*1000;



cut_CACC_3___01___Sensor_1___X = CACC_3___01___Sensor_1___X(round(diff_starttimes_time*CACC_3___01___Sensor_1___X_KHz*1000):(end-round(samplestocut)));
cut_CACC_3___02___Sensor_1___Y = CACC_3___02___Sensor_1___Y(round(diff_starttimes_time*CACC_3___01___Sensor_1___X_KHz*1000):(end-round(samplestocut)));
cut_CACC_3___03___Sensor_1___Z = CACC_3___03___Sensor_1___Z(round(diff_starttimes_time*CACC_3___01___Sensor_1___X_KHz*1000):(end-round(samplestocut)));




tot_len_cutacc = length(cut_CACC_3___01___Sensor_1___X);
tot_time_cutacc = tot_len_cutacc/(CACC_3___01___Sensor_1___X_KHz*1000);





% fromwhere_relativetoendofwaitperiod = -17;%this should be the start of the trial
fromwhere_relativetoendofwaitperiod = 0;%this should be the start of the reaction time

% 
% load('rData_PT4.mat')
% load('AbvTrgt_60_00893.mat')
% load('spkData_a60_00893_1_clzD_cluster2of3_lookedbestbutfewestspikes_bottom_3SD.mat')
% load('input_matrix_rndm_Dec28.mat')
% % rData = rData_PT4;
% 
% 
% spike_timestamp = spikeDATA.waveforms.negWaveInfo.neglocs;
% 


% lasttrialwewant = length(rData);
% trialsperblock = 9;


% behavior_timestamp = ttlInfo.ttl_up; %.ttl_dn is just 2200 samples after this, otherwise same
behavior_timestamp = CDIG_IN_1_Up; %.ttl_dn is just 2200 samples after this, otherwise same

x = behavior_timestamp/44000;
y = zeros(1,length(x)); y(:)=0.35;
sz = 2;
scatter(x,y,sz,'MarkerEdgeColor',[0 .2 .2],...
              'MarkerFaceColor',[0 .2 .2],...
              'LineWidth',1.5)
hold on
          
          
waitperiod_index = zeros(2,length(behavior_timestamp));
stopgap = 11; %this is needed because we are 'looking' for the LAST TTL of the 11 train TTL that indicates a successful completion of the wait period
for i = stopgap:(length(behavior_timestamp)-1)
    if behavior_timestamp(i+1) - behavior_timestamp(i) < 400 && behavior_timestamp(i) - behavior_timestamp(i-10) < 13200
        waitperiod_index(1,i) = 1;
        waitperiod_index(2,i) = behavior_timestamp(i+fromwhere_relativetoendofwaitperiod);
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



x = waitperiod_index_easilyscannable/44000;
y = zeros(1,length(x)); y(:)=0.35;

sz = 2;
scatter(x,y,sz,'MarkerEdgeColor',[1 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth',1.5)


hold on


acc_x = cut_CACC_3___01___Sensor_1___X;
acc_y = cut_CACC_3___02___Sensor_1___Y;
acc_z = cut_CACC_3___03___Sensor_1___Z;

input = acc_x;
normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x/(CACC_3___01___Sensor_1___X_KHz*1000);
y = normalizedData;
plot(x1,y)
hold on


input = acc_y;
normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x/(CACC_3___01___Sensor_1___X_KHz*1000);
y = normalizedData;
plot(x1,y)
hold on


input = acc_z;
normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x/(CACC_3___01___Sensor_1___X_KHz*1000);
y = normalizedData;
plot(x1,y)
hold on





%%
%here we want to plot what the recorded reaction times were in the rsp and
%compare to the accelerometer/taskTTLs

%waitperiod_index_easilyscannable is the TTL that marks the start of a
%trial, so 'reaction time' starts from basically exactly the first TTL of the double that occurs right after the go cue. so, I think we just want to go 2 PAST the end of the wait period, and we're good?



rxn_TTLstart = waitperiod_index_easilyscannable(:);

reactiontime_unaltered = [];
for i = 1:18
reactiontime_unaltered(i) = rsp_master_v3(i).rtime;
end
% reactiontime_unaltered = reactiontime_unaltered';



delay_accounting = [];
for i = 1:18
delay_accounting(i) = rsp_master_v3(i).Writeread_response;
end
% delay_accounting = delay_accounting';

reactiontime_altered = reactiontime_unaltered - delay_accounting;



TTLtime_reactiontime_unaltered = reactiontime_unaltered*44000;
TTLtime_reactiontime_altered = reactiontime_altered*44000;

plotme_TTLtime_unaltered=[];
for i = 1:18
    plotme_TTLtime_unaltered(i) = rxn_TTLstart(i)+reactiontime_unaltered(i);
end

plotme_TTLtime_altered=[];
for i = 1:18
    plotme_TTLtime_altered(i) = rxn_TTLstart(i)+reactiontime_altered(i);
end



x = plotme_TTLtime_unaltered;
y = zeros(1,length(x)); y(:)=0.37;

sz = 2;
scatter(x,y,sz,'MarkerEdgeColor','b',...
    'MarkerFaceColor','b',...
    'LineWidth',1.5)


hold on



x = plotme_TTLtime_altered;
y = zeros(1,length(x)); y(:)=0.35;

sz = 2;
scatter(x,y,sz,'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerFaceColor',[0.5 0.5 0.5],...
    'LineWidth',1.5)


hold on

acc_x = CACC_3___01___Sensor_1___X;
acc_y = CACC_3___02___Sensor_1___Y;
acc_z = CACC_3___03___Sensor_1___Z;

input = acc_x;

normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x*(44/2.75);
y = normalizedData;
plot(x1,y)
hold on

input = acc_y;

normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x*(44/2.75);
y = normalizedData;
plot(x1,y)
hold on

input = acc_z;

normalizedData = mat2gray(input);
x = 1:length(normalizedData);
x1 = x*(44/2.75);
y = normalizedData;
plot(x1,y)
hold on


