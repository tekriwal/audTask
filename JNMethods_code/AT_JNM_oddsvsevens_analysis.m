%need to load in (rndm_input_matrix)
%need to load in  output struct of task (reads rData)

%% as of 10/23 task generates interesting figure, I think it warrants inclusion
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
mean = mean(analysismatrix(:,3));
stdev = std(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - mean)/stdev; %Z score;
% plot line and scatter
scatter([1:144],analysismatrix(:,4))
hold on
plot(analysismatrix(:,4))
%% this cell produces graph that takes all the even blocks (which are all internally specified) and compares against all the odd blocks (stimulus guided) using the RAW reaction times
odds = [];
evens = [];
rxntimes_normalized = analysismatrix(:,3);
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
        ax1 = subplot(1, 2, 1); %subplot to the left is for the odd trials
        plot (matrixoutput(:,i))
        title('Odd blocks: Stimulus Guided')
        ylabel('Raw reaction time (seconds)')
        hold on
        plot(xaxis,aveoftrials_odds,'.b'); %adds the dot points for mean computed values
        hold on
        plot(xaxis,f_odds,'--r') %adds the linearly computed mean as red dotted line
        hold on
    elseif evenorodd == 0
        ax2 = subplot(1, 2, 2); %subplot to the right is for the even trials
        plot (matrixoutput(:,i))
        title('Even blocks: Internally Specified')
        ylabel('Raw reaction time (seconds)')
        hold on
        plot(xaxis,aveoftrials_evens,'.b')
        hold on
        plot(xaxis,f_evens,'--r','DisplayName','Best Fit of Mean')%adds the linearly computed mean as red dotted line
        hold on
    end
end
     linkaxes([ax1,ax2],'xy')

%% this cell produces graph that takes all the even blocks (which are all internally specified) and compares against all the odd blocks (stimulus guided) using the NORMALIZED reaction times
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
        ax1 = subplot(1, 2, 1); %subplot to the left is for the odd trials
        plot (matrixoutput(:,i))
        title('Odd blocks: Stimulus Guided')
        ylabel('Normalized reaction time (Z-score)')
        hold on
        plot(xaxis,aveoftrials_odds,'.b'); %adds the dot points for mean computed values
        hold on
        plot(xaxis,f_odds,'--r') %adds the linearly computed mean as red dotted line
        hold on
    elseif evenorodd == 0
        ax2 = subplot(1, 2, 2); %subplot to the right is for the even trials
        plot (matrixoutput(:,i))
        title('Even blocks: Internally Specified')
        ylabel('Normalized reaction time (Z-score)')
        hold on
        plot(xaxis,aveoftrials_evens,'.b')
        hold on
        plot(xaxis,f_evens,'--r','DisplayName','Best Fit of Mean')%adds the linearly computed mean as red dotted line
        hold on
    end
end
     linkaxes([ax1,ax2],'xy')

% 
% sumperblock = sum(matrixoutput);
% meanperblock = sumperblock/blocklength;
%now we can use meanperblock(i) to draw out specific values
%%
% blocklength = 9;
% numbblocks = 16;
% mean_block = zeros(numbblocks,1);
% std_block = zeros(numbblocks,1);
% for n = 1:(numbblocks)
%     sum = sum(analysismatrix(10:18,3) );
%     mean_block(n+1) = sum/blocklength;
%     stdmat = (analysismatrix( (1+(n*blocklength)):((n+1)*blocklength), 3) );
%     std_block(n+1) = std(stdmat);
% end
%% 
% %%
% rxntimes = analysismatrix(:,3);
% 
% blocklength = 9;
% numbblocks = 16;
% 
% 
% matrixoutput = zeros(numbblocks,blocklength);
% rxnave_perblock = zeros(numbblocks,1);
% 
% for i = 1:numbblocks
%     matrixoutput(i,:) = rxntimes((((i*blocklength)-blocklength)+1):i*blocklength);
%     blockave = 
% end

%
%%
% plot
% subplot(i,1,numbblocks)
% (matrixoutput(1,:));

        
        