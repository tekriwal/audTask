%AT 6/29/20 updating w/ the cutfirst3trials field
%AT updating 6/24/20, writing as V2

%AT as of 5/22/20, this fx produces the three plots that go into Fig 2 of
%io paper

%AT 5/21/20, this fx is what generates the IO behavioral figures

% creating fx to generate figures for IO behavior



function [] = behaviorAnalysis_IO_V2()

szz = 600;

exclusionFilter = 0;
cutfirst3trials = 0;

if exclusionFilter == 0 && cutfirst3trials == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_nofilter_V2.mat', 'behavior')
elseif exclusionFilter == 1 && cutfirst3trials == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050s_V2.mat', 'behavior')
elseif exclusionFilter == 2 && cutfirst3trials == 1
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050snoHardSG_V2.mat', 'behavior')
elseif exclusionFilter == 0 && cutfirst3trials == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_nofilter_keepalltrials_V2.mat', 'behavior')
elseif exclusionFilter == 1 && cutfirst3trials == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050s_keepalltrials_V2.mat', 'behavior')
elseif exclusionFilter == 2 && cutfirst3trials == 0
    load('/Users/andytek/Box/Auditory_task_SNr/Data/generated_analyses/behavior_IO/behavior_struct_IO_no5050snoHardSG_keepalltrials_V2.mat', 'behavior')
end


caseIndex = {'case01';'case02';'case03';'case04';'case05';'case06';'case07';'case08';'case09';'case10';'case11';'case12';'case13'};
caseIndex = {'case01';'case02';'case03';'case04';'case05';'case06';'case07';'case10';'case11';'case12';'case13'};



SGrxntimemean = [];
ISrxntimemean = [];
SGperccorr = [];
ISperccorr = [];
SGerrorCount = [];
ISerrorCount = [];

for i = 1:11
    
    caseID = caseIndex{i};
    
    
    
    substruct = 'mean_rxnTime';
    substruct2 = 'SG';
    SGrxntimemean(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISrxntimemean(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    substruct = 'mean_rxnTime_wholetrial';
    substruct2 = 'SG';
    SGmean_rxnTime_wholetrial(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISmean_rxnTime_wholetrial(i) = behavior.(caseID).(substruct).(substruct2);

    substruct = 'mean_rxnTime_leftUPtillFeedback';
    substruct2 = 'SG';
    SGmean_rxnTime_leftUPtillFeedback(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISmean_rxnTime_leftUPtillFeedback(i) = behavior.(caseID).(substruct).(substruct2);
    
    
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
    
    
    substruct = 'percerrors';
    substruct2 = 'SG';
    SGpercerrors(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISpercerrors(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct = 'errors_errorsPtHeard';
    substruct2 = 'SG';
    SGerrorCount_errorsPtHeard(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISerrorCount_errorsPtHeard(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    substruct = 'percerrors_errorsPtHeard';
    substruct2 = 'SG';
    SGpercerrors_errorsPtHeard(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISpercerrors_errorsPtHeard(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    
    substruct = 'median_rxnTime';
    substruct2 = 'SG';
    SGrxntimemedian(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISrxntimemedian(i) = behavior.(caseID).(substruct).(substruct2);
    
    
    substruct = 'median_rxnTime_wholetrial';
    substruct2 = 'SG';
    SGmedian_rxnTime_wholetrial(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISmedian_rxnTime_wholetrial(i) = behavior.(caseID).(substruct).(substruct2);

    substruct = 'median_rxnTime_leftUPtillFeedback';
    substruct2 = 'SG';
    SGmedian_rxnTime_leftUPtillFeedback(i) = behavior.(caseID).(substruct).(substruct2);
    
    substruct2 = 'IS';
    ISmedian_rxnTime_leftUPtillFeedback(i) = behavior.(caseID).(substruct).(substruct2);
    
    
end



%AT 6/24/20; let's look at things within subject and generate some
%analyses, starting with rxn time
% caseIndex = {'case01';'case02';'case03';'case04';'case05';'case06';'case07';'case08';'case09';'case10';'case11';'case12';'case13'};
caseIndex = {'case01';'case02';'case03';'case04';'case05';'case06';'case07';'case10';'case11';'case12';'case13'};

for i = 1:11
    
    caseID = caseIndex{i};
    
    substruct = 'rxnTime';
    substruct2 = 'SG';
    SG_indivRxntime = behavior.(caseID).(substruct).(substruct2);
    %     SG_indivRxntime_all(i) = SG_indivRxntime;
    substruct2 = 'IS';
    IS_indivRxntime= behavior.(caseID).(substruct).(substruct2);
    %     IS_indivRxntime_all(i) = IS_indivRxntime;
    
    
    [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_indivRxntime,IS_indivRxntime);
    pvalue_allrxnTime(i) = pvalue;
    outcome_allrxnTime{i} = outcome;
    paraORnonpara_allrxnTime{i} = paraORnonpara;
    
    
    
    
    
        substruct = 'rxnTime_wholetrial';
    substruct2 = 'SG';
    SG_indivRxntimewholetrial = behavior.(caseID).(substruct).(substruct2);
    %     SG_indivRxntime_all(i) = SG_indivRxntime;
    substruct2 = 'IS';
    IS_indivRxntimewholetrial= behavior.(caseID).(substruct).(substruct2);
    %     IS_indivRxntime_all(i) = IS_indivRxntime;
    
    
    [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_indivRxntimewholetrial,IS_indivRxntimewholetrial);
    pvalue_allrxnTimewholetrial(i) = pvalue;
    outcome_allrxnTimewholetrial{i} = outcome;
    paraORnonpara_allrxnTimewholetrial{i} = paraORnonpara;
    
    
    
    
    
    
        substruct = 'rxnTime_leftUPtillFeedback';
    substruct2 = 'SG';
    SG_indivRxntimeleftUPtillFeedback = behavior.(caseID).(substruct).(substruct2);
    %     SG_indivRxntime_all(i) = SG_indivRxntime;
    substruct2 = 'IS';
    IS_indivRxntimeleftUPtillFeedback= behavior.(caseID).(substruct).(substruct2);
    %     IS_indivRxntime_all(i) = IS_indivRxntime;
    
    
    [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_indivRxntimeleftUPtillFeedback,IS_indivRxntimeleftUPtillFeedback);
    pvalue_allrxnTimeleftUPtillFeedback(i) = pvalue;
    outcome_allrxnTimeleftUPtillFeedback{i} = outcome;
    paraORnonpara_allrxnTimeleftUPtillFeedback{i} = paraORnonpara;
    
    
    
    
    
    
    
    %AT 6/29/20; below is meant to be a measure of latency to movement
    
    SG_latencytoMove = SG_indivRxntime - SG_indivRxntimeleftUPtillFeedback;
    IS_latencytoMove = IS_indivRxntime - IS_indivRxntimeleftUPtillFeedback;
    
    [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_latencytoMove,IS_latencytoMove);
    pvalue_latencytoMove(i) = pvalue;
    outcome_latencytoMove{i} = outcome;
    paraORnonpara_latencytoMove{i} = paraORnonpara;
    
    
    
    
    
    %AT 6/29/20; below is looking at diff in timing for all things outside
    %of actual rxn time
    
    SG_nonrxntimes = SG_indivRxntimewholetrial - SG_indivRxntime;
    IS_nonrxntimes = IS_indivRxntimewholetrial - IS_indivRxntime;
    
    [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_nonrxntimes,IS_nonrxntimes);
    pvalue_nonrxntimes(i) = pvalue;
    outcome_nonrxntimes{i} = outcome;
    paraORnonpara_nonrxntimes{i} = paraORnonpara;
    
    
    
    
    %the below will get incorporated back in downstream
    substruct = 'mean_rxnTime_nonrxnTimes';
    substruct2 = 'SG';
    SGmean_rxnTime_nonrxnTimes(i) = mean(SG_nonrxntimes);
    
    substruct2 = 'IS';
    ISmean_rxnTime_nonrxnTimes(i) = mean(IS_nonrxntimes);
    
      %the below will get incorporated back in downstream
    substruct = 'median_rxnTime_nonrxnTimes';
    substruct2 = 'SG';
    SGmedian_rxnTime_nonrxnTimes(i) = median(SG_nonrxntimes);
    
    substruct2 = 'IS';
    ISmedian_rxnTime_nonrxnTimes(i) = median(IS_nonrxntimes);
    
      
    
end

% 
% for i = 1:11
%     
%     caseID = caseIndex{i};
%     
%     substruct = 'rxnTime_wholetrial';
%     substruct2 = 'SG';
%     SG_indivRxntime = behavior.(caseID).(substruct).(substruct2);
%     %     SG_indivRxntime_all(i) = SG_indivRxntime;
%     substruct2 = 'IS';
%     IS_indivRxntime= behavior.(caseID).(substruct).(substruct2);
%     %     IS_indivRxntime_all(i) = IS_indivRxntime;
%     
%     
%     [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_indivRxntime,IS_indivRxntime);
%     pvalue_allrxnTime_wholetrial(i) = pvalue;
%     outcome_allrxnTime_wholetrial{i} = outcome;
%     paraORnonpara_allrxnTime_wholetrial{i} = paraORnonpara;
%     
%     
%     
% end
% 
% 
% 
% for i = 1:11
%     
%     caseID = caseIndex{i};
%     
%     substruct = 'rxnTime_leftUPtillFeedback';
%     substruct2 = 'SG';
%     SG_indivRxntime = behavior.(caseID).(substruct).(substruct2);
%     %     SG_indivRxntime_all(i) = SG_indivRxntime;
%     substruct2 = 'IS';
%     IS_indivRxntime= behavior.(caseID).(substruct).(substruct2);
%     %     IS_indivRxntime_all(i) = IS_indivRxntime;
%     
%     
%     [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(SG_indivRxntime,IS_indivRxntime);
%     pvalue_allrxnTime_leftUPtillFeedback(i) = pvalue;
%     outcome_allrxnTime_leftUPtillFeedback{i} = outcome;
%     paraORnonpara_allrxnTime_leftUPtillFeedback{i} = paraORnonpara;
%     
%     
%     
% end
















% 
% %cut case 8 and 9 from spaghetti analysis because no IS trials
% i = 9;
% SGrxntime(i) = [];
% ISrxntime(i) = [];
% SGmedian_rxnTime_wholetrial(i) = [];
% ISmedian_rxnTime_wholetrial(i) = [];
% SGperccorr(i) = [];
% ISperccorr(i) = [];
% SGerrorCount(i) = [];
% ISerrorCount(i) = [];
% SGerrorCount_errorsPtHeard(i) = [];
% ISerrorCount_errorsPtHeard(i) = [];
% SGpercerrors_errorsPtHeard(i) = [];
% ISpercerrors_errorsPtHeard(i) = [];
% SGpercerrors(i) = [];
% ISpercerrors(i) = [];
% i = 8;
% SGrxntime(i) = [];
% ISrxntime(i) = [];
% SGmedian_rxnTime_wholetrial(i) = [];
% ISmedian_rxnTime_wholetrial(i) = [];
% SGperccorr(i) = [];
% ISperccorr(i) = [];
% SGerrorCount(i) = [];
% ISerrorCount(i) = [];
% SGerrorCount_errorsPtHeard(i) = [];
% ISerrorCount_errorsPtHeard(i) = [];
% SGpercerrors_errorsPtHeard(i) = [];
% ISpercerrors_errorsPtHeard(i) = [];
% SGpercerrors(i) = [];
% ISpercerrors(i) = [];
% 


figure()

input1 = SGrxntimemean;
input2 = ISrxntimemean;
%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([0 4.0]);
xlim([.99 1.04]);






figure()

input1 = SGrxntimemedian;
input2 = ISrxntimemedian;
%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, median(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, median(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Reaction time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([0 4.0]);
xlim([.99 1.04]);


% 
% figure()
% 
% input1 = SGmean_rxnTime_wholetrial;
% input2 = ISmean_rxnTime_wholetrial;
% %stats
% [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
% [pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
% [pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)
% 
% hx_sg = lillietest(input1); %1 means nonpara, 0 means normally distrib
% hx_is = lillietest(input2);
% 
% [p_ttest_nonparaunpaired, h_ttest_nonparaunpaired] = ranksum(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
% [p_ttest_nonparapaired, h_ttest_nonparapaired] = signrank(input1, input2) ; %PAIRED
% 
% [p_ttest_unpaired, h_ttest_unpaired] = ttest2(input1, input2) ; %'left' tests the hypothesis that x2 > x1 (UNPAIRED)
% [h_ttest_paired, p_ttest_paired] = ttest(input1, input2) ; %PAIRED, normal distributions
% %
% xmin = -0.1;
% xmax = 0.1;
% n = length(input1);
% x1 = xmin+rand(1,n)*(xmax-xmin);
% x1 = 0;
% 
% xaxis_onPairedSG = 1:(length(input1));
% xaxis_onPairedSG(:) = 1;
% xaxis_onPairedSG = xaxis_onPairedSG + x1;
% 
% xaxis_onPairedIS = 1:(length(input2));
% xaxis_onPairedIS(:) = 1.03;
% xaxis_onPairedIS = xaxis_onPairedIS + x1;
% 
% scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
% hold on
% scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)
% 
% hold on
% for j = 1:length(input2)
%     plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
%     plot1.Color(4) = 3/8;
%     hold on
% end
% 
% hold on
% scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
% hold on
% 
% scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
% 
% hold on
% plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
% 
% 
% % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
% set(gca, 'XTick', [1 1.03]);
% 
% set(gca, 'FontSize', 18, 'FontName', 'Georgia')
% 
% xticklabels({'SG', 'IS'});
% ylabel('Whole trial time'); %, 'FontSize', 14);
% 
% set(gca, 'FontSize', 18, 'FontName', 'Georgia')
% 
% if hx_sg == 0 && hx_is == 0
%     str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
% else
%     str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
% end
% title(str);
% 
% 
% % ylim([0 3.0]);
% xlim([.99 1.04]);
% 









figure()

input1 = SGmean_rxnTime_leftUPtillFeedback;
input2 = ISmean_rxnTime_leftUPtillFeedback;
%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('left up until feedback rxn time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.0]);
xlim([.99 1.04]);








figure()

input1 = SGmedian_rxnTime_leftUPtillFeedback;
input2 = ISmedian_rxnTime_leftUPtillFeedback;
%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, median(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, median(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [median(input1)  median(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('left up until feedback rxn time'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.0]);
xlim([.99 1.04]);










%AT adding below 6/29/20, these are the 'nonrxntimes', so time of the whole
%trial minus the actual rxn time

figure()

input1 = SGmean_rxnTime_nonrxnTimes;
input2 = ISmean_rxnTime_nonrxnTimes;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'MarkerFaceColor', [.5 .5 .5],'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Non rxn times'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


% ylim([0 3.0]);
xlim([.99 1.04]);






figure()

input1 = SGperccorr;
input2 = ISperccorr;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Percent correct'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([0 1]);
xlim([.99 1.04]);














figure()

input1 = SGerrorCount;
input2 = ISerrorCount;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

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
xlim([.99 1.04]);









figure()

input1 = SGpercerrors;
input2 = ISpercerrors;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Number of out earlies as %'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([-0.1 0.3]);
xlim([.99 1.04]);













figure()

input1 = SGerrorCount_errorsPtHeard;
input2 = ISerrorCount_errorsPtHeard;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Number of out earlies (errors pt heard)'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([-1 8]);
xlim([.99 1.04]);










figure()

input1 = SGpercerrors_errorsPtHeard*100;
input2 = ISpercerrors_errorsPtHeard*100;

%stats
[pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
[pvalue1,outcome1,paraORnonpara1] = stats_subfx_compToZero(input1)
[pvalue2,outcome2,paraORnonpara2] = stats_subfx_compToZero(input2)

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
xaxis_onPairedIS(:) = 1.03;
xaxis_onPairedIS = xaxis_onPairedIS + x1;

scatter(xaxis_onPairedSG(:),input1(:), szz, [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)
hold on
scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5], 'MarkerFaceAlpha',3/8)

hold on
for j = 1:length(input2)
    plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 3);
    plot1.Color(4) = 3/8;
    hold on
end

hold on
scatter(1, mean(input1), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
hold on

scatter(1.03, mean(input2), szz*1.5,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)

hold on
plot([1 1.03], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);


% set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
set(gca, 'XTick', [1 1.03]);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

xticklabels({'SG', 'IS'});
ylabel('Number of out earlies as % (errors pt heard)'); %, 'FontSize', 14);

set(gca, 'FontSize', 18, 'FontName', 'Georgia')

if hx_sg == 0 && hx_is == 0
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_paired));
else
    str = strcat({' 2tailed p value equals '}, num2str(p_ttest_nonparapaired));
end
title(str);


ylim([-.1 100]);
xlim([.99 1.04]);






















































%do some analysises




    function [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(stats_subfx1tailedinput1,stats_subfx1tailedinput2)
        
        outcome = 'nodiffs';
        pvalue = NaN;
        
        hx_input1 = lillietest(stats_subfx1tailedinput1);
        hx_input2 = lillietest(stats_subfx1tailedinput2);
        input2_lessthan_input1 = [];
        input2_greaterthan_input1 = [];
        if hx_input1 == 0 && hx_input2 == 0
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_greaterthan_input1 = 1;
                outcome = 'input2_greaterthan_input1';
                pvalue = p_ttest;
                
            end
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
                pvalue = p_ttest;
                
            end
            %             pvalue = p_ttest;
            paraORnonpara = 'para';
        elseif hx_input1 == 1 || hx_input2 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest1, h_ttest1] = ranksum(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input2_greaterthan_input1 = 1;
                outcome = 'input2_greaterthan_input1';
                pvalue = p_ttest1;
                
            end
            [p_ttest1, h_ttest1] = ranksum(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
                pvalue = p_ttest1;
                
            end
            %             pvalue = p_ttest1;
            paraORnonpara = 'nonpara';
            
        end
        
        if input2_greaterthan_input1 == 1
            disp('input2_greaterthan_input1')
        elseif input2_lessthan_input1 == 1
            disp('input2_lessthan_input1')
        elseif isempty(input2_greaterthan_input1) && isempty(input2_lessthan_input1)
            disp('no differences')
        end
        
    end













    function [pvalue,paraORnonpara] = stats_subfx2tailed(input1_stats_subfx2tailed,input2_stats_subfx2tailed, pairedORnotpaired)
        
        
        hx_input1 = lillietest(input1_stats_subfx2tailed);
        hx_input2 = lillietest(input2_stats_subfx2tailed);
        input2_lessthan_input1 = [];
        input2_greaterthan_input1 = [];
        if hx_input1 == 0 && hx_input2 == 0
            [h_ttest1, p_ttest1] = ttest2(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            
            paraORnonpara = 'para';
            %below is paired
            [h_ttest11, p_ttest11] = ttest(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            if strcmp(pairedORnotpaired, 'notpaired')
                pvalue = p_ttest1;
            elseif strcmp(pairedORnotpaired, 'paired')
                pvalue = p_ttest11;
            end
        elseif hx_input1 == 1 || hx_input2 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest2, h_ttest2] = ranksum(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            
            pvalue = p_ttest2;
            paraORnonpara = 'nonpara';
            %below is paired
            [p_ttest22, h_ttest22] = signrank(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
            if strcmp(pairedORnotpaired, 'notpaired')
                pvalue = p_ttest2;
            elseif strcmp(pairedORnotpaired, 'paired')
                pvalue = p_ttest22;
            end
        end
        
        
    end








    function [pvalue,outcome,paraORnonpara] = stats_subfx_compToZero(stats_subfx1tailedinput1)
        
        
        outcome = 'nodiffs';
        
        hx_input1 = lillietest(stats_subfx1tailedinput1);
        %         hx_input2 = lillietest(stats_subfx1tailedinput2);
        input1_diffthan_zero = [];
        if hx_input1 == 0
            [h_ttest, p_ttest] = ttest(stats_subfx1tailedinput1) ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input1_diffthan_zero = 1;
                outcome = 'input1_diffthan_zero';
            end
            pvalue = p_ttest;
            paraORnonpara = 'para';
        elseif hx_input1 == 1
            %for ranksum....
            % H=0 indicates that
            %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
            %   level. H=1 indicates that the null hypothesis can be rejected at the
            %   5% level
            [p_ttest1, h_ttest1] = signrank(stats_subfx1tailedinput1) ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input1_diffthan_zero = 1;
                outcome = 'input1_diffthan_zero';
                
            end
            pvalue = p_ttest1;
            paraORnonpara = 'nonpara';
            
        end
        if input1_diffthan_zero == 1
            disp('input1_diffthan_zero')
        elseif isempty(input1_diffthan_zero)
            disp('no differences')
        end
        
    end




end