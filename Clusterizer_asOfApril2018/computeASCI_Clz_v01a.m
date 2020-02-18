function [corInds] = computeASCI_Clz_v01a(waveforms, idx, crit)
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

nClusts = numel(unique(idx(idx ~= 0)));
cid = unique(idx(idx ~= 0));
cInd = idx;

waves2use = tempWaves(ismember(cInd, cid),:);
w2uAInd = find(ismember(cInd, cid));
wNOTind = ~ismember(cInd, cid);

corVals = zeros(size(tempWaves,1),nClusts);

for ni = 1:nClusts
   
    % Create Rp, Rn and Rz from clust template
    
    cidi = cid(ni);
    
    cWaves = tempWaves(cInd == cidi,:);
    
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
    
    
    for ai = 1:size(waves2use,1);
        
        w2uInd = w2uAInd(ai);
        
        tWave = waves2use(ai,:);
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
        
        corVals(w2uInd,ni) = SCC;
        
    end

end

[~, corValInd] = max(corVals,[],2);
corValInd(wNOTind) = 0;
% Remap corValInd to acutal IDs
corValIndact = zeros(length(corValInd),1);
for mii = 1:numel(unique(corValInd(corValInd ~= 0)));
   
    trLc = cid(mii);

    ind2rep = corValInd == mii;
    
    corValIndact(ind2rep) = trLc;
    
end


corInds = zeros(size(corValIndact,1),1);
for ni = 1:nClusts
    
    tcl = cid(ni);
    
    corInd = corValIndact == tcl & corVals(:,ni) > crit;   
    
    corInds(corInd) = tcl;
    
end






end

