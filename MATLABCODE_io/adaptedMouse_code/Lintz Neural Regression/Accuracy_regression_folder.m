% set events to align to and raster/psth windows
epochs = {[2 3]}; % odor sample

DATA_ROOT = 'C:\Behavior Data\';
FNAME = 'mouse_database.xlsx';
SHEET_NAME = 'SNr_Acc';

BEHAV_ROOT = 'C:\Behavior Data\nlx data\';
SPK_ROOT = 'C:\Neuralynx\';

SAVED_FIG_ROOT = 'C:\Behavior Data\Accuracy regression\';

%% read in the first Excel sheet
[numfields, textfields] = xlsread(strcat(DATA_ROOT, FNAME), SHEET_NAME);

textfields = textfields(3:end, :); % b/c first two rows is field titles

animal_name = textfields(:, 1);
tb_filename = textfields(:, 6);
cluster_quality = textfields(:, 8);
tetrode_num = numfields(:, 1);
cell_num = numfields(:, 2);
trials_to_include_all = textfields(:, 12);
trials_to_include_start = numfields(:, 10);
trials_to_include_end = numfields(:, 11);

% loop through each neuron
for cell_ind = 1:length(cell_num); % some cells have already been processed
    
    % some rows/fields are blank, so make sure the neuron exists;
    % also, make sure this isn't a poor cluster
    if (~isnan(cell_num(cell_ind)) && isempty(strfind(cluster_quality{cell_ind}, 'poor')))
        
        % construct the filename for the taskbase file
        behav_fname = strcat(BEHAV_ROOT, animal_name{cell_ind}, filesep, tb_filename{cell_ind}, '.mat');
        
        % construct the filename for the recording (spike) file
        % first, find the spike folder corresponding to the animal name
        d = dir(SPK_ROOT);
        d = struct2cell(d);
        
        animal_spk_folder = d(1, strmatch(animal_name{cell_ind}, d(1, :)));
        if length(animal_spk_folder) > 1
            error('>1 possible spike folders for this animal');
        else
            animal_spk_folder = char(animal_spk_folder);
            
        end
        if isempty(animal_spk_folder)
            error('No clear match between animal and spike folder names');
        end
        
        % second, find the spike folder corresponding to the recording session
        % -figure out the date (in the format used by neuralynx to name folders)
        date_str = strcat('20', tb_filename{cell_ind}((end - 6):(end - 5)), '-',...
            tb_filename{cell_ind}((end - 4):(end - 3)), '-',...
            tb_filename{cell_ind}((end - 2):(end - 1)));
        
        % -find this date in the folders corresponding to this mouse
        d = dir(strcat(SPK_ROOT, animal_spk_folder));
        d = struct2cell(d);
        
        date_folder = d(1, strmatch(date_str, d(1, :)));
        if length(date_folder) > 1
            error('>1 possible spike folders for this date');
        else
            date_folder = char(date_folder);
        end
        if isempty(date_folder)
            error('No clear match between date and spike folder names');
        end
        
        spk_fname = strcat(SPK_ROOT, animal_spk_folder, filesep,...
            date_folder, filesep, 'TT', num2str(tetrode_num(cell_ind)), '_',...
            num2str(cell_num(cell_ind)), '.mat');
        
        % make sure the files exist, then call CellSummary_choice_nochoice
        if ((exist(behav_fname) == 0) || (exist(spk_fname) == 0))
            warning('The desired behavior or spike file does not exist');
        else
            
            file_name = [behav_fname((max(findstr(behav_fname, filesep)) + 1):(end - 4)), '-',...
                spk_fname((max(findstr(spk_fname, filesep)) + 1):(end - 4))];
                    
            start_event_bound = 0; 
            stop_event_bound = 0;


            if strfind(trials_to_include_all{cell_ind, 1}, 'all') == 1;
                [acc_reg_mdl] = Accuracy_regression(behav_fname, spk_fname, epochs, start_event_bound, stop_event_bound);
            else
%                 [acc_reg_mdl] = Accuracy_regression(behav_fname, spk_fname, epochs,start_event_bound, stop_event_bound,...
%                     [trials_to_include_start(cell_ind, 1):trials_to_include_end(cell_ind, 1)]);
            end
         
            
            save([SAVED_FIG_ROOT, behav_fname((max(findstr(behav_fname, filesep)) + 1):(end - 4)), '-',...
                spk_fname((max(findstr(spk_fname, filesep)) + 1):(end - 4))], 'acc_reg_mdl');
            
            CI_acc = acc_reg_mdl{1}.coefCI;
            
                 acc_reg_tbl(cell_ind, :) = {eval('file_name') acc_reg_mdl{1}.Coefficients.Estimate(1)...
                    acc_reg_mdl{1}.Coefficients.SE(1) acc_reg_mdl{1}.Coefficients.tStat(1)...
                    acc_reg_mdl{1}.Coefficients.pValue(1) CI_acc(1,1) CI_acc(1,2) acc_reg_mdl{1}.Coefficients.Estimate(2)...
                    acc_reg_mdl{1}.Coefficients.SE(2) acc_reg_mdl{1}.Coefficients.tStat(2)...
                    acc_reg_mdl{1}.Coefficients.pValue(2) CI_acc(2,1) CI_acc(2,2) acc_reg_mdl{1}.Coefficients.Estimate(3)...
                    acc_reg_mdl{1}.Coefficients.SE(3) acc_reg_mdl{1}.Coefficients.tStat(3)...
                    acc_reg_mdl{1}.Coefficients.pValue(3) CI_acc(3,1) CI_acc(3,2) acc_reg_mdl{1}.Coefficients.Estimate(4)...
                    acc_reg_mdl{1}.Coefficients.SE(4) acc_reg_mdl{1}.Coefficients.tStat(4)...
                    acc_reg_mdl{1}.Coefficients.pValue(4) CI_acc(4,1) CI_acc(4,2)};
        end
    end
end

acc_reg_tbl(any(cellfun(@isempty,acc_reg_tbl),2),:) = []; %delete row with any empty cells

acc_reg_tbl_ds = dataset({acc_reg_tbl 'Cell', 'Int_Est', 'Int_SE', 'Int_tStat', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_SE',...
    'x1_tStat', 'x1_pValue', 'x1_CI_low', 'x1_CI_high', 'x2_Est', 'x2_SE', 'x2_tStat', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_SE',...
    'x3_tStat', 'x3_pValue', 'x3_CI_low', 'x3_CI_high'}, 'obsnames','');

ts = cell2mat(strcat(regexp(datestr(now), '-|:', 'split')));
ts = (regexprep(ts, ' ', '_'));

%% Save and export files

% save matrices
cd 'C:\Behavior Data\Accuracy regression\datasets\'

% save datasets
savename = strcat('acc_reg_tbl_ds_',ts,'.mat');
save(savename, 'acc_reg_tbl_ds');





