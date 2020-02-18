function [] = create_Fig3_Tekriwal_method_v1(FigureNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


switch FigureNum
    case 1
        
        [trialHSI1 , correctSI1] = getPsyData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData',1);
        [trialHSI2 , correctSI2] = getPsyData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4',1);
        
        trialHSI = [trialHSI1 ; trialHSI2];
        correctSI = [correctSI1 ; correctSI2];
        
        [percent_L , xAxisM , y_fit , x_axis] = derivePsyAve(trialHSI , correctSI);
        
        figure;
        p = plot(xAxisM, percent_L, 'ko');
        set(p, 'MarkerFaceColor', 'k', 'MarkerSize', 10);
        hold on
        % the fit
        p = plot(x_axis, y_fit, 'k');
        set(p, 'LineWidth', 2);
        ylim([-0.1 1.1])
        yticks([0 0.5 1])
        ylabel('Fraction of left choices');
        xlim([0.9 5.1])
        xticks([1 2 3 4 5])
        xticklabels([130.8 233 261.6 293 523])
        xlabel('Frequency of tone (Hz)')
        
        axis square
        
    case 2
        
        [analysismatrix1 , ~] = getBehData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData');
        [analysismatrix2 , ~] = getBehData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4');
        
        blockNum = 9;
        
        [oMeanBl , eMeanBl , oy1 , ox1 , ey1 , ex1] = getScatData(analysismatrix1 , blockNum);
        [oMeanB2 , eMeanB2 , oy2 , ox2 , ey2 , ex2] = getScatData(analysismatrix2 , blockNum);
        
        oddSBx = [ox1 ; ox2];
        oddSBy = [oy1 ; oy2];
        evenSBx = [ex1 ; ex2];
        evenSBy = [ey1 ; ey2];
        
        odds_meanperblock = mean([oMeanBl ; oMeanB2]);
        evens_meanperblock = mean([eMeanBl ; eMeanB2]);
        
        figure
        
        hold on
        scatter(oddSBx , oddSBy , 15 , [0 0 0])
        scatter(evenSBx , evenSBy , 15 , [1 0 0])
        
        line([(1:2:blockNum)-0.4 ; (1:2:blockNum)+0.4] , [odds_meanperblock ; odds_meanperblock],...
            'Color' , [0 0 0] , 'LineWidth' , 2)
        
        line([(2:2:blockNum)-0.4 ; (2:2:blockNum)+0.4] , [evens_meanperblock ; evens_meanperblock],...
            'Color' , [1 0 0] , 'LineWidth' , 2)
        xlim([0 blockNum+1])
        xticks(1:1:blockNum)
        axis square
        yVals = get(gca,'YTick');
        ylim([0 max(yVals)]);
        yticks([0 round(max(yVals)/2,2), max(yVals)])
        title('Reaction time by block')
        ylabel('Reaction time (seconds)')
        xlabel('Block #')
        axis square
        
    case 3
        
        [analysismatrix1 , ~] = getBehData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData');
        [analysismatrix2 , ~] = getBehData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4');
        
        figure
        
        blockNum = 9;
        
        [~ , ~ , oy1 , ~ , ey1 , ~] = getScatData(analysismatrix1 , blockNum);
        [~ , ~ , oy2 , ~ , ey2 , ~] = getScatData(analysismatrix2 , blockNum);
        
        odds_mean = nanmean([oy1 ; oy2]);
        odds_std = nanstd([oy1 ; oy2]);
        
        evens_mean = nanmean([ey1 ; ey2]);
        evens_std = nanstd([ey1 ; ey2]);
        
        %         [mean_odds_meanperblock , mean_evens_meanperblock , std_odds1 ,std_evens1] = getBarData(odds_meanperblock , evens_meanperblock);
        
        c = bar([odds_mean;evens_mean]);
        hold on
        errorbar([odds_mean;evens_mean],...
            [odds_std;evens_std])
        c.FaceColor = 'flat';
        c.CData(1,:) = [0 0 0];%makes the odds average purple
        c.CData(2,:) = [1 0 0];%makes the odds average purple
        title('Reaction time by block type')
        ylabel('Reaction time (seconds)')
        xticks([1 2])
        xticklabels({'SG','IS'})
        yVals = get(gca,'YTick');
        ylim([0 max(yVals)]);
        yticks([0 round(max(yVals)/2,2), max(yVals)])
        
        axis square
        
    case 4
        
        [~ , correctSI1] = getPsyData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData',0);
        [~ , correctSI2] = getPsyData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4',0);
        
        %         trialH = [reshape(trialHSI1,9,4) , reshape(trialHSI2,9,4)];
        correctSI = [reshape(correctSI1,9,4) , reshape(correctSI2,9,4)];
        
        leftBlocks = correctSI(:,[1 3 5 7]);
        rightBlocks = correctSI(:,[2 4 6 8]);
        
        leftFracC = sum(leftBlocks,2)/4;
        rightFracC = sum(rightBlocks,2)/4;
        
        leftMean = zeros(2,1);
        rightMean = zeros(2,1);
        F = [1 , 5];
        L = [4 , 9];
        for mi = 1:2
            
            leftMean(mi) = mean(leftFracC(F(mi):L(mi)));
            rightMean(mi) = mean(rightFracC(F(mi):L(mi)));
            
        end
        
        %         hold on
        %         plot(leftFracC,'b-')
        %         plot(1-rightFracC,'g-')
        hold on
        scatter([1 , 2],leftMean,50,'b','filled')
        scatter([1 , 2],1-rightMean,50,'g','filled')
        
        ylim([0 1])
        xlim([0.75 2.25])
        
        xticks([1 2])
        xticklabels({'early', 'late'})
        xlabel('Trial bins');
        ylabel('Fraction left choice');
        yticks([0 0.5 1]);
        
        line([1 2],[leftMean leftMean],'Color','b','LineWidth',2)
        line([1 2],[1-rightMean 1-rightMean],'Color','g','LineWidth',2)
        
        axis square
        
    case 5
        
        [~ , correctSI1] = getPsyData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData',0);
        [~ , correctSI2] = getPsyData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4',0);
        
        %         trialH = [reshape(trialHSI1,9,4) , reshape(trialHSI2,9,4)];
        correctSI = [reshape(correctSI1,9,4) , reshape(correctSI2,9,4)];
        
        leftBlocks = correctSI(:,[1 3 5 7]);
        rightBlocks = correctSI(:,[2 4 6 8]);
        
        leftFracC = sum(leftBlocks,2)/4;
        rightFracC = sum(rightBlocks,2)/4;
        
        
        leftMean = mean(leftFracC);
        rightMean = mean(1-rightFracC);
            
        leftSD = std(leftFracC);
        rightSD = std(1-rightFracC);
%  
        
        %         hold on
        %         plot(leftFracC,'b-')
        %         plot(1-rightFracC,'g-')
        hold on
%         scatter(ones(length(leftFracC),1),leftFracC,50,'b','filled')
%         scatter(ones(length(rightFracC),1)+1,1-rightFracC,50,'g','filled')
        bar([leftMean , rightMean])
        ylim([0 1])
        xlim([0.75 2.25])
        errorbar([leftMean , rightMean],[leftSD , rightSD])
        
        xticks([1 2])
        xticklabels({'Left', 'Right'})
        xlabel('Trial type');
        ylabel('Fraction left correct');
        yticks([0 0.5 1]);
        
%         line([1 2],[leftMean leftMean],'Color','b','LineWidth',2)
%         line([1 2],[1-rightMean 1-rightMean],'Color','g','LineWidth',2)
        
        axis square
        
        
        
end

end



function [analysismatrix , blockNum] = getBehData(InputFile, InputData, rawFile, rawData)


load(InputFile, InputData)
load(rawFile, rawData)
inputMat = eval(InputData);
rData = eval(rawData);
rTEST = {rData.Stimbeepduration};
if iscell(rTEST)
    isEM = cellfun(@(x) ~isempty(x), rTEST);
    actual = {rData.actual};
    actual = actual(isEM);
    response = {rData.Response};
    response = response(isEM);
    rTime = {rData.rtime};
    rTime = rTime(isEM);
    inputMat = inputMat(isEM);
end

trialNum = ceil(length(inputMat)/9)*9;
blockNum = ceil(length(inputMat)/9);
inputTemp = nan(trialNum,1);
inputTemp(1:length(inputMat)) = inputMat;
inputMat = inputTemp;

if iscell(rTEST)
    
    actualU = num2cell(nan(trialNum,1));
    actualU(1:length(actual)) = actual;
    actualU2 = actualU;
    actualU2(strcmp(actualU,'f')) = {nan};
    
    respU = num2cell(nan(trialNum,1));
    respU(1:length(response)) = response;
    respU2 = respU;
    respU2(strcmp(respU,'f')) = {nan};
    
    rTimeU = num2cell(nan(trialNum,1));
    rTimeU(1:length(rTime)) = rTime;
    rTimeU2 = rTimeU;
    rTimeU2(strcmp(respU,'f')) = {nan};
    
end

analysismatrix = zeros(trialNum,10);
analysismatrix(:,1) = inputMat; %1st column is trial type

corT = cellfun(@(x,y) isequal(x,y), respU2, actualU2);
analysismatrix(:,2) = corT;
analysismatrix(:,3) = cell2mat(rTimeU2);
% Z score = (value - mean/SD)
mean_analysismat = nanmean(analysismatrix(:,3));
stdev = nanstd(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - mean_analysismat)/stdev; %Z score;



end




function [odds_meanperblock , evens_meanperblock , oddSBy , oddSBx , evenSBy , evenSBx] = getScatData(analysismatrix , blockNum)

blocklength = 9;
matrixoutput = reshape(analysismatrix(:,3),blocklength,blockNum);

meanperblock = nanmean(matrixoutput); %now you have the average rxn time for each block
%
odds_meanperblock = meanperblock(1:2:blockNum);
evens_meanperblock = meanperblock(2:2:blockNum);

oddSBy = reshape(matrixoutput(:,1:2:blockNum),numel(matrixoutput(:,1:2:blockNum)),1);
oddSBx = reshape(repmat(1:2:blockNum,9,1),numel(matrixoutput(:,1:2:blockNum)),1);

evenSBy = reshape(matrixoutput(:,2:2:blockNum),numel(matrixoutput(:,2:2:blockNum)),1);
evenSBx = reshape(repmat(2:2:blockNum,9,1),numel(matrixoutput(:,2:2:blockNum)),1);


end



function [mean_odds_meanperblock , mean_evens_meanperblock , std_odds1 ,std_evens1] = getBarData(odds_meanperblock , evens_meanperblock)



mean_odds_meanperblock = mean(odds_meanperblock);
mean_evens_meanperblock = mean(evens_meanperblock);
std_odds1 = std(odds_meanperblock);
std_evens1 = std(evens_meanperblock);



end









function [trialHSI , correctSI] = getPsyData(InputFile, InputData, rawFile, rawData, figN)

load(InputFile, InputData)
load(rawFile, rawData)
inputMat = eval(InputData);
rData = eval(rawData);

for i = 1:length(inputMat)
    if rData(i).Response == 'f'
        rData(i).actual = 0;
    end
end

for i = 1:length(inputMat)
    if rData(i).Response == 'f'
        inputMat(i) = NaN;
    end
end

rTEST = {rData.Stimbeepduration};
if iscell(rTEST)
    isEM = cellfun(@(x) ~isempty(x), rTEST);
    actual = {rData.actual};
    actual = actual(isEM);
    response = {rData.Response};
    response = response(isEM);
    inputMat = inputMat(isEM);
end

trialNum = ceil(length(response)/9)*9;
inputTemp = nan(trialNum,1);
inputTemp(1:length(inputMat)) = inputMat;
inputMat = inputTemp;
if iscell(rTEST)
    
    actualU = num2cell(nan(trialNum,1));
    actualU(1:length(actual)) = actual;
    
    respU = num2cell(nan(trialNum,1));
    respU(1:length(response)) = response;
    
end

blockNum = ceil(length(response)/9);



if figN
    numOblks = numel(1:2:blockNum);
    siInd2 = [1:9;19:27;37:45;55:63;73:81;91:99;109:117;127:135];
    
    siInd = [];
    for i = 1:numOblks
        siInd = [siInd , siInd2(i,:)]; %#ok<AGROW>
    end
    siInd = siInd(5:end);
else
    numOblks = numel(2:2:blockNum);
    siInd2 = [1:9;19:27;37:45;55:63;73:81;91:99;109:117;127:135];
    siInd3a = siInd2 - 9;
    siInd3 = siInd3a(2:end,:);
    
    siInd = [];
    for i = 1:numOblks
        siInd = [siInd , siInd3(i,:)]; %#ok<AGROW>
    end
    
    
end



choice = respU;
% choiceSI = choice(siInd);
actualN = actualU;
% actualSI = actual(siInd);
trialHist = inputMat;

% TEST taking off first half of first block

trialHSI = trialHist(siInd);
correct = cellfun(@(x,y) isequal(x,y), choice, actualN);
correctSI = correct(siInd);

% 1 = easy left
% 2 = med left
% 3 = 50/50
% 4 = med right
% 5 = easy right



end




function [percent_L , xAxisM , y_fit , x_axis] = derivePsyAve(trialHSI , correctSI)

observationsL = zeros(1,5);
observationsL(1,1) = sum(trialHSI == 1 & correctSI);
observationsL(1,2) = sum(trialHSI == 2 & correctSI);
observationsL(1,3) = sum(trialHSI == 301 & correctSI) + sum(trialHSI == 302 & ~correctSI);
observationsL(1,4) = sum(trialHSI == 4 & ~correctSI);
observationsL(1,5) = sum(trialHSI == 5 & ~correctSI);

trialnum = zeros(1,5);
trialnum(1,1) = sum(trialHSI == 1);
trialnum(1,2) = sum(trialHSI == 2);
trialnum(1,3) = sum(trialHSI == 301) + sum(trialHSI == 302);
trialnum(1,4) = sum(trialHSI == 4);
trialnum(1,5) = sum(trialHSI == 5);

percent_L = zeros(1,5);
percent_L(1,1) = sum(trialHSI == 1 & correctSI) / sum(trialHSI == 1);
percent_L(1,2) = sum(trialHSI == 2 & correctSI) / sum(trialHSI == 2);

percent_L(1,3) = (sum(trialHSI == 301 & correctSI) + sum(trialHSI == 302 & ~correctSI)) /...
    (sum(trialHSI == 301) + sum(trialHSI == 302));

percent_L(1,4) = sum(trialHSI == 4 & ~correctSI) / sum(trialHSI == 4);
percent_L(1,5) = sum(trialHSI == 5 & ~correctSI) / sum(trialHSI == 5);


xAxisM = [1,2,3,4,5];
b = glmfit(xAxisM',[observationsL; trialnum]' , 'binomial');

x_axis = (1:0.1:5);
y_fit = glmval(b, x_axis, 'logit');

end






