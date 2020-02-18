function [metrics] = clusterQual_at(featMatrix, clusIND , clustID)

nSpikes = size(featMatrix,1);

IsolDist = 0; % > 20
Lratio = 0; % < 0.4

i = clustID;

ClusterSpikes = find(clusIND == i);

%     if length(ClusterSpikes) < size(normalX,2)
%         Lratio(i) = 0.8;
%         IsolDist(i) = 5;
%         continue
%     end

nClusterSpikes = length(ClusterSpikes);
NoiseSpikes = setdiff(1:nSpikes, ClusterSpikes);
m = mahal(featMatrix, featMatrix(ClusterSpikes,:));

%     mCluster = m(ClusterSpikes);
mNoise = m(NoiseSpikes);

df = size(featMatrix,2);

L = sum(1-chi2cdf(m(NoiseSpikes),df));
Lratio = L/nClusterSpikes;


%     InClu = ismember(1:nSpikes, ClusterSpikes);
if (nClusterSpikes < nSpikes/2)
    [sorted, ~] = sort(mNoise);
    IsolDist = sorted(nClusterSpikes);
else
    IsolDist = NaN;
end

metrics.IsDs = IsolDist;
metrics.LRat = Lratio;



end
