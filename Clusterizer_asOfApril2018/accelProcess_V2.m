function [] = accelProcess_V2(inPUTS)
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
    inPUTS.LowPfil (1,1) double = 100
    inPUTS.runArtR (1,1) logical = 1
    inPUTS.stDu    (1,1) double = 1.5
    inPUTS.movWin  (1,1) double = 10
end

if contains(inPUTS.dirLOC,"noloc")
    tdirLoc = uigetdir();
    cd(tdirLoc);
else
    tdirLoc = inPUTS.dirLOC;
    cd(tdirLoc);
end

matLIST = getMatNames(tdirLoc , 1);
fldNs = {'X','Y','Z','SumVec'};
for mi = 1:length(matLIST)
    
    miT = matLIST{mi};
    
    load(miT, 'accel')
    accFs = accel.sampFreqHz;
    allDat = load(miT);
    
    for ai = 1:4 % X, Y, Z and XYZ
        
        if ai < 4
            acclU = accel.accS1{ai};
        else
            xAcc = double(accel.accS1{1});
            yAcc = double(accel.accS1{2});
            zAcc = double(accel.accS1{3});
            acclU = sqrt(xAcc.^2 + yAcc.^2 + zAcc.^2);
        end
        
        if isnan(inPUTS.LowPfil)
            accFiltered = double(acclU);
        else
            acceDoub = double(acclU);
            
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

        % SMOOTH 
        accSmooth = movmean(accDecy,round(accFs/4));
        % DETREND
        accDet = detrend(accSmooth,2);

        % REMOVE ARTIFACTS
        if inPUTS.runArtR
            [accArem] = remArt(accDet , inPUTS.stDu , inPUTS.movWin);
        else
            accArem = accDecy;
        end

        if inPUTS.toPlot
            figure;
            plot(accArem)
            pause
            close all
        end
        
        if ai == 1
            allDat.accel.proc.LowPFilt = inPUTS.LowPfil;
            allDat.accel.proc.timeStart = accel.timeStart;
            allDat.accel.proc.timeEnd = accel.timeEnd;
        end
        
        allDat.ACCEL_P.(fldNs{ai}) = accArem;
        
    end

    save(miT,'-struct','allDat')
end

end




function [tmpSignal] = remArt(inSignal , stdU , movWindow)


lmean = mean(inSignal);
lstd = std(inSignal);
bORd = stdU;
uLine = lmean + (lstd*bORd);
bLine = lmean - (lstd*bORd);

artif = inSignal;
artif(inSignal > uLine | inSignal < bLine) = NaN;
tmpSignal = fillmissing(artif,'movmedian',movWindow);



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