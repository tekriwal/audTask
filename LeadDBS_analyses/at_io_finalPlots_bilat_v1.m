function [] = at_io_finalPlots_bilat_v1(inputARGS)
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

% X (column 1) adjustment to bring sides closer together
xColCor = 5;

% Left data
ucor_LSNR = finalMesh.SNR.L;
ucor_LSNC = finalMesh.SNC.L;
ucor_LSTN = finalMesh.STN.L;

cor_LSNR = finalMesh.SNR.L;
cor_LSNC = finalMesh.SNC.L;
cor_LSTN = finalMesh.STN.L;

cor_LSNR.vertices(:,1) = ucor_LSNR.vertices(:,1) + xColCor;
cor_LSNC.vertices(:,1) = ucor_LSNC.vertices(:,1) + xColCor;
cor_LSTN.vertices(:,1) = ucor_LSTN.vertices(:,1) + xColCor;

figure;
hold on
d = drawMesh(cor_LSNR.vertices, cor_LSNR.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.125;
d.EdgeColor = 'none';

d = drawMesh(cor_LSTN.vertices, cor_LSTN.faces);
d.FaceColor = [0.85 0 0];
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';

d = drawMesh(cor_LSNC.vertices, cor_LSNC.faces);
d.FaceColor = [0.25 0.25 0.25];
d.FaceAlpha = 0.5;
d.EdgeColor = 'none';
view([167 11])


% Right data
ucor_RSNR = finalMesh.SNR.R;
ucor_RSNC = finalMesh.SNC.R;
ucor_RSTN = finalMesh.STN.R;

cor_RSNR = finalMesh.SNR.R;
cor_RSNC = finalMesh.SNC.R;
cor_RSTN = finalMesh.STN.R;

cor_RSNR.vertices(:,1) = ucor_RSNR.vertices(:,1) - xColCor;
cor_RSNC.vertices(:,1) = ucor_RSNC.vertices(:,1) - xColCor;
cor_RSTN.vertices(:,1) = ucor_RSTN.vertices(:,1) - xColCor;

d = drawMesh(cor_RSNR.vertices, cor_RSNR.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.125;
d.EdgeColor = 'none';

d = drawMesh(cor_RSTN.vertices, cor_RSTN.faces);
d.FaceColor = [0.85 0 0];
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';

d = drawMesh(cor_RSNC.vertices, cor_RSNC.faces);
d.FaceColor = [0.25 0.25 0.25];
d.FaceAlpha = 0.5;
d.EdgeColor = 'none';

% Raw points
rXY3d = allXYZ;

% Corrected points
negVals = sign(rXY3d(:,1)) == -1;

rXY3d_c = rXY3d;
rXY3d_c(negVals,1) = rXY3d(negVals,1) + xColCor;
rXY3d_c(~negVals,1) = rXY3d(~negVals,1) - xColCor;

snInd = allSpkf(:,2) == 1;
snVerInd = (allSpkf(:,1) == 1 & allSpkf(:,2) == 1);

hold on

camlight

% Double Verify SNR
% scatter3(rXY3d(allSpkf(:,1) == 1,1),rXY3d(allSpkf(:,1) == 1,2),rXY3d(allSpkf(:,1) == 1,3),50,'g','filled')
% Single Verify SNR
scatter3(rXY3d_c(allSpkf(:,2) == 1,1),rXY3d_c(allSpkf(:,2) == 1,2),rXY3d_c(allSpkf(:,2) == 1,3),50,'g','filled')
% NOT SNR
scatter3(rXY3d_c(allSpkf(:,1) == 0,1),rXY3d_c(allSpkf(:,1) == 0,2),rXY3d_c(allSpkf(:,1) == 0,3),50,'k','filled')


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

