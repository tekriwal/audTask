function [] = figure_3_atJNM(fName , groupList)

%code that illustrates correct/incorrects
%need to load in (rndm_input_matrix)
%need to load in  output struct of task (reads rData)

if nargin == 1
    groupList = {};
end

load('input_matrix_rndm_matonly.mat', 'input_matrix_rndm')
load(fName , 'rData')

analysismatrix = zeros(144,10);
analysismatrix(:,1) = input_matrix_rndm; %1st column is trial type
corT = transpose([rData.Response] == [rData.actual]);
analysismatrix(:,2) = corT;
analysismatrix(:,3) = transpose([rData.rtime]);
% Z score = (value - mean/SD)
mean_analysismat = mean(analysismatrix(:,3));
stdev = std(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - mean_analysismat)/stdev; %Z score;

%% Generates bar graph for reaction times
 %in column 3 are raw reaction times
blocklength = 9;
numbblocks = 16;
matrixoutput = reshape(analysismatrix(:,3),blocklength,numbblocks);

meanperblock = mean(matrixoutput); %now you have the average rxn time for each block
%
odds_meanperblock = meanperblock(1:2:16);
evens_meanperblock = meanperblock(2:2:16);

oddSBy = reshape(matrixoutput(:,1:2:16),numel(matrixoutput(:,1:2:16)),1);
oddSBx = reshape(repmat(1:2:16,9,1),numel(matrixoutput(:,1:2:16)),1);

evenSBy = reshape(matrixoutput(:,2:2:16),numel(matrixoutput(:,2:2:16)),1);
evenSBx = reshape(repmat(2:2:16,9,1),numel(matrixoutput(:,2:2:16)),1);

figure(1)
subplot(3,1,1)

hold on
scatter(oddSBx , oddSBy , 15 , [.5 0 .5])
scatter(evenSBx , evenSBy , 15 , [0 0 .5])

line([(1:2:16)-0.4 ; (1:2:16)+0.4] , [odds_meanperblock ; odds_meanperblock],...
    'Color' , [.5 0 .5] , 'LineWidth' , 2)

line([(2:2:16)-0.4 ; (2:2:16)+0.4] , [evens_meanperblock ; evens_meanperblock],...
    'Color' , [0 0 .5] , 'LineWidth' , 2)
xlim([0 17])
xticks(1:1:16)

% b = bar(meanperblock);
% b.FaceColor = 'flat';
% b.CData(1:2:16,:) = repmat([.5 0 .5],8,1);

title('Reaction time by block')
ylabel('Reaction time (seconds)')
xlabel('Block #')
mean_odds_meanperblock = mean(odds_meanperblock);
mean_evens_meanperblock = mean(evens_meanperblock);

subplot(3,1,2)
c = bar([mean_odds_meanperblock;mean_evens_meanperblock]);
c.FaceColor = 'flat';
c.CData(1,:) = [.5 0 .5];%makes the odds average purple
title('Reaction time by block type')
ylabel('Reaction time (seconds)')
xticks([1 2])
xticklabels({'SG','IS'})


%% Generates bar graph for NORMALIZED reaction times

matrixoutputN = reshape(analysismatrix(:,4),blocklength,numbblocks);
sumperblockN = sum(matrixoutputN);
meanperblockN = sumperblockN/blocklength;
odds_meanperblockN = meanperblockN(1:2:16);
evens_meanperblockN = meanperblockN(2:2:16);

oddSByn = reshape(matrixoutputN(:,1:2:16),numel(matrixoutputN(:,1:2:16)),1);
oddSBxn = reshape(repmat(1:2:16,9,1),numel(matrixoutputN(:,1:2:16)),1);

evenSByn = reshape(matrixoutputN(:,2:2:16),numel(matrixoutputN(:,2:2:16)),1);
evenSBxn = reshape(repmat(2:2:16,9,1),numel(matrixoutputN(:,2:2:16)),1);

% subplot(2,2,2)
% 
% hold on
% scatter(oddSBxn , oddSByn , 15 , [.5 0 .5])
% scatter(evenSBxn , evenSByn , 15 , [0 0 .5])
% 
% line([(1:2:16)-0.4 ; (1:2:16)+0.4] , [odds_meanperblockN ; odds_meanperblockN],...
%     'Color' , [.5 0 .5] , 'LineWidth' , 2)
% 
% line([(2:2:16)-0.4 ; (2:2:16)+0.4] , [evens_meanperblockN ; evens_meanperblockN],...
%     'Color' , [0 0 .5] , 'LineWidth' , 2)
% 
% xlim([0 17])
% xticks(1:1:16)

% bn = bar(meanperblockN);
% bn.FaceColor = 'flat';
% bn.CData(1:2:16,:) = repmat([.5 0 .5],8,1);

title('Normalized reaction time by block')
ylabel('Normalized reaction time (Z-score)')
mean_odds_meanperblockN = mean(odds_meanperblockN);
mean_evens_meanperblockN = mean(evens_meanperblockN);

subplot(3,1,3)
c = bar([mean_odds_meanperblockN;mean_evens_meanperblockN]);
c.FaceColor = 'flat';
c.CData(1,:) = [.5 0 .5];%makes the odds average purple
title('Normalized reaction time by block type')
ylabel('Reaction time (Z-score)')
xticks([1 2])
xticklabels({'SG','IS'})

set(gcf,'Position', [679 174 360 767])


%% Group plot


for gi = 1:length(groupList)
    
    
    
    
    
    
end



