%V1 for post created 4/23/20
%Note, you'll want to run import_excelData_auditoryTask_V1 before this and
%use that output for this input

function [inputmatrix1, rsp_struct1, inputmatrix2, rsp_struct2, inputmatrix3, rsp_struct3, inputmatrix4, rsp_struct4] = import_behavior_postIO_auditoryTask_V1(caseInfo_table, selectInputs)
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



behaviorfolder = caseInfo_table.("Name of subfolder with post IO behavioral data on box.com  ");

% inputmatrix_name = caseInfo_table.("io name of input matrix  file "); 
inputmatrix_name1 = 'input_matrix_rndm1'; 
inputmatrix_name2 = 'input_matrix_rndm2'; 
inputmatrix_name3 = 'input_matrix_rndm3'; 
inputmatrix_name4 = 'input_matrix_rndm4'; 

% rsp_name = caseInfo_table.("io name of rsp file");
rsp_name1 = 'rsp_master_v4_postio1';
rsp_name2 = 'rsp_master_v4_postio2';
rsp_name3 = 'rsp_master_v4_postio3';
rsp_name4 = 'rsp_master_v4_postio4';


%not being very clever with below code, import the 4 relevant inputmat's
%and rsp's for post io
inputmatrix_filePath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, inputmatrix_name1);
inputmatrix_rspPath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, rsp_name1);

inputmatrix1 = load(cell2mat(inputmatrix_filePath));
rsp_struct1 = load(cell2mat(inputmatrix_rspPath));

%%

inputmatrix_filePath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, inputmatrix_name2);
inputmatrix_rspPath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, rsp_name2);

inputmatrix2 = load(cell2mat(inputmatrix_filePath));
rsp_struct2 = load(cell2mat(inputmatrix_rspPath));

%%

inputmatrix_filePath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, inputmatrix_name3);
inputmatrix_rspPath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, rsp_name3);

inputmatrix3 = load(cell2mat(inputmatrix_filePath));
rsp_struct3 = load(cell2mat(inputmatrix_rspPath));

%%

inputmatrix_filePath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, inputmatrix_name4);
inputmatrix_rspPath = fullfile('Users','andytek','Box','Auditory_task_SNr','Data','post_io_behavior_data', behaviorfolder, rsp_name4);

inputmatrix4 = load(cell2mat(inputmatrix_filePath));
rsp_struct4 = load(cell2mat(inputmatrix_rspPath));

%%


end