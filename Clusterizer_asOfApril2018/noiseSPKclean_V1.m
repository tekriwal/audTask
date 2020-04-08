function [] = noiseSPKclean_V1(dirLOC , fName , plotCk)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


cd(dirLOC)

tmpDat = load(fName);

fNsAll = fieldnames(tmpDat);
fNsSummary = {'accel','emg','mer','mLFP','lfp','ttl','fName',...
    'CDIG_IN_1_Up','CDIG_IN_1_Down'};
fNsCycle = fNsAll(~ismember(fNsAll,fNsSummary));

cleanStruct = struct;
for ci = 1:length(fNsCycle)
    
    tmpN = fNsCycle{ci}(1:4);
    tmpA = fNsCycle{ci};
    
    switch tmpN
        case 'CACC'
            sampF = tmpDat.accel.KHz;
        case 'CEMG'
            sampF = tmpDat.emg.KHz;
        case 'CLFP'
            sampF = tmpDat.mLFP.KHz;
        case 'CMac'
            sampF = tmpDat.lfp.KHz;
        case 'CSPK'
            sampF = tmpDat.mer.KHz;
    end
    

    signal = double(tmpDat.(tmpA));
    
    nanIND = isnan(signal);
    % To Get Cut off value
    toDsignal = signal;
    toDsignal(nanIND) = 0;
    tSignal = detrend(toDsignal);
    trSignal = abs(tSignal);
    badCutOff = round(abs(mean(trSignal) + (std(trSignal))*4));
    
    % Was 35 for spike
    % FIND badIndex locations
    badIndexes = trSignal > badCutOff;
    
    % Revert back to original signal
    newSignal = tSignal;
    newSignal(badIndexes) = 0;

    newSignali = newSignal;
    newSignali(isnan(newSignal)) = 0;
    
    % Max TTL + 10 seconds to remove last bit of recording
    
    ttlMaxInd = max([tmpDat.CDIG_IN_1_Down , tmpDat.CDIG_IN_1_Up]) + (sampF*1000*10);
    ttlMaxTime = ttlMaxInd/44000;
    ttlMaxNewf = round(ttlMaxTime * sampF * 1000);
    
    newSignalt = newSignali(1:ttlMaxNewf);
    
    if plotCk
        
        plot(newSignalt)
        pause
        keyboard
        close all
        
    end
    cleanStruct.(tmpA) = newSignalt;
    
    
end

for si = 1:length(fNsSummary)
    
    tmpS = fNsSummary{si};
    cleanStruct.(tmpS) = tmpDat.(tmpS);
    
end

% FileName
tFirC = tmpDat.fName;
tFPs = strsplit(tFirC,'.');

if length(tFPs) == 4
    tFPs2 = [tFPs(1) , tFPs(2) , tFPs(3), {'CL'}, tFPs(4)];
else
    tFPs2 = [tFPs(1) , tFPs(2) , {'CL'}, tFPs(3)];
end

tFirN = strjoin(tFPs2,'.');
% Save Location
cleanStruct.fName = tFirN;
cleanStruct.mer.timeStart = tmpDat.mer.TimeBegin;
cleanStruct.mer.sampFreqHz = tmpDat.mer.KHz*1000;
save(tFirN,'-struct','cleanStruct')

end

