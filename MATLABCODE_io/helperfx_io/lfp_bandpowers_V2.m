
%AT created V2 on 4/7/20; the whole size of the signal is no necessary but
%maybe I built it in the past with an eye towards future analyses?

%AT created 3/26/20



function [struct] = lfp_bandpowers_V2(struct, trial_num, signal, Fs)
    



% AT 4/7/20 idk why but im not getting equivalent between summing
% individual bandpowers from .5 to 200 Hz vs taking that range itself. So
% amendending the below from origina few lines of code to larger setup
%     for ii = 1:size(signal,1)
%         struct.ptot_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[0.5 200]);
%     end
%     for ii = 1:size(signal,1)
%         struct.ptot_pband_wOUT_delta(1,trial_num) = bandpower(signal(ii,:),Fs,[4 200]);
%     end


%below is for taking the power of each trial
%range below
frequ1 = 0.5;
frequ2 = 4;

for ii = 1:size(signal,1)
    struct.delta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end


%below is for taking the power of each trial
%range below
frequ1 = 4;
frequ2 = 8;

for ii = 1:size(signal,1)
    struct.theta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end


%below is for taking the power of each trial
%range below
frequ1 = 8;
frequ2 = 13;

for ii = 1:size(signal,1)
    struct.alpha_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end


%below is for taking the power of each trial
%range below
frequ1 = 13;
frequ2 = 35;

for ii = 1:size(signal,1)
    struct.beta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end

%below is for taking the power of each trial
%range below
frequ1 = 35;
frequ2 = 80;

for ii = 1:size(signal,1)
    struct.lowgamma_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end


%below is for taking the power of each trial
%range below
frequ1 = 80;
frequ2 = 200;

for ii = 1:size(signal,1)
    struct.highgamma_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
end


struct.ptot_pband(1,trial_num) = struct.delta_pband(1,trial_num) + struct.theta_pband(1,trial_num) + struct.alpha_pband(1,trial_num) + struct.beta_pband(1,trial_num) + struct.lowgamma_pband(1,trial_num) + struct.highgamma_pband(1,trial_num);
struct.ptot_pband_wOUT_delta(1,trial_num) = struct.theta_pband(1,trial_num) + struct.alpha_pband(1,trial_num) + struct.beta_pband(1,trial_num) + struct.lowgamma_pband(1,trial_num) + struct.highgamma_pband(1,trial_num);



%below is for taking the power of each trial
    %range below
    frequ1 = 0.5;
    frequ2 = 4;
    
    for ii = 1:size(signal,1)
        struct.delta_perc_power(1,trial_num) = 100*(struct.delta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end
    

    
    
     %below is for taking the power of each trial
    %range below
    frequ1 = 4;
    frequ2 = 8;

    for ii = 1:size(signal,1)
        struct.theta_perc_power(1,trial_num) = 100*(struct.theta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
        struct.theta_perc_power_wOUT_delta(1,trial_num) = 100*(struct.theta_pband(1,trial_num)/struct.ptot_pband_wOUT_delta(1,trial_num));
    end
    
    

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 8;
    frequ2 = 13;
    
    for ii = 1:size(signal,1)
        struct.alpha_perc_power(1,trial_num) = 100*(struct.alpha_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
        struct.alpha_perc_power_wOUT_delta(1,trial_num) = 100*(struct.alpha_pband(1,trial_num)/struct.ptot_pband_wOUT_delta(1,trial_num));
    end
    

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 13;
    frequ2 = 35;

    for ii = 1:size(signal,1)
        struct.beta_perc_power(1,trial_num) = 100*(struct.beta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
        struct.beta_perc_power_wOUT_delta(1,trial_num) = 100*(struct.beta_pband(1,trial_num)/struct.ptot_pband_wOUT_delta(1,trial_num));
    end
    

    
    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 35;
    frequ2 = 80;
 
    for ii = 1:size(signal,1)
        struct.lowgamma_perc_power(1,trial_num) = 100*(struct.lowgamma_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
        struct.lowgamma_perc_power_wOUT_delta(1,trial_num) = 100*(struct.lowgamma_pband(1,trial_num)/struct.ptot_pband_wOUT_delta(1,trial_num));
    end

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 80;
    frequ2 = 200;
  
    for ii = 1:size(signal,1)
        struct.highgamma_perc_power(1,trial_num) = 100*(struct.highgamma_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
        struct.highgamma_perc_power_wOUT_delta(1,trial_num) = 100*(struct.highgamma_pband(1,trial_num)/struct.ptot_pband_wOUT_delta(1,trial_num));
    end

    
    
    
    
    
    
end
    

    