% set events to align to and raster/psth windows
DATA_ROOT = 'C:\Behavior Data\';
FNAME = 'mouse_database.xlsx';
SHEET_NAME = 'SNr';

BEHAV_ROOT = 'C:\Behavior Data\nlx data\';
SPK_ROOT = 'C:\Neuralynx\';

SAVED_FIG_ROOT = 'C:\Behavior Data\lin_models\beta plots\full with reaction\';

%% read in the first Excel sheet
[numfields, textfields] = xlsread(strcat(DATA_ROOT, FNAME), SHEET_NAME);

textfields = textfields(3:end, :); % b/c first two rows is field titles

animal_name = textfields(:, 1);
tb_filename = textfields(:, 6);
cluster_quality = textfields(:, 8);
tetrode_num = numfields(:, 1);
cell_num = numfields(:, 2);

model = 1;
y_ax = 80;
fig = 0;
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
            
            NR_CNC_beta_plot(behav_fname, spk_fname, model, y_ax, fig);
            
            % save the figure image
                fig_name = [SAVED_FIG_ROOT, behav_fname((max(findstr(behav_fname, filesep)) + 1):(end - 4)), '-',...
                    spk_fname((max(findstr(spk_fname, filesep)) + 1):(end - 4)), '.jpg']; 

                saveas(1, fig_name);

                close(1); % close the matlab figure
                       
       end
    end
end