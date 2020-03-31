% CALC_EPOCH_ROC  
% Compute the ROC in epochs.
%
% Useage: 
%  [roc_area,roc_pr,roc_trials] = calc_epoch_roc(cellids,rate,comps,iter)
% 
% Calculates cell selectivity based on the variable 'rate'.
% Each selectivity value is a comparison between 2 conditions, here called
% 'types'. Selectivity is calculated here using the function ROC_SV which uses the standard area
% under the ROC curve, which ranges from 0 to 1, where 0.5 is
% non-selective.
%
% RATE is an NxK cell array (N indexes cells, K indexes epochs; see
% function CALC_EPOCH_RATES)
% DUR is an NxK cell array (N indexes cells, K indexes epochs; see
% function CALC_EPOCH_RATES)
% ITER specifies the number of iterations for bootstrap calculation of
% significance (default 0)
% COMPS is a Jx3 cell arrays specifying the types of trials which will be used for the
% comparisons (see DEFINE_ROC_COMPARISONS).
% EPOCHS is the vector with epoch definitions.
%
% Returns:
% ROC_AREA is an KxJ cell array (K indexes epoches, J indexes comparison types) of 1xN vectors of ROCarea curve values 
% ROC_PR is an KxJ cell array of 1xN vectors of corresponding significance levels
% ROC_TRIALS is an KxJ cell array of 2xN corresponding trial numbers [Atrials Btrials]

% Clau 3/11/04
% ZFM 4/27/04
% ZFM 10/14/04
% Clau 10/20/04
% Clau 05/22/05  modified to deal with mixtures and new odors (choose a
% subset of trials).
% clau 06/15/05  modified to calculate the roc for no odor trials only
% (OPTIONAL)


function [roc_area,roc_pr,roc_trials] = calc_epoch_roc(cellids,rate,comps,epochs,event_windows,events,iter,restrict_trials,pure,new_odors,no_odor)

if nargin < 7
    iter = 0;       % bootstrap iterations (0 for no bootstrap)
end

if nargin < 8
    restrict_trials = 0;
end

% pure =1  use only pure odor trials for mixture experiments.
if nargin < 9
    pure = 0;
end

% new_odors=1 use only block 1 (before new odors introduction for
% analysis), new_odors=2 block 2, new_odors=0 all trials.
if nargin < 10
    new_odors = 0;
end

% use only no_odor trials when no_odor=1.  Clau 06/15/05.
if nargin < 11
    no_odor = 0;
    % when its short trials, I want to use all trials in mixture
    % experiments
end

cellbase_datapath = getpref('cellbase','datapath');
infofile = [cellbase_datapath '\cellinfo.mat'];
load(infofile);

alpha = 0.05; % significance level for ROC -- not really used

% define some lengths for convenience
n_cells = size(rate,1);
n_epochs = size(rate,2);
n_comps = size(comps,1);

% calculate the roc values
%
% ao_roc = area under roc
% count = number of spikes

% initialize arrays to hold the results
for k=1:n_epochs
    for j=1:n_comps
        roc_area{k,j} = repmat(NaN,1,n_cells);
        roc_pr{k,j} = repmat(NaN,1,n_cells);
        roc_trials{k,j} = repmat(NaN,2,n_cells);
    end
    fixed_length(k)= epochs{k,3}(2)-epochs{k,3}(1);
    event_ref = epochs{k,4};
    m(k) = sel_event(events,event_ref);
    % this is a somewhat dirty way to skip those epochs that dont have a
    % reference in events (the reward period).
    if isnan(m(k)) | strcmp(epochs{k,1},'Reward')
        fixed_length(k) = NaN;
    end
end

for n=1:n_cells
    disp(['Calc epoch roc ' cellids{n}])
    
    % note: we are now loading just trial events and we load them into a
    % structure so that they don't get loose
    fname_events = cellbase_filename(cellids{n},'TrialEvents2.mat');
    s = load(fname_events);
    
    % this will exclude cells without nose pokes
    if isfield(s,'OdorPokeIn')
        use_trials = 1:length(s.TrialStart);
        
        % if it's a mixture experiment, look for trials with pure odors
        % only - Added Clau 05/22/05.
        if pure & strcmp(task{n},'binmix')
            use_trials = [];
            use_trials = s.pure_trials;
        end
        
        % if it's a new odors experiment, use the trials after introduction
        % of the new pair (block=2) - Added Clau 05/22/05.
        
        if new_odors & strcmp(task{n},'new_odors');
            use_trials = [];
            use_trials = find(s.block==new_odors);
        end
        
        % Added Clau 06/15/05 to choose to use only no_odor trials.
        if no_odor
            use_trials = [];
            use_trials = find(s.short);
        end
        
        for k=1:n_epochs
            % get the actual epoch duration for this cell, in this epoch.
            if ~isnan(m(k))
                real_dur = event_windows{n,m(k)}(2,:)-event_windows{n,m(k)}(1,:);
            end
            for j=1:n_comps
               
                % These 2 lines are a little trick to allow us to 
                % get the right trials depending on what condition we're using
                A = eval(sprintf('find(s.%s)',comps{j,2}));
                B = eval(sprintf('find(s.%s)',comps{j,3}));
                
                use_trialsA = intersect(A,use_trials);
                use_trialsB = intersect(B,use_trials);
                
                % this is to take out trials that are too short (shorter than the fixed window chosen for the epoch).
                % Added Clau 10/20/04
                if restrict_trials & ~isnan(fixed_length(k))
                    % these are indexing onto A and B, not all trials!
                    long_enoughA = find(real_dur(A) >= fixed_length(k));
                    long_enoughB = find(real_dur(B) >= fixed_length(k));
                    
                else
                    long_enoughA = 1:length(A);
                    long_enoughB = 1:length(B);
                end
                % these are the trials that can be used because they are
                % not too short
                A = A(long_enoughA);
                B = B(long_enoughB);
                
                A = intersect(A,use_trialsA);
                B = intersect(B,use_trialsB);
                
                if ~isempty(rate{n,k})
                    
                    Atrials = rate{n,k}(A);
                    Btrials = rate{n,k}(B);
                    
                    roc_trials{k,j}(1,n) = sum(~isnan(Atrials));
                    roc_trials{k,j}(2,n) = sum(~isnan(Btrials));
                    
                    if sum(~isnan(Atrials)) > 1 & sum(~isnan(Btrials)) > 1
                        
                        % make sure the array is correctly oriented
                        X = [Atrials'; Btrials'];
                        grps = [ones(length(Atrials),1); -1*ones(length(Btrials),1)];
                        
                        % calculate roc
                        area = roc_sv(X,grps,'nofigure');
                        roc_area{k,j}(n) = area;
                        % need to flip the values if < 0.5
                        if area >= 0.5
                            grps = [ones(length(Atrials),1); -1*ones(length(Btrials),1)];
                        else
                            grps = [-1*ones(length(Atrials),1); ones(length(Btrials),1)];
                        end
                        
                        % calculate significance
                        if iter > 0              
                            % bootstrap roc -- from RE Strauss library
                            [ci,pr] = res_bootstrp('roc_bootstrp',[0 1 0 1],iter,alpha,X,grps,0);
                            roc_pr{k,j}(n) = pr;
                        end
                    end 
                    
                else % isempty(rate{n,k})
                    
                    disp(sprintf('Warning: %s has no rate information, skipped',cellids{n}))       
                end 
            end  % end  for j (loop over comparison types)
        end   % end for k (loop over epochs)  
        
    else % ~exist(OdorPokeIn,var)
        disp(sprintf('Warning: %s has no OdorPokeIn, skipped',cellids{n}))
    end
  
end   % end for n (loop over cells)


function ind = sel_event(events,name)

[tf,ind_array] = ismember(events(:,1),name);
ind = find(ind_array == 1);
if isempty(ind)
    ind = NaN;
end



