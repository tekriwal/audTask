%4/29/20 - V3 incorporates the waveform output as with the spiketime

%3/19/20 'V1' has been updated to reflect the clusterID's that're labeled
%in the 'V2' version of the spike sorting.

%V1 as of 12/1/19 works

%Note, you'll want to run import_excelData_auditoryTask_V1 before this and
%use that output for this input

function [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V3(caseInfo_table, spikeMethod_folder)
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

% spikeMethod_folder = 'processed_spikes_BClust';


neuraldata_folder = caseInfo_table.("Name of subfolder with neural data on box.com ");

ephysfile_name = caseInfo_table.("Name of raw ephys file");

if strcmp (spikeMethod_folder, 'processed_spikes_BClust')
    spike1_name = caseInfo_table.("Name of spike1 located in subfolder  'processed_spikes_BClust'");
    spike2_name = caseInfo_table.("Name of spike2 located in subfolder  'processed_spikes_BClust'");
    spike3_name = caseInfo_table.("Name of spike3 located in subfolder  'processed_spikes_BClust'");
elseif strcmp (spikeMethod_folder, 'processed_spikes_V2')
    spike1_name = caseInfo_table.("Name of spike1 located in subfolder  'processed_spikes_V2'");
    spike2_name = caseInfo_table.("Name of spike2 located in subfolder  'processed_spikes_V2'");
    spike3_name = caseInfo_table.("Name of spike3 located in subfolder  'processed_spikes_V2'");
end

Ephys_struct = load(cell2mat(ephysfile_name));


% AT 3/28/20 I manually checked that the start and end times are the same for the individual cases. but below is how we'd automate
% Ephys_struct.mer.timeStart ~= Ephys_struct.lfp.timeStart ~= Ephys_struct.emg.timeStart ~= Ephys_struct.mLFP.timeStart ~=
if Ephys_struct.mer.timeStart >  Ephys_struct.ttlInfo.timeStart || Ephys_struct.mer.timeEnd <  Ephys_struct.ttlInfo.timeEnd
    msg = 'Error in ephys files, see import_ephys_io_auditoryTask_VX ';
    error(msg)
end



if ~strcmp(caseInfo_table.Properties.RowNames, '7') && ~strcmp(caseInfo_table.Properties.RowNames, '10') && ~strcmp(caseInfo_table.Properties.RowNames, '12') && ~strcmp(caseInfo_table.Properties.RowNames, '13')
    
    %4/5/20 need to check that stard and end times for ttl and mer match
    %reality. and that lfp matches spike for start times, if it doesn't we need
    %to pad the lfp.
    mer_timeLength = Ephys_struct.mer.timeEnd - Ephys_struct.mer.timeStart;
    cspk_timeLength = length(Ephys_struct.CSPK_01)/Ephys_struct.mer.sampFreqHz;
    if round(mer_timeLength) ~= round(cspk_timeLength)
        error('mismatched mer lengths')
    end
    
    
    
    lfp_timeLength = Ephys_struct.lfp.timeEnd - Ephys_struct.lfp.timeStart;
    clfp_timeLength = length(Ephys_struct.CLFP_01)/Ephys_struct.lfp.sampFreqHz;
    if round(lfp_timeLength) ~= round(clfp_timeLength)
        error('mismatched lfp lengths')
    end
    
    
    
    if round(Ephys_struct.mer.timeStart) ~= round(Ephys_struct.lfp.timeStart)
        
        if Ephys_struct.mer.timeStart < Ephys_struct.lfp.timeStart
            delta = Ephys_struct.lfp.timeStart - Ephys_struct.mer.timeStart;
            buffer = zeros(1, round((Ephys_struct.ttlInfo.sampFreqHz)*delta));
            Ephys_struct.CLFP_01 = [buffer, Ephys_struct.CLFP_01];
            %     if Ephys_struct.mer.timeStart < Ephys_struct.lfp.timeStart
            error('check to see if fix worked - figureitout')
            %     end
        elseif Ephys_struct.mer.timeStart > Ephys_struct.lfp.timeStart
            %we'll need to cut the first 'X' portion of lfp recording, will
            %need to calculate what that should be based on diff in mer and lfp
            %length.
            error('figureitout')
        end
        
    end
    
end




%AT 3/28/20; the below accounts for ttl being shorter than mer (which is
%should be, since the ttl clock starts once the first TTL is detected and
%this is always occurring AFTER we being acquiring spike recordings)
delta = Ephys_struct.ttlInfo.timeStart - Ephys_struct.mer.timeStart;
buffer = round((Ephys_struct.ttlInfo.sampFreqHz)*delta);
Ephys_struct.ttlInfo.ttl_up = Ephys_struct.ttlInfo.ttl_up+buffer;

Ephys_struct.ttlInfo.timeStart = Ephys_struct.mer.timeStart;








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
if strcmp(cell2mat(caseInfo_table.Properties.RowNames), '13')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    
    %  clustIndex_0 = clustids  == 0;
    clustIndex_1 = clustids  == 2;
    clustIndex_2 = clustids  == 3;
    
    % spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_0  = spiketimes(clustIndex_0);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    %     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike1.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike1.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    
    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike2.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike2.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '12')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;

    clustIndex_1 = clustids  == 2;
    clustIndex_2 = clustids  == 3;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);

    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike1.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike1.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '11')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);

    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '10')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
  
    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '9')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '8')
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '7')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '6')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '5')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    
    spiketimes = spike3.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike3.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike3.spikeDATA.features;
    spike3.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike3.spikeDATA.waveforms.allWaves.waves;
    spike3.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '4')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
        %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike3.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike3.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    clustIndex_2 = clustids  == 3;
    
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    
    %AT added below 4/29/20
    waveformfeatures = spike3.spikeDATA.features;
    spike3.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike3.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike3.spikeDATA.waveforms.allWaves.waves;
    spike3.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike3.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '3')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
        %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike2.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike2.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    
    spiketimes = spike3.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike3.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
        %AT added below 4/29/20
    waveformfeatures = spike3.spikeDATA.features;
    spike3.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike3.spikeDATA.waveforms.allWaves.waves;
    spike3.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '2')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 3;
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
        %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
   
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 3;
    
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    
        %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike2.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike2.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    
    spiketimes = spike3.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike3.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    
        %AT added below 4/29/20
    waveformfeatures = spike3.spikeDATA.features;
    spike3.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    %AT added below 4/30/20
    waveform = spike3.spikeDATA.waveforms.allWaves.waves;
    spike3.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);

    
elseif strcmp(cell2mat(caseInfo_table.Properties.RowNames), '1')
    
    spiketimes = spike1.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike1.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 2;
    clustIndex_2 = clustids  == 3;
    
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    
    %AT added below 4/29/20
    waveformfeatures = spike1.spikeDATA.features;
    spike1.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike1.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    %AT added below 4/30/20
    waveform = spike1.spikeDATA.waveforms.allWaves.waves;
    spike1.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike1.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);

    %     spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1 = [spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1; spike1.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2];
    
    
    spiketimes = spike2.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike2.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    clustIndex_3 = clustids  == 3;
    
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    spike2.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    
    %AT added below 4/29/20
    waveformfeatures = spike2.spikeDATA.features;
    spike2.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike2.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    spike2.spikeDATA.features_clustIndex_3 = waveformfeatures(clustIndex_3,:);
    %AT added below 4/30/20
    waveform = spike2.spikeDATA.waveforms.allWaves.waves;
    spike2.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike2.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    spike2.spikeDATA.waveform_clustIndex_3 = waveform(:, clustIndex_3);
    
    spiketimes = spike3.spikeDATA.waveforms.posWaveInfo.posLocs';
    clustids = spike3.spikeDATA.clustIDS;
    clustIndex_1 = clustids  == 1;
    clustIndex_2 = clustids  == 2;
    clustIndex_3 = clustids  == 3;
    
    %AT 3/20/20 we prob want to merge clusters 2 and 3;
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_1  = spiketimes(clustIndex_1);
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2  = spiketimes(clustIndex_2);
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3  = spiketimes(clustIndex_3);
    %AT 3/20/20 so the 2nd cluster for case 1 is now merged
    spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2 = [spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_2;spike3.spikeDATA.waveforms.posWaveInfo.posLocs_clustIndex_3];
    
    
        %AT added below 4/29/20
    waveformfeatures = spike3.spikeDATA.features;
    spike3.spikeDATA.features_clustIndex_1 = waveformfeatures(clustIndex_1,:);
    spike3.spikeDATA.features_clustIndex_2 = waveformfeatures(clustIndex_2,:);
    spike3.spikeDATA.features_clustIndex_3 = waveformfeatures(clustIndex_3,:);

    spike3.spikeDATA.features_clustIndex_2 = [spike3.spikeDATA.features_clustIndex_2; spike3.spikeDATA.features_clustIndex_3];
         
     %AT added below 4/30/20
    waveform = spike3.spikeDATA.waveforms.allWaves.waves;
    spike3.spikeDATA.waveform_clustIndex_1 = waveform(:, clustIndex_1);
    spike3.spikeDATA.waveform_clustIndex_2 = waveform(:, clustIndex_2);
    spike3.spikeDATA.waveform_clustIndex_3 = waveform(:, clustIndex_3);
    
    spike3.spikeDATA.waveform_clustIndex_2 = [spike3.spikeDATA.waveform_clustIndex_2, spike3.spikeDATA.waveform_clustIndex_3];
    
    
end



end