function [] = figure_4_atJNM_ATV2(fName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
% Example: figure_2_atJNM('AT_Oct20.mat')


load(fName , 'rData')
load('input_matrix_rndm_matonly')

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
tM = mean(analysismatrix(:,3));
stdev = std(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - tM)/stdev; %Z score;

odds = [];
evens = [];
rxntimes_normalized = analysismatrix(:,4);
blocklength = 9;
numbblocks = 16;
matrixoutput = zeros(blocklength,numbblocks);

for i = 1:numbblocks
    matrixoutput(:,i) = rxntimes_normalized((((i*blocklength)-blocklength)+1):i*blocklength);
end

for i = 1:numbblocks
    evenorodd = mod(i,2); %returns 0 if even, returns 1 if odd
    if evenorodd == 1
        A = (matrixoutput(:,i));
        odds = [odds ; A];
    elseif evenorodd == 0
        A = (matrixoutput(:,i));
        evens = [evens ; A];
    end
    
end
odds = reshape(odds,[blocklength,numbblocks/2]); %arranges data back in matrix, each column is one block
evens = reshape(evens,[blocklength,numbblocks/2]); %arranges data back in matrix, each column is one block

%this part computes a line of best fit from the means of odds or evens
xaxis = 1:numbblocks/2;
aveoftrials_odds = (sum(odds))/blocklength;  %taking ave of all odd trials, prob a more rigorous way to do this
plot(xaxis,aveoftrials_odds,'.b')
p_odds = polyfit(xaxis,aveoftrials_odds,1);
f_odds = polyval(p_odds,xaxis);
% hold on
% plot(xaxis,f_odds,'--r')
aveoftrials_evens = (sum(evens))/blocklength;  %taking ave of all even trials, prob a more rigorous way to do this
plot(xaxis,aveoftrials_evens,'.b')
p_evens = polyfit(xaxis,aveoftrials_evens,1);
f_evens = polyval(p_evens,xaxis);
% hold on
% plot(xaxis,f_evens,'--r')


for i = 1:numbblocks %here we plot both individual blocks and overall mean
    figure(1)
    evenorodd = mod(i,2); %returns 0 if even, returns 1 if odd
    if evenorodd == 1
        ax1 = subplot(2, 2, 1); %subplot to the left is for the odd trials
        plot (matrixoutput(:,i))
        title('All Stimulus Guided blocks')
        ylabel('Normalized reaction time (Z-score)')
        hold on
    elseif evenorodd == 0
        ax2 = subplot(2, 2, 2); %subplot to the right is for the even trials
        plot (matrixoutput(:,i))
        title('All Internally Specified blocks')
        ylabel('Normalized reaction time (Z-score)')
        hold on
    end
end
ax3 = subplot(2,2,3);
plot(xaxis,aveoftrials_odds,'.b')
hold on
plot(xaxis,f_odds,'--r','DisplayName','Best Fit of Mean')%adds the linearly computed mean as red dotted line
hold on
title('Average for all Stimulus Guided blocks')
ylabel('Normalized reaction time (Z-score)')

ax4 = subplot(2,2,4);
plot(xaxis,aveoftrials_evens,'.b')
hold on
plot(xaxis,f_evens,'--r','DisplayName','Best Fit of Mean')%adds the linearly computed mean as red dotted line
hold on
title('Average for all Internally Specified blocks')
ylabel('Normalized reaction time (Z-score)')


linkaxes([ax1,ax2],'xy')
linkaxes([ax3,ax4],'xy')

