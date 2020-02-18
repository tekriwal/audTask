function [ idxF ] = clusterSingle_v1( waveForms, clustInd, clustID, Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



tempWaves1 = transpose(waveForms);
tempWaves2 = tempWaves1(clustInd == clustID,:);

[ xFeats ] = createSpkFeatures2( transpose(tempWaves2),  Fs , 0 );

% [ ~ , Knum2use ] = threshEstimate( sampData , spkData,  handles.spkFS );

[~,b] = pca(xFeats);


[idxF,~] = kmeans(b(:,1:2),2,'Distance','cityblock',...
    'Replicates',6);

% [ nidx , ~ , ~] = spkClusterQual_Sing( b(:,1:2), idxF, Cen, 2 );



%%





end

