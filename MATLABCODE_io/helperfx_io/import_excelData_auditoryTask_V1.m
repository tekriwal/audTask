%V1 as of 12/1/19 works 
%Note, need Matlab 2019b

function [caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNumber)
%example use: 
% [caseInfo_table, ~] = import_excelData_auditoryTask_V1(4)

%Use: function's purpose is to call in the desired information from the excel
%file 'IntraoperativeTracking_Data_Sheet' for an individual case

%Detailed explanation:
%inputvars:
%'caseNumber' variable is the case number we want to pull from, input as a
%simple integer value. Note, the unsuccessful trials have been designated
%as 0_1, 0_2, etc
%outputvars:
%'caseInfo_table' gives the 'table' output corresponding to the relevant case
%number
%'raw' gives the raw script from entire xlsx sheet, may be useful as reference



%%

%variables necessary for fx to work:

%you will need to change the below if trying to run from different computer
%path to filename for excel sheet
filepath = fullfile('Users','andytek','Box','Auditory_task_SNr','IntraoperativeTracking_Data_Sheet.xlsx');


%you'll want to keep the below static unless trying to repurpose the fx
sheetname = 'auditoryTask_masterSheet';
caseNumber_str = mat2str(caseNumber);


%We can set the way a given row/column is imported with regard to data type
%and other (?) features, generally I think this is an important feature of
%tables. It lets us have a lot of control over what form and which columns
%of data are imported
% opts = spreadsheetImportOptions;
% opts = detectImportOptions(filepath);

%Load in the excel data sheet that will determine the names
%and such of files. Not primary way we're going to use this fx, but not a
%bad thing to include in output
[num,txt,raw] = xlsread(filepath, sheetname);

%we set 'sheet' to the name of the sheet we want to import
%we set 'preservevariablenames' to true if we want it to preserve the same names as what I have used in the sheet itself
%we set 'readrownames' to true so the first column of each row (which is the case #) will allow us to index based on row name
Table_master = readtable(filepath, 'Sheet', sheetname, 'PreserveVariableNames', true, 'ReadRowNames', true); 

%convert the date into something matlab can interpret; tbh, not very
%important
Table_master.("IO date") = datetime(Table_master.("IO date"),'InputFormat','dd-MMM-yy'); %


caseInfo_table = Table_master(caseNumber_str,:);









end