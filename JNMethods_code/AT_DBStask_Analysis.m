%need to load in whatever the template for trial structure was
%(rndm_input_matrix)
%need to load in whatever output struct of task was

analysismatrix = zeros(144,10);
analysismatrix(:,1) = input_matrix_rndm; %1st column is trial type
for i = 1:length(input_matrix_rndm)%2nd column is correct or incorrect
    if AT_Oct20(i).Response == AT_Oct20(i).actual
        analysismatrix(i,2) = 1; %if correct
    else
        analysismatrix(i,2) = 0; %if incorrect
    end
    analysismatrix(i,3) = AT_Oct20(i).rtime;
end
%% Z score = (value - mean/SD)
ave = mean(analysismatrix(:,3));
stdev = std(analysismatrix(:,3));
analysismatrix(:,4) = (analysismatrix(:,3) - ave)/stdev; %Z score;
% plot line and scatter
scatter([1:144],analysismatrix(:,4))
hold on
plot(analysismatrix(:,4))
% %% compare blocks
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
% 
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

%%
matrixoutput = zeros(numbblocks,blocklength);
for i = 1:numbblocks
    matrixoutput(i,:) = rxntimes((((i*blocklength)-blocklength)+1):i*blocklength);
end

plot
subplot(i,1,numbblocks)
(matrixoutput(1,:));

        
        