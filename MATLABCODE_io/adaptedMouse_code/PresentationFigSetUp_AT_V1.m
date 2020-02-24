%% PresentationFigSetUp.m
% Sets default values for figures.
% For general help on object properties, in helpdesk search
% "Function Name" for "get", and at bottom of page,
% click on "Handle Graphics Properties"
%
% For more info on defaults, in helpdesk search "Document Titles"
% for "Defining Default Values" and "Setting Default Property Values".
% 10/27/03
%
% to re-reference entire figure, after calling this fcn: set(gcf, 'CurrentAxes', whole_fig);
%
% $ Settings updated for selectivity plots for rat neurons 2/13/06 - GF $
% $ Screen Settings updated for John Thompson Desktop 1/3/2012 - JAT
% $ Settings updated for general Felsen Lab use 4/16/2013 - GF $


%PRESENTATION_TYPE = 'talk'; % talk or paper (affects font sizes)
PRESENTATION_TYPE = 'paper'; % talk or paper (affects font sizes)

% get width of current monitor
screen_size = get(0, 'ScreenSize');
screen_width = screen_size(3);
screen_height = screen_size(4);

% Set the width of the figure, relative to the screen size
FRACTION_h = 0.8;
FRACTION_w = 0.5;

%% set a square figure window, so that when units are normalized, .1 vertically = .1 horizontally
FIG_HEIGHT = screen_height * FRACTION_h;
FIG_WIDTH = screen_width * FRACTION_w;

% account for the approximate height of the icons, menu bar, etc. of the figure
% (which isn't taken into account in the sizing of the figure, apparently)
FIG_MENU_HEIGHT = 40; 

%fig_position = [350 40 FIG_WIDTH FIG_HEIGHT];
FIG_L = (screen_width /2) - (FIG_WIDTH / 2);
FIG_U = (screen_height / 2) - (FIG_HEIGHT / 2) - (FIG_MENU_HEIGHT / 2);

fig_position = [FIG_L FIG_U FIG_WIDTH FIG_HEIGHT];


PANEL_LABEL_FONT_SIZE = 24; %% size of the letters labeling each subfigure panel
PANEL_LABEL_FONT_WEIGHT = 'normal';


if strcmp(PRESENTATION_TYPE, 'talk')
    TEXT_FONT_SIZE = 18; %% size of axis labels
else
    TEXT_FONT_SIZE = 14; %%
end

fig = figure;
set(fig, 'Position', fig_position);

set(fig,...
    'Units', 'normalized',...
    'DefaultAxesFontName', 'Georgia',...
    'DefaultAxesColor', [1 1 1],...
    'DefaultAxesFontSize', TEXT_FONT_SIZE,...
    'DefaultAxesLineWidth', 1,...
    'DefaultAxesColorOrder', [0 0 0],...
    'DefaultAxesTickDir', 'out',...
    'DefaultAxesTickLength', [0.015 0.015],...
    'DefaultLineLineWidth', 2,...
    'DefaultTextFontName', 'Georgia',...
    'DefaultTextFontSize', TEXT_FONT_SIZE, ...
    'DefaultTextVerticalAlignment', 'Middle', ...
    'DefaultTextHorizontalAlignment', 'Center' ...
    );

% set a 'whole_fig' axis that can be rereferenced in the figure-producing
% mfile to make axis labels, etc.
whole_fig = axes('Position', [0 0 1 1]);

% to show grids on the figure, set SHOW_GRIDS = 1 before calling PresentationFigSetUp
if exist('SHOW_GRIDS')
    if SHOW_GRIDS == 1
        set(gca,'Visible','on');
        grid on;
    else
        set(gca,'Visible','off');
    end
else
    set(gca,'Visible','off');
end    

%%% Below is specific for making rasters/psths from ratbase files %%%

%% Set the colors common to rasters and psths
RASTER_COLORS.L = [0 0 0];
RASTER_COLORS.R = [1 0 0];
RASTER_COLORS.mix.odorA = [0 0 1; 0.5 0.5 0.5];
RASTER_COLORS.mix.odorB = [0 1 0; 0.5 0 0.5];

RASTER_COLORS.correct = '-';
RASTER_COLORS.error = '--';

% RASTER_COLORS.gotone_short = '-';
% RASTER_COLORS.gotone_long = '--';

% colors of raster ticks for trial events
SECONDARY_EVENTS_COLORS = [...
    0 1 0;...         %  Neon Green OdorPokeIn
    1 0.5 1;...       %  Hot Pink OdorValveOn
    0.75 0 0.75;...   %  Dark Pink OdorPokeOut
    0 0.75 0.75;...   %  Turquoise WaterPokeIn
    0 0 1;...         %  Navy Blue WaterValveOn
    0.75 0 0;...      %  Red WaterPokeOut
    0 1 0;...         %  Neon Green NextOdorPokeIn
    0.85 0.85 0];     %  Yellow Go Signal


