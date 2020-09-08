function [] = createFinalMeshAT_both_v3()

% Update - 08/06/2020 - Add SNc

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
    
    % LOOP THROUGH MESHES
    matNs = dir('*.mat');
    
    for mi = 1:length(matNs)
        % get mat name
        matName = matNs(mi).name;
        
        % 1a. Load mesh
        load(matName , 'outputmesh');
        objNames = fieldnames(outputmesh);
        
        % 1b. Type of model
        namePart = strsplit(matName,{'_','.'});
        nameOI = namePart{3};
        
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
        %         stnMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'STN')});
        %         snrMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SNr')});
        %         sncMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SNc')});
        %         stnMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'STN')});
        %         snrMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SNr')});
        %         sncMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SNc')});
        
        if strcmp(nameOI,'SNall')
            snMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SN')});
            snMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SN')});
            stnMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'STN')});
            stnMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'STN')});
        else
            %             snrMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SNr')});
            sncMeshL = outputmesh.(objNames{contains(objNames,'left') & contains(objNames,'SNc')});
            %             snrMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SNr')});
            sncMeshR = outputmesh.(objNames{contains(objNames,'right') & contains(objNames,'SNc')});
        end
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
        
        % UPDATE MODEL output
        
        if strcmp(nameOI,'SNall')
            finalMesh.STN.L = stnMeshL;
            finalMesh.STN.R = stnMeshR;
            
            finalMesh.SN.L = snMeshL;
            finalMesh.SN.R = snMeshR;
        else
            finalMesh.SNC.L = sncMeshL;
            finalMesh.SNC.R = sncMeshR;
        end
        
        
        finalMesh.Wire = wireMesh;
        finalMesh.LeadDat = XYZleads;
        
        
        
    end
%     patCid = datTab.pat_num(pi);
    
    cd('D:\Neuroimaging\FinalCheck\Comb')
    saveName = [datTab.pat_int{pi},'_',num2str(datTab.caseN(pi)),'_finalMesh.mat'];
    save(saveName,'finalMesh')
    
    disp([num2str(pi),' out of ', num2str(height(datTab)), ' done!']);
    
end
