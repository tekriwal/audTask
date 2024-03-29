function [] = at_io_finalPlots_ATLAS_Fuse_v3(inputARGS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

arguments
    inputARGS.plotNum = 1
    inputARGS.plName = 'default'
    inputARGS.latV = 'L';
end


switch inputARGS.plotNum
    case 1
        pltN = 1;
    case 2
        pltN = 2;
    case 3
        pltN = 3;
end

%%
cd('D:\Neuroimaging\dataForPlotting')
load('ai_io_plotting09142020.mat','datCell')

% Exclude Cases 8, 9, 11
% Exclude recording tracks: 1 for 8, 9, both, 11, 2
datCellclean = cleanUPdt(datCell);

% close all;
% Create data
allSpk = nan(50,3);
spkC = 1;
xyzAll = nan(50,3);
locAll = cell(50,1);
% figID = zeros(50,1);
figNnum = [5,8,12];
for ti = 1:13
    
    tmpS = datCellclean{ti};
    
    tmpF = fieldnames(tmpS);
    
    if isempty(tmpF)
        continue
    else
        
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
            
            if ismember(ti,figNnum)
                allSpk(spkC,3) = ti;
            else
                allSpk(spkC,3) = 1;
            end
            
            xyzAll(spkC,:) = tmpS.(tmpF{ti2}).XYZ;
            locAll{spkC,1} = cell2mat(table2cell(tmpS.(tmpF{ti2}).regionLOCs));
            spkC = spkC + 1;
        end
    end
end

allSpkf = allSpk(~isnan(allSpk(:,1)),:);
allXYZ = xyzAll(~isnan(allSpk(:,1)),:);
% allLOC = locAll(~isnan(allSpk(:,1)),:);


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

switch pltN
    case 1
        figure;
        hold on
        d = drawMesh(cor_LSNR.vertices, cor_LSNR.faces);
        d.FaceColor = 'k';
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_LSTN.vertices, cor_LSTN.faces);
        d.FaceColor = [0.9 0 0];
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_LSNC.vertices, cor_LSNC.faces);
        d.FaceColor = [0.2 0.2 0.2];
        d.FaceAlpha = 0.5;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_RSNR.vertices, cor_RSNR.faces);
        d.FaceColor = 'k';
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_RSTN.vertices, cor_RSTN.faces);
        d.FaceColor = [0.9 0 0];
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_RSNC.vertices, cor_RSNC.faces);
        d.FaceColor = [0.2 0.2 0.2];
        d.FaceAlpha = 0.5;
        d.EdgeColor = 'none';
        view([-180 90])
    case 2
        figure;
        hold on
        d = drawMesh(cor_LSNR.vertices, cor_LSNR.faces);
        d.FaceColor = 'k';
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_LSTN.vertices, cor_LSTN.faces);
        d.FaceColor = [0.9 0 0];
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_LSNC.vertices, cor_LSNC.faces);
        d.FaceColor = [0.2 0.2 0.2];
        d.FaceAlpha = 0.5;
        d.EdgeColor = 'none';
        if strcmp(inputARGS.latV,'l')
            view([-90 0])
        else
            view([90 0])
        end
    case 3
        figure;
        hold on
        d = drawMesh(cor_RSNR.vertices, cor_RSNR.faces);
        d.FaceColor = 'k';
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_RSTN.vertices, cor_RSTN.faces);
        d.FaceColor = [0.9 0 0];
        d.FaceAlpha = 0.1;
        d.EdgeColor = 'none';
        
        d = drawMesh(cor_RSNC.vertices, cor_RSNC.faces);
        d.FaceColor = [0.2 0.2 0.2];
        d.FaceAlpha = 0.5;
        d.EdgeColor = 'none';
        if strcmp(inputARGS.latV,'l')
            view([90 0])
        else
            view([-90 0])
        end
end

% PLOT Recording lines

% FIX THE NUMBER OF LINES and WHERE THEY GO

switch pltN
    case 1
        
        for li = 1:length(datCellclean)
            tmpN = datCellclean{li};
            tFns = fieldnames(tmpN);
            for ti = 1:length(tFns)
                tWire = tmpN.(tFns{ti}).wire3D;
                tWire2 = tWire(round(size(tWire,1)/2):end,:);
                plot3(tWire2(:,1),tWire2(:,2),tWire2(:,3),'k')
            end
        end
        
    case 2
        
        for li = 1:length(datCellclean)
            tmpN = datCellclean{li};
            tFns = fieldnames(tmpN);
            for ti = 1:length(tFns)
                
                if sign(tmpN.(tFns{ti}).XYZ(1)) == 1
                    continue
                else
                    tWire = tmpN.(tFns{ti}).wire3D;
                    tWire2 = tWire(round(size(tWire,1)/2):end,:);
                    plot3(tWire2(:,1),tWire2(:,2),tWire2(:,3),'k')
                end
            end
        end
        
        
    case 3
        
        for li = 1:length(datCellclean)
            tmpN = datCellclean{li};
            tFns = fieldnames(tmpN);
            for ti = 1:length(tFns)
                
                if sign(tmpN.(tFns{ti}).XYZ(1)) == -1
                    continue
                else
                    tWire = tmpN.(tFns{ti}).wire3D;
                    tWire2 = tWire(round(size(tWire,1)/2):end,:);
                    plot3(tWire2(:,1),tWire2(:,2),tWire2(:,3),'k')
                end
            end
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

% COLORS
% C1 = 240 228 66
% C2 = 0 114 178
% C3 = 213 94 0

switch pltN
    case 1
        
        allRECS = rXY3d_c(allSpkf(:,2) == 1,:);
        figREP1 = rXY3d_c(allSpkf(:,3) == 12,:);
        figREP2 = rXY3d_c(allSpkf(:,3) == 5,:);
        
        scatter3(allRECS(:,1),allRECS(:,2),allRECS(:,3),50,[213/255, 94/255 0/255],'filled')
        scatter3(figREP1(:,1),figREP1(:,2),figREP1(:,3),50,[240/255, 228/255 66/255],'filled')
        scatter3(figREP2(:,1),figREP2(:,2),figREP2(:,3),50,[0/255, 114/255 178/255],'filled')
    case 2
        
        allRECS = rXY3d_c((allSpkf(:,2) == 1 & negVals == 1),:);
        figREP1 = rXY3d_c((allSpkf(:,3) == 12 & negVals == 1),:);
        figREP2 = rXY3d_c((allSpkf(:,3) == 5 & negVals == 1),:);
        
        scatter3(allRECS(:,1),allRECS(:,2),allRECS(:,3),50,[213/255, 94/255 0/255],'filled')
        scatter3(figREP1(:,1),figREP1(:,2),figREP1(:,3),50,[240/255, 228/255 66/255],'filled')
        scatter3(figREP2(:,1),figREP2(:,2),figREP2(:,3),50,[0/255, 114/255 178/255],'filled')
    case 3
        allRECS = rXY3d_c((allSpkf(:,2) == 1 & negVals == 0),:);
        figREP1 = rXY3d_c((allSpkf(:,3) == 12 & negVals == 0),:);
        figREP2 = rXY3d_c((allSpkf(:,3) == 5 & negVals == 0),:);
        
        scatter3(allRECS(:,1),allRECS(:,2),allRECS(:,3),50,[213/255, 94/255 0/255],'filled')
        scatter3(figREP1(:,1),figREP1(:,2),figREP1(:,3),50,[240/255, 228/255 66/255],'filled')
        scatter3(figREP2(:,1),figREP2(:,2),figREP2(:,3),50,[0/255, 114/255 178/255],'filled')
        
end

zlabel('Ventral - Dorsal')
ylabel('Anterior - Posterior')
axis square

zticks([])
xticks([])
yticks([])


cd('D:\Neuroimaging\Neuroimaging\ARONSKENNETHJ_587764\PublicationImage')
plotNAME = [inputARGS.plName , '.png'];
ax = gca; exportgraphics(ax,plotNAME,'ContentType','image','Resolution',300)
% ax = gca; exportgraphics(ax,'obView.pdf','ContentType','image','Resolution',300)















end




function [datCellclean] = cleanUPdt(datCell)

caseCks = [8 , 9 , 11];
trkRms = {1,[1,2],2};
tcount = 1;
datCellclean = datCell;
for ti = 1:13
    
    tmpS = datCell{ti};
    tmpF = fieldnames(tmpS);
    
    if ~ismember(ti,caseCks)
        continue
    else
        
        for ti2 = 1:length(tmpF)
            
            trkCk = tmpS.(tmpF{ti2}).trackNum;
            
            if ismember(trkCk,trkRms{tcount})
                datCellclean{ti} = rmfield(datCellclean{ti} , tmpF{ti2});
            else
                continue
            end
        end
        tcount = tcount + 1;
    end
end

end


