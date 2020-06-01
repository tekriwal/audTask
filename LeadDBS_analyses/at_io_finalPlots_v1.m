function [] = at_io_finalPlots_v1(inputARGS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

arguments
    inputARGS.plotNum = 1
end


switch inputARGS.plotNum
    case 1
        
    case 2
        
    case 3
        
end

%%
cd('D:\Neuroimaging\dataForPlotting')
load('ai_io_plotting.mat','datCell')

close all;
% Create data
allSpk = nan(50,2);
spkC = 1;
xyzAll = nan(50,3);
locAll = cell(50,1);
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
        xyzAll(spkC,:) = tmpS.(tmpF{ti2}).XYZ;
        locAll{spkC,1} = cell2mat(table2cell(tmpS.(tmpF{ti2}).regionLOCs));
        spkC = spkC + 1;
    end
end

allSpkf = allSpk(~isnan(allSpk(:,1)),:);
allXYZ = xyzAll(~isnan(allSpk(:,1)),:);
allLOC = locAll(~isnan(allSpk(:,1)),:);

% allSpkFrac = sum(allSpkf(:,1)) / size(allSpkf,1);
% 
% snrSpkFrac = sum(allSpkf(logical(allSpkf(:,2)),1)) / numel(allSpkf(logical(allSpkf(:,2)),1));

%%

% plot3(1:10,1:10,1:10,'.')
% patch([1,10,10,1],[5,5,5,5],[1,1,10,10],'r','FaceAlpha',0.3,'EdgeColor','none');
% patch([1,10,10,1],[5,5,5,5],[1,1,10,10],'r','FaceAlpha',0.3,'EdgeColor','none');
% patch([1,10,10,1],[5,5,5,5],[1,1,10,10],'r','FaceAlpha',0.3,'EdgeColor','none');



%%

% Create Absolutized data set: make all recordings right and remove z
% 2D 

% Stock SN block
cd('D:\Neuroimaging\FinalCheck')
nd = dir('*.mat');
nd2 = {nd.name};
tmpN = nd2{1};
load(tmpN,'finalMesh')
tmpTD = finalMesh.SNR.R;
tmpTTD = finalMesh.SNR.R;

rXY3d = allXYZ;
rXY3d(:,1) = abs(rXY3d(:,1));


figure;
d = drawMesh(tmpTD.vertices, tmpTD.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';
hold on

snInd = allSpkf(:,2) == 1;
snVerInd = (allSpkf(:,1) == 1 & allSpkf(:,2) == 1);

for ci = 1:3
    
    all3 = [1,2,3];
    use2 = all3(~ismember(all3,ci));
    
    tu1 = use2(1);
    tu2 = use2(2);
    
    rXY2d = allXYZ;
    rXY2d(:,1) = abs(rXY2d(:,1));
    
    sn_medianZ = round(median(allXYZ(snInd,ci)));
    
    tmpTTD.vertices(:,4) = round(tmpTTD.vertices(:,ci));
    medZbound = tmpTTD.vertices(:,4) == sn_medianZ;
    tmpSVerts = tmpTTD.vertices(medZbound,:);
    
    
    k = boundary(tmpSVerts(:,tu1),tmpSVerts(:,tu2));
    
    hold on
    %     figure;
    xLM = get(gca,'xlim')
    yLM = get(gca,'ylim')
    zLM = get(gca,'zlim')
    switch ci
        case 1
            plot3(repmat(sn_medianZ,size(tmpSVerts(k,1))),tmpSVerts(k,2),tmpSVerts(k,3),'Color',[0.5 0.5 0.5],'LineWidth',2)
%             patch([sn_medianZ,sn_medianZ,sn_medianZ,sn_medianZ],[yLM(1),yLM(2),yLM(2),yLM(1)],...
%                 [zLM(1),zLM(1),zLM(2),zLM(2)],'r','FaceAlpha',0.3,'EdgeColor','none');
        case 2
            plot3(tmpSVerts(k,1),repmat(sn_medianZ,size(tmpSVerts(k,2))),tmpSVerts(k,3),'Color',[0.5 0.5 0.5],'LineWidth',2)
        case 3
           plot3(tmpSVerts(k,1),tmpSVerts(k,2),repmat(sn_medianZ,size(tmpSVerts(k,2))),'Color',[0.5 0.5 0.5],'LineWidth',2)
%            patch([xLM(1),xLM(2),xLM(2),xLM(1)],[yLM(1),yLM(2),yLM(2),yLM(1)],...
%                [sn_medianZ,sn_medianZ,sn_medianZ,sn_medianZ],'r','FaceAlpha',0.3,'EdgeColor','none');
    end

    
end


scatter3(rXY3d(snInd,1),rXY3d(snInd,2),rXY3d(snInd,3),30,'g','filled')

scatter3(rXY3d(snVerInd,1),rXY3d(snVerInd,2),rXY3d(snVerInd,3),30,'b','filled')

axis square

xticks([])
yticks([])
zticks([])



%% 3D


 view([90,0])
view([90,90])
 view([180,0])






%%

% xlabel('Medial - Lateral')
% ylabel('Posterior - Anterior')
% zlabel('Ventral - Dorsal')
view([16.8,12.0])


figure;
d = drawMesh(tmpTD.vertices, tmpTD.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';
hold on
scatter3(rXY3d(snInd,1),rXY3d(snInd,2),rXY3d(snInd,3),30,'g','filled')

scatter3(rXY3d(snVerInd,1),rXY3d(snVerInd,2),rXY3d(snVerInd,3),30,'b','filled')

axis square

xticks([])
yticks([])
zticks([])
% xlabel('Medial - Lateral')
% ylabel('Posterior - Anterior')
% zlabel('Ventral - Dorsal')
view([17.17,81.0])



figure;
d = drawMesh(tmpTD.vertices, tmpTD.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';
hold on
scatter3(rXY3d(snInd,1),rXY3d(snInd,2),rXY3d(snInd,3),30,'g','filled')

scatter3(rXY3d(snVerInd,1),rXY3d(snVerInd,2),rXY3d(snVerInd,3),30,'b','filled')

axis square

xticks([])
yticks([])
zticks([])
% xlabel('Medial - Lateral')
% ylabel('Posterior - Anterior')
% zlabel('Ventral - Dorsal')
view([155.30,33.6])

%%

uniLocs = unique(allLOC);

uniCounts = zeros(3,1);
for ui = 1:length(uniLocs)
    
    uniCounts(ui) = sum(ismember(allLOC,uniLocs{ui}));
    
    
end

bar(uniCounts)
xticklabels(uniLocs)
ylabel('Neuron count')
axis square

















end

