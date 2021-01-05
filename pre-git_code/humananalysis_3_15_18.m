%some preprocessing to remove incorrects

% IS_ipsi_matrix
X = IS_ipsi_matrix;
incorrect_condition = X(:,6)==2; %if a 2 is present, then that one was WRONG
IS_ipsi_matrix(incorrect_condition,:) = []; %remove the whole row

% IS_contra_matrix
X = IS_contra_matrix;
incorrect_condition = X(:,6)==2; %if a 2 is present, then that one was WRONG
IS_contra_matrix(incorrect_condition,:) = []; %remove the whole row

% SG_ipsi_matrix
X = SG_ipsi_matrix;
incorrect_condition = X(:,6)==2; %if a 2 is present, then that one was WRONG
SG_ipsi_matrix(incorrect_condition,:) = []; %remove the whole row

% SG_contra_matrix
X = SG_contra_matrix;
incorrect_condition = X(:,6)==2; %if a 2 is present, then that one was WRONG
SG_contra_matrix(incorrect_condition,:) = []; %remove the whole row


%% this cell is for the 4rasters used to compare GO CUE to RESPONSE
figure(12)
title('PT 4, Go-Cue in blue, Response in red')

inputmatrix = IS_ipsi_matrix;
nameofplot = {'IS Left'};
subplotposition = 1;
range = [-1,5];
%for below, the events are numbered like in the lab book
trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued 


subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,responsetime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);





inputmatrix = IS_contra_matrix; 
nameofplot = {'IS Right'};
subplotposition = 2;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued 

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,responsetime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);




inputmatrix = SG_ipsi_matrix;
nameofplot = {'SG Left'};
subplotposition = 3;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued 

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,responsetime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);



inputmatrix = SG_contra_matrix;
nameofplot = {'SG Right'};
subplotposition = 4;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued 

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,responsetime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);

%% this cell is for the 4rasters used to compare first time UP pressed and then when relaxed to FEEDBACK
figure(13)
title('PT 4, Trial-Start in blue, Left UP position in red')

inputmatrix = IS_ipsi_matrix;
nameofplot = {'IS Left'};
subplotposition = 1;
range = [-2,8];
%for below, the events are numbered like in the lab book
trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,uppositionFIRSTpushed_vector, range,uppositionleft_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);





inputmatrix = IS_contra_matrix; 
nameofplot = {'IS Right'};
subplotposition = 2;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,uppositionFIRSTpushed_vector, range,uppositionleft_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);




inputmatrix = SG_ipsi_matrix;
nameofplot = {'SG Left'};
subplotposition = 3;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,uppositionFIRSTpushed_vector, range,uppositionleft_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);




inputmatrix = SG_contra_matrix;
nameofplot = {'SG Right'};
subplotposition = 4;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,uppositionFIRSTpushed_vector, range,uppositionleft_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);

%% this cell is for the 4rasters used to compare gocue pressed and feedback
figure(14)
title('PT 4, go cue in blue, feedback in red')

inputmatrix = IS_ipsi_matrix;
nameofplot = {'IS Left'};
subplotposition = 1;
range = [-2,8];
%for below, the events are numbered like in the lab book
trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,feedbacktime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);





inputmatrix = IS_contra_matrix; 
nameofplot = {'IS Right'};
subplotposition = 2;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,feedbacktime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);




inputmatrix = SG_ipsi_matrix;
nameofplot = {'SG Left'};
subplotposition = 3;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,feedbacktime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);




inputmatrix = SG_contra_matrix;
nameofplot = {'SG Right'};
subplotposition = 4;

trialstart_seconds = (inputmatrix(:,1)/44000)';
Start_loop_vector = inputmatrix(:,9)'; %this time point is right up until the 'up' position is selected
Hold_time_vector = inputmatrix(:,10)'; %this point is right after the go cue was given
Postholdtime_vector = inputmatrix(:,11)'; %post hold goes right up until a response was issued 
responsetime_vector = inputmatrix(:,18)'; %post hold goes right up until a response was issued , corrected for sampling time
feedbacktime_vector = inputmatrix(:,13)'; %feedbacktime
uppositionleft_vector = inputmatrix(:,19)'; %post hold goes right up until a response was issued , corrected for sampling time
uppositionFIRSTpushed_vector = inputmatrix(:,20)'; %when trial was initiated

subplot(2,2,subplotposition)
[ref_spike_times, trial_inds] = raster(spike_seconds,trialstart_seconds,Hold_time_vector, range,feedbacktime_vector); % raster(spike_seconds,trialstart_seconds,Postholdtime_vector, [-1, 1]);
title(nameofplot);

