
% creating fx to generate figures for IO behavior



function [] = behaviorAnalysis_IO()


filterlevel = 1;


if filterlevel == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_nofilter.mat', 'behavior')
elseif filterlevel == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050s.mat', 'behavior')
elseif filterlevel == 2
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050snoHardSG.mat', 'behavior')
end


caseIndex = {'case01';'case02';'case03';'case04';'case05';'case06';'case07';'case08';'case09';'case10';'case11';'case12';'case13'};



SGrxntime = [];
ISrxntime = [];
SGperccorr = [];
ISperccorr = [];
SGerrorCount = [];
ISerrorCount = [];

for i = 1:13
    
    caseID = caseIndex{i};
    
    
    
    substruct = 'median_rxnTime';
    substruct2 = 'SG';
    SGrxntime(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISrxntime(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    
    substruct = 'percCorr';
    substruct2 = 'SG';
    SGperccorr(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISperccorr(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    
    substruct = 'errors';
    substruct2 = 'SG';
    SGerrorCount(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISerrorCount(i) = behavior.(caseID).(substruct).(substruct2);
    
    
end


%cut case 8 and 9 from spaghetti analysis because no IS trials
i = 9;
SGrxntime(i) = [];
ISrxntime(i) = [];
SGperccorr(i) = [];
ISperccorr(i) = [];
SGerrorCount(i) = [];
ISerrorCount(i) = [];
i = 8;
SGrxntime(i) = [];
ISrxntime(i) = [];
SGperccorr(i) = [];
ISperccorr(i) = [];
SGerrorCount(i) = [];
ISerrorCount(i) = [];





figure()
szz = 75;

input1 = SGrxntime;
input2 = ISrxntime;
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
scatter(1, median(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, median(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([0 3.5]);
xlim([.95 1.25]);















figure()
szz = 75;

input1 = SGperccorr;
input2 = ISperccorr;

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
scatter(1, median(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, median(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Percent correct'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([0 1.5]);
xlim([.95 1.25]);














figure()
szz = 75;

input1 = SGerrorCount;
input2 = ISerrorCount;

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
scatter(1, median(input1), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.2, median(input2), szz*3,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.2], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.2]);

set(gca, 'FontSize', 14, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Number of out earlies'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([-1 8]);
xlim([.95 1.25]);









end