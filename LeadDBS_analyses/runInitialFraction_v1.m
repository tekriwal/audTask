%%% TO ADD
%%% X flatten
%%% Y flatten

clear; close all

datCell = cell(13,1);
for ci = 1:13
    close all;
    datCell{ci} = final_AT_DBSrecLoc_v1(ci);
end

cd('D:\Neuroimaging\dataForPlotting')
save('ai_io_plotting.mat','datCell')

%%
close all;
allSpk = nan(50,2);
spkC = 1;
snrIOc = 0;
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

allSpkFrac = sum(allSpkf(:,1)) / size(allSpkf,1);

snrSpkFrac = sum(allSpkf(logical(allSpkf(:,2)),1)) / numel(allSpkf(logical(allSpkf(:,2)),1));

%%

% make all recordings right and remove z
rXY2d = allXYZ(:,1:2);
rXY2d(:,1) = abs(rXY2d(:,1));

rXY3d = allXYZ;
rXY3d(:,1) = abs(rXY3d(:,1));

% Get boundary for mid z slice for SN
snInd = allSpkf(:,2) == 1;
snVerInd = allSpkf(:,1) == 1 & allSpkf(:,2) == 1;
sn_medianZ = round(median(allXYZ(snInd,3)));


% Stock SN block
nd = dir('*.mat');
nd2 = {nd.name};
tmpN = nd2{1};
load(tmpN,'finalMesh')
tmpTD = finalMesh.SNR.R;
tmpTTD = finalMesh.SNR.R;
tmpTTD.vertices(:,4) = round(tmpTTD.vertices(:,3));

medZbound = tmpTTD.vertices(:,4) == sn_medianZ;
tmpSVerts = tmpTTD.vertices(medZbound,:);

k = boundary(tmpSVerts(:,1),tmpSVerts(:,2));
figure;
plot(tmpSVerts(k,1),tmpSVerts(k,2),'Color',[0.5 0.5 0.5],'LineWidth',2)
hold on
plot(rXY2d(snInd,1),rXY2d(snInd,2),'go')
plot(rXY2d(snVerInd,1),rXY2d(snVerInd,2),'bo')
xlabel('Medial - Lateral')
ylabel('Posterior - Anterior')
axis square

xticks([])
yticks([])

%%

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

