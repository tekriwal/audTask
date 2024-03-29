function [] = emgPROCESS_V1(inPUTS)
% emgPROCESS_V1
% Default inputs with plot Example:
% [] = emgPROCESS_V1('toPlot',1)
% Point function to folder with Raw NeuroOmega file
%
% File will load EMG 1 and EMG 2
% 
% It will conduct the following processing steps
% 
% 1. Rectify - convert all values to positive deflections
% 2. Run a low pass filter (default 80 Hz)
% 3. Remove artifacts with 4 SD
% 4. Linear detrend
% 5. Downsample to 250 Hz
% 6. Trim the recording between 10 seconds before first TTL and 10 seconds
% after last TTL
% %
% %
% CRITICAL
% It will add two new fields to file
% 1. CEMG_1_P 
% 2. CEMG_2_P
% It will add new fields to the .emg field
% 1. New Fs = 250
% 2. New timeBegin
% 3. New timeEnd

arguments
    inPUTS.dirLOC (1,1) string = "noloc"
    inPUTS.dnSamp (1,1) double = NaN
    inPUTS.toPlot (1,1) logical = 0
    inPUTS.LowPfil (1,1) double = NaN
    inPUTS.trimOpt (1,1) logical = 0
end

if contains(inPUTS.dirLOC,"noloc")
    tdirLoc = uigetdir();
    cd(tdirLoc);
else
    tdirLoc = inPUTS.dirLOC;
    cd(tdirLoc);
end

matLIST = getMatNames(tdirLoc , 1);

for mi = 1:length(matLIST)
    
    miT = matLIST{mi};
    
    load(miT, 'emg')
    
    emgFs = emg.sampFreqHz;
    
    for i = 1:2
        allDat = load(miT);
        switch i
            case 1
                emg1 = load(miT, 'CEMG_2___01');
                emgU = emg1.('CEMG_2___01');
            case 2
                emg1 = load(miT, 'CEMG_2___02');
                emgU = emg1.('CEMG_2___02');
        end
        
        %         emg1 = emg1(round(x(1)):round(x(2)));
        
        if isnan(inPUTS.LowPfil)
            emgFiltered = emgU;
        else
            rect = abs(double(emgU));
            [bl , al] = butter(2,inPUTS.LowPfil/(emgFs/2),'low');
            emgFiltered = filtfilt(bl,al,rect);
        end
        %Reck: Down-sample data to 250Hz to minimize data size
        if isnan(inPUTS.dnSamp)
            decy = emgFiltered;
        else
            decy = decimate(emgFiltered,round(emgFs/inPUTS.dnSamp));
        end
        % REMOVE ARTIFACTS
        if inPUTS.trimOpt
            [sigClear , emgTn] = trimSignal(decy , allDat.emg , allDat.ttlInfo , inPUTS.dnSamp , inPUTS.trimOpt);
        else
            sigClear = decy;
            emgTn.StartTimeNew = allDat.emg.timeStart;
            emgTn.EndTimeNew = allDat.emg.timeEnd;
        end
        
        % DETREND
        finDT = detrend(double(sigClear));
        % RECTIFY
        recDT = abs(finDT);
        % HIBBERT ENVELOPE
        windLength = 500;
        [ampEnvDT , ~] = envelope(recDT,windLength,'rms');
        % SMOOTH DATA
        [finalDT , ~] = smoothdata(ampEnvDT,'movmedian',round(length(sigClear)*0.0025));

        if inPUTS.toPlot
            figure;
            plot(finalDT)
        end
        
        if isnan(inPUTS.dnSamp)
            allDat.emg.proc.Fs = allDat.emg.sampFreqHz;
        else
            allDat.emg.proc.Fs = inPUTS.dnSamp;
        end
        
        allDat.emg.proc.LowPFilt = inPUTS.LowPfil;
        allDat.emg.proc.timeStart = emgTn.StartTimeNew;
        allDat.emg.proc.timeEnd = emgTn.EndTimeNew;
        
        if i == 1
            allDat.CEMG_1_P = finalDT;
            save(miT,'-struct','allDat')
        else
            allDat.CEMG_2_P = finalDT;
            save(miT,'-struct','allDat')
        end
        
    end

end

end




function [tmpSignal , emgT] = trimSignal(inSignal , emg , ttlInfo , nFs , trimOpt)


floatS = double(inSignal);

% Trim front and back with TTL
ttlMaxInd = max([ttlInfo.ttl_dn , ttlInfo.ttl_up]) + (nFs*10);
ttlMinInd = min([ttlInfo.ttl_dn , ttlInfo.ttl_up]) - (nFs*10);
ttLMinClock = ttlInfo.ttlTimeBegin + ttlMinInd/44000;
ttLMaxClock = ttlInfo.ttlTimeBegin + ttlMaxInd/44000;

emgClockts = linspace(1,length(floatS),length(floatS))/nFs + emg.timeStart;

[~, ttlMinLOC] = min(abs(emgClockts - ttLMinClock));
[~, ttlMaxLOC] = min(abs(emgClockts - ttLMaxClock));

if trimOpt
    tmpSignal = floatS(ttlMinLOC:ttlMaxLOC);
else
    tmpSignal = floatS;
end

% Detrend
% floatST = detrend(tmpSignal);
% 
% % Find artifcats
% % badCutOff = round(abs(mean(floatST) + (std(floatST))*4));
% % badIndexes = floatST > badCutOff;
% 
% % Remove artifcats
% newSignal = floatST;
% 
% gausSmooth = smoothdata(newSignal,'gaussian',75);
% 
% outSignal = movmean(gausSmooth ,125);

% newSignal(badIndexes) = 0;

% outSignal = newSignal;

if trimOpt
    emgT.StartTimeNew = emg.timeStart + (ttlMinLOC/nFs);
    emgT.EndTimeNew = emg.timeStart + (ttlMaxLOC/nFs);
else
    emgT.StartTimeNew = emg.timeStart;
    emgT.EndTimeNew = emg.timeEnd;
end

end




%%%% GETMATNAMES FUNCTION
function [outMatNames] = getMatNames(mainDir,matflag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cd(mainDir)

if matflag
    getCons = dir('*.mat');
else
    getCons = [dir('*.mat'); dir('*.txt')];
end

outMatNames = {getCons.name};

end