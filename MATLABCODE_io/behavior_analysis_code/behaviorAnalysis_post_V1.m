
% 4/22/2020; creating fx to generate figures for post behavior, hoping to compare stim
%on vs off

%post for case 2, 4, 6, 7, 8, 10, 11, 13 (these are listed as
%'1'/'2'/'3'/'4'


function [] = behaviorAnalysis_post_V1()


filterlevel = 0;


if filterlevel == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_nofilter.mat', 'postIO_behavior')
elseif filterlevel == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050s.mat', 'postIO_behavior')
elseif filterlevel == 2
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_postIO/behavior_struct_postIO_no5050snoHardSG.mat', 'postIO_behavior')
end


%post for case 2, 4, 6, 7, 8, 10, 11, 13 (but don't use 8, since only SG)
caseIndex = {'case02';'case04';'case06';'case07';'case10';'case11';'case13'};




%% below is for DBS ON
ONorOFF = 'ON';
% SGrxntime.(ONorOFF) = [];
% ISrxntime.(ONorOFF) = [];
% SGperccorr.(ONorOFF) = [];
% ISperccorr.(ONorOFF) = [];
% SGerrorCount.(ONorOFF) = [];
% ISerrorCount.(ONorOFF) = [];

for i = 1:length(caseIndex)
    
    caseID = caseIndex{i};
    
    substruct = 'median_rxnTime';
    substruct2 = 'SG';
    SGrxntime(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISrxntime(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
    
    substruct = 'percCorr';
    substruct2 = 'SG';
    SGperccorr(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISperccorr(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
    
    substruct = 'errors';
    substruct2 = 'SG';
    SGerrorCount(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISerrorCount(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
end





%% below is for DBS OFF
ONorOFF = 'OFF';
% SGrxntime.(ONorOFF) = [];
% ISrxntime.(ONorOFF) = [];
% SGperccorr.(ONorOFF) = [];
% ISperccorr.(ONorOFF) = [];
% SGerrorCount.(ONorOFF) = [];
% ISerrorCount.(ONorOFF) = [];

for i = 1:length(caseIndex)
    
    caseID = caseIndex{i};
    
    substruct = 'median_rxnTime';
    substruct2 = 'SG';
    SGrxntime(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISrxntime(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
    
    substruct = 'percCorr';
    substruct2 = 'SG';
    SGperccorr(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISperccorr(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
    
    substruct = 'errors';
    substruct2 = 'SG';
    SGerrorCount(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISerrorCount(i).(ONorOFF) = postIO_behavior.(caseID).(ONorOFF).(substruct).(substruct2);
    
    
end


%% below is for comparing SG rxn, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = SGrxntime(i).OFF;
    input2(i) = SGrxntime(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG OFF', 'SG ON'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);






%% below is for comparing IS rxn, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = ISrxntime(i).OFF;
    input2(i) = ISrxntime(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'IS OFF', 'IS ON'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);








%% below is for comparing SG perc corr, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = SGperccorr(i).OFF;
    input2(i) = SGperccorr(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG OFF', 'SG ON'});
ylabel('Perc corr'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);






%% below is for comparing IS perc corr, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = ISperccorr(i).OFF;
    input2(i) = ISperccorr(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'IS OFF', 'IS ON'});
ylabel('Percent Corr'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);
















%% below is for comparing SG perc corr, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = SGerrorCount(i).OFF;
    input2(i) = SGerrorCount(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG OFF', 'SG ON'});
ylabel('Error Count'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);






%% below is for comparing IS perc corr, OFF vs ON

figure()
szz = 75;

for i = 1:length(caseIndex)
    input1(i) = ISerrorCount(i).OFF;
    input2(i) = ISerrorCount(i).ON;
end

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'IS OFF', 'IS ON'});
ylabel('Error Count'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);









%% below is some plotting to compare SG and IS


% SGrxntime.(ONorOFF) = [];
% ISrxntime.(ONorOFF) = [];
% SGperccorr.(ONorOFF) = [];
% ISperccorr.(ONorOFF) = [];
% SGerrorCount.(ONorOFF) = [];
% ISerrorCount.(ONorOFF) = [];
for i = 1:length(caseIndex)

     SGminusIS_rxnTime_ON(i) = SGrxntime(i).ON - ISrxntime(i).ON;
    SGminusIS_rxnTime_OFF(i) = SGrxntime(i).OFF - ISrxntime(i).OFF;
    
    SGminusIS_percCorr_ON(i) = SGperccorr(i).ON - ISperccorr(i).ON;
    SGminusIS_percCorr_OFF(i) = SGperccorr(i).OFF - ISperccorr(i).OFF;
    
    SGminusIS_OEcount_ON(i) = SGerrorCount(i).ON - ISerrorCount(i).ON;
    SGminusIS_OEcount_OFF(i) = SGerrorCount(i).OFF - ISerrorCount(i).OFF;
end



figure()
szz = 75;

input1 = SGminusIS_rxnTime_OFF;
input2 = SGminusIS_rxnTime_ON;
%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%
xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'OFF (SG-IS)', 'ON (SG-IS)'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.5]);
xlim([.95 1.25]);















figure()
szz = 75;

input1 = SGminusIS_percCorr_OFF;
input2 = SGminusIS_percCorr_ON;

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'OFF (SG-IS)', 'ON (SG-IS)'});
ylabel('Percent correct'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 1.5]);
xlim([.95 1.25]);














figure()
szz = 75;

input1 = SGminusIS_OEcount_OFF;
input2 = SGminusIS_OEcount_ON;

%stats
hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
hx_is = lillietest(input2);

[p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED

[p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
[h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
%

xmin = -0.1;
xmax = 0.1;
n = length(input1);
x1 = xmin+rand(1,n)*(xmax-xmin);
x1 = 0;

xaxis_onPairedSG = 1:(length(input1));
xaxis_onPairedSG(:) = 1;
xaxis_onPairedSG = xaxis_onPairedSG + x1;

xaxis_onPairedIS = 1:(length(input2));
xaxis_onPairedIS(:) = 1.2;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, mean(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'OFF (SG-IS)', 'ON (SG-IS)'});
ylabel('Number of out earlies'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([-1 8]);
xlim([.95 1.25]);









end