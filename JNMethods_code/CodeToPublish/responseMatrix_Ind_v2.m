function [] = responseMatrix_Ind_v2(InputFile, InputData, rawFile, rawData)

% responseMatrix_Ind_v2('inputshorten_PT2.mat','inputshorten_PT2','rData_PT2.mat','rData_PT2')
% responseMatrix_Ind_v2('inputshorten_PT1.mat','inputshorten','rData_PT1.mat','rData_PT1')
% responseMatrix_Ind_v2('input_matrix_rndm_matonly.mat', 'input_matrix_rndm','NB_Oct20.mat','NB_Oct20')

load(InputFile, InputData)
load(rawFile, rawData)

if ~iscell(eval(rawData))
    tmpRD = eval(rawData);
    tmpActual = {tmpRD.actual};
    tmpResp = {tmpRD.Response};
    rData = struct2table(tmpRD);
    rData.actual = transpose(tmpActual);
    rData.Response = transpose(tmpResp);
else
    rData = struct2table(eval(rawData));
end

% check for missing values
if iscell(rData.rtime)
    isEm = cellfun(@(x) ~isempty(x), rData.rtime);
    rData = rData(isEm,:);
    input_matrix_rndm = eval(InputData);
    input_matrix_rndm = input_matrix_rndm(isEm);
else
    rData.rtime = num2cell(rData.rtime);
    input_matrix_rndm = eval(InputData);
end

blocklength = 9;
numbblocks = ceil(length(input_matrix_rndm)/blocklength);

analysismatrix = zeros(height(rData),3);
analysismatrix(:,1) = input_matrix_rndm; %1st column is trial type
for i = 1:length(input_matrix_rndm)%2nd column is correct or incorrect
    %if AT_Oct20(i).Response == AT_Oct20(i).actual
    if rData.Response{i} == rData.actual{i}

        analysismatrix(i,2) = 1; %if correct
    else
        analysismatrix(i,2) = 0; %if incorrect
    end
    %analysismatrix(i,3) = AT_Oct20(i).rtime;
    analysismatrix(i,3) = rData.rtime{i};

end

% (below) matrix where each row is a block and contains binary for whether response was correct or not
rightorwrong = analysismatrix(:,2); %in column 2 are right/wrong

RoW_matrixoutput = zeros(numbblocks, blocklength);

numShort = numel(RoW_matrixoutput) - length(rightorwrong);
for i = 1:numbblocks
    
    if i < numbblocks
        
        RoW_matrixoutput(i,:) = rightorwrong((((i*blocklength)-blocklength)+1):i*blocklength);
        
    else
        
        RoW_matrixoutput(i,1:blocklength - numShort) = rightorwrong((((i*blocklength)-blocklength)+1):i*blocklength - numShort);
        RoW_matrixoutput(i,blocklength - numShort + 1 : blocklength) = 0.5;
        
    end
end

%now generate plot
rowPlotMat = zeros(size(RoW_matrixoutput));
%now generate plot
tC = 1;
for i = 1:numbblocks
    for k = 1:blocklength
        figure(1)
        if RoW_matrixoutput(i,k) == 1
            if ismember(input_matrix_rndm(tC),[1 5])
                rowPlotMat(i,k) = 1;
                tC = tC + 1;
                continue
            elseif ismember(input_matrix_rndm(tC),[2 4])
                rowPlotMat(i,k) = 0.70;
                tC = tC + 1;
            elseif input_matrix_rndm(tC) > 300
                rowPlotMat(i,k) = 0.55;
                tC = tC + 1;
            end
        elseif RoW_matrixoutput(i,k) == 0
            if ismember(input_matrix_rndm(tC),[1 5])
                rowPlotMat(i,k) = 1;
                tC = tC + 1;
                continue
            elseif ismember(input_matrix_rndm(tC),[2 4])
                rowPlotMat(i,k) = 0.30;
                tC = tC + 1;
            elseif input_matrix_rndm(tC) > 300
                rowPlotMat(i,k) = 0.45;
                tC = tC + 1;
            end
            
        elseif RoW_matrixoutput(i,k) == 0.5
            rowPlotMat(i,k) = 0.5;
            
        end
    end
end

imagesc(rowPlotMat);
magHalf = [ones(32,1) , transpose(linspace(0,1,32)) , ones(32,1)];
magHalf2 = [transpose(linspace(1,0,32)) , ones(32,1) , transpose(linspace(1,0,32))];
maggrenA = [magHalf ; magHalf2];

maggrenAN = maggrenA;
maggrenAN(32,:) = [ 0 0 0];
maggrenAN(33,:) = [ 0 0 0];
colormap(maggrenAN);

caxis([0 1])

set(gca,'Ydir','reverse')
title('Occurrence Correct vs Incorrect Responses')
ylabel('Block number')
xlabel('Trial number')
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16])
axis square


            