%% ROC_preference
%% Calculates preference for Conditions A vs. B based on firing rate, using
%% an ROC analysis. Preference is related to the area under the ROC curve.
%%
%% USAGE: [pref, p_val] = ROC_preference(a, b, num_repeats)
%% EXAMPLE: [pref, p] = ROC_preference(firing_rates1, firing_rates2, 500);
%%
%% INPUTS:  a - number_of_trials x 1 vector of firing rates under Condition A
%%          b - number_of_trials x 1 vector of firing rates under Condition B
%%          num_repeats - number of times to permute a and b and
%%            recalculate preference (used for calculating the p_val associated
%%              with pref)
%%
%% OUTPUTS: pref - The preference value, ranging from -1 (maximally prefers Condition
%%              A) to 1 (maximally prefers Condition B). pref = 2 * (ROC_area - 0.5).
%%          p_val - the p_value associated with this pref. p = .04, e.g.,
%%              means there's a 4% chance of this pref being this high OR low
%%              given randomly permuted firing rates.
%%           
%% DEPENDENCIES: randmat (from Matlab file exchange) - this mfile uses
%% rand, so it is highly recommended that you randomize your seed upon
%% startup of matlab (but NOT every time you run this code). E.g.,
%% rand('state',sum(100*clock)) (randomizes to the clock; you generally don't
%% start matlab at exactly the same second every day)
%%
%% This code is designed to replace the ROC analyses in use through 8/2013,
%% inherited from the Mainen Lab (and written by someone else entirely). It
%% has been validated against that inherited code.
%% The code has been vectorized to run much faster (specifically, speed is
%% not linearly related to num_repeats).
%% 
%%  8/27/2013 - GF

function [pref, p_val] = ROC_preference(a, b, num_repeats)

NUM_THRESHOLDS_ACTUAL = 1000; % # of thresholds to use to construct ROC curve for the real data
NUM_THRESHOLDS_PERMUTED = 50; % # of thresholds to use to construct ROC curve for the permuted data (to get p_val)
% the # of thresholds for the permuted is lower for memory purposes but this is still a sufficient # of thresholds
% these values have been validated against the previous method for calculating ROC area


%%% Construct an ROC curve and calculate area under it (and convert to preference)

% determine what the thresholds should be
min_FR = min([a; b]) - 0.001; % subtract a small amount to make sure all rates are above the min
max_FR = max([a; b]) + 0.001; % add a small amount to make sure all rates are below the min
thresholds = [min_FR:((max_FR - min_FR) / (NUM_THRESHOLDS_ACTUAL - 1)):max_FR];

%x-coordinates of ROC curve
prob_a_larger_than_thresh = sum((repmat(a, 1, NUM_THRESHOLDS_ACTUAL)) > (repmat(thresholds, length(a), 1)), 1) / length(a);
%y-coordinates of ROC curve
prob_b_larger_than_thresh = sum((repmat(b, 1, NUM_THRESHOLDS_ACTUAL)) > (repmat(thresholds, length(b), 1)), 1) / length(b);

% calculate area by summing the trapezoids defined by the points on the
% curve
% - note that area of trapezoid is ((x * y)/2) * h, where x and y are the
% parallel sides and h is the height
% - also note that the vectors of ROC coordinates have been "fliplr"ed in
% order to go from the bottom left to the top right (otherwise areas of
% trapezoids would be calculated as being negative)
% Also see "ROC Analysis with Matlab", A. Slaby, Proceedings of the ITI 2007 29th Int. Conf. on Information
% Technology Interfaces, p. 194, bottom left.
prob_a_larger_than_thresh = fliplr(prob_a_larger_than_thresh);
prob_b_larger_than_thresh = fliplr(prob_b_larger_than_thresh);

ROC_area = sum(diff(prob_a_larger_than_thresh) .*...
    ((prob_b_larger_than_thresh(1:(end - 1)) + prob_b_larger_than_thresh(2:end)) / 2));

% make preference go from -1 to 1
pref = 2 * (ROC_area - 0.5);


%%% Calculate p-value of preference: randomly assign the values in a and b
%%% to new permuted_a and permuted_b, recalculate preference, and repeat
%%% num_repeats times in order to get a distribution of preferences that
%%% would be expected by chance. p_val is determined by how far out on the
%%% tail of this distribution the actual pref (calculated above) lies. The
%%% basic calculations are the same as above, but with an extra dimension
%%% added corresponding to num_repeats.


% create matrices for "a" and "b" where each column is a different random permutation of a and b
% (randmat does this; found on the matlab file exchange)
permuted_FR = randmat(repmat([a; b], 1, num_repeats), 1);

permuted_a = permuted_FR(1:length(a), :);
permuted_b = permuted_FR((length(a) + 1):end, :);

% find new thresholds (fewer than for real data)
thresholds_permuted = [min_FR:((max_FR - min_FR) / (NUM_THRESHOLDS_PERMUTED - 1)):max_FR];

%x-coordinates of ROC curve
prob_permuted_a_larger_than_thresh = squeeze(sum(repmat(permuted_a, [1 1 NUM_THRESHOLDS_PERMUTED]) > ...
    repmat(reshape(thresholds_permuted, [1 1 NUM_THRESHOLDS_PERMUTED]), [length(a) num_repeats 1]), 1) / length(a)); 
%y-coordinates of ROC curve
prob_permuted_b_larger_than_thresh = squeeze(sum(repmat(permuted_b, [1 1 NUM_THRESHOLDS_PERMUTED]) > ...
    repmat(reshape(thresholds_permuted, [1 1 NUM_THRESHOLDS_PERMUTED]), [length(b) num_repeats 1]), 1) / length(b)); 
% within the above computations, we are creating a num_trials x num_repeats x num_thresholds matrix

% calculate area (see above for description for actual (non-permuted) data)
prob_permuted_a_larger_than_thresh = fliplr(prob_permuted_a_larger_than_thresh);
prob_permuted_b_larger_than_thresh = fliplr(prob_permuted_b_larger_than_thresh);

permuted_ROC_area = sum(diff(prob_permuted_a_larger_than_thresh, 1, 2) .* ...
    ((prob_permuted_b_larger_than_thresh(:, 1:(end - 1)) + prob_permuted_b_larger_than_thresh(:, 2:end)) / 2), 2);

permuted_pref = 2 * (permuted_ROC_area - 0.5);

% See where the actual preference falls in the distribution of preferences
% calculated from randomly permuted data in order to calculate the p-value
% associated with this actual preference.
% Note that this p_value corresponds to a 2-tailed test (since we don't
% know a priori whether the actual preference will be low or high), so the
% highest possible p_val is 0.5.
tmp = find(pref > sort(permuted_pref), 1, 'last') / num_repeats;
if isempty(tmp) % in case pref is lower than all values in the permuted_pref distribution
    tmp = 0;
end

if tmp > 0.5
    p_val = 1 - tmp;
else
    p_val = tmp;
end


