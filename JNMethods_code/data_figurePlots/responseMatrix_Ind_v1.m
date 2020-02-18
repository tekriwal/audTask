function [] = responseMatrix_Ind_v1(fName)
% RESPONSEMATRIX_IND_V1 generates a matrix (TRIAL x BLOCK) highlighting 
% which trial types the subject made the correct or incorrect response.
% Green blocks indicate correct responses and magenta blocks indicate
% incorrect responses. Color gradients represent trial difficulty from dark
% (50/50) to light (easy - high tone).
%
%
% The function will require the input_matrix used to generate the session
% in addition to the output struct.
%
% INPUTS:
% 'fName' - string/character of the file name used for the output .mat file
% generated by the paradigm code. Example: 'JD_Oct20.mat'
%
% Example usage: responseMatrix_Ind_v1('JD_Oct20.mat')


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
tC = 1;
for i = 1:numbblocks
    for k = 1:blocklength
        figure(1)
        if RoW_matrixoutput(i,k) == 1
            if ismember(input_matrix_rndm(tC),[1 5])
                tC = tC + 1;
                continue
            elseif ismember(input_matrix_rndm(tC),[2 4])
                RoW_matrixoutput(i,k) = 0.8;
                tC = tC + 1;
            elseif input_matrix_rndm(tC) > 300
                RoW_matrixoutput(i,k) = 0.65;
                tC = tC + 1;
            end
        elseif RoW_matrixoutput(i,k) == 0
            if ismember(input_matrix_rndm(tC),[1 5])
                tC = tC + 1;
                continue
            elseif ismember(input_matrix_rndm(tC),[2 4])
                RoW_matrixoutput(i,k) = 0.2;
                tC = tC + 1;
            elseif input_matrix_rndm(tC) > 300
                RoW_matrixoutput(i,k) = 0.35;
                tC = tC + 1;
            end
            
            
        end
    end
end



imagesc(RoW_matrixoutput);
magHalf = [ones(32,1) , transpose(linspace(0,1,32)) , ones(32,1)];
magHalf2 = [transpose(linspace(1,0,32)) , ones(32,1) , transpose(linspace(1,0,32))];
maggrenA = [magHalf ; magHalf2];
colormap(maggrenA);

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


            