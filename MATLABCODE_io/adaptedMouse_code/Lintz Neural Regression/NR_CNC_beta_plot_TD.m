%% Function to create plot of beta-values across sliding windows of 50 ms
% The input "model" selects for which model was used in the linear
% regression and thus which model should be used to plot. The different
% models are listed below with their corresponding numberical input:
% models 
% full = 1
% choice_only = 2
% current choice only = 3
% current_choice_and_type = 4
% current_choice_and_reaction_time = 5

function [h1, h2, h3] = NR_CNC_beta_plot_TD(behav_fname, spk_fname, y_ax, fig);
% set events to align to and raster/psth windows
% 50 msec bins starting at 450 ms before odorvalveon
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

OdorValveOn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound);

clearvars epochs start_bound stop_bound

% 50 msec bins starting at 300 msec before odorpokeout
bin_starts_3 = [-0.3:0.01:-0.1];
bin_stops_3 = [-0.2:0.01:0];

for epoch_ind_3 = 1:length(bin_starts_3);
    epochs{epoch_ind_3} = [888 bin_starts_3(epoch_ind_3) 3 888 bin_stops_3(epoch_ind_3) 3];
end

% 50 msec bins starting at odorpokeout and going to 1000 msec after
% odorpokeout
bin_starts_4 = [0:0.01:1.4];
bin_stops_4 = [0.1:0.01:1.5];

for epoch_ind_4 = length(bin_starts_3)+1:length(bin_starts_3)+length(bin_starts_4);
    epochs{epoch_ind_4} = [999 3 bin_starts_4(epoch_ind_4-length(bin_starts_3)) 999 3 bin_stops_4(epoch_ind_4-length(bin_starts_3))];
end

start_bound = 0;
stop_bound = 4; % if the end of a bin is after the go signal (event #8), disregard this trial

OdorPokeOut_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound);

clearvars epochs start_bound stop_bound

% 50 msec bins starting at 400 msec before WaterPokeIn
bin_starts_5 = [-0.4:0.01:-0.1];
bin_stops_5 = [-0.3:0.01:0];

for epoch_ind_5 = 1:length(bin_starts_5);
    epochs{epoch_ind_5} = [888 bin_starts_5(epoch_ind_5) 4 888 bin_stops_5(epoch_ind_5) 4];
end

% 50 msec bins starting at odorpokeout and going to 1000 msec after
% WaterPokeIn
bin_starts_6 = [0:0.01:1.4];
bin_stops_6 = [0.1:0.01:1.5];

for epoch_ind_6 = length(bin_starts_5)+1:length(bin_starts_5)+length(bin_starts_6);
    epochs{epoch_ind_6} = [999 4 bin_starts_6(epoch_ind_6-length(bin_starts_5)) 999 4 bin_stops_6(epoch_ind_6-length(bin_starts_5))];
end

start_bound = 3;
stop_bound = 6; % if the end of a bin is after the go signal (event #8), disregard this trial

WaterPokeIn_mdl = NeuralRegression_CNC(behav_fname, spk_fname, epochs, start_bound, stop_bound);

%% Create tables and datasets including the variables dicted by the selected model
% and plot the output
if fig == 0
    PresentationFigSetUp;
elseif fig == 1;
end

%% Full_with reaction time model
    for cell_ind_1 = 1:length(OdorValveOn_mdl.full);
        
        con_int_1 = OdorValveOn_mdl.full{cell_ind_1}.coefCI;
        try
            linmdl_full(cell_ind_1, :) = [OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(1)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(1) con_int_1(1,1) con_int_1(1,2)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(2) OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(2)...
                con_int_1(2,1) con_int_1(2,2) OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(3)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(3) con_int_1(3,1) con_int_1(3,2)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(4) OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(4)...
                con_int_1(4,1) con_int_1(4,2) OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(5)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(5) con_int_1(5,1) con_int_1(5,2)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.Estimate(6)...
                OdorValveOn_mdl.full{cell_ind_1}.Coefficients.pValue(6) con_int_1(6,1) con_int_1(6,2)];
        catch
        end
    end
    
    [tbl1_row, tbl1_col] = find(isnan(linmdl_full));
    tbl1_row = unique(tbl1_row);
    linmdl_full(tbl1_row, :) = [];
    
    linmdl_full_ds = dataset({linmdl_full 'Int_Est', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_pValue', 'x1_CI_low',...
        'x1_CI_high', 'x2_Est', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_pValue', 'x3_CI_low', 'x3_CI_high',...
        'x4_Est', 'x4_pValue', 'x4_CI_low', 'x4_CI_high', 'x5_Est', 'x5_pValue', 'x5_CI_low', 'x5_CI_high'}, 'obsnames','');
    
    bin_starts_e1 = [bin_starts_1 bin_starts_2];
    bin_starts_e1 = bin_starts_e1(1:size(linmdl_full,1))';
    
    for cell_ind_2 = 1:length(OdorPokeOut_mdl.full);
        
        con_int_2 = OdorPokeOut_mdl.full{cell_ind_2}.coefCI;
        try
            linmdl_full_2(cell_ind_2, :) = [OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(1)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(1) con_int_2(1,1) con_int_2(1,2)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(2)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(2) con_int_2(2,1) con_int_2(2,2)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(3)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(3)...
                con_int_2(3,1) con_int_2(3,2) OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(4)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(4) con_int_2(4,1) con_int_2(4,2)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(5)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(5) con_int_2(5,1) con_int_2(5,2)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.Estimate(6)...
                OdorPokeOut_mdl.full{cell_ind_2}.Coefficients.pValue(6) con_int_2(6,1) con_int_2(6,2)];
        catch
        end
    end
    
    [tbl2_row, tbl2_col] = find(isnan(linmdl_full_2));
    tbl2_row = unique(tbl2_row);
    linmdl_full_2(tbl2_row, :) = [];
    
    linmdl_full_2_ds = dataset({linmdl_full_2 'Int_Est', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_pValue', 'x1_CI_low',...
        'x1_CI_high', 'x2_Est', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_pValue', 'x3_CI_low', 'x3_CI_high',...
        'x4_Est', 'x4_pValue', 'x4_CI_low', 'x4_CI_high', 'x5_Est', 'x5_pValue', 'x5_CI_low', 'x5_CI_high'}, 'obsnames','');
    
    bin_starts_e2 = [bin_starts_3 bin_starts_4];
    bin_starts_e2 = bin_starts_e2(1:size(linmdl_full_2,1))';
    
    for cell_ind_3 = 1:length(WaterPokeIn_mdl.full);
        
        con_int_3 = WaterPokeIn_mdl.full{cell_ind_3}.coefCI;
        try
            linmdl_full_3(cell_ind_3, :) = [WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(1)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(1) con_int_3(1,1) con_int_3(1,2)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(2)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(2) con_int_3(2,1) con_int_3(2,2)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(3)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(3)...
                con_int_3(3,1) con_int_3(3,2) WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(4)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(4) con_int_3(4,1) con_int_3(4,2)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(5)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(5) con_int_3(5,1) con_int_3(5,2)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.Estimate(6)...
                WaterPokeIn_mdl.full{cell_ind_3}.Coefficients.pValue(6) con_int_3(6,1) con_int_3(6,2)];
        catch
        end
    end
    
    [tbl3_row, tbl3_col] = find(isnan(linmdl_full_3));
    tbl3_row = unique(tbl3_row);
    linmdl_full_3(tbl3_row, :) = [];
    
    linmdl_full_3_ds = dataset({linmdl_full_3 'Int_Est', 'Int_pValue', 'Int_CI_low', 'Int_CI_high', 'x1_Est', 'x1_pValue', 'x1_CI_low',...
        'x1_CI_high', 'x2_Est', 'x2_pValue', 'x2_CI_low', 'x2_CI_high', 'x3_Est', 'x3_pValue', 'x3_CI_low', 'x3_CI_high',...
        'x4_Est', 'x4_pValue', 'x4_CI_low', 'x4_CI_high', 'x5_Est', 'x5_pValue', 'x5_CI_low', 'x5_CI_high'}, 'obsnames','');
    
    bin_starts_e3 = [bin_starts_5 bin_starts_6];
    bin_starts_e3 = bin_starts_e3(1:size(linmdl_full_3,1))';
    
    %% Generate vector for patch plot
    % Create patch files for OdorValveOn epoch
    % patch for aligned epoch 1 and beta 1
    patch_trials_e1x1 = vertcat(bin_starts_e1, sort(bin_starts_e1, 'descend'));
    patch_trials_e1x1(1:length(patch_trials_e1x1), 2) = nan;
    patch_trials_e1x1(1:length(bin_starts_e1),2) = linmdl_full_ds.x1_CI_low;
    patch_trials_e1x1(length(bin_starts_e1) + 1:length(patch_trials_e1x1),2) = flip(linmdl_full_ds.x1_CI_high);
    
    % patch for aligned epoch 1 and beta 2
    patch_trials_e1x2 = vertcat(bin_starts_e1, sort(bin_starts_e1, 'descend'));
    patch_trials_e1x2(1:length(patch_trials_e1x2), 2) = nan;
    patch_trials_e1x2(1:length(bin_starts_e1),2) = linmdl_full_ds.x2_CI_low;
    patch_trials_e1x2(length(bin_starts_e1) + 1:length(patch_trials_e1x2),2) = flip(linmdl_full_ds.x2_CI_high);
    
    % patch for aligned epoch 1 and beta 3
    patch_trials_e1x3 = vertcat(bin_starts_e1, sort(bin_starts_e1, 'descend'));
    patch_trials_e1x3(1:length(patch_trials_e1x3), 2) = nan;
    patch_trials_e1x3(1:length(bin_starts_e1),2) = linmdl_full_ds.x3_CI_low;
    patch_trials_e1x3(length(bin_starts_e1) + 1:length(patch_trials_e1x3),2) = flip(linmdl_full_ds.x3_CI_high);
    
    % patch for aligned epoch 1 and beta 4
    patch_trials_e1x5 = vertcat(bin_starts_e1, sort(bin_starts_e1, 'descend'));
    patch_trials_e1x5(1:length(patch_trials_e1x5), 2) = nan;
    patch_trials_e1x5(1:length(bin_starts_e1),2) = linmdl_full_ds.x5_CI_low;
    patch_trials_e1x5(length(bin_starts_e1) + 1:length(patch_trials_e1x5),2) = flip(linmdl_full_ds.x5_CI_high);
    
    %% Create patch files for OdorPokeOut epoch
    % patch for aligned epoch 2 and beta 1
    patch_trials_e2x1 = vertcat(bin_starts_e2, sort(bin_starts_e2, 'descend'));
    patch_trials_e2x1(1:length(patch_trials_e2x1), 2) = nan;
    patch_trials_e2x1(1:length(bin_starts_e2),2) = linmdl_full_2_ds.x1_CI_low;
    patch_trials_e2x1(length(bin_starts_e2) + 1:length(patch_trials_e2x1),2) = flip(linmdl_full_2_ds.x1_CI_high);
    
    % patch for aligned epoch 2 and beta 2
    patch_trials_e2x2 = vertcat(bin_starts_e2, sort(bin_starts_e2, 'descend'));
    patch_trials_e2x2(1:length(patch_trials_e2x2), 2) = nan;
    patch_trials_e2x2(1:length(bin_starts_e2),2) = linmdl_full_2_ds.x2_CI_low;
    patch_trials_e2x2(length(bin_starts_e2) + 1:length(patch_trials_e2x2),2) = flip(linmdl_full_2_ds.x2_CI_high);
    
    % patch for aligned epoch 2 and beta 3
    patch_trials_e2x3 = vertcat(bin_starts_e2, sort(bin_starts_e2, 'descend'));
    patch_trials_e2x3(1:length(patch_trials_e2x3), 2) = nan;
    patch_trials_e2x3(1:length(bin_starts_e2),2) = linmdl_full_2_ds.x3_CI_low;
    patch_trials_e2x3(length(bin_starts_e2) + 1:length(patch_trials_e2x3),2) = flip(linmdl_full_2_ds.x3_CI_high);
    
    % patch for aligned epoch 2 and beta 4
    patch_trials_e2x5 = vertcat(bin_starts_e2, sort(bin_starts_e2, 'descend'));
    patch_trials_e2x5(1:length(patch_trials_e2x5), 2) = nan;
    patch_trials_e2x5(1:length(bin_starts_e2),2) = linmdl_full_2_ds.x5_CI_low;
    patch_trials_e2x5(length(bin_starts_e2) + 1:length(patch_trials_e2x5),2) = flip(linmdl_full_2_ds.x5_CI_high);
    
    %% Create patch files for WaterPokeIn epoch
    % patch for aligned epoch 3 and beta 1
    patch_trials_e3x1 = vertcat(bin_starts_e3, sort(bin_starts_e3, 'descend'));
    patch_trials_e3x1(1:length(patch_trials_e3x1), 2) = nan;
    patch_trials_e3x1(1:length(bin_starts_e3),2) = linmdl_full_3_ds.x1_CI_low;
    patch_trials_e3x1(length(bin_starts_e3) + 1:length(patch_trials_e3x1),2) = flip(linmdl_full_3_ds.x1_CI_high);
    
    % patch for aligned epoch 3 and beta 2
    patch_trials_e3x2 = vertcat(bin_starts_e3, sort(bin_starts_e3, 'descend'));
    patch_trials_e3x2(1:length(patch_trials_e3x2), 2) = nan;
    patch_trials_e3x2(1:length(bin_starts_e3),2) = linmdl_full_3_ds.x2_CI_low;
    patch_trials_e3x2(length(bin_starts_e3) + 1:length(patch_trials_e3x2),2) = flip(linmdl_full_3_ds.x2_CI_high);
    
    % patch for aligned epoch 3 and beta 3
    patch_trials_e3x3 = vertcat(bin_starts_e3, sort(bin_starts_e3, 'descend'));
    patch_trials_e3x3(1:length(patch_trials_e3x3), 2) = nan;
    patch_trials_e3x3(1:length(bin_starts_e3),2) = linmdl_full_3_ds.x3_CI_low;
    patch_trials_e3x3(length(bin_starts_e3) + 1:length(patch_trials_e3x3),2) = flip(linmdl_full_3_ds.x3_CI_high);
    
    % patch for aligned epoch 3 and beta 4
    patch_trials_e3x5 = vertcat(bin_starts_e3, sort(bin_starts_e3, 'descend'));
    patch_trials_e3x5(1:length(patch_trials_e3x5), 2) = nan;
    patch_trials_e3x5(1:length(bin_starts_e3),2) = linmdl_full_3_ds.x5_CI_low;
    patch_trials_e3x5(length(bin_starts_e3) + 1:length(patch_trials_e3x5),2) = flip(linmdl_full_3_ds.x5_CI_high);
    
    %% Plotting
    % x1 = current choice
    % x2 = previous choice
    % x5 = trial type
    
    % Odor valve open epoch
    h1 = axes
    hold on;
    p_e1x1 = patch(patch_trials_e1x1(:,1), patch_trials_e1x1(:,2), 1);
    p_e1x2 = patch(patch_trials_e1x2(:,1), patch_trials_e1x2(:,2), 1);
    p_e1x5 = patch(patch_trials_e1x5(:,1), patch_trials_e1x5(:,2), 1);
    plot(bin_starts_e1, linmdl_full_ds.x1_Est, 'Color', [0 0 0], 'LineWidth', 2);
    plot(bin_starts_e1, linmdl_full_ds.x2_Est, 'Color', [0 1 1], 'LineWidth', 2);
    plot(bin_starts_e1, linmdl_full_ds.x5_Est, 'Color', [1 0 1], 'LineWidth', 2);
%     
    % Label and format
%     xlabel('Time from odor valve open');
    ylabel('Coefficient estimate');
    set(p_e1x1,'FaceColor',[.8 .8 .8]);
    set(p_e1x1,'EdgeColor',[.8 .8 .8]);
    set(p_e1x2,'FaceColor',[.8 1 1]);
    set(p_e1x2,'EdgeColor',[.8 1 1]);
    set(p_e1x5,'FaceColor',[1 .8 1]);
    set(p_e1x5,'EdgeColor',[1 .8 1]);
%     set(gca, 'XTick', [-0.4 0 0.4]);
    set(gca, 'YTick', [-y_ax -y_ax/2 0 y_ax/2]);
    axis([-0.4 0.4 -y_ax y_ax/2]);
    line([0,0],[-y_ax 25], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    line([-0.4 0.4],[0 0], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    hold off;
    set(h1, 'Position', [0.10 0.5 0.26 0.26]);
    
    % Odor port exit epoch
    h2 = axes
    hold on;
    p_e2x1 = patch(patch_trials_e2x1(:,1), patch_trials_e2x1(:,2), 1);
    p_e2x2 = patch(patch_trials_e2x2(:,1), patch_trials_e2x2(:,2), 1);
    p_e2x5 = patch(patch_trials_e2x5(:,1), patch_trials_e2x5(:,2), 1);
    plot(bin_starts_e2, linmdl_full_2_ds.x1_Est, 'Color', [0 0 0], 'LineWidth', 2);
    plot(bin_starts_e2, linmdl_full_2_ds.x2_Est, 'Color', [0 1 1], 'LineWidth', 2);
    plot(bin_starts_e2, linmdl_full_2_ds.x5_Est, 'Color', [1 0 1], 'LineWidth', 2);
    
    
    % Label and format
%     xlabel('Time from odor port exit');
    set(p_e2x1,'FaceColor',[.8 .8 .8]);
    set(p_e2x1,'EdgeColor',[.8 .8 .8]);
    set(p_e2x2,'FaceColor',[.8 1 1]);
    set(p_e2x2,'EdgeColor',[.8 1 1]);
    set(p_e2x5,'FaceColor',[1 .8 1]);
    set(p_e2x5,'EdgeColor',[1 .8 1]);
    set(gca, 'YTick', []);
%     set(gca, 'XTick', [-0.2 0 0.3]);
    axis([-0.2 0.3 -y_ax y_ax/2]);
    line([0,0],[-y_ax y_ax/2], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    line([-0.2 0.3],[0 0], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    hold off;
    set(h2, 'Position', [0.4 0.5 0.26 0.26]);
    
    % Water port entry epoch
    h3 = axes
    hold on;
    p_e3x1 = patch(patch_trials_e3x1(:,1), patch_trials_e3x1(:,2), 1);
    p_e3x2 = patch(patch_trials_e3x2(:,1), patch_trials_e3x2(:,2), 1);
    p_e3x5 = patch(patch_trials_e3x5(:,1), patch_trials_e3x5(:,2), 1);
    plot(bin_starts_e3, linmdl_full_3_ds.x1_Est, 'Color', [0 0 0], 'LineWidth', 2);
    plot(bin_starts_e3, linmdl_full_3_ds.x2_Est, 'Color', [0 1 1], 'LineWidth', 2);
    plot(bin_starts_e3, linmdl_full_3_ds.x5_Est, 'Color', [1 0 1], 'LineWidth', 2);
    
    
    % Label and format
%     xlabel('Time from water port entry');
    set(p_e3x1,'FaceColor',[.8 .8 .8]);
    set(p_e3x1,'EdgeColor',[.8 .8 .8]);
    set(p_e3x2,'FaceColor',[.8 1 1]);
    set(p_e3x2,'EdgeColor',[.8 1 1]);
    set(p_e3x5,'FaceColor',[1 .8 1]);
    set(p_e3x5,'EdgeColor',[1 .8 1]);
    set(gca, 'YTick', []);
%     set(gca, 'XTick', [-0.2 0 1]);
    axis([-0.2 1 -y_ax y_ax/2]);
    line([0,0],[-y_ax y_ax/2], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    line([-0.2 1],[0 0], 'Color', [0 0 0], 'LineStyle', '--', 'LineWidth', 1);
    hold off;
    set(h3, 'Position', [0.7 0.5 0.26 0.26]);
    
%     keyboard;


end
