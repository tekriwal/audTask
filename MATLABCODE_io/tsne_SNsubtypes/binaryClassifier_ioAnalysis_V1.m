function [h,p,k,DANn_pref,DANn_rp, GABA_pref, GABA_rp] = binaryClassifier_ioAnalysis_V1(subName2, factor1, factor2, masterspikestruct_V2)



num_iter = 200;
% subName2 = 'periReward';
% factor1 = 'Corrects';
% factor2 = 'Incorrects';
% %more complicated than initially thought, see below:
GABA_i = 1;
DANn_i = 1;
for i = 1:length(masterspikestruct_V2.clustfileIndex)
    
    structLabel = masterspikestruct_V2.clustfileIndex{i};
    
    input1 = masterspikestruct_V2.FRstruct.(structLabel).(subName2).(factor1);
    input2 = masterspikestruct_V2.FRstruct.(structLabel).(subName2).(factor2);
    
%     if strcmp(factor1,'SGipsi') || strcmp(factor1,'ISipsi') || strcmp(factor1,'SGcontra') || strcmp(factor1,'IScontra')
%         [pref, rp] = ROC_preference(input1', input2', num_iter); % Calls new ROC function
%     else
        [pref, rp] = ROC_preference(cell2mat(input1'), cell2mat(input2'), num_iter); % Calls new ROC function
%     end
    
    if strcmp(masterspikestruct_V2.DA_or_GABA_TSNE{i}, 'GABA')
        
        GABA_pref(GABA_i) = pref;
        GABA_rp(GABA_i) = rp;
        GABA_i = 1 + GABA_i;
        
    elseif strcmp(masterspikestruct_V2.DA_or_GABA_TSNE{i}, 'DANn')
        
        DANn_pref(DANn_i) = pref;
        DANn_rp(DANn_i) = rp;
        DANn_i = 1 +  DANn_i;
        
    end
end

GABA_pref_i = 1;
GABA_sigpref = [];
for ii = 1:length(GABA_pref)
    if GABA_rp(ii) < 0.05
        GABA_sigpref(GABA_pref_i) = GABA_pref(ii);
        GABA_pref_i = GABA_pref_i + 1;
    end
end

DANn_pref_i = 1;
DANn_sigpref = [];
for ii = 1:length(DANn_pref)
    if DANn_rp(ii) < 0.05
        DANn_sigpref(DANn_pref_i) = DANn_pref(ii);
        DANn_pref_i = DANn_pref_i + 1;
    end
end


%little aside here for plotting the pref histograms GABA
prefs = GABA_pref;
prefs_sig = GABA_sigpref;
%AT 3/11/20; for numbers to be used in text
figure()

% x = -1:0.2:1;
x = linspace(-1, 1, 20);
[n1, xout1] = hist(prefs,x);
if ~isempty(GABA_sigpref)
    pref_sig_ipsi = prefs_sig(prefs_sig<0);
    pref_sig_contra = prefs_sig(prefs_sig>0);
    [n2, xout2] = hist(pref_sig_ipsi,x);
    [n3, xout3] = hist(pref_sig_contra,x);
    %AT 9/22/19 - we want to plot all the neurons as grey first and then fill
    %in with other colors
    ngrey = n1+n2+n3;
else
    ngrey = n1;
end
h1 = axes;
bar1 = bar(xout1, ngrey);
set(bar1,'FaceColor',[.5 .5 .5],'EdgeColor','k')
hold on
if ~isempty(GABA_sigpref)
    bar2 = bar(xout2, n2);
    set(bar2,'FaceColor','b','EdgeColor','k')
    hold on
    bar3 = bar(xout3, n3);
    set(bar2,'FaceColor','r','EdgeColor','k')
    % axis([-1 1 0 15])
end
set(gca, 'Box', 'off');
xlabel('Preference', 'FontName', 'Georgia');
ylabel('Number of neurons', 'FontName', 'Georgia');
title(strcat('GABA, ', subName2))

set(gca,'XTick',[-1.0 0 1.0])
set(gca,'YTick',[0,2,4,6,8,10,12,14,16])
ylim([0,16])




%little aside here for plotting the pref histograms DANn
prefs = DANn_pref;
prefs_sig = DANn_sigpref;
%AT 3/11/20; for numbers to be used in text
figure()

x = linspace(-1, 1, 20);
[n1, xout1] = hist(prefs,x);
if ~isempty(DANn_sigpref)
    pref_sig_ipsi = prefs_sig(prefs_sig<0);
    pref_sig_contra = prefs_sig(prefs_sig>0);
    [n2, xout2] = hist(pref_sig_ipsi,x);
    [n3, xout3] = hist(pref_sig_contra,x);
    %AT 9/22/19 - we want to plot all the neurons as grey first and then fill
    %in with other colors
    ngrey = n1+n2+n3;
else
    ngrey = n1;
end
h1 = axes;
bar1 = bar(xout1, ngrey);
set(bar1,'FaceColor',[.5 .5 .5],'EdgeColor','k')
hold on
if ~isempty(DANn_sigpref)
    bar2 = bar(xout2, n2);
    set(bar2,'FaceColor','b','EdgeColor','k')
    hold on
    bar3 = bar(xout3, n3);
    set(bar2,'FaceColor','r','EdgeColor','k')
    % axis([-1 1 0 15])
end
set(gca, 'Box', 'off');
xlabel('Preference', 'FontName', 'Georgia');
ylabel('Number of neurons', 'FontName', 'Georgia');
title(strcat('DANn, ', subName2))

set(gca,'XTick',[-1.0 0 1.0])
set(gca,'YTick',[0,2,4,6,8,10,12,14,16])
ylim([0,16])







DANn_lill = lillietest(DANn_pref);
GABA_lill = lillietest(GABA_pref);

if DANn_lill == 0 && GABA_lill == 0
    [h_ttest01, p_ttest01] = ttest2(DANn_pref, GABA_pref, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    
    [h_ttest02, p_ttest02] = ttest2(DANn_pref, GABA_pref, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    
elseif DANn_lill == 1 || GABA_lill == 1
    %for ranksum....
    % H=0 indicates that
    %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
    %   level. H=1 indicates that the null hypothesis can be rejected at the
    %   5% level
    [p_ttest1, h_ttest1] = ranksum(DANn_pref, GABA_pref, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    [p_ttest2, h_ttest2] = ranksum(DANn_pref, GABA_pref, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    
end
[p_ttest_histo, h_ttest_histo] = ranksum(DANn_pref, GABA_pref) ; %'left' tests the hypothesis that x2 > x1
% Test the null hypothesis that data in vectors x1 and x2 comes from populations with the same distribution.
% The returned value of h = 1 indicates that kstest rejects the null hypothesis at the default 5% significance level.
[h,p,k] = kstest2(DANn_pref,GABA_pref);
%below shift fx comparison describes how hemiPD relates to control deciles.
[xd, yd, delta, deltaCI] = shifthd_AT( GABA_pref, strcat('GABA_pref, ', subName2), DANn_pref, strcat('DANn_pref, ', subName2), 200, 1);








end