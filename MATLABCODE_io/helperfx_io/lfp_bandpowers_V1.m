
%AT created 3/26/20



function [struct] = lfp_bandpowers_V1(struct, trial_num, signal, Fs)
    




    for ii = 1:size(signal,1)
        struct.ptot_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[0.5 200]);
    end





%below is for taking the power of each trial
    %range below
    frequ1 = 0.5;
    frequ2 = 4;
    
    for ii = 1:size(signal,1)
        struct.delta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.delta_perc_power(1,trial_num) = 100*(struct.delta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end
    

    
    
     %below is for taking the power of each trial
    %range below
    frequ1 = 4;
    frequ2 = 8;

    for ii = 1:size(signal,1)
        struct.theta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.theta_perc_power(1,trial_num) = 100*(struct.theta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end
    
    

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 8;
    frequ2 = 13;
    
    for ii = 1:size(signal,1)
        struct.alpha_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.alpha_perc_power(1,trial_num) = 100*(struct.alpha_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end
    

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 13;
    frequ2 = 35;

    for ii = 1:size(signal,1)
        struct.beta_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.beta_perc_power(1,trial_num) = 100*(struct.beta_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end
    

    
    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 35;
    frequ2 = 80;
 
    for ii = 1:size(signal,1)
        struct.lowgamma_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.lowgamma_perc_power(1,trial_num) = 100*(struct.lowgamma_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end

    
    
    %below is for taking the power of each trial
    %range below
    frequ1 = 80;
    frequ2 = 200;
  
    for ii = 1:size(signal,1)
        struct.highgamma_pband(1,trial_num) = bandpower(signal(ii,:),Fs,[frequ1 frequ2]);
        struct.highgamma_perc_power(1,trial_num) = 100*(struct.highgamma_pband(1,trial_num)/struct.ptot_pband(1,trial_num));
    end

    
    
    
    
    
    
    
    
    
    
    
end
    

    