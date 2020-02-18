function [ outthresh , outKclu ] = threshEstimate( sampData , spkData,  spkFS )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


startThresh = 4;
startKclu = 6;
crit = true;

knCount = 0;
thCount = 0;

while crit
    
    thresh = (round(std(double(sampData)) * startThresh) + mean(double(sampData)));
    noise = (round(std(double(sampData)) * 12) + mean(double(sampData)));
    minDist = round(spkFS/1000) * 1.9;
    
    [ waveData ] = extractWaveforms_Clz_v01(spkData, thresh, noise, minDist, spkFS);
    
    waveForms = waveData.allWaves.waves;
    
    % STEP 4 COMPILE FEATURES
    
    if size(waveForms,2) < 7
        outKclu = startKclu;
        outthresh = startThresh;
        return
    end
    
    [ xFeats ] = createSpkFeatures( waveForms, spkFS  );
    
    % STEP 5 OBTAIN INITIAL CLUSTERS
    
    [idxF, Cen] = kmeans(xFeats,startKclu,'Distance','cityblock',...
        'Replicates',6);
    
    if size(xFeats,1) < 30
        outKclu = startKclu;
        outthresh = startThresh;
        crit = false;
    else
        
        [ ~ , lmetrics , ~] = spkClusterQual( xFeats, idxF, Cen, 1 );
        
        if startThresh <= 6
            
            if all(lmetrics.IsDs < 20 | lmetrics.LRat > 0.4)
                startThresh = startThresh + 0.5;
            elseif any(lmetrics.IsDs > 20 | lmetrics.LRat < 0.4)
                if sum(lmetrics.IsDs > 20 & lmetrics.LRat < 0.4) >= 2
                    outKclu = startKclu;
                    outthresh = startThresh;
                    crit = false;
                else
                    
                    if knCount == thCount
                        
                        startThresh = startThresh + 0.5;
                        thCount = thCount + 1;
                        crit = true;
                        
                    elseif knCount ~= thCount
                        
                        startKclu = startKclu - 1;
                        knCount = knCount + 1;
                        crit = true;
                        
                    end
                end
            end
            
        else
            outKclu = 5;
            outthresh = 5;
            crit = false;
        end
    end
end


end

