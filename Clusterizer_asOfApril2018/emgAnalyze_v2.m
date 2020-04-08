function [emgDatOut] = emgAnalyze_v2(inPUTS)
%emgAnalyze_v1 Summary of this function goes here
%   Detailed explanation goes here

arguments
    inPUTS.dirLOC (1,1) string = "noloc" % TEMPORARY
    inPUTS.userPC (1,1) string = "AT" 
    inPUTS.caseNum (1,1) double = NaN % IN USE for CASE NUMBER
    inPUTS.toPlot (1,1) logical = 0 % IN USE for plot check
    inPUTS.alignIND (1,1) double = 2; % IN USE for align selection
end

% CHECK If Case number was input by user

if isnan(inPUTS.caseNum)
    uiGET = inputdlg('Choose Case','CASE',1,{'NaN'});
    uiGETo = str2double(uiGET);
    
    uiCHK = 1;
    while uiCHK
        
        if isnan(uiGETo)
            uiGET = inputdlg('Choose Case','CASE',1,'NaN');
            uiGETo = str2double(uiGET);
        elseif uiGETo <= 0 || uiGETo > 13
            uiGET = inputdlg('Choose Case','CASE',1,'NaN');
            uiGETo = str2double(uiGET);
        else
            uiCHK = 0;
        end
    end
else
    uiGETo = inPUTS.caseNum;
end

% CHECK if case is 8 or 9

if uiGETo == 8 || uiGETo == 9
    SGonly = 1;
else
    SGonly = 0;
end

% SET up PARAS
caseNum = uiGETo;
% alignI = inPUTS.alignIND;


% AT LOAD code
% [caseInfo_table, raw] = import_excelData_auditoryTask_V1(caseNum);
% FROM import_excelData_auditoryTask_V1

if strcmp(inPUTS.userPC,"AT")
    boxLOC = [filesep,strjoin({'Users','andytek','Box','Auditory_task_SNr','Data'},filesep)];
elseif strcmp(inPUTS.userPC,"JT")
    boxLOC = ['D:',filesep,'ATtest'];
end


filepath = fullfile(boxLOC,'IntraoperativeTracking_Data_Sheet.xlsx');

sheetname = 'auditoryTask_masterSheet';
caseNumber_str = mat2str(caseNum);
Table_master = readtable(filepath, 'Sheet', sheetname, 'PreserveVariableNames', true, 'ReadRowNames', true); 
Table_master.("IO date") = datetime(Table_master.("IO date"),'InputFormat','MM/dd/yyyy'); %
caseInfo_table = Table_master(caseNumber_str,:);

% [inputmatrix, rsp_struct] = import_behavior_io_auditoryTask_V1(caseInfo_table);
% FROM import_behavior_io_auditoryTask_V1
behaviorfolder = caseInfo_table.("Name of subfolder with behavioral data on box.com ");
inputmatrix_name = caseInfo_table.("io name of input matrix  file ");
rsp_name = caseInfo_table.("io name of rsp file");
inputmatrix_filePath = fullfile(boxLOC,'io_behavior_data', behaviorfolder, inputmatrix_name);
inputmatrix_rspPath = fullfile(boxLOC,'io_behavior_data', behaviorfolder, rsp_name);
inputmatrix = load(cell2mat(inputmatrix_filePath));
rsp_struct = load(cell2mat(inputmatrix_rspPath));

surgerySide = caseInfo_table.("Target (R/L STN)");
% AT 3/16/20; BClust were clustered at 2 SD and refined down as much as
% possible; while _V2 were clustered to 3SD and largely left unrefined.
% [Ephys_struct, spike1, spike2, spike3] = import_ephys_io_auditoryTask_V1(caseInfo_table, 'processed_spikes_BClust');

ephysLoc = fullfile(boxLOC,'io_neural_data');
[Ephys_struct] = import_ephys_io_auditoryTask_noSPK_V1(caseInfo_table,ephysLoc);

% rsp_struct = rsp_struct1.(rsps_tmpFN{1});
inputmatrix = inputmatrix.input_matrix_rndm;%unpacking, AT
if caseNum == 3 || caseNum == 2 || caseNum == 1
    rData = rsp_struct.rsp_master_v1;%unpacking, AT
elseif caseNum == 4
    rData = rsp_struct.rsp_master_v2;%unpacking, AT
else
    rData = rsp_struct.rsp_master_v3;%unpacking, AT
end

%AT 2/15/20, needed to do some processing on the behavior file rData in
%order have the timings reflect time from beginning of each individual
%trial. This is really important! To account for different versions of our
%task, we should use different versions of the below fx!
if caseNum == 4
    rData = Case04_behavior_adapter(rData);
end

if caseNum == 3 || caseNum == 2 || caseNum == 1
    rData = Case03_behavior_adapter(rData);
end


cutfirst3trials = 0; %set to 1 to cut first three trials of session
cutNearOEs = 1; %point of this input is to remove trials in which rxn is essentially zero; means that pt had already initiate movement before go tone could have been heard
[taskbase_io, ~, index_errors] = behav_file_adapter_V2(rData, inputmatrix, cutfirst3trials, cutNearOEs);

if caseNum == 4
    taskbase_io = Case04_AOstart_adapter_V2(taskbase_io, Ephys_struct, 'trialStart', rData, index_errors); %this should add output field in taskbase struct which contains the start of each trial in the time of the alphaomega clock.
elseif caseNum == 3 || caseNum == 2 || caseNum == 1
    taskbase_io = Case03_AOstart_adapter_V2(taskbase_io, Ephys_struct, 'trialStart', rData, index_errors); %this should add output field in taskbase struct which contains the start of each trial in the time of the alphaomega clock.
else
    taskbase_io = AOstart_adapter_V3(taskbase_io, Ephys_struct, 'trialStart', rData, index_errors); %this should add output field in taskbase struct which contains the start of each trial in the time of the alphaomega clock.
end

%AT adding below on 3/20/20 to account for weirdness in the way file was
%saved.
if caseNum == 1
    taskbase_io.trialStart_AO = taskbase_io.trialStart_AO(14:(end-5));
end

%AT adding below on 3/20/20 to account for weirdness in the way file was
%saved.
if caseNum == 1
    taskbase_io.trialStart_AO = taskbase_io.trialStart_AO(14:(end-5));
end

% %AT adding below in order to get rid of the error'ed trials from
% % index_errors = behavioral_matrix(:,5)==3; %this says, if column five has a 3 in it because 3 means they error'ed on that trial
% % taskbase_io.trialStart_AO(index_errors,:) = []; %remove the whole row

if cutfirst3trials == 1
    taskbase_io.trialStart_AO(1:3,:) = [];
end

GetPhysioGlobals_io_V1;

[choice_trials_L ,...
    choice_trials_R ,...
    nochoice_trials_L ,...
    nochoice_trials_R ,...
    ~ ,...
    ~ ,...
    ~ ,...
    ~] = io_taskindexing_AT_V2(rData, inputmatrix);

choice_trials = choice_trials_L + choice_trials_R; %AT making combined SG index
nochoice_trials = nochoice_trials_L + nochoice_trials_R; %AT making combined SG index

%2/17/19 the point of below is to let us easily plot the just SG trials
if SGonly == 1
    nochoice_trials = choice_trials;
end


%%
% Identify and extract sections of relevant EMG
tmpEphysFields = fieldnames(Ephys_struct);
if sum(contains(tmpEphysFields,{'CEMG_2_P','CEMG_1_P'})) == 0
    disp('NEED TO RUN emgPROCESS_V1!!!')
    return
end
%AT 3/28/20; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
secsDelta = Ephys_struct.emg.proc.timeStart - Ephys_struct.mer.timeStart;
emgBuffer = round(secsDelta * 44000);
emgTaskbase_ioAO = taskbase_io.trialStart_AO + emgBuffer;
taskbase_io.emgTrialStart_AO = emgTaskbase_ioAO;
% delta = Ephys_struct.ttlInfo.timeStart - Ephys_struct.mer.timeStart;
% buffer = round((Ephys_struct.ttlInfo.sampFreqHz)*delta);
% Ephys_struct.ttlInfo.ttl_up = Ephys_struct.ttlInfo.ttl_up+buffer;
% 
% Ephys_struct.ttlInfo.timeStart = Ephys_struct.mer.timeStart;

trial_inds = find((taskbase_io.response == 1) & (choice_trials == 1)); %%%%%%%%%%%%%%%%%%%%%%%%%%% TRIAL INDS - SG LEFT
trial_start_times = taskbase_io.events.trialStart(trial_inds)';

% FUNCTION to extract and 10 trials and resort
%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
[trialStart_times , UPstart ,...
    AudStim , GoCue,...
    MVstart , MVend,...
    fdBack] = getTIMES_v1(taskbase_io, trial_inds  , trial_start_times);

% keyboard;

taskElems = transpose([UPstart ; AudStim ; GoCue ; ...
             MVstart ; MVend ; fdBack]);

% check plot
epochRefTimes = zeros(length(trial_start_times),6);
for ti = 1:length(trial_start_times)
    
    epochRefTimes(ti,:) = taskElems(ti,:) + trialStart_times(ti);

end

% bot = 1:1:size(epochRefTimes,1);
% toP = 2:1:size(epochRefTimes,1) + 1;
% coLrs = 'rbgkcm';
% for epC = 1:6
%     
%    hold on
%    line(transpose([taskElems(:,epC) taskElems(:,epC)]) ,[bot ; toP] , 'Color', coLrs(epC),'LineWidth',2)
%     
% end

% Events: UPstart   |   AudStim   |    GoCue  |    MVstart  |   MVend   |   fdBack
% Epoch 1
%         UPstart ---------------- AudStim 
% Epoch 2 
%         UPstart(-250ms) -------- MVend(-100ms)
% Epoch 3
%         MVstart ---------------- fdBack
% Epoch 4
%         AudStim ---------------- GoCue
% Epoch 5
%         GoCue ------------------ MVstart
% Epoch 6
%         MVstart ---------------- MVend
epochIbeg = [1 ; 1 ; 4 ; 2 ; 3 ; 4];
epochIend = [2 ; 5 ; 6 ; 3 ; 4 ; 5];
epochIbsi = [1 ; -1 ; 1 ; 1 ; 1 ; 1];
epochIesi = [1 ; -1 ; 1 ; 1 ; 1 ; 1];
epochIbo = [0 ; 250 ; 0 ; 0 ; 0 ; 0];
epochIeo = [0 ; 100 ; 0 ; 0 ; 0 ; 0];

epochItab = table(epochIbeg,epochIend,epochIbsi,epochIesi,epochIbo,epochIeo,...
    'VariableNames',{'B_Epoch','E_Epoch','B_EpSign','E_EpSign','B_EpOff','E_EpOff'},...
    'RowNames',{'1','2','3','4','5','6'});

%%%% TO DO 
%%%% 1. Collect EMGs in Cell arrays
%%%% 2. Loop through Epochs
%%%% 3. Summarize with mean and sd

emgIDs = {'CEMG_1_P','CEMG_2_P'};
epochIDs = {'Strt2Stim','PrStrt2PoMVend','MVStrt2fdBk','Stim2GoCue','GoCue2MVStrt','MVStrt2MVend'}; 
emgDatOut = struct;
for emgpI = 1:2
    tmpEi = emgIDs{emgpI};
    if ismember(tmpEi,tmpEphysFields)
        
        emgDATA = Ephys_struct.(tmpEi);
        emgPms = Ephys_struct.emg.proc;
        
        for epoI = 1:6
            
            [emgEpochData , nRMS , zScr , nPwr] = getEMGepoch(epoI,epochRefTimes,emgDATA,emgPms,epochItab);

            emgTABLE = table(nRMS , zScr , nPwr, 'VariableNames',{'nRMS','ZScoreAmp','nPwr'});
            tmpEnames = emgTABLE.Properties.VariableNames;
            sumTab = table;
            for eei = 1:width(emgTABLE)
               
                sumTab.(tmpEnames{eei})('mean') = nanmean(emgTABLE.(tmpEnames{eei}));
                sumTab.(tmpEnames{eei})('std') = nanstd(emgTABLE.(tmpEnames{eei}));
                sumTab.(tmpEnames{eei})('median') = nanmedian(emgTABLE.(tmpEnames{eei}));
                tmpVec = emgTABLE.(tmpEnames{eei});
                tmpNONnan = tmpVec(~isnan(tmpVec));
                sumTab.(tmpEnames{eei})('firstQ') = quantile(tmpNONnan,0.25);
                sumTab.(tmpEnames{eei})('thirdQ') = quantile(tmpNONnan,0.75);
                sumTab.(tmpEnames{eei})('iqr') = iqr(tmpNONnan);
                disp(['Trial ' , num2str(eei), ' done'])
            end
            
            
            emgDatOut.(emgIDs{emgpI}).(epochIDs{epoI}).AllDat = emgTABLE;
            emgDatOut.(emgIDs{emgpI}).(epochIDs{epoI}).Tseries = emgEpochData;
            emgDatOut.(emgIDs{emgpI}).(epochIDs{epoI}).SumDat = sumTab;
            
        end
    else
        continue
    end
end


%%%% SAVE DATA

% Save Name
saveFname = ['EMG_Results_C_', num2str(caseNum) , '.mat'];
% Save Location
neuraldata_folder = caseInfo_table.("Name of subfolder with neural data on box.com ");
fileLOC = fullfile(ephysLoc,neuraldata_folder{1},'emgResult');

if ~exist(fileLOC,'dir')
    mkdir(fileLOC)
end

cd(fileLOC)        
% Conduct the save
save(saveFname,'emgDatOut')




%% Look at L, choice (active decision making) trials %%%
% aka L choices made during SG











end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tSt , uPt ,...
    sDt1 , gCt,...
    leftUt , submitRt1,...
    feedBt] = getTIMES_v1(taskbase_io, trial_inds ,trial_start_times)

t2Plot = 1:length(trial_start_times);

nTrInds = trial_inds(t2Plot);

sDt1 = taskbase_io.events.stimDelivered(nTrInds)';
submitRt1 = taskbase_io.events.submitsResponse(nTrInds)';

% [~, rEsortTind] = sort(submitRt1 - sDt1);
% nTrInds2 = nTrInds(rEsortTind);

% sDt2 = taskbase_io.events.stimDelivered(nTrInds2)';
% submitRt2 = taskbase_io.events.submitsResponse(nTrInds2)';

tSt = (taskbase_io.emgTrialStart_AO(nTrInds)')/(44000); % SET TO TTL collection Hz
uPt = taskbase_io.events.upPressed(nTrInds)';

gCt = taskbase_io.events.goCue(nTrInds)';
leftUt = taskbase_io.events.leftUP(nTrInds)';

feedBt = taskbase_io.events.feedback(nTrInds)';


end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [emgEpochData , emgnRMS , emgZscrAmp , emgNpwr] = getEMGepoch(epochID,epochTimes,EMGraw,emgParams,epochItab)

%%%%%%% CHECK OFFSET OF EMG CLOCK AND NO CLOCK!!!!!!!!!!!!!!!!!!!

trialNUM = size(epochTimes,1);

[sampLenLong , epAbsTrefs] = getLongSamp(epochTimes , epochID , epochItab , emgParams.Fs);

emgTS = (0:1:length(EMGraw))/emgParams.Fs;

emgEpochData = nan(trialNUM,sampLenLong);
emgnRMS = zeros(trialNUM,1);
emgZscrAmp = zeros(trialNUM,1);
emgNpwr = zeros(trialNUM,1);

for ei = 1:trialNUM
    
    ep_b_s = epAbsTrefs(ei,1);
    ep_e_s = epAbsTrefs(ei,2);
    
    [~ , ep_b_i] = min(abs(emgTS - ep_b_s));
    [~ , ep_e_i] = min(abs(emgTS - ep_e_s));
    
    epBIN = ep_b_i:1:ep_e_i;
    
    emgDlen = length(epBIN);
    
    emgEpochData(ei,1:emgDlen) = EMGraw(epBIN);
    
    [nRMS , zScoreAmp , nPwr] = analyzeEMG(epBIN , ep_b_s , ep_e_s , EMGraw);
    
    emgnRMS(ei) = nRMS;
    emgZscrAmp(ei) = zScoreAmp;
    emgNpwr(ei) = nPwr;

end

end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sampLong , epAbsVecs] = getLongSamp(epochTimes , epochID, epochItab , emgFS)

ep2u = epochItab(epochID,:);

epBtmes = epochTimes(:,ep2u.B_Epoch) + (ep2u.B_EpSign*ep2u.B_EpOff);
epEtmes = epochTimes(:,ep2u.E_Epoch) + (ep2u.E_EpSign*ep2u.E_EpOff);

epAbsVecs = [epBtmes , epEtmes];

epTimesAll = epEtmes - epBtmes;

sampLong = ceil(max(epTimesAll)*emgFS);

end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [nRMS , zScoreAmp , nPwr] = analyzeEMG(EMGbin ,epBs , epEs , EMGrawWhole)

% nFs = 44000;
% %%% TRIM off ends to remove high offsets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Trim front and back with TTL
% ttlMaxInd = max(ttlTIMEs) + (nFs*5);
% ttlMinInd = min(ttlTIMEs) - (nFs*5);
% ttLMinClock = ttlMinInd/nFs;
% ttLMaxClock = ttlMaxInd/nFs;
% 
% emgClockts = linspace(1,length(EMGrawWhole),length(EMGrawWhole))/5500;
% 
% [~, ttlMinLOC] = min(abs(emgClockts - ttLMinClock));
% [~, ttlMaxLOC] = min(abs(emgClockts - ttLMaxClock));
% 
% EMGrawPad = EMGrawWhole;
% EMGrawPad(1:ttlMinLOC) = NaN;
% EMGrawPad(ttlMaxLOC:end) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zScoreWhole = zscore(EMGrawWhole);
EMGrawSamp = EMGrawWhole(EMGbin);

% rmsWHOLE = 
nRMS = sqrt(mean(EMGrawSamp.^2));
zScoreAmp = mean(zScoreWhole(EMGbin));

[pSpec,freQ,tS] = pspectrum(EMGrawWhole,5500,'spectrogram','TimeResolution',0.2);

[~ , ep_b_i] = min(abs(tS - epBs));
[~ , ep_e_i] = min(abs(tS - epEs));

% nSpec = normalize(pSpec,'range');

nPwr = mean(mean(pSpec(freQ < 20 & freQ > 0.5, ep_b_i:1:ep_e_i)));

end

