function [percent_L, y_fit] = figure_5_atJNM(fName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
% Example: figure_2_atJNM('AT_Oct20.mat')



load(fName , 'rData')
load('input_matrix_rndm_matonly')

siInd = [1:9,19:27,37:45,55:63,73:81,91:99,109:117,127:135];

choice = transpose([rData.Response]);
% choiceSI = choice(siInd); 
actual = transpose([rData.actual]);
% actualSI = actual(siInd);
trialHist = input_matrix_rndm;
trialHSI = trialHist(siInd);
correct = choice == actual;
correctSI = correct(siInd);

% 1 = easy left
% 2 = med left
% 3 = 50/50
% 4 = med right
% 5 = easy right

observationsL = zeros(1,5);
observationsL(1,1) = sum(trialHSI == 1 & correctSI);
observationsL(1,2) = sum(trialHSI == 2 & correctSI);
observationsL(1,3) = sum(trialHSI == 301 & correctSI);
observationsL(1,4) = sum(trialHSI == 4 & ~correctSI);
observationsL(1,5) = sum(trialHSI == 5 & ~correctSI);

trialnum = zeros(1,5);
trialnum(1,1) = sum(trialHSI == 1);
trialnum(1,2) = sum(trialHSI == 2);
trialnum(1,3) = sum(trialHSI == 301);
trialnum(1,4) = sum(trialHSI == 4);
trialnum(1,5) = sum(trialHSI == 5);

percent_L = zeros(1,5);
percent_L(1,1) = sum(trialHSI == 1 & correctSI) / sum(trialHSI == 1);
percent_L(1,2) = sum(trialHSI == 2 & correctSI) / sum(trialHSI == 2);

percent_L(1,3) = sum(trialHSI == 301 & correctSI) / sum(trialHSI == 301);

percent_L(1,4) = sum(trialHSI == 4 & ~correctSI) / sum(trialHSI == 4);
percent_L(1,5) = sum(trialHSI == 5 & ~correctSI) / sum(trialHSI == 5);


xAxisM = [5,4,3,2,1];
b = glmfit(xAxisM',[observationsL; trialnum]' , 'binomial');

x_axis = (1:0.1:5);
y_fit = glmval(b, x_axis, 'logit');

figure;
p = plot(xAxisM, percent_L, 'ko');
set(p, 'MarkerFaceColor', 'k', 'MarkerSize', 10);
hold on
% the fit
p = plot(x_axis, y_fit, 'k');
set(p, 'LineWidth', 2);
ylim([0 1])
yticks([0 0.5 1])
ylabel('Fraction of right choices');
xticks([1 2 3 4 5])
xlabel('Frequency of tone')


end

