% 1 = left
% 2 = right


% 1 L
% 2 L
% 3 rand
% 4 R
% 5 R

% Block = 9 trials






%%
function [] = analyzeAdata(Dfile)

load(Dfile)

respT = [rData.rtime];
newS = reshape(respT,16,9);

sG = newS(1:2:16,:);
iG = newS(2:2:16,:);

msG = mean(sG);
miG = mean(iG);

plot(msG,'Color','k','LineWidth',3)
hold on
plot(miG,'Color','r','LineWidth',3)

legend('SG','IG')


end