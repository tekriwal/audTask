%% Code to calculate AIC for linear four_param models


%% Load individual mdl files for building matrix 
cd('C:\Behavior Data\SC data\lin_models');
regression_cells = dir('C:\Behavior Data\SC data\lin_models');
regression_cells = cellstr(ls);
regression_cells = regression_cells(5:length(regression_cells));
regression_cells = cellfun(@(x) regexprep(x,'.mat',''), regression_cells, 'UniformOutput', 0);

AIC_table = nan(length(regression_cells), 6);

for cell_ind = 1:length(regression_cells);
mdl_file = load(cell2mat(regression_cells(cell_ind,:)));

%AIC_table(cell_ind, 1) = mdl_file.lin_models.choice_only{1}.ModelCriterion.AIC; % AIC for choice only model
AIC_table(cell_ind, 1) = mdl_file.lin_models.full{1}.ModelCriterion.AIC; % AIC for full model
AIC_table(cell_ind, 2) = mdl_file.lin_models.full_with_reaction_time{1}.ModelCriterion.AIC; % AIC for full w/ reaction time model
AIC_table(cell_ind, 3) = mdl_file.lin_models.full_w_rxn_w_diff{1}.ModelCriterion.AIC; % AIC for full_w_rxn_w_diff model

% Model comparisons
AICmin = min(AIC_table,[],2);

AIC_table(cell_ind, 4) = AIC_table(cell_ind, 1)-AICmin(cell_ind, 1); % compare full model to best model
AIC_table(cell_ind, 5) = AIC_table(cell_ind, 2)-AICmin(cell_ind, 1); % compare full/rxn model to best model
AIC_table(cell_ind, 6) = AIC_table(cell_ind, 3)-AICmin(cell_ind, 1); % compare full/rxn/diff model to best model

end

keyboard;

