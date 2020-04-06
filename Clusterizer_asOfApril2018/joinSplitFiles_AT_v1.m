function [] = joinSplitFiles_AT_v1(dirLOC)

cd(dirLOC)

toTList = getMatNames(dirLOC , 1);

[firF , secF] = getFileInfoOrder(toTList);
% Check offset

block1_end = firF.mer.TimeEnd;
block2_start = secF.mer.TimeBegin;

timeDiff = block2_start - block1_end;
fNsAll = fieldnames(firF);
fNsSummary = {'accel','emg','mer','mLFP','lfp','ttl','fName'};
fNsCycle = fNsAll(~ismember(fNsAll,fNsSummary));

combStruct = struct;
for ci = 1:length(fNsCycle)
    
    tmpN = fNsCycle{ci}(1:4);
    tmpA = fNsCycle{ci};
    firC = double(firF.(tmpA));
    secC = double(secF.(tmpA));
    
    switch tmpN
        case {'CACC','CEMG','CLFP','CMac','CSPK'}
            switch tmpN
                case 'CACC'
                    sampF = firF.accel.KHz;
                case 'CEMG'
                    sampF = firF.emg.KHz;
                case 'CLFP'
                    sampF = firF.mLFP.KHz;
                case 'CMac'
                    sampF = firF.lfp.KHz;
                case 'CSPK'
                    sampF = firF.mer.KHz;
            end
            buffSamp = round(timeDiff * sampF * 1000);
            bufferZ = NaN(1,buffSamp,'like',firC);
            combine = [firC , bufferZ , secC];
            combStruct.(tmpA) = combine;
        case 'CDIG'
            sampF = firF.ttl.KHz;
            buffSamp = round(timeDiff * sampF * 1000);
            combine = [firC , firC(end) + secC + buffSamp];
            combStruct.(tmpA) = combine;
    end
end

for si = 1:length(fNsSummary)
    
    tmpA = fNsSummary{si};
    firC = firF.(tmpA);
    secC = secF.(tmpA);
    switch tmpA
        case {'accel','emg','mer','mLFP','lfp'}
            combStruct.(tmpA).TimeBegin = firC.TimeBegin;
            combStruct.(tmpA).TimeEnd = secC.TimeEnd;
            combStruct.(tmpA).KHz = firC.KHz;
            combStruct.(tmpA).BitResolution = firC.BitResolution;
            combStruct.(tmpA).Gain = firC.Gain;
        case 'ttl'
            combStruct.(tmpA).TimeBegin = firC.TimeBegin;
            combStruct.(tmpA).TimeEnd = secC.TimeEnd;
            combStruct.(tmpA).KHz = firC.KHz;
        case 'fName'
            
            tFirC = firC;
            tFPs = strsplit(tFirC,'.');
            tFirN = [tFPs{1},'.',tFPs{2},'.COM.mat'];
            
            combStruct.(tmpA) = tFirN;
    end
    
    
end

save(tFirN,'-struct','combStruct')


end % END of FUNCTION







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




%%%% GET FILE INFO and ORDER
function [First , Second] = getFileInfoOrder(toTList)

allDat = cell(1,2);
ordeR = zeros(1,2);
tmpTime = 0;
for ti = 1:length(toTList)
   
    tmpMat = toTList{ti};
    allDat{ti} = load(tmpMat);

    if allDat{ti}.ttl.TimeBegin > tmpTime
        tmpTime = allDat{ti}.ttl.TimeBegin;
        ordeR(2) = ti;
    else
        ordeR(1) = ti;
    end
    
end

First = allDat{ordeR == 1};
First.fName = toTList{ordeR == 1};
Second = allDat{ordeR == 2};
Second.fName = toTList{ordeR == 2};
end