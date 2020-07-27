%AT created 7/26/20 to help match up taskbase_io output w/ output from
%spike structure




function [logical_SGorIS, logical_ipsiorcontra, logical_corrorincorr] = logisticMatrix_helperfx_V1(caseNumb, masterspikestruct_V2, taskbase_io)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%need to index taskbase_io for SG/IS and L/R

if  caseNumb == 1
    caseName = 'case01';
elseif caseNumb == 2
    caseName = 'case02';
elseif caseNumb == 3
    caseName = 'case03';
elseif caseNumb == 4
    caseName = 'case04';
elseif caseNumb == 5
    caseName = 'case05';
elseif caseNumb == 6
    caseName = 'case06';
elseif caseNumb == 7
    caseName = 'case07';
elseif caseNumb == 8
    caseName = 'case08';
elseif caseNumb == 9
    caseName = 'case09';
elseif caseNumb == 10
    caseName = 'case10';
elseif caseNumb == 11
    caseName = 'case11';
elseif caseNumb == 12
    caseName = 'case12';
elseif caseNumb == 13
    caseName = 'case13';
end


digits(6) %sets vars so they contain 6 digits at most
p = genpath('/Users/andytek/Box/Auditory_task_SNr');
addpath(p);
p = genpath('/Users/andytek/Desktop/git/audTask/MATLABCODE_io');
addpath(p);
% p = genpath('/Users/andytek/Desktop/git/audTask/IO/AT_lfp_code');
% addpath(p);


[caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumb);


[inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);

surgerySide = caseInfo_table.("Target (R/L STN)");








%when saving out logical matrix, need to convert L/R to ipsi/contra as
%appropriate

if strcmp('R', surgerySide)
    spiketrainStrct_V2.IS.ipsi = spikestruct;    
elseif ~strcmp('R', surgerySide)
    spiketrainStrct_V2.IS.contra = spikestruct;    
end








end

