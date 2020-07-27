function motulsky(dat)
% replicate figure 5 from Motulsky's 2014 paper
% I've added a percentile bootstrap CI + reference line, which shows
% that mean +/- SEM does not include the median.
% Common Misconceptions about Data Analysis and Statistics
% http://www.ncbi.nlm.nih.gov/pubmed/25204545

% motulsky(dat,q1dat,q2dat,q3dat,mdat,sddat,CI,bootCI,semdat,mindat,maxdat)

% compute summary statistics >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
alpha = 0.05;
nobs = numel(dat); % number of observations
mdat = mean(dat);
y = prctile(dat,[25 50 75]);
q1dat = y(1); % 1st quartile
q2dat = y(2); % median
q3dat = y(3); % 3rd quartile
sddat = std(dat); % standard deviation
semdat = std(dat) / sqrt(nobs); % standard error of the mean

[H,P,CI,STATS] = ttest(dat,alpha); % classic 95% confidence interval
% using the formula instead:
% df = nobs-1;
% CI(1) = mean(dat) + tinv(.025,df) .* std(dat)./sqrt(nobs); % tinv = inverse Student's T cdf
% CI(2) = mean(dat) - tinv(.025,df) .* std(dat)./sqrt(nobs);

mindat = min(dat);
maxdat = max(dat);

Nb = 1000;
est = 'mean';
[BEST,EST,bootCI,p] = pbci(dat,Nb,alpha,est);

% figure >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure('Color','w','NumberTitle','off')
hold on

% scatter + median
%add jitter to x-axis:
xpts = UnivarScatter_nofig(dat);
scatter(xpts,dat,70,'k','filled')
plot([0.6 1.4],[q2dat q2dat],'Color',[0 0 0],'LineWidth',2)
plot([0 8],[q2dat q2dat],'Color',[0 0 0],'LineWidth',1,'LineStyle',':')

% boxplot - by hand! (no outlier flagged)
plot([1.7 2.3],[q1dat q1dat],'k','LineWidth',2) % 1st quartile
plot([1.7 2.3],[q2dat q2dat],'k','LineWidth',2) % 2nd quartile
plot([1.7 2.3],[q3dat q3dat],'k','LineWidth',2) % 3rd quartile
plot([1.7 1.7],[q1dat q3dat],'k','LineWidth',2) % box
plot([2.3 2.3],[q1dat q3dat],'k','LineWidth',2)
plot([2 2],[q3dat maxdat],'k','LineWidth',2) % whisker 1
plot([1.9 2.1],[maxdat maxdat],'k','LineWidth',2)
plot([2 2],[mindat q1dat],'k','LineWidth',2) % whisker 2
plot([1.9 2.1],[mindat mindat],'k','LineWidth',2)

% quartiles
plot(3,q2dat,'ko','MarkerSize',10,'MarkerFaceColor','k')
plot([3 3],[q2dat q3dat],'k','LineWidth',2) % whisker 1
plot([2.9 3.1],[q3dat q3dat],'k','LineWidth',2)
plot([3 3],[q1dat q2dat],'k','LineWidth',2) % whisker 2
plot([2.9 3.1],[q1dat q1dat],'k','LineWidth',2)

% mean +/- SD
plot(4,mdat,'ko','MarkerSize',10,'MarkerFaceColor','k')
plot([4 4],[mdat mdat+sddat],'k','LineWidth',2) % whisker 1
plot([3.9 4.1],[mdat+sddat mdat+sddat],'k','LineWidth',2)
plot([4 4],[mdat mdat-sddat],'k','LineWidth',2) % whisker 2
plot([3.9 4.1],[mdat-sddat mdat-sddat],'k','LineWidth',2)

% mean with CI
plot(5,mdat,'ko','MarkerSize',10,'MarkerFaceColor','k')
plot([5 5],[mdat CI(2)],'k','LineWidth',2) % whisker 1
plot([4.9 5.1],[CI(2) CI(2)],'k','LineWidth',2)
plot([5 5],[mdat CI(1)],'k','LineWidth',2) % whisker 2
plot([4.9 5.1],[CI(1) CI(1)],'k','LineWidth',2)

% mean with bootCI
plot(6,mdat,'ko','MarkerSize',10,'MarkerFaceColor','k')
plot([6 6],[mdat bootCI(2)],'k','LineWidth',2) % whisker 1
plot([5.9 6.1],[bootCI(2) bootCI(2)],'k','LineWidth',2)
plot([6 6],[mdat bootCI(1)],'k','LineWidth',2) % whisker 2
plot([5.9 6.1],[bootCI(1) bootCI(1)],'k','LineWidth',2)

% mean +/- SEM
plot(7,mdat,'ko','MarkerSize',10,'MarkerFaceColor','k')
plot([7 7],[mdat mdat+semdat],'k','LineWidth',2) % whisker 1
plot([6.9 7.1],[mdat+semdat mdat+semdat],'k','LineWidth',2)
plot([7 7],[mdat mdat-semdat],'k','LineWidth',2) % whisker 2
plot([6.9 7.1],[mdat-semdat mdat-semdat],'k','LineWidth',2)

set(gca,'XLim',[0 8],'FontSize',14)
box on

labels = {'Scatter';'Box & whiskers';'Quartiles';'Mean +/- SD';...
    'Mean with CI';'Mean with bootCI';'Mean +/- SEM'};
set(gca,'XTick',1:7,'XTickLabel',labels,'XTickLabelRotation',45)