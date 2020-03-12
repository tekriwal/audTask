function [outDat] = AT_subClusCk(inPUTS)
% AT_SUBCLUSCK
% Default inputs with plot Example:
% [outDat] = AT_subClusCk('toPlot',1)


arguments
    inPUTS.fLoc (1,1) string = "noloc"
    inPUTS.SDi (1,1) double = 1
    inPUTS.toPlot (1,1) logical = 0
end


if contains(inPUTS.fLoc,"noloc")
    [fName , fdir] = uigetfile();
    fileLoad = fullfile(fdir,fName);
else
    fileLoad = char(inPUTS.floc);
end

load(fileLoad);

numFeats = size(spikeDATA.features,1);

if numFeats < 3000
    num2use = 1:1:numFeats;
else
    num2use = randsample(numFeats,3000);
end

spkSample = spikeDATA.features(num2use,:);
cluSample = spikeDATA.clustIDS(num2use);

disp('Running TSNE.....')
tsneOUT = tsne(spkSample, 'Algorithm','exact','Distance','mahalanobis');
disp('TSNE Done.....')
uniC = unique(spikeDATA.clustIDS);

[censAll , xSTDall , ySTDall , polyAll] = getSTATS(tsneOUT , uniC , cluSample , inPUTS.SDi);

TF = overlaps(polyAll);

outDat.overlapMat = TF;
outDat.cluspoly = polyAll;
outDat.censAll = censAll;
outDat.xSTDall = xSTDall;
outDat.ySTDall = ySTDall;
outDat.orgFeats = spikeDATA.features;
outDat.subFeats = spkSample;
outDat.orgCLids = spikeDATA.clustIDS;
outDat.subCLids = cluSample;
outDat.cluID = uniC;


if inPUTS.toPlot
    plotFUN(outDat)
end

end



%%% Functions

function [cens , xSTD , ySTD , polyS] = getSTATS(tsneIN , uniCs , cluSam , stdU)

cens = zeros(length(uniCs) , 2);
xSTD = zeros(length(uniCs) , 1);
ySTD = zeros(length(uniCs) , 1);
polyS = [];

for ui = 1:length(uniCs)
   tmpCLR = cluSam == uniCs(ui);
   tmpTSNE = tsneIN(tmpCLR,:);
   
   cens(ui , :) = mean(tmpTSNE);
   xSTD(ui) = std(tmpTSNE(:,1)) * stdU;
   ySTD(ui) = std(tmpTSNE(:,2)) * stdU;
   
   [xCoords , yCoords] = ellipseGet(cens(ui,:) , xSTD(ui) , ySTD(ui));
   
   polyS = [polyS , polyshape(xCoords , yCoords)];
 
end

end



%%%% 
function [xCoords , yCoords] = ellipseGet(xy , xRad , yRad)


xCenter = xy(1);
yCenter = xy(2);
xRadius = xRad;
yRadius = yRad;
theta = 0 : 0.01 : 2*pi;
xCoords = xRadius * cos(theta) + xCenter;
yCoords = yRadius * sin(theta) + yCenter;


end


function [] = plotFUN(inDAT)



numPs = length(inDAT.cluspoly);

colsR = rand(numPs,3);

for pi = 1:numPs
    hold on
    plot(inDAT.cluspoly(pi),'FaceColor',colsR(pi,:),'FaceAlpha',0.1)
    
    
    scatter(inDAT.censAll(pi,1),inDAT.censAll(pi,2),40,colsR(pi,:),'filled');
    text(inDAT.censAll(pi,1),inDAT.censAll(pi,2),...
        ['Clust ',num2str(inDAT.cluID(pi))],...
        'VerticalAlignment','bottom','HorizontalAlignment','center');
    
end



end