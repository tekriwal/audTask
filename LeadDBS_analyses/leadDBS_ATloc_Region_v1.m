function [] = leadDBS_ATloc_Region_v1()

nLoc = 'D:\Neuroimaging\Neuroimaging';
cd(nLoc)
datTab = readtable('at_neuroProgress.xlsx');
recTab = readtable('recSpikeLocs.xlsx');

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
        bAh = 'right';
        eleh = 'Side1';
    else
        bAh = 'left';
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
    stnMesh = outputmesh.(objNames{contains(objNames,bAh) & contains(objNames,'STN')});
    snrMesh = outputmesh.(objNames{contains(objNames,bAh) & contains(objNames,'SNr')});
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
    
    keyboard
    
    % 3a. Get patient recording table
    
    tmpMRN = datTab.MRN(pi);
    
    tmpMRNtab = recTab(ismember(recTab.MRN,tmpMRN),:);
    
    % 3b. Determine electrode track location
    for ti = 1:height(tmpMRNtab)
        
        recTrK = tmpMRNtab.recTrkID{ti};
        impTrK = datTab.track{pi};
        if strcmp(recTrK,impTrK)
            
            % GET INFO from CURRENT LINE
            
        else
           
            %[outDat] = getTRKoff(brainSIDE, impTRK, recTRK)
            [outDat] = getTRKoff(dbsSide, impTrK, recTrK , XYZleads)
        end
        
       
        
        if strcmp(impTrK,'Medial')
            if strcmp(dbsSide,'L')
                xLead = xLead - 2;
            else
                xLead = xLead + 2;
            end
        elseif strcmp(impTrK,'Lateral')
            if strcmp(dbsSide,'R')
                xLead = xLead + 2;
            else
                xLead = xLead - 2;
            end
        elseif strcmp(impTrK,'Anterior')
            yLead = yLead - 2;
        elseif strcmp(impTrK,'Posterior')
            yLead = yLead + 2;
        end
        
        % 3. Compute best fit line
        % view(-89.68 , 18.19)
        
        
        % H = plot3(x, y, z);
        
        
    end
end



end


function [oXYZleads] = getTRKoff(brainSIDE, impTRK, recTRK, XYZleads)

% IF RIGHT brain ADD to go lateral and SUBTRACT to go medial
% IF LEFT brain SUBTRACT to go lateral and ADD to go medial
% ADD to go anterior and SUBTRACT to go posterior

if strcmp(impTRK,'Medial')
    if strcmp(brainSIDE,'L')
        oXYZleads(:,1) = XYZleads(:,1) - 2;
    else
        oXYZleads(:,1) = XYZleads(:,1) + 2;
    end
elseif strcmp(impTRK,'Lateral')
    if strcmp(brainSIDE,'R')
        oXYZleads(:,1) = XYZleads(:,1) + 2;
    else
        oXYZleads(:,1) = XYZleads(:,1) - 2;
    end
elseif strcmp(impTRK,'Anterior')
    oXYZleads(:,2) = XYZleads(:,2) - 2;
elseif strcmp(impTrK,'Posterior')
    oXYZleads(:,2) = XYZleads(:,2) + 2;
end



end





