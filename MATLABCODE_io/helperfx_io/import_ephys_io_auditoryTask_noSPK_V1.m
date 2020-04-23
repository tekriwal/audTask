%3/19/20 'V1' has been updated to reflect the clusterID's that're labeled
%in the 'V2' version of the spike sorting.

%V1 as of 12/1/19 works

%Note, you'll want to run import_excelData_auditoryTask_V1 before this and
%use that output for this input

function [Ephys_struct] = import_ephys_io_auditoryTask_noSPK_V1(caseInfo_table , baseLoc)
%example use:
% [Raw_ephys, spike1, spike2, ~] = import_ephys_io_auditoryTask_V1(caseInfo_table)

%Use: function's purpose is to load in the desired behavioral info

%Detailed explanation:
%inputvars:
%'caseInfo_table' variable is output from
%fx'import_excelData_auditoryTask_V1'
%outputvars:
%'Raw_ephys' gives raw ephys file
%'spikeN' gives spike files

% spikeMethod_folder = 'processed_spikes_BClust';


neuraldata_folder = caseInfo_table.("Name of subfolder with neural data on box.com");

ephysfile_name = caseInfo_table.("Name of raw ephys file");

fileLOC = fullfile(baseLoc,neuraldata_folder,ephysfile_name);

Ephys_struct = load(cell2mat(fileLOC));


% AT 3/28/20 I manually checked that the start and end times are the same for the individual cases. but below is how we'd automate
% Ephys_struct.mer.timeStart ~= Ephys_struct.lfp.timeStart ~= Ephys_struct.emg.timeStart ~= Ephys_struct.mLFP.timeStart ~= 
if Ephys_struct.mer.timeStart >  Ephys_struct.ttlInfo.timeStart || Ephys_struct.mer.timeEnd <  Ephys_struct.ttlInfo.timeEnd
    msg = 'Error in ephys files, see import_ephys_io_auditoryTask_VX ';
    error(msg)
end
%AT 3/28/20; 
delta = Ephys_struct.ttlInfo.timeStart - Ephys_struct.mer.timeStart;
buffer = round((Ephys_struct.ttlInfo.sampFreqHz)*delta);
Ephys_struct.ttlInfo.ttl_up = Ephys_struct.ttlInfo.ttl_up+buffer;
Ephys_struct.ttlInfo.timeStart = Ephys_struct.mer.timeStart;






end