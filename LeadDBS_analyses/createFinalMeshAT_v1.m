function [] = createFinalMeshAT_v1()

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

%%%%%%%%
for pi = 1:height(datTab)
    
    piN = datTab.MRN(pi);
    
    pName = dirNs{contains(dirNs,num2str(piN))};
    
    meshLoc = [mainNEURO, pName , '\NIFTI\LEADDBS\meshes\'];
    
    cd(meshLoc)
    
    % 1. Load mesh
    matN = dir('*.mat');
    load(matN.name);
    objNames = fieldnames(outputmesh);
    
    % 2a. extract Side of interest
    dbsSide = datTab.sideofbrain{pi};
    
    % 2b. extract lead model
    leadMod = datTab.leadtype{pi};
    
    % Right = Side 1
    % Left = Side 2
    if strcmp(dbsSide,'R')
        eleh = 'Side1';
    else
        eleh = 'Side2';
    end
    
    if strcmp(leadMod,'A')
        wireObj = 'Insulation18';
    elseif strcmp(leadMod,'M')
        wireObj = 'Insulation1';
    elseif strcmp(leadMod,'B')
        wireObj = 'Insulation16';
    end
    
    % Brain Areas
    stnMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'STN')});
    snrMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SN')});
    stnMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'STN')});
    snrMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SN')});
    % Wire
    wireMesh = outputmesh.(objNames{contains(objNames,eleh) & contains(objNames,wireObj)});

    % Compute line of best between top of wire to bottom of contact
    xTop = datTab.topX(pi);
    xBot = datTab.botX(pi);
    yTop = datTab.topY(pi);
    yBot = datTab.botY(pi);
    zTop = datTab.topZ(pi);
    zBot = datTab.botZ(pi);
    
    numPnts = 100;
    
    xLead = transpose(linspace(xTop,xBot,numPnts));
    yLead = transpose(linspace(yTop,yBot,numPnts));
    zLead = transpose(linspace(zTop,zBot,numPnts));
    
    XYZleads = [xLead , yLead , zLead];
    
    finalMesh.STN.L = stnMeshL;
    finalMesh.STN.R = stnMeshR;
    finalMesh.SNR.L = snrMeshL;
    finalMesh.SNR.R = snrMeshR;
    finalMesh.Wire = wireMesh;
    finalMesh.LeadDat = XYZleads;
    
    cd('D:\Neuroimaging\FinalCheck')
    saveName = [datTab.pat_int{pi},'_',num2str(datTab.caseN(pi)),'_finalMesh.mat'];
    save(saveName,'finalMesh')
    
    
end
