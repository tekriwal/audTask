function [] = figure_1_atJNM(fName)

%code that illustrates correct/incorrects
%need to load in (rndm_input_matrix)
%need to load in  output struct of task (reads rData)

load('input_matrix_rndm_matonly.mat', 'input_matrix_rndm')
load(fName , 'rData')
analysismatrix = zeros(144,10);
analysismatrix(:,1) = input_matrix_rndm; %1st column is trial type
for i = 1:length(input_matrix_rndm)%2nd column is correct or incorrect
    %if AT_Oct20(i).Response == AT_Oct20(i).actual
    if rData(i).Response == rData(i).actual

        analysismatrix(i,2) = 1; %if correct
    else
        analysismatrix(i,2) = 0; %if incorrect
    end
    %analysismatrix(i,3) = AT_Oct20(i).rtime;
    analysismatrix(i,3) = rData(i).rtime;

end

% (below) matrix where each row is a block and contains binary for whether response was correct or not
rightorwrong = analysismatrix(:,2); %in column 2 are right/wrong
blocklength = 9;
numbblocks = 16;
RoW_matrixoutput = zeros(numbblocks, blocklength);

for i = 1:numbblocks
    RoW_matrixoutput(i,:) = rightorwrong((((i*blocklength)-blocklength)+1):i*blocklength);
end

%now generate plot
for i = 1:numbblocks
    for k = 1:blocklength
        figure(1)
        if RoW_matrixoutput(i,k) == 1
%             plot(k, i, 'og','MarkerSize',20)
%             hold on
        elseif RoW_matrixoutput(i,k) == 0
%             plot(k, i, 'xr','MarkerSize',20)
%             hold on
        end
    end
end

map = zeros(64,3);
map(1:32,:) = repmat([1 0 1],32,1);
map(33:64,:) = repmat([0 1 0],32,1);

imagesc(RoW_matrixoutput);
colormap(map);

set(gca,'Ydir','reverse')
title('Occurrence Correct vs Incorrect Responses')
ylabel('Block number')
xlabel('Trial number')
% xlim([0 11])
% ylim([0 20])
% xticks([0 1 2 3 4 5 6 7 8 9])
% xticklabels({'','1','2','3','4','5','6','7', '8', '9', ''})
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16])
% yticklabels({'','1','2','3','4','5','6','7', '8', '9', '10', '11', '12', '13', '14', '15', '16'})
axis square


            