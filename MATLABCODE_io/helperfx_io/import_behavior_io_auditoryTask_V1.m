%V1 as of 12/1/19 works 
%Note, you'll want to run import_excelData_auditoryTask_V1 before this and
%use that output for this input

function [inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table)
%example use: 
% [inputmatrix, rsp_struct] = import_behavior(caseInfo_table)

%Use: function's purpose is to load in the desired behavioral info

%Detailed explanation:
%inputvars:
%'caseInfo_table' variable is output from
%fx'import_excelData_auditoryTask_V1'
%outputvars:
%'inputmatrix' gives the order and ID of stimuli
%'rsp_struct' gives task output from time of testing

behaviorfolder = caseInfo_table.("Name of subfolder with behavioral data on box.com ");
inputmatrix_name = caseInfo_table.("io name of input matrix  file ");
rsp_name = caseInfo_table.("io name of rsp file");


inputmatrix_filePath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_behavior_data', behaviorfolder, inputmatrix_name);
inputmatrix_rspPath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_behavior_data', behaviorfolder, rsp_name);


inputmatrix = load(cell2mat(inputmatrix_filePath));
rsp_struct = load(cell2mat(inputmatrix_rspPath));



end