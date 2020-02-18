function [] = create_Fig3B_Tekriwal_method_v1()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Scatter Plot (Fig3B)

blockNum = 9;

[analysismatrix1 , ~] = getBehData('input_matrix_P3_short.mat','input_short_P3','PT3_a.mat','rData');
[analysismatrix2 , ~] = getBehData('input_matrix_rndm_Dec28.mat', 'input_matrix_rndm', 'PT4b.mat', 'rData4');

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
scatter(oddSBx , oddSBy , 15 , [.5 0 .5])
scatter(evenSBx , evenSBy , 15 , [0 0 .5])

line([(1:2:blockNum)-0.4 ; (1:2:blockNum)+0.4] , [odds_meanperblock ; odds_meanperblock],...
    'Color' , [.5 0 .5] , 'LineWidth' , 2)

line([(2:2:blockNum)-0.4 ; (2:2:blockNum)+0.4] , [evens_meanperblock ; evens_meanperblock],...
    'Color' , [0 0 .5] , 'LineWidth' , 2)
xlim([0 blockNum+1])
xticks(1:1:blockNum)
axis square
yVals = get(gca,'YTick');
ylim([0 max(yVals)]);
yticks([0 round(max(yVals)/2,2), max(yVals)])
    
test = 1;

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