caseN = 11

nLoc = 'D:\Neuroimaging\Neuroimaging';
cd(nLoc)
datTab = readtable('at_neuroProgress.xlsx');

% Get dir list
mainNEURO = 'D:\Neuroimaging\Neuroimaging\';
cd(mainNEURO)
tdir = dir;
dirNs = {tdir.name};
dirNs = dirNs([tdir.isdir]);
dirNs = dirNs(~ismember(dirNs,{'.','..'}));

% 'D:\Neuroimaging\Neuroimaging\KALKWARFPAULD_2405893\NIFTI\LEADDBS\meshes'


%%%% REMOVE
datOUT = zeros(height(datTab),6);
%%%%%%%%

pi = caseN;

piN = datTab.MRN(ismember(datTab.pat_num,pi),:);

piTab = datTab(ismember(datTab.pat_num,pi),:);

pName = dirNs{contains(dirNs,num2str(piN))};

meshLoc = [mainNEURO, pName , '\NIFTI\LEADDBS\meshes\'];

cd(meshLoc)

% 1. Load mesh
matN = dir('*.mat');
load(matN(1).name);
objNames = fieldnames(outputmesh);

% 2a. extract Side of interest
dbsSide = piTab.sideofbrain{1};

% 2b. extract lead model
leadMod = piTab.leadtype{1};

% Right = Side 1
% Left = Side 2
if strcmp(dbsSide,'R')
    bAh = 'right';
    eleh = 'Side1';
else
    bAh = 'left';
    eleh = 'Side2';
end

if strcmp(leadMod,'A')
    wireObj = 'Insulation18';
    finOjb = 'Contact1';
elseif strcmp(leadMod,'M')
    wireObj = 'Insulation1';
    finOjb = 'Contact1';
elseif strcmp(leadMod,'B')
    wireObj = 'Insulation16';
    finOjb = 'Contact1';
end

% Brain Areas
stnMesh = outputmesh.(objNames{contains(objNames,bAh) & contains(objNames,'STN')});
snrMesh = outputmesh.(objNames{contains(objNames,bAh) & contains(objNames,'SN')});
% Wire

cf1 = cellfun(@(x) strsplit(x,'_'), objNames, 'UniformOutput', false);
% sizInd = cellfun(@(x) size(x,2) == 3, cf1);
cf2 = cellfun(@(x) x{2}, cf1, 'UniformOutput', false);

wireMesh = outputmesh.(objNames{contains(objNames,eleh) & ismember(cf2,wireObj)});
% Bottom contact
botCont = outputmesh.(objNames{contains(objNames,eleh) & contains(objNames,finOjb)});

% Compute line of best between top of wire to bottom of contact

% vertices = X, Y, Z
%     [nf,nv] = reducepatch(wireMesh,0.1)

close all

drawMesh(wireMesh.vertices,wireMesh.faces, 'r')

pause
keyboard

datOUT(pi,1:3) = tcen.Position;

close all

drawMesh(botCont.vertices,botCont.faces, 'g')

pause

keyboard

if strcmp(leadMod,'B')
    p3 = bo1.Position;
else
    p3 = [mean([bo1.Position(1),bo2.Position(1)]),mean([bo1.Position(2),bo2.Position(2)]),bo1.Position(3)];
end
plot3(p3(1),p3(2),p3(3),'ro','MarkerSize',30)

datOUT(pi,4:6) = p3;




% 3. Compute best fit line



%     x1 = 24.113
%     x2 = 10.811
%     y1 = 5.92
%     y2 = -14.21
%     z1 = 27.8
%     z2 = -10.86
%     N = 100
%     x=linspace(x1,x2,N);
%     y=linspace(y1,y2,N);
%     z=linspace(z1,z2,N);
% H = plot3(x, y, z);



%%


% fi = fieldnames(outputmesh)
%
% for i = 1:length(fi)
%
%
%     hold on
%     if contains(fi{i},{'STN','SN'})
%         continue
%     end
%
%     drawMesh(outputmesh.(fi{i}).vertices,outputmesh.(fi{i}).faces, 'r')
%     title(fi{i})
%     pause
%
%
%
%
% end
%
%







