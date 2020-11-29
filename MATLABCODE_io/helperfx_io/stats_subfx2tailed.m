
function [pvalue,paraORnonpara] = stats_subfx2tailed(input1_stats_subfx2tailed,input2_stats_subfx2tailed, pairedORnotpaired)


hx_input1 = lillietest(input1_stats_subfx2tailed);
hx_input2 = lillietest(input2_stats_subfx2tailed);
input2_lessthan_input1 = [];
input2_greaterthan_input1 = [];
if hx_input1 == 0 && hx_input2 == 0
    [h_ttest1, p_ttest1] = ttest2(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
    
    paraORnonpara = 'para';
    %below is paired
    if strcmp(pairedORnotpaired, 'paired')
        [h_ttest11, p_ttest11] = ttest(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
    end
    
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
    if strcmp(pairedORnotpaired, 'paired')
        [p_ttest22, h_ttest22] = signrank(input1_stats_subfx2tailed, input2_stats_subfx2tailed) ; %'left' tests the hypothesis that x2 > x1
    end
    if strcmp(pairedORnotpaired, 'notpaired')
        pvalue = p_ttest2;
    elseif strcmp(pairedORnotpaired, 'paired')
        pvalue = p_ttest22;
    end
end


end

