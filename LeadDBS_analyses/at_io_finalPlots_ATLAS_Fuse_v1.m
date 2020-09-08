function [] = at_io_finalPlots_ATLAS_Fuse_v1(inputARGS)
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
load('ai_io_plotting09072020.mat','datCell')

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


%%

% Stock SN block
cd('D:\Neuroimaging\FinalCheck\Comb')
nd = dir('*.mat');
nd2 = {nd.name};
tmpN = nd2{1};
load(tmpN,'finalMesh')

% X (column 1) adjustment to bring sides closer together
xColCor = 0;

% Left data
ucor_LSNR = finalMesh.SN.L;
ucor_LSNC = finalMesh.SNC.L;
ucor_LSTN = finalMesh.STN.L;

cor_LSNR = finalMesh.SN.L;
cor_LSNC = finalMesh.SNC.L;
cor_LSTN = finalMesh.STN.L;

cor_LSNR.vertices(:,1) = ucor_LSNR.vertices(:,1) + xColCor;
cor_LSNC.vertices(:,1) = ucor_LSNC.vertices(:,1) + xColCor;
cor_LSTN.vertices(:,1) = ucor_LSTN.vertices(:,1) + xColCor;

figure;
hold on
d = drawMesh(cor_LSNR.vertices, cor_LSNR.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';

d = drawMesh(cor_LSTN.vertices, cor_LSTN.faces);
d.FaceColor = [0.9 0 0];
d.FaceAlpha = 0.25;
d.EdgeColor = 'none';

d = drawMesh(cor_LSNC.vertices, cor_LSNC.faces);
d.FaceColor = [0.2 0.2 0.2];
d.FaceAlpha = 0.5;
d.EdgeColor = 'none';
view([167 11])


% Right data
ucor_RSNR = finalMesh.SN.R;
ucor_RSNC = finalMesh.SNC.R;
ucor_RSTN = finalMesh.STN.R;

cor_RSNR = finalMesh.SN.R;
cor_RSNC = finalMesh.SNC.R;
cor_RSTN = finalMesh.STN.R;

cor_RSNR.vertices(:,1) = ucor_RSNR.vertices(:,1) - xColCor;
cor_RSNC.vertices(:,1) = ucor_RSNC.vertices(:,1) - xColCor;
cor_RSTN.vertices(:,1) = ucor_RSTN.vertices(:,1) - xColCor;

d = drawMesh(cor_RSNR.vertices, cor_RSNR.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.1;
d.EdgeColor = 'none';

d = drawMesh(cor_RSTN.vertices, cor_RSTN.faces);
d.FaceColor = [0.9 0 0];
d.FaceAlpha = 0.25;
d.EdgeColor = 'none';

d = drawMesh(cor_RSNC.vertices, cor_RSNC.faces);
d.FaceColor = [0.2 0.2 0.2];
d.FaceAlpha = 0.5;
d.EdgeColor = 'none';


% PLOT Recording lines

% FIX THE NUMBER OF LINES and WHERE THEY GO

for li = 1:length(datCell)
    tmpN = datCell{li};
    
    tFns = fieldnames(tmpN);
    
    for ti = 1:length(tFns)
        
        tWire = tmpN.(tFns{ti}).wire3D;
        
        tWire2 = tWire(round(size(tWire,1)/2):end,:);
        
        plot3(tWire2(:,1),tWire2(:,2),tWire2(:,3),'k')
    end

    
end

% Raw points
rXY3d = allXYZ;

% Corrected points
negVals = sign(rXY3d(:,1)) == -1;

rXY3d_c = rXY3d;
rXY3d_c(negVals,1) = rXY3d(negVals,1) + xColCor;
rXY3d_c(~negVals,1) = rXY3d(~negVals,1) - xColCor;

hold on

camlight

% Double Verify SNR
% scatter3(rXY3d(allSpkf(:,1) == 1,1),rXY3d(allSpkf(:,1) == 1,2),rXY3d(allSpkf(:,1) == 1,3),50,'g','filled')
% Single Verify SNR
scatter3(rXY3d_c(allSpkf(:,2) == 1,1),rXY3d_c(allSpkf(:,2) == 1,2),rXY3d_c(allSpkf(:,2) == 1,3),50,'g','filled')
% NOT SNR
scatter3(rXY3d_c(allSpkf(:,1) == 0,1),rXY3d_c(allSpkf(:,1) == 0,2),rXY3d_c(allSpkf(:,1) == 0,3),50,'k','filled')

zlabel('Ventral - Dorsal')
ylabel('Anterior - Posterior')
axis square

zticks([])
xticks([])
yticks([])
view([-180 90])















end

