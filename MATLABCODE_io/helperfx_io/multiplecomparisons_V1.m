%AT V1 on 9/14/20, point is to create fx that will run multiple comparisons as needed for the spaghettiplot fxz.
%note that the first three outputs are the corrected output while the
%latter 3 are the noncorrect outputs

function [c_pvalues_2tailed, c_pvalues_lft1tailed, c_pvalues_rt1tailed, pvalues_2tailed, pvalues_lft1tailed, pvalues_rt1tailed] = multiplecomparisons_V1(groupvar, meanORmedian, subName1, subName2, indeX)


epochName1 = 'priors';
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

    input1 = inputinfo1;
    input2 = inputinfo2;
    
    
    [pvalue_subplot1,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot1,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot1,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    

    
    
    
    

    epochName1 = 'sensoryProcessing';
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

    
    input1 = inputinfo1;
    input2 = inputinfo2;
    %     yLabel = 'Firing rate (Hz)';
   
    
    [pvalue_subplot2,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot2,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot2,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    

     
    
    
    
    
    
    
    
    
    
    
    
    epochName1 = 'movePrep';
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
    inputinfo1 = input1 - baselineFR1;
    
    input2  = (groupvar.(meanORmedian).(epochName2).(subName2)(indeX));
    inputinfo2 = input2 - baselineFR2;

    input1 = inputinfo1;
    input2 = inputinfo2;

  
    [pvalue_subplot3,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot3,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot3,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);

     
    
    
    
    
    
    
    
    
    
    epochName1 = 'moveInit';
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

    input1 = inputinfo1;
    input2 = inputinfo2;
    
    [pvalue_subplot4,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot4,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot4,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
     
    
    
    
    
    
    
    
    epochName1 = 'periReward';
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
    
    input1 = inputinfo1;
    input2 = inputinfo2;
    
    [pvalue_subplot5,paraORnonpara] = stats_subfx2tailed(input1,input2, 'paired');
    
    [pvalueinfo1_subplot5,outcomeinfo1,paraORnonparainfo1] = stats_subfx_compToZero(input1);
    [pvalueinfo2_subplot5,outcomeinfo2,paraORnonparainfo2] = stats_subfx_compToZero(input2);
    
    
    
    
    
    
    
    %AT below is for the multiple comparisons now.
    
    %2 tailed input
    pvalues_2tailed = [pvalue_subplot1,pvalue_subplot2,pvalue_subplot3,pvalue_subplot4,pvalue_subplot5]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
    alpha = 0.05;
    plotting = false;
    [c_pvalues_2tailed, c_alpha_2tailed, h_2tailed, extra_2tailed] = fdr_BH(pvalues_2tailed, alpha, plotting);


    %1 tailed input for left side
    pvalues_lft1tailed = [pvalueinfo1_subplot1,pvalueinfo1_subplot2,pvalueinfo1_subplot3,pvalueinfo1_subplot4,pvalueinfo1_subplot5]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
    alpha = 0.05;
    plotting = false;
    [c_pvalues_lft1tailed, c_alpha_lft1tailed, h_lft1tailed, extra_lft1tailed] = fdr_BH(pvalues_lft1tailed, alpha, plotting);


    %1 tailed input for right side
    pvalues_rt1tailed = [pvalueinfo2_subplot1,pvalueinfo2_subplot2,pvalueinfo2_subplot3,pvalueinfo2_subplot4,pvalueinfo2_subplot5]; %need to input pvalues for the tests we're interested in comparing (for us, theres 3 p values per epoch).
    alpha = 0.05;
    plotting = false;
    [c_pvalues_rt1tailed, c_alpha_rt1tailed, h_rt1tailed, extra_rt1tailed] = fdr_BH(pvalues_rt1tailed, alpha, plotting);


    
    
    
end
    