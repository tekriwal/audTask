% Define variables for access to mouse_database.xlsx which contains
% information necessary to access behavior files and spike files for each
% cell to be analyzed. 

DATA_ROOT = 'C:\Behavior Data\';
FNAME = 'mouse_database.xlsx';
SHEET_NAME = 'SNr';

BEHAV_ROOT = 'C:\Behavior Data\nlx data\';
SPK_ROOT = 'C:\Neuralynx\';

SAVED_FIG_ROOT = 'C:\Behavior Data\lin_models\sliding_window\';

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

            
            
% set events to align to and raster/psth windows
            % 100 msec bins with 10 msec overlap starting at 450 ms before odorvalveon 
            bin_starts_1 = [-0.45:0.01:-0.1];
            bin_stops_1 = [-0.35:0.01:0];

            for epoch_ind_1 = 1:length(bin_starts_1);
                epochs{epoch_ind_1} = [888 bin_starts_1(epoch_ind_1) 2 888 bin_stops_1(epoch_ind_1) 2];
            end

            % 50 msec bins starting at odorvalveon and going to 1500 msec after odorvalveon
            bin_starts_2 = [0:0.01:1.5];
            bin_stops_2 = [0.1:0.01:1.6];

            for epoch_ind_2 = length(bin_starts_1)+1:length(bin_starts_1)+length(bin_starts_2);
                epochs{epoch_ind_2} = [999 2 bin_starts_2(epoch_ind_2-length(bin_starts_1)) 999 2 bin_stops_2(epoch_ind_2-length(bin_starts_1))];
            end

            start_bound = 0;
            stop_bound = 3; % if the end of a bin is after the go signal (event #8), disregard this trial

            if strfind(trials_to_include_all{cell_ind, 1}, 'all') == 1;
                OdorValveOn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1);
            else
                OdorValveOn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1,... 
                    [trials_to_include_start(cell_ind, 1):trials_to_include_end(cell_ind, 1)]);
            end
            
            clearvars bin_starts_1 bin_stops_1 bin_starts_2 bin_stops_2 epoch_ind_1 epoch_ind_2 epochs start_bound stop_bound

            
            % 100 msec bins with 10 msec overlap starting at 300 msec before odorpokeout 
            bin_starts_1 = [-0.3:0.01:-0.1];
            bin_stops_1 = [-0.2:0.01:0];

            for epoch_ind_1 = 1:length(bin_starts_1);
                epochs{epoch_ind_1} = [888 bin_starts_1(epoch_ind_1) 3 888 bin_stops_1(epoch_ind_1) 3];
            end

            % 50 msec bins starting at odorpokeout and going to 1000 msec after
            % odorpokeout
            bin_starts_2 = [0:0.01:1.5];
            bin_stops_2 = [0.1:0.01:1.6];

            for epoch_ind_2 = length(bin_starts_1)+1:length(bin_starts_1)+length(bin_starts_2);
                epochs{epoch_ind_2} = [999 3 bin_starts_2(epoch_ind_2-length(bin_starts_1)) 999 3 bin_stops_2(epoch_ind_2-length(bin_starts_1))];
            end

            start_bound = 0;
            stop_bound = 4; % if the end of a bin is after the go signal (event #8), disregard this trial

            if strfind(trials_to_include_all{cell_ind, 1}, 'all') == 1;
                OdorPokeOut_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1);
            else
                OdorPokeOut_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1,... 
                    [trials_to_include_start(cell_ind, 1):trials_to_include_end(cell_ind, 1)]);
            end
                 
            clearvars epochs start_bound stop_bound
            
                                   
            % 50 msec bins starting at 400 msec before WaterPokeIn 
            bin_starts_1 = [-0.4:0.01:-0.1];
            bin_stops_1 = [-0.3:0.01:0];

            for epoch_ind_1 = 1:length(bin_starts_1);
                epochs{epoch_ind_1} = [888 bin_starts_1(epoch_ind_1) 4 888 bin_stops_1(epoch_ind_1) 4];
            end

            % 50 msec bins starting at odorpokeout and going to 1000 msec after
            % WaterPokeIn
            bin_starts_2 = [0:0.01:1.5];
            bin_stops_2 = [0.1:0.01:1.6];

            for epoch_ind_2 = length(bin_starts_1)+1:length(bin_starts_1)+length(bin_starts_2);
                epochs{epoch_ind_2} = [999 4 bin_starts_2(epoch_ind_2-length(bin_starts_1)) 999 4 bin_stops_2(epoch_ind_2-length(bin_starts_1))];
            end

            start_bound = 3;
            stop_bound = 6; % if the end of a bin is after the go signal (event #8), disregard this trial
            
            if strfind(trials_to_include_all{cell_ind, 1}, 'all') == 1;
                WaterPokeIn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1);
            else
                WaterPokeIn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound, 1,... 
                    [trials_to_include_start(cell_ind, 1):trials_to_include_end(cell_ind, 1)]);
            end
            
            
           % save the output
            cd 'C:\Behavior Data\lin_models\sliding_window\'
            
            save([SAVED_FIG_ROOT, behav_fname((max(findstr(behav_fname, filesep)) + 1):(end - 4)), '-',...
                spk_fname((max(findstr(spk_fname, filesep)) + 1):(end - 4))], 'OdorValveOn_mdl', 'OdorPokeOut_mdl', 'WaterPokeIn_mdl');
            
       end
    end
end










