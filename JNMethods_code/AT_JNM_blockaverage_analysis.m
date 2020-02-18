%need to load in (rndm_input_matrix)
%need to load in  output struct of task (reads rData)
clear all
load('input_matrix_rndm_matonly')
load('AT_Oct20.mat')
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
% Z score = (value - mean/SD)
mean_analysismat = mean(analysismatrix(:,3));
stdev = std(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - mean_analysismat)/stdev; %Z score;
% plot line and scatter
% scatter([1:144],analysismatrix(:,4))
% hold on
% plot(analysismatrix(:,4))
%% Generates bar graph for reaction times
rxntimes_NORMALIZED = analysismatrix(:,3); %in column 3 are raw reaction times
blocklength = 9;
numbblocks = 16;
matrixoutput = zeros(blocklength,numbblocks);

for i = 1:numbblocks
    matrixoutput(:,i) = rxntimes_NORMALIZED((((i*blocklength)-blocklength)+1):i*blocklength);
end

sumperblock = sum(matrixoutput);
meanperblock = sumperblock/blocklength; %now you have the average rxn time for each block
%
odds_meanperblock = [];
evens_meanperblock = [];

figure(1)
subplot(2,1,1)
b = bar(meanperblock);
for i = 1:numbblocks
    evenorodd = mod(i,2); %returns 0 if even, returns 1 if odd
    if evenorodd == 1 %if odd block number
        b.FaceColor = 'flat';
        b.CData(i,:) = [.5 0 .5];
        A = (meanperblock(1,i));
        odds_meanperblock = [odds_meanperblock ; A];
    elseif evenorodd == 0 %if even block number
        A = (meanperblock(1,i));
        evens_meanperblock = [evens_meanperblock ; A];
    end
end
title('Reaction time, averaged per block')
ylabel('Reaction time (seconds)')
mean_odds_meanperblock = mean(odds_meanperblock);
mean_evens_meanperblock = mean(evens_meanperblock);

subplot(2,1,2)
c = bar([mean_odds_meanperblock;mean_evens_meanperblock]);
c.FaceColor = 'flat';
c.CData(1,:) = [.5 0 .5];%makes the odds average purple
title('Reaction time, average for block type (SG vs IS)')
ylabel('Reaction time (seconds)')
xticks([1 2])
xticklabels({'Stimulus Guided','Internally Specified'})


%% Generates bar graph for NORMALIZED reaction times
rxntimes_NORMALIZED = analysismatrix(:,4); %in column 4 are normalized reaction times
blocklength = 9;
numbblocks = 16;
matrixoutput = zeros(blocklength,numbblocks);

for i = 1:numbblocks
    matrixoutput(:,i) = rxntimes_NORMALIZED((((i*blocklength)-blocklength)+1):i*blocklength);
end

sumperblock = sum(matrixoutput);
meanperblock = sumperblock/blocklength; %now you have the average rxn time for each block
%
odds_meanperblock = [];
evens_meanperblock = [];

figure(2)
subplot(2,1,1)
b = bar(meanperblock);
for i = 1:numbblocks
    evenorodd = mod(i,2); %returns 0 if even, returns 1 if odd
    if evenorodd == 1 %if odd block number
        b.FaceColor = 'flat';
        b.CData(i,:) = [.5 0 .5];
        A = (meanperblock(1,i));
        odds_meanperblock = [odds_meanperblock ; A];
    elseif evenorodd == 0 %if even block number
        A = (meanperblock(1,i));
        evens_meanperblock = [evens_meanperblock ; A];
    end
end
title('Normalized reaction time, average per block')
ylabel('Normalized reaction time (Z-score)')
mean_odds_meanperblock = mean(odds_meanperblock);
mean_evens_meanperblock = mean(evens_meanperblock);

subplot(2,1,2)
c = bar([mean_odds_meanperblock;mean_evens_meanperblock]);
c.FaceColor = 'flat';
c.CData(1,:) = [.5 0 .5];%makes the odds average purple
title('Normalized reaction time, average for block type (SG vs IS)')
ylabel('Normalized reaction time (Z-score)')
xticks([1 2])
xticklabels({'Stimulus Guided','Internally Specified'})







%now we can use meanperblock(i) to draw out specific values
%%
norm_toblock_mean = zeros(blocklength,numbblocks);
for i = 1:numbblocks
    for k = 1:blocklength
        norm_toblock_mean(k,i) = matrixoutput(k,i)/meanperblock(i);%gives values averaged to each block
    end
end
