function [] = plotClustCheck( waveForms , nidx , stage)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

tempWaves = transpose(waveForms);

if stage == 1
    
    cols = 'rgbkm';
    % nums = [1,2,5];
    nidxes = unique(nidx);
    for ti = 1:numel(nidxes)
        
        figure;
        
        nuM = nidxes(ti);
        plot(tempWaves(nidx == nuM,:)','k')
        hold on
        plot(mean(tempWaves(nidx == nuM,:)),'Color',cols(ti));
        ylim([-5000 5000])
        title(num2str(size(tempWaves(nidx == nuM,:),1)));
        
        
    end
    
    figure;
    for ti = 1:numel(nidxes)
        
        
        
        nuM = nidxes(ti);
        
        plot(mean(tempWaves(nidx == nuM,:)),'Color',cols(ti));
        hold on
        ylim([-5000 5000])
        
        
    end
    
elseif stage == 2
    
    colors = 'rbgck';
    
    allCvals = unique(nidx);
    cluVals = allCvals(allCvals ~= 0);
    
    if any(isnan(cluVals))
        disp('Only one cluster')
        return
    end
        
    
    for ni = 1:numel(cluVals)
        
        nuM = cluVals(ni);
  
        corInd = nidx == nuM;

        figure;
        plot(tempWaves(corInd,:)',colors(ni))
        ylim([min(tempWaves(:)) max(tempWaves(:))]);

        numWaves = sum(corInd);
        
        titleStr = ['Clust ', num2str(ni) , ' = '  , num2str(numWaves)];
        title(titleStr);
        
        figure;
        plot(mean(tempWaves(corInd,:))',colors(ni),'LineWidth',2)
        ylim([min(tempWaves(:)) max(tempWaves(:))]);

    end
    
    
    figure;
    for ni = 1:numel(cluVals)
        
        nuM = cluVals(ni);
  
        corInd = nidx == nuM;
        plot(mean(tempWaves(corInd,:))',colors(ni),'LineWidth',2)
        hold on
        
    end
    
    
    
    
end


end

