%% load up some files
% load linear model table

load('C:\Behavior Data\lin_models\linmdl_full_tbl_ds_20Apr2016_233722.mat') %last SNr
load('C:\Behavior Data\activity_info\datasets\cell_activity_ds_28Mar2016_161209.mat') % last SNr
% 
% load('C:\Behavior Data\SC data\lin_models\data tables\linmdl_full_tbl_ds_17Nov2015_143929.mat');
% 
% load('C:\Behavior Data\SC data\activity_info\datasets\cell_activity_ds_17Nov2015_143206.mat');


%% eliminate cells with odor sampling firing rates < 2.5 Hz
 lfr = find(cell2mat(cell_activity_ds.L_OdorSample) < 2.5 |...
     cell2mat(cell_activity_ds.R_OdorSample) < 2.5 | cell2mat(cell_activity_ds.nc_L_OdorSample) < 2.5 |...
     cell2mat(cell_activity_ds.nc_R_OdorSample) < 2.5);
 
 cell_activity_ds(lfr, :) = [];
 linmdl_full_tbl_ds(lfr, :) = [];
 cell_activity_ds = dataset2table(cell_activity_ds);

%% find ipsi preferring, contra preferring, and no direction preference cells
ipsi_pref = cell2mat(eval(strcat('cell_activity_ds', '.pref_OS'))) < 0 & cell2mat(eval(strcat('cell_activity_ds', '.pval_pref_OS'))) < 0.05;
ipsi_pref_linmdl = linmdl_full_tbl_ds(ipsi_pref, :);

contra_pref = cell2mat(eval(strcat('cell_activity_ds', '.pref_OS'))) > 0 & cell2mat(eval(strcat('cell_activity_ds', '.pval_pref_OS'))) < 0.05;
contra_pref_linmdl = linmdl_full_tbl_ds(contra_pref, :);

no_pref = cell2mat(eval(strcat('cell_activity_ds', '.pval_pref_OS'))) >= 0.05;
no_pref_linmdl = linmdl_full_tbl_ds(no_pref, :);


%% find significant betas for cells isolated above
% x1 = current choice, x2 = previous choice, x3 = trial type, x4 = reaction time  

%% Calculate all beta combinations for ipsilateral preferring cells %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ipsi_total = strcat('Ipsi', '(', num2str(eval('sum(ipsi_pref)')), ')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find ipsi-preferring cells selective of only a single beta
% find ipsi-preferring cells selective for current trial only 
ipsi_x1 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells selective for previous trial only 
ipsi_x2 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells selective for block type only
ipsi_x3 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells selective for reaction time only, 
% (right or left)
ipsi_x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find ipsi-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for only all or none

% find ipsi-preferring cells that are selective for all
ipsi_all = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);

% find ipsi-preferring cells that aren't selective 
ipsi_none = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find ipsi-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 3 out of 4 betas

% find ipsi-preferring cells that are selective for current, previous, and
% trial type
ipsi_x1x2x3 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells that are selective for current, previous, and
% reaction time
ipsi_x1x2x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);

% find ipsi-preferring cells that are selective for current, trial type,
% and reaction time
ipsi_x1x3x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);

% find ipsi-preferring cells that are selective for previous, trial type,
% and reaction time
ipsi_x2x3x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find ipsi-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 2 out of 4 betas

% find ipsi-preferring cells that are selective for current and previous
ipsi_x1x2 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells that are selective for current and trial type
ipsi_x1x3 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells that are selective for current and reaction
% time
ipsi_x1x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);

% find ipsi-preferring cells that are selective for previous and trial type
ipsi_x2x3 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) > 0.05);

% find ipsi-preferring cells that are selective for previous and reaction
% time
ipsi_x2x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);

% find ipsi-preferring cells that are selective for trial type and reaction
% time
ipsi_x3x4 = sum(cell2mat(eval(strcat('ipsi_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('ipsi_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('ipsi_pref_linmdl', '.x4_pValue'))) < 0.05);


%% Calculate all beta combinations for contralateral preferring cells %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contra_total = strcat('contra', '(', num2str(eval('sum(contra_pref)')), ')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find contra-preferring cells selective of only a single beta
% find contra-preferring cells selective for current trial only 
contra_x1 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells selective for previous trial only 
contra_x2 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells selective for block type only
contra_x3 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells selective for reaction time only, 
% (right or left)
contra_x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find contra-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for only all or none

% find contra-preferring cells that are selective for all
contra_all = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);

% find contra-preferring cells that aren't selective 
contra_none = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find contra-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 3 out of 4 betas

% find contra-preferring cells that are selective for current, previous, and
% trial type
contra_x1x2x3 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells that are selective for current, previous, and
% reaction time
contra_x1x2x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);

% find contra-preferring cells that are selective for current, trial type,
% and reaction time
contra_x1x3x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);

% find contra-preferring cells that are selective for previous, trial type,
% and reaction time
contra_x2x3x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find contra-preferring cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 2 out of 4 betas

% find contra-preferring cells that are selective for current and previous
contra_x1x2 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells that are selective for current and trial type
contra_x1x3 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells that are selective for current and reaction
% time
contra_x1x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);

% find contra-preferring cells that are selective for previous and trial type
contra_x2x3 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) > 0.05);

% find contra-preferring cells that are selective for previous and reaction
% time
contra_x2x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);

% find contra-preferring cells that are selective for trial type and reaction
% time
contra_x3x4 = sum(cell2mat(eval(strcat('contra_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('contra_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('contra_pref_linmdl', '.x4_pValue'))) < 0.05);


%% Calculate all beta combinations for cells that show no direction preference %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
none_total = strcat('none', '(', num2str(eval('sum(no_pref)')), ')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find no-preference cells selective of only a single beta
% find no-preference cells selective for current trial only 
none_x1 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells selective for previous trial only 
none_x2 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells selective for block type only
none_x3 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells selective for reaction time only, 
% (right or left)
none_x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find no-preference cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for only all or none

% find no-preference cells that are selective for all
none_all = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);

% find no-preference cells that aren't selective 
none_none = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find no-preference cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 3 out of 4 betas

% find no-preference cells that are selective for current, previous, and
% trial type
none_x1x2x3 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells that are selective for current, previous, and
% reaction time
none_x1x2x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);

% find no-preference cells that are selective for current, trial type,
% and reaction time
none_x1x3x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);

% find no-preference cells that are selective for previous, trial type,
% and reaction time
none_x2x3x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find no-preference cells selective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for 2 out of 4 betas

% find no-preference cells that are selective for current and previous
none_x1x2 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells that are selective for current and trial type
none_x1x3 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells that are selective for current and reaction
% time
none_x1x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);

% find no-preference cells that are selective for previous and trial type
none_x2x3 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) > 0.05);

% find no-preference cells that are selective for previous and reaction
% time
none_x2x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) < 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);

% find no-preference cells that are selective for trial type and reaction
% time
none_x3x4 = sum(cell2mat(eval(strcat('no_pref_linmdl', '.x1_pValue'))) > 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x2_pValue'))) > 0.05 &...
    cell2mat(eval(strcat('no_pref_linmdl', '.x3_pValue'))) < 0.05 & cell2mat(eval(strcat('no_pref_linmdl', '.x4_pValue'))) < 0.05);


total = strcat('Total', '(', num2str(eval('size(cell_activity_ds, 1)')), ')');
%% Create summary table 

beta_totals = {ipsi_total ipsi_x1 ipsi_x2 ipsi_x3 ipsi_x4 ipsi_all ipsi_x1x2x3 ipsi_x1x2x4 ipsi_x1x3x4 ipsi_x2x3x4 ipsi_x1x2 ipsi_x1x3 ipsi_x1x4...
    ipsi_x2x3 ipsi_x2x4 ipsi_x3x4 ipsi_none nan;...
    contra_total contra_x1 contra_x2 contra_x3 contra_x4 contra_all contra_x1x2x3 contra_x1x2x4 contra_x1x3x4 contra_x2x3x4 contra_x1x2 contra_x1x3 contra_x1x4...
    contra_x2x3 contra_x2x4 contra_x3x4 contra_none nan;...
    none_total none_x1 none_x2 none_x3 none_x4 none_all none_x1x2x3 none_x1x2x4 none_x1x3x4 none_x2x3x4 none_x1x2 none_x1x3 none_x1x4...
    none_x2x3 none_x2x4 none_x3x4 none_none nan;...
    total nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan};
    
    beta_totals{1,18} = sum(cell2mat(beta_totals(1, 2:17)));
    beta_totals{2,18} = sum(cell2mat(beta_totals(2, 2:17)));
    beta_totals{3,18} = sum(cell2mat(beta_totals(3, 2:17)));
    
    for i = 2:size(beta_totals, 2);
        beta_totals{4,i} = sum(cell2mat(beta_totals(1:3, i)));
    end

    beta_totals_ds = dataset({beta_totals 'Preference', 'x1', 'x2', 'x3', 'x4', 'All', 'x1_x2_x3', 'x1_x2_x4', 'x1_x3_x4',...
        'x2_x3_x4', 'x1_x2', 'x1_x3', 'x1_x4', 'x2_x3', 'x2_x4', 'x3_x4', 'None', 'Total'}, ...
        'obsnames','');

% create timestamp
     ts = cell2mat(strcat(regexp(datestr(now), '-|:', 'split')));
        ts = (regexprep(ts, ' ', '_'));

%% Save and export files

        % save dataset & create excel file and save
        cd 'C:\Behavior Data\lin_models\summary tables\'
        
        savename = strcat('beta_totals_ds_',ts,'.mat');
        save(savename, 'beta_totals_ds');
        
        exportname = strcat('beta_totals_',ts,'.xlsx');
        export(beta_totals_ds,'XLSfile',exportname);
        
        exportname = strcat('linmdl_full_tbl_',ts,'.xlsx');
        export(linmdl_full_tbl_ds,'XLSfile',exportname);



