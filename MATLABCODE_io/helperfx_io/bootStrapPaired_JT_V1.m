function [pVal, effectSize] = bootStrapPaired_JT_V1(group1, group2, perMNum)
% Paired data mean difference bootstrap
%%% Fraction of sample set to 20% or 0.2;
fractionToTest = 0.4;
%%% EXAMPLE input:
%%% [p, effect] = bootStrapPaired(SG, IS, 1000)


% Actual mean difference between groups
meanDiff = mean(group1 - group2);



% Distribution of difference permutations
diffDistM = zeros(perMNum,1);
allMean1 = zeros(perMNum,1);
allMean2 = zeros(perMNum,1);

for ii = 1:perMNum
    
    % Random sample of indices from data
    tmpPerm = randperm(length(group1),round(length(group1)*fractionToTest));
    
    % Mean difference of random sample
    meanDi = mean(group1(tmpPerm) - group2(tmpPerm));
    
    % Mean of group 1
    allMean1(ii) = mean(group1(tmpPerm));
    % Mean of group 2
    allMean2(ii) = mean(group2(tmpPerm));

    % Add to distribution
    diffDistM(ii) = meanDi;
    
end

% histogram(diffDistM)
% 
% hold on
% 
% line([meanDiff meanDiff] , [0 150], 'Color','k', 'LineWidth',3)

pVal = sum((diffDistM < meanDiff))/numel(diffDistM);
    
% SD pool
sd1 = std(allMean1);
sd2 = std(allMean2);
sdPool = sqrt(((sd1^2) + (sd2^2))/2);
effectSize = (mean(diffDistM))/sdPool;



