%fx to change taskbase from io session into same format as taskbase from

%load in io data file and set equal to rData
rData = rsp_master_v3;

%load in psth matrix that corresponds to the above
% psth_matrix = psth_matrix;

%create struct that we'll move io data into
taskbase_io_reformatted = struct();

%% big struct field names

% path of the variable; how do we get? 
taskbase_io_reformatted.expid = NaN;

taskbase_io_reformatted.host = 'win2'; %I think this variable has no effect 
taskbase_io_reformatted.synch_flag = 1; %I think this variable has no effect 

%these are the start times of each trial, in seconds (spike clock)
taskbase_io_reformatted.start = psth_matrix(:,1)/44000;

taskbase_io_reformatted.stimID = psth_matrix(:,12); %numbers from io for stim ID do not automatically match numbers from mouse behavior, will need to adjust

taskbase_io_reformatted.OdorPokeIn = psth_matrix(:,9); %9 is for when UP pushed (trial start)

%what is 'DIO'?
taskbase_io_reformatted.DIO = NaN; 

taskbase_io_reformatted.OdorPokeDur = psth_matrix(:,19) - psth_matrix(:,9); %here, we're substracting (when UP position left - when UP position first detected)

taskbase_io_reformatted.OdorSampDur = 30/1000; %setting odorsampdur to 30 ms because thats about how  long stim delivered

taskbase_io_reformatted.OdorPokeOut = psth_matrix(:,19);

taskbase_io_reformatted.WaterPokeIn = psth_matrix(:,18);

taskbase_io_reformatted.WaterPokeOut = NaN; %we don't record this info, but could theoretically be gleaned from accelerometer data 

taskbase_io_reformatted.WaterDeliv = psth_matrix(:,13); %note, for mouse this field is when POSITIVE feedback given, but in IO we give both positive and negative feedback, so it is just time of feedback here

taskbase_io_reformatted.choice =  psth_matrix(:,3); %here, what was the response that was given by the participant?

%below; was the trial correct (1) or incorrect (0)
for i = 1:length(psth_matrix)
    if psth(i,3) == psth(i,2)
        taskbase_io_reformatted(i).reward = 1;
    else
        taskbase_io_reformatted(i).reward = 0;
    end
end

%I don't understand what the below two are representing. Doesnt make sense with the '.reward' output  
%GF says that below means where reward would have been available
taskbase_io_reformatted.LeftReward, 
taskbase_io_reformatted.RightReward, 

%I think below are how long the solenoid is open when delivering water?
taskbase_io_reformatted.WaterDeliveredL, 
taskbase_io_reformatted.WaterDeliveredR, 

%the clock for 'NextOdorPokeIn' is counting from the start of the previous trial. 
for i = 1:(length(psth_matrix)-1)
    taskbase_io_reformatted(i).NextOdorPokeIn = psth_matrix(i,13)+ psth_matrix(i+1,9)  %'13' is time up until feedback, then '9' is when UP pressed, so should give a good idea of what this is representing (but might be shorting time)

taskbase_io_reformatted.odor_params = struct(); 
taskbase_io_reformatted.odor_params.odors =  
taskbase_io_reformatted.odor_params.L_prob =  
taskbase_io_reformatted.odor_params.R_prob =  
taskbase_io_reformatted.odor_params.fraction_of_trials = 

taskbase_io_reformatted.opto = struct(); 
taskbase_io_reformatted.opto.go_on = NaN; 
taskbase_io_reformatted.opto.lights_on = NaN;  
taskbase_io_reformatted.opto.lights_off = NaN;  
taskbase_io_reformatted.opto.PulseOnWidth = NaN;  
taskbase_io_reformatted.opto.PulseOffWidth = NaN;  
taskbase_io_reformatted.opto.PulseNo = NaN;

taskbase_io_reformatted.fib_lit = NaN; %set to NaN in the mouse taskbase I am using as a template

%what is this?
taskbase_io_reformatted.HitHistory, 

%what is this?
taskbase_io_reformatted.req_time, 

taskbase_io_reformatted.cue, 
taskbase_io_reformatted.BeforeTI, 
taskbase_io_reformatted.SideBTI, 
taskbase_io_reformatted.AfterFOE, 
taskbase_io_reformatted.SideAFOE, 
taskbase_io_reformatted.AfterOE, 
taskbase_io_reformatted.SideAOE, 
taskbase_io_reformatted.mass = NaN; 
taskbase_io_reformatted.Valve7A, 
taskbase_io_reformatted.Valve7B

%% structs within a struct

 