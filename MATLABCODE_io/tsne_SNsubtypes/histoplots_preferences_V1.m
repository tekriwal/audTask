%

function [] = histoplots_preferences_V1(input1_pref, input1_rp, input2_pref, input2_rp )





input1_pref_i = 1;
input1_sigpref = [];
for ii = 1:length(input1_pref)
    if input1_rp(ii) < 0.05
        input1_sigpref(input1_pref_i) = input1_pref(ii);
        input1_pref_i = input1_pref_i + 1;
    end
end

input2_pref_i = 1;
input2_sigpref = [];
for ii = 1:length(input2_pref)
    if input2_rp(ii) < 0.05
        input2_sigpref(input2_pref_i) = input2_pref(ii);
        input2_pref_i = input2_pref_i + 1;
    end
end


%little aside here for plotting the pref histograms input1
prefs = input1_pref;
prefs_sig = input1_sigpref;
%AT 3/11/20; for numbers to be used in text
figure()

% x = -1:0.2:1;
x = linspace(-1, 1, 20);
[n1, xout1] = hist(prefs,x);
if ~isempty(input1_sigpref)
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
if ~isempty(input1_sigpref)
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
title(strcat('input1, '))

set(gca,'XTick',[-1.0 0 1.0])
set(gca,'YTick',[0,2,4,6,8,10,12,14,16])
ylim([0,16])




%little aside here for plotting the pref histograms input2
prefs = input2_pref;
prefs_sig = input2_sigpref;
%AT 3/11/20; for numbers to be used in text
figure()

x = linspace(-1, 1, 20);
[n1, xout1] = hist(prefs,x);
if ~isempty(input2_sigpref)
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
if ~isempty(input2_sigpref)
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
title(strcat('input2, '))

set(gca,'XTick',[-1.0 0 1.0])
set(gca,'YTick',[0,2,4,6,8,10,12,14,16])
ylim([0,16])







input2_lill = lillietest(input2_pref);
input1_lill = lillietest(input1_pref);

if input2_lill == 0 && input1_lill == 0
    [h_ttest01, p_ttest01] = ttest2(input2_pref, input1_pref, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    
    [h_ttest02, p_ttest02] = ttest2(input2_pref, input1_pref, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    
elseif input2_lill == 1 || input1_lill == 1
    %for ranksum....
    % H=0 indicates that
    %   the null hypothesis ("medians are equal") cannot be rejected at the 5%
    %   level. H=1 indicates that the null hypothesis can be rejected at the
    %   5% level
    [p_ttest1, h_ttest1] = ranksum(input2_pref, input1_pref, 'Tail', 'left') ; %'left' tests the hypothesis that x2 > x1
    [p_ttest2, h_ttest2] = ranksum(input2_pref, input1_pref, 'Tail', 'right') ; %'left' tests the hypothesis that x2 > x1
    
end
[p_ttest_histo, h_ttest_histo] = ranksum(input2_pref, input1_pref) ; %'left' tests the hypothesis that x2 > x1
% Test the null hypothesis that data in vectors x1 and x2 comes from populations with the same distribution.
% The returned value of h = 1 indicates that kstest rejects the null hypothesis at the default 5% significance level.
[h,p,k] = kstest2(input2_pref,input1_pref);
%below shift fx comparison describes how hemiPD relates to control deciles.
[xd, yd, delta, deltaCI] = shifthd_AT( input1_pref, 'input1_pref, general pref', input2_pref, 'input2_pref, general pref', 200, 1);












end