function [corInds] = computeASCI_Clz_v01ex(waveforms, idx, crit)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% if numel(unique(idx)) == 1;
%      corInds = nan(length(idx),1);
%      return
% end

if nargin == 2
    crit = 0.665;
end

tempWaves = transpose(waveforms);
nClusts = numel(unique(idx(idx ~=0)));
cid = unique(idx(idx ~=0));
cInd = idx;

corVals = nan(size(tempWaves,1),nClusts);

popWaveLoc = find(ismember(cInd,cid));

for ni = 1:nClusts
   
    % Create Rp, Rn and Rz from clust template
    
    cidi = cid(ni);
    
    cWaves = tempWaves(cInd == cidi,:);
    popWaves = tempWaves(ismember(cInd,cid),:);
    
    meanCw = mean(cWaves);
    
    template = meanCw/max(meanCw);
    
    Rp = nan(size(template));
    Rn = nan(size(template));
    
    for mi = 1:length(template);
        
        tRz = template(mi);
        
        if abs(tRz) <= 0.25
            Rp(mi) = 0.25;
            Rn(mi) = -0.25;
        elseif tRz > 0.25
            Rp(mi) = max([tRz/2, 0.25]);
            Rn(mi) = Rp(mi) - 0.25;
        else
            Rn(mi) = min([tRz/2 , -0.25]);
            Rp(mi) = Rn(mi) + 0.25;
        end
        
    end
    
    
    for ai = 1:size(popWaves,1);
        
        tPopWL = popWaveLoc(ai);
        
        tWave = popWaves(ai,:);
        tWaveN = tWave/max(meanCw);
        
        SY = nan(1,size(tWaveN,2));
        SX = template;
        
        for ti = 1:size(tWaveN,2)
            
            yi = tWaveN(ti);
            if yi < Rp(ti) && yi > Rn(ti)
                SY(ti) = 0;
            elseif yi > Rp(ti)
                SY(ti) = 1;
            elseif yi < Rn(ti)
                SY(ti) = -1;
            end
            
            xi = template(ti);
            if xi < Rp(ti) && xi > Rn(ti)
                SX(ti) = 0;
            elseif xi > Rp(ti)
                SX(ti) = 1;
            elseif xi < Rn(ti)
                SX(ti) = -1;
            end
            
        end
        
        %------------------------------------------------------------
        % To satisfy dot prod makes indicies where both zeros equal 1
        bzInd = SY == 0 & SX == 0;
        SX(bzInd) = 1;
        SY(bzInd) = 1;
        %------------------------------------------------------------
        
        SCC = sum(SY.*SX)/length(SY);
        
        corVals(tPopWL,ni) = SCC;
        
    end

end



corValIndact = nan(length(corVals),2);
corInds = zeros(size(corValIndact,1),1);
for cvi = 1:length(corVals);

    if isnan(corVals(cvi,1))
        continue
    else
        [~, maxInd] = max(corVals(cvi,:));
        
        corValIndact(cvi,1) = cid(maxInd);
        corValIndact(cvi,2) = corVals(cvi,maxInd);
        
        if corValIndact(cvi,2) > crit;
            corInds(cvi) = corValIndact(cvi,1);
        end
        
    end
         
end



% 
% corInds = zeros(size(corValIndact,1),1);
% for ni = 1:nClusts
%     
%     tcl = cid(ni);
%     
%     corInd = corValIndact == tcl & corVals(:,ni) > crit;   
%     
%     corInds(corInd) = tcl;
%     
% end






end

