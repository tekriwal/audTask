
function [h1, h2, h3] = NR_pop_fraction_plot(fig, new_model);
if new_model == 1;

%% Load individual mdl files for building matrix 
cd('C:\Behavior Data\lin_models\sliding_window');
regression_cells = dir('C:\Behavior Data\lin_models\sliding_window');
regression_cells = cellstr(ls);
regression_cells = regression_cells(5:length(regression_cells));
regression_cells = cellfun(@(x) regexprep(x,'.mat',''), regression_cells, 'UniformOutput', 0);

% This file is written to handle analysis for 3 epochs, 

e1_sig_bins = nan(303, 187, 4); 
e2_sig_bins = nan(303, 172, 4);
e3_sig_bins = nan(303, 182, 4);

for cell_ind = 1:size(regression_cells,1);
    mdl_file = load(cell2mat(regression_cells(cell_ind,:)));
    
    for e1_bins = 1:length(mdl_file.OdorValveOn_mdl.full_with_reaction_time);
        try
            for mdl_var = 2:length(mdl_file.OdorValveOn_mdl.full_with_reaction_time{1,1}.Coefficients.pValue)
                e1_sig_bins(cell_ind, e1_bins, mdl_var-1) = mdl_file.OdorValveOn_mdl.full_with_reaction_time{1,e1_bins}.Coefficients.pValue(mdl_var);
            end
        end
    end
    
    for e2_bins = 1:length(mdl_file.OdorPokeOut_mdl.full_with_reaction_time);
        try
            for mdl_var = 2:length(mdl_file.OdorPokeOut_mdl.full_with_reaction_time{1,1}.Coefficients.pValue)
                e2_sig_bins(cell_ind, e2_bins, mdl_var-1) = mdl_file.OdorPokeOut_mdl.full_with_reaction_time{1,e2_bins}.Coefficients.pValue(mdl_var);
            end
        end
    end 
    
    for e3_bins = 1:length(mdl_file.WaterPokeIn_mdl.full_with_reaction_time);
        try
            for mdl_var = 2:length(mdl_file.WaterPokeIn_mdl.full_with_reaction_time{1,1}.Coefficients.pValue)
                e3_sig_bins(cell_ind, e3_bins, mdl_var-1) = mdl_file.WaterPokeIn_mdl.full_with_reaction_time{1,e3_bins}.Coefficients.pValue(mdl_var);
            end
        end
    end 
end

%%

% For the Odor Valve On epoch, count cells with significant betas during 
% individual bins. also count the number of nans per bin.
for mdl_var = 1:size(e1_sig_bins, 3);
    for e1_bins = 1:size(e1_sig_bins, 2);
        tot_nans_e1(1, e1_bins, mdl_var) = sum(isnan(e1_sig_bins(:, e1_bins, mdl_var)));
        tot_sig_cells_e1(1, e1_bins, mdl_var) = sum(e1_sig_bins(:, e1_bins, mdl_var) < 0.05);
    end
end

for mdl_var = 1:size(e1_sig_bins, 3);
    bins_w_data_e1(1, :, mdl_var) = 300 - tot_nans_e1(1, :, mdl_var);
end

for mdl_var = 1:size(e1_sig_bins, 3);
    for e1_bins = 1:size(e1_sig_bins, 2);
        fract_cells_e1(mdl_var, e1_bins) = tot_sig_cells_e1(1, e1_bins, mdl_var)/bins_w_data_e1(1, e1_bins, mdl_var);
    end
end

% For the Odor Poke Out epoch, count cells with significant betas during 
% individual bins. also count the number of nans per bin.
for mdl_var = 1:size(e2_sig_bins, 3);
    for e2_bins = 1:size(e2_sig_bins, 2);
        tot_nans_e2(1, e2_bins, mdl_var) = sum(isnan(e2_sig_bins(:, e2_bins, mdl_var)));
        tot_sig_cells_e2(1, e2_bins, mdl_var) = sum(e2_sig_bins(:, e2_bins, mdl_var) < 0.05);
    end
end

for mdl_var = 1:size(e2_sig_bins, 3);
    bins_w_data_e2(1, :, mdl_var) = 300 - tot_nans_e2(1, :, mdl_var);
end

for mdl_var = 1:size(e2_sig_bins, 3);
    for e2_bins = 1:size(e2_sig_bins, 2);
        fract_cells_e2(mdl_var, e2_bins) = tot_sig_cells_e2(1, e2_bins, mdl_var)/bins_w_data_e2(1, e2_bins, mdl_var);
    end
end


% For the Water Poke In epoch, count cells with significant betas during 
% individual bins. also count the number of nans per bin.
for mdl_var = 1:size(e3_sig_bins, 3);
    for e3_bins = 1:size(e3_sig_bins, 2);
        tot_nans_e3(1, e3_bins, mdl_var) = sum(isnan(e3_sig_bins(:, e3_bins, mdl_var)));
        tot_sig_cells_e3(1, e3_bins, mdl_var) = sum(e3_sig_bins(:, e3_bins, mdl_var) < 0.05);
    end
end

for mdl_var = 1:size(e3_sig_bins, 3);
    bins_w_data_e3(1, :, mdl_var) = 300 - tot_nans_e3(1, :, mdl_var);
end

for mdl_var = 1:size(e3_sig_bins, 3);
    for e3_bins = 1:size(e3_sig_bins, 2);
        fract_cells_e3(mdl_var, e3_bins) = tot_sig_cells_e3(1, e3_bins, mdl_var)/bins_w_data_e3(1, e3_bins, mdl_var);
    end
end

%% get time information for x-axis of plot

e1_times = [-0.45:0.011:1.6];
e2_times = [-0.3:0.011:1.5890];
e3_times = [-0.4:0.011:1.6];

%% Save matrix 
cd 'C:\Behavior Data\lin_models\sliding_window\population\'
save('fraction_population.mat', 'fract_cells_e1', 'fract_cells_e2', 'fract_cells_e3',...
    'e1_times', 'e2_times', 'e3_times');

elseif new_model == 0;
    load('C:\Behavior Data\lin_models\sliding_window\population\fraction_population.mat');
end
%% Do the plotting

if fig == 0;
PresentationFigSetUp;
elseif fig == 1;
end

%a = subplot(1, 3, 1)
h1 = axes;
plot(e1_times, fract_cells_e1(1, :), 'Color', [0 0 0], 'LineWidth', 2);
hold on
plot(e1_times, fract_cells_e1(2, :), 'Color', [0 1 1], 'LineWidth', 2);
plot(e1_times, fract_cells_e1(3, :), 'Color', [1 0 1], 'LineWidth', 2);
plot(e1_times, fract_cells_e1(4, :), 'Color', [1 1 0], 'LineWidth', 2);
axis([-0.4 0.4 0 1]);
line([0,0],[0 1], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
set(gca, 'YTick', [0 0.5 1]);
set(gca, 'XTick', [-0.4 0 0.4]);
set(gca, 'Box', 'off');
set(h1, 'Position', [0.07 0.20 0.28 0.28]);
ylabel('Fraction of sig. sel. neurons');
xlabel('Time (s) from odor valve open');
hold off
set(h1, 'Position', [0.10 0.5 0.26 0.26]);

% hleg1 = legend('current choice', 'previous choice', 'trial type');
%      set(hleg1,'Location','NorthEast');
     
%b = subplot(1, 3, 2)
h2 = axes;
plot(e2_times, fract_cells_e2(1, :), 'Color', [0 0 0], 'LineWidth', 2);
hold on
plot(e2_times, fract_cells_e2(2, :), 'Color', [0 1 1], 'LineWidth', 2);
plot(e2_times, fract_cells_e2(3, :), 'Color', [1 0 1], 'LineWidth', 2);
plot(e2_times, fract_cells_e2(4, :), 'Color', [1 1 0], 'LineWidth', 2);
axis([-0.2 0.3 0 1]);
line([0,0],[0 1], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
set(gca, 'YTick', []);
set(gca, 'XTick', [-0.2 0 0.3]);
set(gca, 'Box', 'off');
set(h2, 'Position', [0.39 0.2 0.28 0.28]);
xlabel('Time (s) from odor port exit');
hold off
set(h2, 'Position', [0.4 0.5 0.26 0.26]);

%c = subplot(1, 3, 3)
h3 = axes;
plot(e3_times, fract_cells_e3(1, :), 'Color', [0 0 0], 'LineWidth', 2);
hold on
plot(e3_times, fract_cells_e3(2, :), 'Color', [0 1 1], 'LineWidth', 2);
plot(e3_times, fract_cells_e3(3, :), 'Color', [1 0 1], 'LineWidth', 2);
plot(e3_times, fract_cells_e3(4, :), 'Color', [1 1 0], 'LineWidth', 2);
axis([-0.2 1.0 0 1]);
line([0,0],[0 1], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
set(gca, 'YTick', []);
set(gca, 'XTick', [-0.2 0 1]);
set(gca, 'Box', 'off');
set(h3, 'Position', [0.71 0.2 0.28 0.28]);
xlabel('Time (s) from water port entry');
hold off
set(h3, 'Position', [0.7 0.5 0.26 0.26]);
  
end
     



        
        
        
        
    
    
    
    
    
    
    
    
    
    