function [] = at_io_finalPlots_v2(inputARGS)
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
load('ai_io_plotting08062020.mat','datCell')

% close all;
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
        
        if strcmp(tOI,tNR) && strcmp(tOI,'SNR')
            allSpk(spkC,1) = 1; % double verify SNR
        elseif strcmp(tOI,'SNR')
            allSpk(spkC,1) = 2; % IO verify SNR
        else
            allSpk(spkC,1) = 0; % NOT SNR
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
tmpTD = finalMesh.SNR.L;
tmpTTDl = finalMesh.SNR.L;
tmpTTDr = finalMesh.SNR.R;
tmpTDstn = finalMesh.STN.L;
tmpTDsnc = finalMesh.SNC.L;

rXY3d = allXYZ;
rXY3d(:,1) = (abs(rXY3d(:,1)))*-1;

figure;
d = drawMesh(tmpTD.vertices, tmpTD.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.125;
d.EdgeColor = 'none';
hold on
d = drawMesh(tmpTDstn.vertices, tmpTDstn.faces);
d.FaceColor = [0.85 0 0];
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';

d = drawMesh(tmpTDsnc.vertices, tmpTDsnc.faces);
d.FaceColor = [0.25 0.25 0.25];
d.FaceAlpha = 0.5;
d.EdgeColor = 'none';
view([167 11])

snInd = allSpkf(:,2) == 1;
snVerInd = (allSpkf(:,1) == 1 & allSpkf(:,2) == 1);

rXY2d = allXYZ;
rXY2d(:,1) = (abs(rXY2d(:,1)))*-1;

sn_medianZ = round(median(allXYZ(snInd,3)));

% left
tmpTTDl.vertices(:,4) = round(tmpTTDl.vertices(:,3));
medZboundl = tmpTTDl.vertices(:,4) == sn_medianZ;
tmpSVertsl = tmpTTDl.vertices(medZboundl,:);
% right
% tmpTTDr.vertices(:,4) = round(tmpTTDr.vertices(:,3));
% medZboundr = tmpTTDr.vertices(:,4) == sn_medianZ;
% tmpSVertsr = tmpTTDr.vertices(medZboundr,:);


kl = boundary(tmpSVertsl(:,1),tmpSVertsl(:,2));
% kr = boundary(tmpSVertsr(:,1),tmpSVertsr(:,2));


hold on
%     figure;
%     xLM = get(gca,'xlim')
%     yLM = get(gca,'ylim')
%     zLM = get(gca,'zlim')

plot3(tmpSVertsl(kl,1),tmpSVertsl(kl,2),repmat(sn_medianZ,size(tmpSVertsl(kl,2))),'Color',[0.75 0 0],'LineWidth',2)
%            patch([xLM(1),xLM(2),xLM(2),xLM(1)],[yLM(1),yLM(2),yLM(2),yLM(1)],...
%                [sn_medianZ,sn_medianZ,sn_medianZ,sn_medianZ],'r','FaceAlpha',0.3,'EdgeColor','none');


camlight

% Double Verify SNR
% scatter3(rXY3d(allSpkf(:,1) == 1,1),rXY3d(allSpkf(:,1) == 1,2),rXY3d(allSpkf(:,1) == 1,3),50,'g','filled')
% Single Verify SNR
scatter3(rXY3d(allSpkf(:,2) == 1,1),rXY3d(allSpkf(:,2) == 1,2),rXY3d(allSpkf(:,2) == 1,3),50,'g','filled')
% NOT SNR
scatter3(rXY3d(allSpkf(:,1) == 0,1),rXY3d(allSpkf(:,1) == 0,2),rXY3d(allSpkf(:,1) == 0,3),50,'k','filled')





axis square

xticks([])
yticks([])
zticks([])



figure;

tmpTTDl.vertices(:,4) = round(tmpTTDl.vertices(:,3));
uniqueVals = unique(tmpTTDl.vertices(:,4));

for ui = 1:length(uniqueVals)
    
    tmpUNI = uniqueVals(ui);
    tmpINDs = tmpTTDl.vertices(:,4) == tmpUNI;
    tmpSVertt = tmpTTDl.vertices(tmpINDs,:);
    tmpBound = boundary(tmpSVertt(:,1),tmpSVertt(:,2));
    
    if tmpUNI == sn_medianZ
    plot(tmpSVertt(tmpBound,1),tmpSVertt(tmpBound,2),'Color','r','LineWidth',2)
    else
    plot(tmpSVertt(tmpBound,1),tmpSVertt(tmpBound,2),'Color',[0.5 0.5 0.5],'LineWidth',0.5)
    end
    
    hold on
    
end

% Double Verify SNR
scatter(rXY2d(allSpkf(:,1) == 1,1),rXY2d(allSpkf(:,1) == 1,2),30,'g','filled')
% Single Verify SNR
scatter(rXY2d(allSpkf(:,1) == 2,1),rXY2d(allSpkf(:,1) == 2,2),30,'b','filled')
% NOT SNR
scatter(rXY2d(allSpkf(:,1) == 0,1),rXY2d(allSpkf(:,1) == 0,2),30,'k','filled')

xlabel('Medial - Lateral')
ylabel('Posterior - Anterior')
axis square

xticks([])
yticks([])
view([-180 90])

%% 3D


%  view([90,0])
% view([90,90])
%  view([180,0])






%%

% xlabel('Medial - Lateral')
% ylabel('Posterior - Anterior')
% zlabel('Ventral - Dorsal')
% view([16.8,12.0])


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

