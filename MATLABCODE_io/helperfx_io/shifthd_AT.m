%6/13/19
%[xd, yd, delta, deltaCI] = shifthd_AT(control_ISpref, 'IS control', hemiPD_ISpref, 'IS hemiPD', 200, 1)
%[xd, yd, delta, deltaCI] = shifthd_AT(control_SGpref, 'SG control', hemiPD_SGpref, 'SG hemiPD', 200, 1)



% [xd, yd, delta, deltaCI] = shifthd_AT(ISprefvalues_control, 'IS control', ISprefvalues_hemiPD_IDLR, 'IS hemiPD', 200, 1);
% [xd, yd, delta, deltaCI] = shifthd_AT(SGprefvalues_control, 'SG control',SGprefvalues_hemipd_IDLR, 'SG hemiPD',200, 1);


% %AT - from webpage: The shift function describes how one distribution should be re-arranged
% to match the other one: it estimates how and by how much one distribution
% must be shifted.

% AT - So when we're looking at the shift plots, one thing to look for is whether
%'0' falls outside of the error for a decile. Another thing to look at is
%the way the plot changes from one decile to another decile. This can
%provide information about the distribution. 

function [xd, yd, delta, deltaCI] = shifthd_AT(x,x1,y,y1,nboot,plotit)
% [xd yd delta deltaCI] = shifthd(x,y,nboot,plotshift)
% SHIFTHD computes the 95% simultaneous confidence intervals
% for the difference between the deciles of two independent groups
% using the Harrell-Davis quantile estimator, in conjunction with
% percentile bootstrap estimation of the quantiles' standard errors.
% See Wilcox Robust hypothesis testing book 2005 p.151-155
%
% INPUTS:
% - x & y are two vectors without missing values
% - nboot = number of bootstrap samples - default = 200
% - plotit = 1 to get a figure; 0 otherwise by default
%
% OUTPUTS:
% - xd & yd = vectors of quantiles
    %AT 1/16/19 - so xd and yd are nine data points that split either xd or
    %yd into deciles (ten equal portions). The reason these data points are
    %used is that it provides a relatively rich way to descript the overall
    %distribution
    
% - delta = vector of differences between quantiles (xd(i)-yd(i))

% - deltaCI = matrix quantiles x low/high bounds of the confidence
% intervals of the quantile differences
    %AT 1/16/19 - so if you take the average of deltaCI(:,1), it will equal
    %the value in delta(1). The difference between deltaCI(i,1) and
    %deltaCI(i,2) will be greater when there is a larger difference between
    %the values xd(i) and yd(i) - this should make sense.
    %AT 1/16/19 delta CI is computed by randomly sampling from the distribution 
    %'nboot' number of times to create a library of responses. The variance for 
    % each x and y  library are then summed, follwed by taking its square root, 'sqrt_var_sum'. 
    %The actual value seen in the deltaCI output is the result of taking
    %the mean and adding or subtracting the sqrt_var_sum
%
% Tied values are not allowed.
% If tied values occur, or if you want to estimate quantiles other than the deciles,
% or if you want to use an alpha other than 0.05, use SHIFTHD_PBCI instead.
%
% Adaptation of Rand Wilcox's shifthd R function,
% http://dornsife.usc.edu/labs/rwilcox/software/
%
% See also HD, SHIFTDHD, SHIFTHD_PBCI

% Copyright (C) 2007, 2013, 2016 Guillaume Rousselet - University of Glasgow
% GAR, University of Glasgow, Dec 2007
% GAR, April 2013: replace randsample with randi
% GAR, June 2013: added list option
% GAR, 29 May 2016: removed call to bootse, removed list option and fixed bootstrap sampling error -
%                   use independent bootstrap sample for each decile.
% GAR, 17 Jun 2016: edited help for github release

if nargin < 3;nboot=200;end
if nargin < 4;plotit=0;end

nx=length(x);
ny=length(y);
n=min(nx,ny);
c=(80.1./n.^2)+2.73; % The constant c was determined so that the simultaneous
% probability coverage of all 9 differences is
% approximately 95% when sampling from normal
% distributions

xd = zeros(9,1);
yd = zeros(9,1);
delta = zeros(9,1);
deltaCI = zeros(9,2);

for d = 1:9

    q = d./10;
    xd(d) = hd(x,q);
    yd(d) = hd(y,q);

    xboot = zeros(nboot,1);
    yboot = zeros(nboot,1);
    xlist = randi(nx,nboot,nx);
    ylist = randi(ny,nboot,ny);

    % Get a different set of bootstrap samples for each decile
    % and each group; AT -  Harrell-Davis estimate of the qth quantile
    for B = 1:nboot
        xboot(B) = hd(x(xlist(B,:)),q);
        yboot(B) = hd(y(ylist(B,:)),q);
    end

    sqrt_var_sum = sqrt( var(xboot) + var(yboot) );
    delta(d) = xd(d)-yd(d);
    deltaCI(d,1) = delta(d)-c.*sqrt_var_sum;
    deltaCI(d,2) = delta(d)+c.*sqrt_var_sum;
end

if plotit==1

    figure();hold on

    ext = 0.1*(max(xd)-min(xd));
    plot([min(xd)-ext max(xd)+ext],[0 0],'LineWidth',1,'Color',[.5 .5 .5]) % zero line
    for qi = 1:9
       plot([xd(qi) xd(qi)],[deltaCI(qi,1) deltaCI(qi,2)],'k','LineWidth',2)
    end
    % mark median
    v = axis;plot([xd(5) xd(5)],[v(3) v(4)],'k:')
    plot(xd,delta,'ko-','MarkerFaceColor',[.9 .9 .9],'MarkerSize',10,'LineWidth',1)
    set(gca,'FontSize',14,'XLim',[min(xd)-ext max(xd)+ext])
    box on
    xlabel([ x1,' quantiles'],'FontSize',16)
    ylabel([x1, ' - ', y1 ,' quantiles'],'FontSize',16)
    
    
    title([x1, ' compared to ', y1],'FontSize',16)
%   saveas(gcf,[x1, 'shift_plot', y1,'.jpg'])

%AT 6/13/19 below plots the swarm distribution and all
shift_fig(xd, yd, delta, deltaCI,x,x1, y, y1,1,5)

% diffall_asym

end
end
% Data from Wilcox 2005 p.150
% control=[41 38.4 24.4 25.9 21.9 18.3 13.1 27.3 28.5 -16.9 26 17.4 21.8 15.4 27.4 19.2 22.4 17.7 26 29.4 21.4 26.6 22.7];
% ozone=[10.1 6.1 20.4 7.3 14.3 15.5 -9.9 6.8 28.2 17.9 -9 -12.9 14 6.6 12.1 15.7 39.9 -15.9 54.6 -14.7 44.1 -9];
