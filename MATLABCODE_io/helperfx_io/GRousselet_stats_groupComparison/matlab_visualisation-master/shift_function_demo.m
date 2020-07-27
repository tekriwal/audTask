% Code to illustrate the shift function and to
% reproduce the figures in my blog post.
%
% Execute each cell in turn by pressing cmd+enter (mac) or ctrl+enter (pc)
% You can navigate between cells by pressing cmd/ctrl + up or down arrow.
%
% Copyright (C) 2016 Guillaume Rousselet - University of Glasgow

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.

%% dependencies

% +cmu
% http://matlab.cheme.cmu.edu/cmu-matlab-package.html

% UnivarScatter

% both available here:
% https://github.com/GRousselet/matlab_visualisation

%% MEAN SHIFT
y1 = randn(500,1);
y2 = randn(500,1)+0.5;

figure('Color','w','NumberTitle','off')

subplot(2,1,1);hold on
hist(y1,50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

subplot(2,1,2)
hist(y2,50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

shifthd(y1,y2,200,1)

%% ASYMMETRIC SHIFT
y1 = randn(500,1);
y2 = randn(500,1);
y2(y2>0) = y2(y2>0)*1.5;

figure('Color','w','NumberTitle','off')

subplot(2,1,1);hold on
hist(y1,50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

subplot(2,1,2)
hist(y2,50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

shifthd(y1,y2,200,1)

%% VARIANCE SHIFT
y1 = randn(500,1);
y2 = randn(500,1).*2;

figure('Color','w','NumberTitle','off')

subplot(2,1,1);hold on
hist(y1,50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

subplot(2,1,2)
hist(y2,50)
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w');
set(gca,'FontSize',14,'Layer','Top','XLim',[-4 4],'YLim',[0 40])
box on

shifthd(y1,y2,200,1)

%% ozone experiment example
% see:
% Doksum, K.A. & Sievers, G.L. (1976) Plotting with Confidence - Graphical Comparisons of 2 Populations. Biometrika, 63, 421-434.

control=[41 38.4 24.4 25.9 21.9 18.3 13.1 27.3 28.5 -16.9 26 17.4 21.8 15.4 27.4 19.2 22.4 17.7 26 29.4 21.4 26.6 22.7];
ozone=[10.1 6.1 20.4 7.3 14.3 15.5 -9.9 6.8 28.2 17.9 -9 -12.9 14 6.6 12.1 15.7 39.9 -15.9 54.6 -14.7 44.1 -9];

[xd, yd, delta, deltaCI] = shifthd(control,ozone,200,1);

shift_fig(xd, yd, delta, deltaCI,control,ozone,1,5)


