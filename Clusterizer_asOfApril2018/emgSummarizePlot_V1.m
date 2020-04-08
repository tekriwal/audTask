function [] = emgSummarizePlot_V1(inPUTS)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%
% EXAMPLE
% emgSummarizePlot_V1('caseNum',8, 'Param',2, 'plotN',2,'userPC','AT')
% 
% caseNum = case number || No Default
% Param = 1, 2, 3 = normalized root mean square, z score amplitude, mean power
%         spectrum 0.5 to 20 Hz || default is 1
% plotN = 1 or 2: 1 = plot summary data, 2 = plot timeseries data ||
%         default is 1
% userPC = 'JT' or 'AT' = will apply appropriate Box location || default is
%          'AT'
% stat = 'N' or 'P' = parametric or non-para || default is 'N'
% deT2 = 1 or 0 = use detrending or not for timeseries data || default is 0
% 

arguments
    inPUTS.userPC (1,1) string = "AT"
    inPUTS.plotN (1,1) double = 1 % IN USE for plot number
    inPUTS.dirLOC (1,1) string = "noloc" % TEMPORARY
    inPUTS.caseNum (1,1) double = NaN % IN USE for CASE NUMBER
    inPUTS.toPlot (1,1) logical = 0 % IN USE for plot check
    inPUTS.Param (1,1) double = 1 % IN USE param check
    inPUTS.stat (1,1) string = "N" % IN USE for stats "N" or "P"
    inPUTS.deT2 (1,1) logical = 0 % IN USE for plot 2 detrending
end



casNUM = inPUTS.caseNum;

if strcmp(inPUTS.userPC,"AT")
    boxLOC = [filesep,strjoin({'Users','andytek','Box','Auditory_task_SNr','Data'},filesep)];
elseif strcmp(inPUTS.userPC,"JT")
    boxLOC = ['D:',filesep,'ATtest'];
end


filepath = fullfile(boxLOC,'IntraoperativeTracking_Data_Sheet.xlsx');

sheetname = 'auditoryTask_masterSheet';
caseNumber_str = mat2str(casNUM);
Table_master = readtable(filepath, 'Sheet', sheetname, 'PreserveVariableNames', true, 'ReadRowNames', true); 
Table_master.("IO date") = datetime(Table_master.("IO date"),'InputFormat','MM/dd/yyyy'); %
caseInfo_table = Table_master(caseNumber_str,:);

neuralLoc = caseInfo_table.("Name of subfolder with neural data on box.com ");

neuralfolder = fullfile(boxLOC,'io_neural_data',neuralLoc{1},'emgResult');

% neuralfolder = ['D:\ATtest\io_neural_data\' , caseInfo_table.neuralLoc{1},'\emgResult'];
emgNAME = ['EMG_Results_C_', num2str(casNUM) ,'.mat'];
emgDatFile = load([neuralfolder , filesep , emgNAME]);

emgDatOut = emgDatFile.emgDatOut;

eps2plot = {'Strt2Stim','Stim2GoCue','GoCue2MVStrt','MVStrt2fdBk'};
emgSS = fieldnames(emgDatOut);

plot2u = inPUTS.plotN;

switch plot2u
    case 1
        
        allParams = {'nRMS','ZScoreAmp','nPwr'};
        useParam = allParams{inPUTS.Param};
        
        if strcmp(inPUTS.stat,"N")
            center = 'median';
            spread = 0;
        elseif strcmp(inPUTS.stat,"P")
            center = 'mean';
            spread = 1;
        else
            return
        end
        
        colORs = 'rk';
        scatCs = cell(1,length(emgSS));
        for emgNUM = 1:length(emgSS)
            for ep = 1:length(eps2plot)
                
                if emgNUM == 1
                    epX = ep;
                else
                    epX = ep + 0.25;
                end
                
                % Get center
                tmpMean = emgDatOut.(emgSS{emgNUM}).(eps2plot{ep}).SumDat.(useParam)(center);
                
                if spread
                    standDeiv = emgDatOut.(emgSS{emgNUM}).(eps2plot{ep}).SumDat.(useParam)('std');
                    tmpUP = tmpMean + standDeiv;
                    tmpDN = tmpMean - standDeiv;
                else
                    tmpUP = emgDatOut.(emgSS{emgNUM}).(eps2plot{ep}).SumDat.(useParam)('thirdQ');
                    tmpDN = emgDatOut.(emgSS{emgNUM}).(eps2plot{ep}).SumDat.(useParam)('firstQ');
                end
                
                hold on;
                
                scatCs{emgNUM} = scatter(epX , tmpMean, 20, colORs(emgNUM),'filled');
                line([epX epX],[tmpDN tmpUP],'Color',colORs(emgNUM),'LineWidth',1.5)
                
            end
            
            
        end
        xticks(1:4);
        xticklabels(eps2plot);
        xtickangle(45);
        ylabel(useParam);
        hL = [scatCs{:}];
        legend(hL,'EMG 1','EMG 2')
        
        
    case 2
        
        for emgNUM = 1:length(emgSS)
            figure;
            colORs = 'rkgb';
            tiledlayout(1,4)
            for ep = 1:length(eps2plot)
                
                trialOr = transpose(emgDatOut.(emgSS{emgNUM}).(eps2plot{ep}).Tseries);
                
                [trialOr2] = dEtrnd(trialOr ,  inPUTS.deT2);
                nexttile
                plot(trialOr2 , colORs(ep))
                title(eps2plot{ep})
                ylabel('Trial number')
                xlabel('Samples')
                if inPUTS.deT2
                    ylim([-10 10])
                end
                
            end
        end
end

end





function [cleanVec] = dEtrnd(nanVec , detChk)

trialOr = nanVec;
trialOr2 = nan(size(trialOr));
for tr = 1:size(trialOr,2)
    
    tmpCol = trialOr(:,tr);
    nanLocs = isnan(tmpCol);
    
    if detChk
        trialOr2(~nanLocs,tr) = detrend(trialOr(~nanLocs,tr));
    else
        trialOr2(:,tr) = tmpCol;
    end
end
cleanVec = trialOr2;

end
