% set events to align to and raster/psth windows
epochs = {[2 3]}; % odor sample

DATA_ROOT = 'C:\Behavior Data\';
FNAME = 'mouse_database.xlsx';
% SHEET_NAME = 'SNr_Acc';
SHEET_NAME = 'SNr';

BEHAV_ROOT = 'C:\Behavior Data\nlx data\';
SPK_ROOT = 'C:\Neuralynx\';

SAVED_FIG_ROOT = 'C:\Behavior Data\lin_models\';

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

% lin_models = NeuralRegression_CNC(behav_fname, spk_fname, epochs, 2, 3); %, start_event_bound, stop_event_bound, 1);
   
            if strfind(trials_to_include_all{cell_ind, 1}, 'all') == 1;
                lin_models = NeuralRegression_CNC_Acc(behav_fname, spk_fname, epochs, start_event_bound, stop_event_bound, 1);
            else
                lin_models = NeuralRegression_CNC_Acc(behav_fname, spk_fname, epochs,start_event_bound, stop_event_bound, 1,...
                    [trials_to_include_start(cell_ind, 1):trials_to_include_end(cell_ind, 1)]);
            end
            
                
                % save the output
            cd 'C:\Behavior Data\lin_models\'
            
            save([SAVED_FIG_ROOT, behav_fname((max(findstr(behav_fname, filesep)) + 1):(end - 4)), '-',...
                spk_fname((max(findstr(spk_fname, filesep)) + 1):(end - 4))], 'lin_models');
            
            CI_accuracy = lin_models.accuracy{1}.coefCI;
            CI_full = lin_models.full{1}.coefCI;

            linmdl_accuracy_tbl(cell_ind, :) = {eval('file_name') lin_models.accuracy{1}.Coefficients.Estimate(1)...
                    lin_models.accuracy{1}.Coefficients.SE(1) lin_models.accuracy{1}.Coefficients.tStat(1)...
                    lin_models.accuracy{1}.Coefficients.pValue(1) CI_accuracy(1,1) CI_accuracy(1,2) lin_models.accuracy{1}.Coefficients.Estimate(2)...
                    lin_models.accuracy{1}.Coefficients.SE(2) lin_models.accuracy{1}.Coefficients.tStat(2)...
                    lin_models.accuracy{1}.Coefficients.pValue(2) CI_accuracy(2,1) CI_accuracy(2,2) lin_models.accuracy{1}.Coefficients.Estimate(3)...
                    lin_models.accuracy{1}.Coefficients.SE(3) lin_models.accuracy{1}.Coefficients.tStat(3)...
                    lin_models.accuracy{1}.Coefficients.pValue(3) CI_accuracy(3,1) CI_accuracy(3,2) lin_models.accuracy{1}.Coefficients.Estimate(4)...
                    lin_models.accuracy{1}.Coefficients.SE(4) lin_models.accuracy{1}.Coefficients.tStat(4)...
                    lin_models.accuracy{1}.Coefficients.pValue(4) CI_accuracy(4,1) CI_accuracy(4,2) lin_models.accuracy{1}.Coefficients.Estimate(5)...
                    lin_models.accuracy{1}.Coefficients.SE(5) lin_models.accuracy{1}.Coefficients.tStat(5)...
                    lin_models.accuracy{1}.Coefficients.pValue(5) CI_accuracy(5,1) CI_accuracy(5,2)...
                    lin_models.accuracy{1}.Coefficients.Estimate(6)...
                    lin_models.accuracy{1}.Coefficients.SE(6) lin_models.accuracy{1}.Coefficients.tStat(6)...
                    lin_models.accuracy{1}.Coefficients.pValue(6) CI_accuracy(6,1) CI_accuracy(6,2)...
                    lin_models.accuracy{1}.Coefficients.Estimate(7)...
                    lin_models.accuracy{1}.Coefficients.SE(7) lin_models.accuracy{1}.Coefficients.tStat(7)...
                    lin_models.accuracy{1}.Coefficients.pValue(7) CI_accuracy(7,1) CI_accuracy(7,2)};
                      
            
            linmdl_full_tbl(cell_ind, :) = {eval('file_name') lin_models.full{1}.Coefficients.Estimate(1)...
                    lin_models.full{1}.Coefficients.SE(1) lin_models.full{1}.Coefficients.tStat(1)...
                    lin_models.full{1}.Coefficients.pValue(1) CI_full(1,1) CI_full(1,2) lin_models.full{1}.Coefficients.Estimate(2)...
                    lin_models.full{1}.Coefficients.SE(2) lin_models.full{1}.Coefficients.tStat(2)...
                    lin_models.full{1}.Coefficients.pValue(2) CI_full(2,1) CI_full(2,2) lin_models.full{1}.Coefficients.Estimate(3)...
                    lin_models.full{1}.Coefficients.SE(3) lin_models.full{1}.Coefficients.tStat(3)...
                    lin_models.full{1}.Coefficients.pValue(3) CI_full(3,1) CI_full(3,2) lin_models.full{1}.Coefficients.Estimate(4)...
                    lin_models.full{1}.Coefficients.SE(4) lin_models.full{1}.Coefficients.tStat(4)...
                    lin_models.full{1}.Coefficients.pValue(4) CI_full(4,1) CI_full(4,2) lin_models.full{1}.Coefficients.Estimate(5)...
                    lin_models.full{1}.Coefficients.SE(5) lin_models.full{1}.Coefficients.tStat(5)...
                    lin_models.full{1}.Coefficients.pValue(5) CI_full(5,1) CI_full(5,2)};

%                 lin_models.full{1}.Coefficients.Estimate(6)...
%                     lin_models.full{1}.Coefficients.SE(6) lin_models.full{1}.Coefficients.tStat(6)...
%                     lin_models.full{1}.Coefficients.pValue(6) CI_full(6,1) CI_full(6,2)...
%                     lin_models.full{1}.Coefficients.Estimate(7)...
%                     lin_models.full{1}.Coefficients.SE(7) lin_models.full{1}.Coefficients.tStat(7)...
%                     lin_models.full{1}.Coefficients.pValue(7) CI_full(7,1) CI_full(7,2)};

                    
                                         

            
       end
    end
end

linmdl_full_tbl(any(cellfun(@isempty,linmdl_full_tbl),2),:) = []; %delete row with any empty cells
linmdl_accuracy_tbl(any(cellfun(@isempty,linmdl_accuracy_tbl),2),:) = []; %delete row with any empty cells

linmdl_accuracy_tbl_ds = dataset({linmdl_accuracy_tbl 'Cell', 'Int_Est', 'Int_SE', 'Int_tStat', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_SE',...
    'x1_tStat', 'x1_pValue', 'x1_CI_low', 'x1_CI_high', 'x2_Est', 'x2_SE', 'x2_tStat', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_SE',...
    'x3_tStat', 'x3_pValue', 'x3_CI_low', 'x3_CI_high', 'x4_Est', 'x4_SE', 'x4_tStat', 'x4_pValue', 'x4_CI_low', 'x4_CI_high',...
    'x5_Est', 'x5_SE', 'x5_tStat', 'x5_pValue', 'x5_CI_low', 'x5_CI_high', 'x4x5_Est', 'x4x5_SE', 'x4x5_tStat', 'x4x5_pValue', 'x4x5_CI_low',...
    'x4x5_CI_high'}, 'obsnames','');
linmdl_accuracy_tbl_ds.Properties.ObsNames = linmdl_accuracy_tbl_ds.Cell;

linmdl_full_tbl_ds = dataset({linmdl_full_tbl 'Cell', 'Int_Est', 'Int_SE', 'Int_tStat', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_SE',...
    'x1_tStat', 'x1_pValue', 'x1_CI_low', 'x1_CI_high', 'x2_Est', 'x2_SE', 'x2_tStat', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_SE',...
    'x3_tStat', 'x3_pValue', 'x3_CI_low', 'x3_CI_high', 'x4_Est', 'x4_SE', 'x4_tStat', 'x4_pValue', 'x4_CI_low', 'x4_CI_high'}, 'obsnames','');
linmdl_full_tbl_ds.Properties.ObsNames = linmdl_full_tbl_ds.Cell;

ts = cell2mat(strcat(regexp(datestr(now), '-|:', 'split')));
ts = (regexprep(ts, ' ', '_'));

%% Save and export files

% save datasets
savename = strcat('linmdl_full_tbl_ds_',ts,'.mat');
save(savename, 'linmdl_full_tbl_ds');

savename = strcat('linmdl_accuracy_tbl_ds_',ts,'.mat');
save(savename, 'linmdl_accuracy_tbl_ds');





