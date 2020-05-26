clear; close all

datCell = cell(13,1);
for ci = 1:13
    close all; 
    datCell{ci} = final_AT_DBSrecLoc_v1(ci);
end

%%
close all;
allSpk = nan(50,2);
spkC = 1;
snrIOc = 0;
for ti = 1:13
   
    tmpS = datCell{ti};
    
    tmpF = fieldnames(tmpS);
    
    for ti2 = 1:length(tmpF)
        
        tOI = tmpS.(tmpF{ti2}).ioBrainRg;
        tNR = tmpS.(tmpF{ti2}).recBrainRg;
        
        if strcmp(tOI,tNR)
            allSpk(spkC,1) = 1;
        else
            allSpk(spkC,1) = 0;
        end
        
        if strcmp(tOI,'SNR')
            allSpk(spkC,2) = 1;
        else
            allSpk(spkC,2) = 0;
        end
        
        spkC = spkC + 1;
    end
end

allSpkf = allSpk(~isnan(allSpk(:,1)),:);

allSpkFrac = sum(allSpkf(:,1)) / size(allSpkf,1);

snrSpkFrac = sum(allSpkf(logical(allSpkf(:,2)),1)) / numel(allSpkf(logical(allSpkf(:,2)),1));
