function [] = accelProcess_V1(inPUTS)
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
    inPUTS.LowPfil (1,1) double = 150
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
    
    load(miT, 'accel')
    accFs = accel.sampFreqHz;
    allDat = load(miT);
    acclU = accel.accS1{1};
    
    if isnan(inPUTS.LowPfil)
        accFiltered = double(acclU);
    else
        acceDoub = double(acclU);
%         [bl , al] = butter(2,inPUTS.LowPfil/(accFs/2),'low');
%         accFiltered = filtfilt(bl,al,accRect);
        
        Hd = designfilt('lowpassfir','FilterOrder',20,'CutoffFrequency',inPUTS.LowPfil,...
            'DesignMethod','window','Window',{@kaiser,3},'SampleRate',accFs);

        accFiltered = filtfilt(Hd,acceDoub);

    end
    %Reck: Down-sample data to 250Hz to minimize data size
    if isnan(inPUTS.dnSamp)
        accDecy = accFiltered;
    else
        accDecy = decimate(accFiltered,round(accFs/inPUTS.dnSamp));
    end
    % REMOVE ARTIFACTS
    if inPUTS.trimOpt
        [accTrim , accTime] = trimSignal(accDecy , allDat.accel , allDat.ttlInfo , inPUTS.dnSamp , inPUTS.trimOpt);
    else
        accTrim = accDecy;
        accTime.StartTimeNew = allDat.accel.timeStart;
        accTime.EndTimeNew = allDat.accel.timeEnd;
    end
    
    % SMOOTH
    accSmooth = movmean(accTrim,round(Fs/3));
    % DETREND
    accFinal = detrend(accSmooth,2);
    
    if inPUTS.toPlot
        figure;
        plot(accFinal)
    end

    allDat.accel.proc.LowPFilt = inPUTS.LowPfil;
    allDat.accel.proc.timeStart = accTime.StartTimeNew;
    allDat.accel.proc.timeEnd = accTime.EndTimeNew;
    
    allDat.ACCEL_P = accFinal;
    save(miT,'-struct','allDat')
end

end




function [tmpSignal , accT] = trimSignal(inSignal , accel , ttlInfo , nFs , trimOpt)


floatS = double(inSignal);

% Trim front and back with TTL
ttlMaxInd = max([ttlInfo.ttl_dn , ttlInfo.ttl_up]) + (nFs*10);
ttlMinInd = min([ttlInfo.ttl_dn , ttlInfo.ttl_up]) - (nFs*10);
ttLMinClock = ttlInfo.ttlTimeBegin + ttlMinInd/44000;
ttLMaxClock = ttlInfo.ttlTimeBegin + ttlMaxInd/44000;

emgClockts = linspace(1,length(floatS),length(floatS))/nFs + accel.timeStart;

[~, ttlMinLOC] = min(abs(emgClockts - ttLMinClock));
[~, ttlMaxLOC] = min(abs(emgClockts - ttLMaxClock));

if trimOpt
    tmpSignal = floatS(ttlMinLOC:ttlMaxLOC);
else
    tmpSignal = floatS;
end


if trimOpt
    accT.StartTimeNew = accel.timeStart + (ttlMinLOC/nFs);
    accT.EndTimeNew = accel.timeStart + (ttlMaxLOC/nFs);
else
    accT.StartTimeNew = accel.timeStart;
    accT.EndTimeNew = accel.timeEnd;
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