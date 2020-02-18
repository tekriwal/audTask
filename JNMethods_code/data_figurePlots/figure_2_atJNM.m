function [] = figure_2_atJNM(fName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
% Example: figure_2_atJNM('AT_Oct20.mat')


load(fName , 'rData')

rTime = [rData.rtime];

rTimeMat = reshape(rTime,16,9);

xAxS = 1:9;
plotCell = cell(16,1);
mTpoints = zeros(1,16);
for ri = 1:16
    y = rTimeMat(ri,:);
    hold on
    if mod(ri,2) ~= 0
%         plot(xAxS, y,'o','MarkerFaceColor','k','MarkerEdgeColor','k')
        p = polyfit(xAxS,rTimeMat(ri,:),1);
        y1 = polyval(p,xAxS);
        
        yy2 = smooth(xAxS,y,0.75,'rloess');
        plotCell{ri} = plot(xAxS , yy2 , 'k-');
        line([min(xAxS) max(xAxS)],[y1(1) y1(length(y1))],'Color','k',...
            'LineStyle',':','LineWidth',2.5)
        
        mTpoints(ri) = median(xAxS);
        
        xAxS = xAxS + 10;
    else
%         plot(xAxS, y,'o','MarkerFaceColor','r','MarkerEdgeColor','r')
        p = polyfit(xAxS,rTimeMat(ri,:),1);
        y1 = polyval(p,xAxS);
        
        yy2 = smooth(xAxS,y,0.75,'rloess');
        plotCell{ri} = plot(xAxS , yy2 , 'r-');
        line([min(xAxS) max(xAxS)],[y1(1) y1(length(y1))],'Color','r',...
            'LineStyle',':','LineWidth',2.5)
        
        mTpoints(ri) = median(xAxS);
        
        xAxS = xAxS + 10;
    end
 
end

yVals = get(gca,'YTick');
yticks([min(yVals) max(yVals)/2 max(yVals)]);
ylabel('Reaction time (seconds)')

xticks(mTpoints);
xticklabels(cellfun(@(x) ['T' , num2str(x)] , num2cell(1:16),'UniformOutput',false))
xlabel('Trial #')
title('Summary of Reaction Times Across Full Session')
legend([plotCell{1} , plotCell{2}],'SG','IG');

set(gcf,'Position',[519 316 932 420])

end

