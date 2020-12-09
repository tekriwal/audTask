

%% AT 12/2/20, this fx calls a couple subfx that run some permutation calculations. The one JT wrote creates a distribution from the sample data itself, while the one I editted from an online source is a paired permutation test that randomly flips the labels of paired data. I like mine.
%% AT 9/15/20 the V2 version of this code has been extensively worked on. Runs quite well for the 5 epoch comparison in the io task.


% AT; V1, 7/19/20, goal of this subfx is to generate the multi-epoch







function [] = spaghett_io_helperfx_V2(SNrsubtype1, subName1, subName2, meanORmedian, groupvar, masterspikestruct_V2, combinedbaseline, multiplecomparisons, saveFig)
saveFig = 1;
%below inputs are for the permutation fx, added 11/28/2020 by AT
iterations = 100000;
% permuteMethod = 'half';
% permuteMethod = 'randomize';


fontSize = 5;
szz = 150;

absDiffPlot = 1;
perChangePlot = 1;
subplotting = 1;





if combinedbaseline==1
    combinedbaselineLabel = ' commonbaseline';
else
    combinedbaselineLabel = '';
end

if combinedbaseline == 1 && strcmp(meanORmedian, 'intraTrialFR_mean')
    error('input mismatch')
elseif combinedbaseline == 1 && strcmp(meanORmedian, 'intraTrialpercFR_mean')
    error('input mismatch')
elseif combinedbaseline == 1 && strcmp(meanORmedian, 'intraTrialFR_median')
    error('input mismatch')
elseif combinedbaseline == 1 && strcmp(meanORmedian, 'intraTrialpercFR_median')
    error('input mismatch')
end

%inputs: groupvar



if strcmp(subName1, 'SG')
    xTickLabels = {'SG', 'IS'};
elseif strcmp(subName1, 'ipsi')
    xTickLabels = {'ipsi', 'contra'};
elseif strcmp(subName1, 'Corrects')
    xTickLabels = {'Corrects', 'Incorrects'};
else
    xTickLabels = {subName1, subName2};
end





if  strcmp(meanORmedian, 'intraTrialpercFR_mean') ||  strcmp(meanORmedian, 'intraTrialpercFR_median')
    y1lim_abs = -50;
    y2lim_abs = 50;
else
    y1lim_abs = -15; %ylims for abs diff FR plot
    y2lim_abs = 25;
end

y1lim_percSGIS = -50; %ylims for abs diff FR plot
y2lim_percSGIS = 60;

y1lim_percipsicontra = -100;
y2lim_percipsicontra =  100;
y1lim_perccorrincorr = -100;
y2lim_perccorrincorr =  100;






cluster1index = ~strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, 'DANn');
cluster2index = ~strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, 'GABA');

if strcmp(SNrsubtype1, 'All neurons')
    indeX = logical(ones(size(cluster2index)));
    SNrsubtype1name = 'allClusts';
elseif strcmp(SNrsubtype1, 'cluster1')
    indeX = cluster1index;
    SNrsubtype1name = 'clust1';
elseif strcmp(SNrsubtype1, 'cluster2')
    indeX = cluster2index;
    SNrsubtype1name = 'clust2';
end



if strcmp(subName1, 'SG')
    subNamename = 'sgVis';
elseif strcmp(subName1, 'ipsi')
    subNamename = 'ipsVcon';
elseif strcmp(subName1, 'Corrects')
    subNamename = 'corVinc';
elseif strcmp(subName1, 'SGipsi') && strcmp(subName2, 'SGcontra')
    subNamename = 'SGipsivSGcontra';
elseif strcmp(subName1, 'ISipsi') && strcmp(subName2, 'IScontra')
    subNamename = 'ISipsivIScontra';
elseif strcmp(subName1, 'SGipsi') && strcmp(subName2, 'ISipsi')
    subNamename = 'SGipsivISipsi';
elseif strcmp(subName1, 'SGcontra') && strcmp(subName2, 'IScontra')
    subNamename = 'SGcontravIScontra';
end

%     if strcmp(meanORmedian,'intraTrialpercFR_mean') || strcmp(meanORmedian,'intraTrialpercFR_median')
%         yLabel = 'Diff in % of firing rate cmp to baseline (Hz)';
%     else
%         yLabel = 'Firing rate (Hz)';
%     end
%









%% below are plots


if absDiffPlot == 1
    
    %9/14/20, adding in below to correct for stats if multiple comparisons
    %are needed.
    if multiplecomparisons == 1
        [c_pvalues_2tailed, c_pvalues_lft1tailed, c_pvalues_rt1tailed, pvalues_2tailed, pvalues_lft1tailed, pvalues_rt1tailed] = multiplecomparisons_V1(groupvar, meanORmedian, subName1, subName2, indeX);
    end
    yLabel = 'Firing rate (Hz)';
    if   strcmp(meanORmedian, 'intraTrialpercFR_mean')
        yLabel = 'Change in firing rate as % of baseline (Hz)';
    end
    
    %ALL neurons, not indexing for GABA/DA
    kWidth = .5;
    hFig = figure();
    if subplotting == 1
        subplot(1, 5, 1)
    else
        figure()
    end
    subplot(1, 5, 1)
    %     subName1 = 'SG';
    epochName1 = 'priors';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = 0;
        baselineFR2  = 0;
    elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    else
        baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
        baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    end
    %meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    

    %     if strcmp(meanORmedian,'intraTrialpercFR_mean')
    %         yLabel = 'Diff in % of firing rate cmp to baseline (Hz)';
    %     else
    %         yLabel = 'Firing rate (Hz)';
    %     end
    
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    ylim([y1lim_abs y2lim_abs])
    xlim([ 0.6 1.4])
    
    [pvalue_subplot1_uncorr,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot1,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    if multiplecomparisons == 1
        statscorrected = 'Corrected for mltiple cmps';
        pvalue_subplot1 = c_pvalues_2tailed(1);
        
        %         pvalueinfo1_subplot1 = c_pvalues_lft1tailed(1);
        %         pvalueinfo2_subplot1 = c_pvalues_rt1tailed(1);
    end
    

    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot1));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot1));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2])
    
    
    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot1));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot1_uncorr));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
        
 [p_permutation, observeddifference_permutation, effectsize_permutation] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    str_perm = strcat({'FlipPerm.,p='}, num2str(p_permutation), {'Efsz='}, num2str(effectsize_permutation));

    [pVal_permutationJT, effectSize_permutationJT] = bootStrapPaired_JT_V1(input1, input2, iterations);
    str_permJT = strcat({'JTperm.,p='}, num2str(pVal_permutationJT), {'Efsz='}, num2str(effectSize_permutationJT));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2,str_perm,str_permJT])
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 2)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'sensoryProcessing';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = 0;
        baselineFR2  = 0;
    elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    else
        baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
        baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    end
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
        [p, observeddifference, effectsize] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
      %     yLabel = 'Firing rate (Hz)';
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    ylim([y1lim_abs y2lim_abs])
    xlim([ 0.6 1.4])
    
    [pvalue_subplot2_uncorr,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot2,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    if multiplecomparisons == 1
        pvalue_subplot2 = c_pvalues_2tailed(2);
        %         pvalueinfo1_subplot2 = c_pvalues_lft1tailed(2);
        %         pvalueinfo2_subplot2 = c_pvalues_rt1tailed(2);
    end
    
    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot2));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot2_uncorr));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
 [p_permutation, observeddifference_permutation, effectsize_permutation] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    str_perm = strcat({'FlipPerm.,p='}, num2str(p_permutation), {'Efsz='}, num2str(effectsize_permutation));

    [pVal_permutationJT, effectSize_permutationJT] = bootStrapPaired_JT_V1(input1, input2, iterations);
    str_permJT = strcat({'JTperm.,p='}, num2str(pVal_permutationJT), {'Efsz='}, num2str(effectSize_permutationJT));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2,str_perm,str_permJT])
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 3)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'movePrep';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = 0;
        baselineFR2  = 0;
    elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    else
        baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
        baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    end
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
        [p, observeddifference, effectsize] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    ylim([y1lim_abs y2lim_abs])
    xlim([ 0.6 1.4])
    
    [pvalue_subplot3_uncorr,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot3,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot3,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    if multiplecomparisons == 1
        pvalue_subplot3 = c_pvalues_2tailed(3);
        %         pvalueinfo1_subplot3 = c_pvalues_lft1tailed(3);
        %         pvalueinfo2_subplot3 = c_pvalues_rt1tailed(3);
    end
    
    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot3));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot3_uncorr));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
 [p_permutation, observeddifference_permutation, effectsize_permutation] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    str_perm = strcat({'FlipPerm.,p='}, num2str(p_permutation), {'Efsz='}, num2str(effectsize_permutation));

    [pVal_permutationJT, effectSize_permutationJT] = bootStrapPaired_JT_V1(input1, input2, iterations);
    str_permJT = strcat({'JTperm.,p='}, num2str(pVal_permutationJT), {'Efsz='}, num2str(effectSize_permutationJT));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2,str_perm,str_permJT])
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 4)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'moveInit';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = 0;
        baselineFR2  = 0;
    elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    else
        baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
        baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    end
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
        [p, observeddifference, effectsize] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    ylim([y1lim_abs y2lim_abs])
    xlim([ 0.6 1.4])
    
    [pvalue_subplot4_uncorr,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot4,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot4,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    if multiplecomparisons == 1
        pvalue_subplot4 = c_pvalues_2tailed(4);
        %         pvalueinfo1_subplot4 = c_pvalues_lft1tailed(4);
        %         pvalueinfo2_subplot4 = c_pvalues_rt1tailed(4);
    end
    
    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot4));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot4_uncorr));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
 [p_permutation, observeddifference_permutation, effectsize_permutation] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    str_perm = strcat({'FlipPerm.,p='}, num2str(p_permutation), {'Efsz='}, num2str(effectsize_permutation));

    [pVal_permutationJT, effectSize_permutationJT] = bootStrapPaired_JT_V1(input1, input2, iterations);
    str_permJT = strcat({'JTperm.,p='}, num2str(pVal_permutationJT), {'Efsz='}, num2str(effectSize_permutationJT));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2,str_perm,str_permJT])
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 5)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'periReward';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = 0;
        baselineFR2  = 0;
    elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    else
        baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
        baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    end
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = input2 - baselineFR2;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
        [p, observeddifference, effectsize] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
      
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    ylim([y1lim_abs y2lim_abs])
    xlim([ 0.6 1.4])
    
    [pvalue_subplot5_uncorr,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot5,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot5,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    if multiplecomparisons == 1
        pvalue_subplot5 = c_pvalues_2tailed(5);
        %         pvalueinfo1_subplot5 = c_pvalues_lft1tailed(5);
        %         pvalueinfo2_subplot5 = c_pvalues_rt1tailed(5);
    end
    
    str = strcat({'Corr 2td p = '}, num2str(pvalue_subplot5));
    str_1 = strcat({'Uncorr 2td p = '}, num2str(pvalue_subplot5_uncorr));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1_subplot1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2_subplot1));
    
 [p_permutation, observeddifference_permutation, effectsize_permutation] = permutationTest_V2(input1, input2, iterations, ...
          'sidedness', 'both', 'plotresult', 0, 'showprogress', 250);
    str_perm = strcat({'FlipPerm.,p='}, num2str(p_permutation), {'Efsz='}, num2str(effectsize_permutation));

    [pVal_permutationJT, effectSize_permutationJT] = bootStrapPaired_JT_V1(input1, input2, iterations);
    str_permJT = strcat({'JTperm.,p='}, num2str(pVal_permutationJT), {'Efsz='}, num2str(effectSize_permutationJT));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel, statscorrected);
    title([titletext, str, str_1 str1t_1,str1t_2,str_perm,str_permJT])
    
    
    %     AT golden ratio calculation. Change the longerside input to what is desired
    x0=10;
    y0=10;
    longersideInput = 500;
    longerside=longersideInput;
    shorterside = longerside*(61.803/100);
    height = longerside;
    width = shorterside*2;
    set(hFig,'position',[x0,y0,width,height])
    
    %
    %
    
    
    
    
    
    
    % %below saves out the figure, hopefully
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
    filename = (['/spagh2_', SNrsubtype1name, '_', subNamename, '_', meanORmedian, '_', combinedbaselineLabel]);
    if saveFig == 1
        saveas(gcf,fullfile(figuresdir, filename), 'pdf');
    end
    
    
    
    
    
    
    
end





%%
%%
%%
%%
%%
%AT below is sister plot to the above


if perChangePlot == 1  &&  ~strcmp(meanORmedian, 'intraTrialFR_mean') &&  ~strcmp(meanORmedian, 'intraTrialpercFR_mean') &&  ~strcmp(meanORmedian, 'intraTrialFR_median') &&  ~strcmp(meanORmedian, 'intraTrialpercFR_median')
    yLabel = 'Percent change in FR';
    
    %     yLabel = 'Percent change in Firing rate (Hz)';
    
    %ALL neurons, not indexing for GABA/DA
    %     subplotting = 1;
    kWidth = .5;
    figure()
    if subplotting == 1
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [.2, 0.3, .7, 0.7]);
        subplot(1, 5, 1)
    else
        figure()
    end
    subplot(1, 5, 1)
    %     subName1 = 'SG';
    epochName1 = 'priors';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    if combinedbaseline == 1
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    end
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    %meanORmedian = 'Mean_ave';
    
    
    
    %     %AT 7/21/20, below added as an example of how to reformat the baseline
    %     %calculation is 'combinedbaseline' is set to 1
    %     if strcmp(meanORmedian, 'intraTrialFR_mean') || strcmp(meanORmedian, 'intraTrialpercFR_mean') || strcmp(meanORmedian, 'intraTrialFR_median') || strcmp(meanORmedian, 'intraTrialpercFR_median')
    %         baselineFR1  = 0;
    %         baselineFR2  = 0;
    %     elseif combinedbaseline == 1 && ~strcmp(meanORmedian, 'intraTrialFR_mean') && ~strcmp(meanORmedian, 'intraTrialpercFR_mean') && ~strcmp(meanORmedian, 'intraTrialFR_median') && ~strcmp(meanORmedian, 'intraTrialpercFR_median')
    %         baselineFR1  = groupvar.(meanORmedian).(epochName).('SGandIS');
    %         baselineFR2  = baselineFR1;
    %     else
    %         baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    %         baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    %     end
    %
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = (input1-baselineFR1)./baselineFR1*100;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = (input2-baselineFR2)./baselineFR2*100;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    
    if strcmp(subName1, 'SG')
        ylim([y1lim_percSGIS y2lim_percSGIS])
    elseif strcmp(subName1, 'ipsi')
        ylim([y1lim_percipsicontra y2lim_percipsicontra])
    elseif strcmp(subName1, 'Corrects')
        ylim([y1lim_perccorrincorr y2lim_perccorrincorr])
    end
    
    xlim([ 0.6 1.4])
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    str = strcat({'2td p = '}, num2str(pvalue));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName, {' '}, combinedbaselineLabel);
    title([titletext, str, str1t_1,str1t_2])
    
    
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 2)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'sensoryProcessing';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    if combinedbaseline == 1
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    end
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    %meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = (input1-baselineFR1)./baselineFR1*100;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = (input2-baselineFR2)./baselineFR2*100;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    if strcmp(subName1, 'SG')
        ylim([y1lim_percSGIS y2lim_percSGIS])
    elseif strcmp(subName1, 'ipsi')
        ylim([y1lim_percipsicontra y2lim_percipsicontra])
    elseif strcmp(subName1, 'Corrects')
        ylim([y1lim_perccorrincorr y2lim_perccorrincorr])
    end
    
    xlim([ 0.6 1.4])
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    str = strcat({'2td p = '}, num2str(pvalue));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName);
    title([titletext, str, str1t_1,str1t_2])
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 3)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'movePrep';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    if combinedbaseline == 1
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    end
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    %meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = (input1-baselineFR1)./baselineFR1*100;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = (input2-baselineFR2)./baselineFR2*100;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    if strcmp(subName1, 'SG')
        ylim([y1lim_percSGIS y2lim_percSGIS])
    elseif strcmp(subName1, 'ipsi')
        ylim([y1lim_percipsicontra y2lim_percipsicontra])
    elseif strcmp(subName1, 'Corrects')
        ylim([y1lim_perccorrincorr y2lim_perccorrincorr])
    end
    
    xlim([ 0.6 1.4])
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    str = strcat({'2td p = '}, num2str(pvalue));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName);
    title([titletext, str, str1t_1,str1t_2])
    
    
    
    
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 4)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'moveInit';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    if combinedbaseline == 1
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    end
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    %meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = (input1-baselineFR1)./baselineFR1*100;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = (input2-baselineFR2)./baselineFR2*100;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    if strcmp(subName1, 'SG')
        ylim([y1lim_percSGIS y2lim_percSGIS])
    elseif strcmp(subName1, 'ipsi')
        ylim([y1lim_percipsicontra y2lim_percipsicontra])
    elseif strcmp(subName1, 'Corrects')
        ylim([y1lim_perccorrincorr y2lim_perccorrincorr])
    end
    
    xlim([ 0.6 1.4])
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    str = strcat({'2td p = '}, num2str(pvalue));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName);
    title([titletext, str, str1t_1,str1t_2])
    
    
    
    
    
    
    
    
    
    if subplotting == 1
        subplot(1, 5, 5)
    else
        figure()
    end
    %     subName1 = 'SG';
    epochName1 = 'periReward';
    %     SNrsubtype1 = 'All neurons';
    %     subName2 = 'IS';
    epochName2 = epochName1;
    %
    epochName = 'wholeTrial';
    baselineFR1  = (groupvar.(meanORmedian).(epochName).(subName1)(indeX));
    baselineFR2  = (groupvar.(meanORmedian).(epochName).(subName2)(indeX));
    if combinedbaseline == 1
        baselineFR1  = (groupvar.(meanORmedian).(epochName).('SGandIS')(indeX));
        baselineFR2  = baselineFR1;
    end
    % baselineFR1  = 0;
    % baselineFR2  = 0;
    
    %     meanORmedian = 'Mean_ave';
    
    input1  = (groupvar.(meanORmedian).(epochName1).(subName1)(indeX));
    % logicalinput1 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype1);
    inputinfo1 = (input1-baselineFR1)./baselineFR1*100;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    % logicalinput2 = strcmp(masterspikestruct_V2.DA_or_GABA_TSNE, SNrsubtype2);
    inputinfo2 = (input2-baselineFR2)./baselineFR2*100;
    
    %    szz = 250;
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
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
    xaxis_onPairedSG(:) = .75;
    xaxis_onPairedSG = xaxis_onPairedSG + x1;
    
    xaxis_onPairedIS = 1:(length(input2));
    xaxis_onPairedIS(:) = 1.25;
    xaxis_onPairedIS = xaxis_onPairedIS + x1;
    
    scatter(xaxis_onPairedSG(:),input1(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    hold on
    scatter(xaxis_onPairedIS(:),input2(:), szz,  [.5 .5 .5], 'filled', 'MarkerFaceAlpha', 2/8, 'MarkerEdgeAlpha', 1)
    
    hold on
    for j = 1:length(input2)
        plot1 = plot([xaxis_onPairedSG(j) xaxis_onPairedIS(j)], [input1(j)' input2(j)'], 'Color', [.5 .5 .5], 'LineWidth', 1);
        plot1.Color(4) = 3/8;
        hold on
    end
    
    hold on
    scatter(.75, mean(input1), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    hold on
    
    scatter(1.25, mean(input2), szz*2,'MarkerFaceColor', 'k','MarkerEdgeColor', 'k', 'MarkerFaceAlpha',6/8)
    
    hold on
    plot([.75 1.25], [mean(input1)  mean(input2)], 'Color', 'k', 'LineWidth', 3);
    hold on
    line([.6, 1.4],[0 0], 'Color','k', 'LineWidth', 1)
    %     line([.6, 1.4],[0 0], 'Color',[1 1 1],'LineStyle','--', 'LineWidth', 1)
    
    
    % set(gca, 'YTick', [-1 -0.5 0 0.5 1]);
    set(gca, 'XTick', [.75 1.25]);
    
    xticklabels(xTickLabels);
    ylabel(yLabel); %, 'FontSize', 14);
    
    set(gca, 'FontSize', fontSize, 'FontName', 'Georgia')
    
    if strcmp(subName1, 'SG')
        ylim([y1lim_percSGIS y2lim_percSGIS])
    elseif strcmp(subName1, 'ipsi')
        ylim([y1lim_percipsicontra y2lim_percipsicontra])
    elseif strcmp(subName1, 'Corrects')
        ylim([y1lim_perccorrincorr y2lim_perccorrincorr])
    end
    
    xlim([ 0.6 1.4])
    
    [pvalue,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    str = strcat({'2td p = '}, num2str(pvalue));
    
    str1t_1 = strcat({'Lft, comp to 0, p = '}, num2str(pvalueinfo1));
    str1t_2 = strcat({'Rgt, comp to 0, p = '}, num2str(pvalueinfo2));
    
    titletext = strcat(SNrsubtype1, {' '}, epochName1,{' - '}, epochName);
    title([titletext, str, str1t_1,str1t_2])
    
    
    
    % %below saves out the figure, hopefully
    figuresdir = fullfile('/Users','andytek','Box','Auditory_task_SNr','Data','generated_analyses','epochs_FR_analysis'); %set this to be 1,2, or 3; note that only a few of the spike recordings are multi-cluster
    filename = (['/spagh2_PERCchange_', SNrsubtype1name, '_', subNamename, '_', meanORmedian]);
    if saveFig == 1
        saveas(gcf,fullfile(figuresdir, filename), 'jpeg');
    end
    
    
    
    
    
    
    
    
end



%%
%%
%AT adding below plot for the percFR calculations









































%do some analysises




    function [pvalue,outcome,paraORnonpara] = stats_subfx1tailed(stats_subfx1tailedinput1,stats_subfx1tailedinput2)
        
        
        
        hx_input1 = lillietest(stats_subfx1tailedinput1);
        hx_input2 = lillietest(stats_subfx1tailedinput2);
        input2_lessthan_input1 = [];
        input2_greaterthan_input1 = [];
        if hx_input1 == 0 && hx_input2 == 0
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_greaterthan_input1 = 1;
                outcome = 'input2_greaterthan_input1';
            end
            [h_ttest, p_ttest] = ttest2(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
            end
            pvalue = p_ttest;
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
                
            end
            [p_ttest1, h_ttest1] = ranksum(stats_subfx1tailedinput1, stats_subfx1tailedinput2, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
            if h_ttest1 == 1
                input2_lessthan_input1 = 1;
                outcome = 'input2_lessthan_input1';
                
            end
            pvalue = p_ttest1;
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
