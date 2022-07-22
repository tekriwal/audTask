%% Setup
% Locate repo audTask

% Load in MasterFile
% masterspikestruct_V2.mat






%% Instructions
% Within the 'epochTimesstruct' are individual substructs for each case#, 
% each spike (lead)#, and each cluster#. For purposes of LFP analysis, 
% we want to concat all the cluster# info into one field and then remove 
% duplicates. Reason we want to do this is that some cluster# have info 
% for some trials and others do not because of intermit FR - 
% which we don't care about for LFP

