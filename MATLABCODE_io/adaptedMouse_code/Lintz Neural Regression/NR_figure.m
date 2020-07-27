%% This is a function to create the neural regression figure of the 
%% SNr paper. The first function plots an example cell showing the
%% changing beta values over the duration of the trial. 
%% The second function, will plot the fraction of cells that
%% display a significant beta for the period indicated. 

PresentationFigSetUp;

% [h1, h2, h3] = NR_pop_fraction_plot(1, 0);
% 
% hold on;
% 
% [h4, h5, h6] = NR_CNC_beta_plot('C:\Behavior Data\nlx data\ML8\tb_ML8_130614a.mat', 'C:\Neuralynx\ML8_LSNrVD4\2013-06-14_10-58-21\TT2_4.mat', 6, 50, 1);
% 
% set(h4, 'Position', [0.07 0.525 0.28 0.28]);
% set(h5, 'Position', [0.39 0.525 0.28 0.28]);
% set(h6, 'Position', [0.71 0.525 0.28 0.28]);
% 
% set(h4, 'XTick', []);
% set(h5, 'XTick', []);
% set(h6, 'XTick', []);


[h1, h2, h3] = NR_pop_fraction_plot_TD(1, 0);
set(h1, 'Position', [0.07 0.2 0.28 0.28]);
set(h2, 'Position', [0.39 0.2 0.28 0.28]);
set(h3, 'Position', [0.71 0.2 0.28 0.28]);

hold on;

[h4, h5, h6] = NR_CNC_beta_plot_TD('C:\Behavior Data\nlx data\ML8\tb_ML8_130614a.mat', 'C:\Neuralynx\ML8_LSNrVD4\2013-06-14_10-58-21\TT2_4.mat', 50, 1);

set(h4, 'Position', [0.07 0.525 0.28 0.28]);
set(h5, 'Position', [0.39 0.525 0.28 0.28]);
set(h6, 'Position', [0.71 0.525 0.28 0.28]);

set(h4, 'XTick', []);
set(h5, 'XTick', []);
set(h6, 'XTick', []);
