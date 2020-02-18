function [ expData ] = extractWaveforms_Clz_v02(spikeData, spkThresh, noisThresh, minDist, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Initial Vars
sampLen = round(Fs/1000);
% boundary = sampLen*2;

% Positive waves
[~, pWavesLocs] = findpeaks(spikeData,'MinPeakHeight',spkThresh,...
    'MinPeakDistance',minDist);

% Negative waves
% ridP = spikeData;
% ridP(ridP > 0) = 0;
% [~, nWavesLocs] = findpeaks(abs(ridP),'MinPeakHeight',spkThresh,...
%     'MinPeakDistance',minDist);

% Positive Noise
[~, pNoiseLocs] = findpeaks(spikeData,'MinPeakHeight',noisThresh);

pNoiseInds = ~ismember(pWavesLocs,pNoiseLocs);
pWavesLocs = pWavesLocs(pNoiseInds);
pWavesLocs = pWavesLocs(pWavesLocs > sampLen);

% Negative Noise
% [~, nNoiseLocs] = findpeaks(abs(ridP),'MinPeakHeight',noisThresh);
% 
% nNoiseInds = ~ismember(nWavesLocs,nNoiseLocs);
% nWavesLocs = nWavesLocs(nNoiseInds);
% nWavesLocs = nWavesLocs(nWavesLocs > sampLen);


% numViols = 0;
% violInds = false(length(nWavesLocs),1);
% for pi = 1:length(pWavesLocs)
%    
%     tmpP = pWavesLocs(pi);
%     
%     if any(nWavesLocs > tmpP - boundary & nWavesLocs < tmpP + boundary)
%         numViols = numViols + 1;
%         
%         violInd = nWavesLocs > tmpP - boundary & nWavesLocs < tmpP + boundary;
%         
%         violInds(violInd) = 1;
%         
%     else
%         continue
%     end
%   
% end

% nWavesLocs = nWavesLocs(~violInds);

posWaves = computeWaves(1,spikeData,pWavesLocs,sampLen);
% negWaves = computeWaves(-1,spikeData,nWavesLocs,sampLen);

% allWaves = [negWaves , posWaves];
allWaves = posWaves;
% allLocs = [nWavesLocs , pWavesLocs];
allLocs = pWavesLocs;

expData.waveAnylsInfo.spkThresh = spkThresh;
expData.waveAnylsInfo.noiseThresh = noisThresh;

expData.allWaves.waves = allWaves;
expData.allWavesInfo.numWaves = size(allWaves,2);
expData.allWavesInfo.alllocs = allLocs;
% expData.negWaveInfo.waves = negWaves;
% expData.negWaveInfo.numWaves = size(negWaves,2);
% expData.negWaveInfo.neglocs = nWavesLocs;
expData.posWaveInfo.waves = posWaves;
expData.posWaveInfo.numWaves = size(posWaves,2);
expData.posWaveInfo.posLocs = pWavesLocs;





end




% Subfunction
function [WavesOut] = computeWaves(nOp,spkData,waves,sampLen)

totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.8)-1));


WavesOut = zeros(totLen, length(waves));
for ai = 1:length(waves)
    
    locP = waves(ai);
    sampPeriod = locP - (sampLen/2):locP + (round(sampLen*0.8)-1);
    
    if any(sampPeriod > length(spkData))
        
        WavesOut(:,ai) = [];
        
        break
    else
        if nOp == -1
            WavesOut(:,ai) = (spkData(sampPeriod))*-1;
        elseif nOp == 1
            WavesOut(:,ai) = spkData(sampPeriod);
        end
        
    end
    
end



end