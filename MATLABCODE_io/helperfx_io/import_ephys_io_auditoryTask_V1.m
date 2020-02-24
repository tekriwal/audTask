%V1 as of 12/1/19 works 
%Note, you'll want to run import_excelData_auditoryTask_V1 before this and
%use that output for this input

function [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table)
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
spike1 = [];
spike2 = [];
spike3 = [];

spikeMethod_folder = 'processed_spikes_BClust';


neuraldata_folder = caseInfo_table.("Name of subfolder with neural data on box.com ");

ephysfile_name = caseInfo_table.("Name of raw ephys file");

spike1_name = caseInfo_table.("Name of spike1 located in subfolder  'processed_spikes_BClust'");
spike2_name = caseInfo_table.("Name of spike2 located in subfolder  'processed_spikes_BClust'");
spike3_name = caseInfo_table.("Name of spike3 located in subfolder  'processed_spikes_BClust'");


Ephys_struct = load(cell2mat(ephysfile_name));

if caseInfo_table.("Number of MER (total)") == 1
    spike1 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike1_name)));
elseif caseInfo_table.("Number of MER (total)") == 2 
    spike1 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike1_name)));
    spike2 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike2_name)));
elseif caseInfo_table.("Number of MER (total)") == 3
    spike1 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike1_name)));
    spike2 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike2_name)));
    spike3 = load(cell2mat(fullfile('Users','andytek','Box','Auditory_task_SNr','Data','io_neural_data', neuraldata_folder, spikeMethod_folder, spike3_name)));
end




%AT 2/18/20; not very 'smart' but the below will work for working with
%various subclusters
if strcmp(cell2mat(caseInfo_table.Properties.RowNames), '11')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    
    clustIndex_0 = clustids  == 0;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    clustIndex_3 = clustids  == 3;
    clustIndex_4 = clustids  == 4;
    clustIndex_5 = clustids  == 5;
    clustIndex_6 = clustids  == 6;
    
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_0  = spiketimes(clustIndex_0);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_4  = spiketimes(clustIndex_4);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_5  = spiketimes(clustIndex_5);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_6  = spiketimes(clustIndex_6);
    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    
    clustIndex_3 = clustids  == 3;
    clustIndex_4 = clustids  == 4;
    clustIndex_5 = clustids  == 5;
    clustIndex_6 = clustids  == 6;
    
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_4  = spiketimes(clustIndex_4);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_5  = spiketimes(clustIndex_5);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_6  = spiketimes(clustIndex_6);


elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '8')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    
%     clustIndex_0 = clustids  == 0;
%     clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    clustIndex_3 = clustids  == 3;
    clustIndex_4 = clustids  == 4;
%     clustIndex_5 = clustids  == 5;
%     clustIndex_6 = clustids  == 6;
    
%     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_0  = spiketimes(clustIndex_0);
%     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_4  = spiketimes(clustIndex_4);
%     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_5  = spiketimes(clustIndex_5);
%     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_6  = spiketimes(clustIndex_6);
    

end



end