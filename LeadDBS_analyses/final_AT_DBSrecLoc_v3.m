function [reclocOUT] = final_AT_DBSrecLoc_v3(cNumS)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


nLoc = 'D:\Neuroimaging\Neuroimaging';
cd(nLoc)
datTab = readtable('at_neuroProgress.xlsx');
recTab = readtable('recSpikeLocs.xlsx');

cd('D:\Neuroimaging\FinalCheck\Comb')
fiNs = dir('*.mat');
% All final names
fNames = {fiNs.name};

for cci = 1:length(cNumS)
    
    cNum = cNumS(cci);
    
    [cIndex] = getCindex(fNames , cNum);
    
    % Load correct tables
    c_dtab = datTab(ismember(datTab.caseN,cNum),:);
    r_dtab = recTab(ismember(recTab.caseN,cNum),:);
    
    load(cIndex , 'finalMesh')
    
    bAs = {'STN','SN','SNC'};
    siDes = c_dtab.sideofbrain;
    
    for i = 1:3
        for ii = 1:1
            hold on
            baU = bAs{i};
            siU = siDes{ii};
            
            d = drawMesh(finalMesh.(baU).(siU).vertices,finalMesh.(baU).(siU).faces);
            if i == 1
                d.FaceColor = 'k';
            elseif i == 2
                d.FaceColor = [0.5 0.5 0.5];
            else
                d.FaceColor = [0.25 0.25 0.25];
            end
            d.FaceAlpha = 0.2;
            d.EdgeColor = 'none';
            
            [~ , mXloc] = max(finalMesh.(baU).(siU).vertices(:,3));
            
            if i == 1
                stnMxpt = finalMesh.(baU).(siU).vertices(mXloc,:);
            end

        end
    end
    
    %%% Electrode Wire
    XYZadj = finalMesh.LeadDat;
    xyzADJ = [c_dtab.xAdj , c_dtab.yAdj , c_dtab.zAdj];
    
    for ai = 1:3
        XYZadj(:,ai) = XYZadj(:,ai) + xyzADJ(ai);
    end
    
    % TRIM top of electrodes
    topEleTr = stnMxpt;
    topEleTr(3) = topEleTr(3) + 15;
    trimIndex = XYZadj(:,3) < topEleTr(3);
    XYZadj2 = XYZadj(trimIndex,:);
    
    plot3(XYZadj2(:,1),XYZadj2(:,2),XYZadj2(:,3),'LineWidth',3 , 'Color', 'y')
    
    recLocS = r_dtab.recTrkID;
    impLoc = c_dtab.track{:};
    BAhemi = c_dtab.sideofbrain{:};
    

    
    for pi = 1:length(recLocS)
        
        [XYZ_new , Rsame] = reOrientTrk(XYZadj2 , impLoc , recLocS{pi} , BAhemi);
        
        % Plot Wire
        if Rsame
            plot3(XYZ_new(:,1),XYZ_new(:,2),XYZ_new(:,3),'LineWidth',3,'Color','b')
        else
            plot3(XYZ_new(:,1),XYZ_new(:,2),XYZ_new(:,3),'LineWidth',3,'Color','r')
        end
        tmpWIRE = XYZ_new;

        %%% GET DATA
        % 1. Compute line of best fit equation to extend line to rec depth
        % P1 = [-3 0 1];
        oldBot = XYZ_new(length(XYZ_new),:);
        % P2 = [3 -1 2];
        oldTop = XYZ_new(1,:);
        distExt = [oldBot; oldTop];
        
        distBtnPt = diff(distExt) ;
        
        UniTs = 0.25;
        depthExt = -UniTs*distBtnPt + oldBot ;
        
        XYZ_depX = zeros(50,3);
        for ti = 1:3
            XYZ_depX(:,ti) = transpose(linspace(oldBot(ti),depthExt(ti),50));
        end
        
        % 2. Get recording depth
        % Actual depth
        recDep = c_dtab.depth;
        % Relative to native space
        rel_depth = oldBot(3) - recDep;
        % Find index
        [~ , relRInd] = min(abs(XYZ_depX(:,3) - rel_depth));
        XYZ_depLoc = XYZ_depX(relRInd,:);
        
        scatter3(XYZ_depLoc(1),XYZ_depLoc(2),XYZ_depLoc(3),50,'r','filled')
        
        % 3. Is it in STN or SNR
        snr = finalMesh.SN.(BAhemi).vertices;
        stn = finalMesh.STN.(BAhemi).vertices;
        snc = finalMesh.SNC.(BAhemi).vertices;
        
        % Centroid of SN
        cenSNr = mean(snr);
        
%         SNRzt = ceil(cenSNr(3));
%         SNRzb = floor(cenSNr(3));
        
%         tmpZ = snr((snr(:,3) < SNRzt & snr(:,3) > SNRzb),:);
        
        [~ , antLOC] = max(snr(:,2));
        antSN = snr(antLOC,:);
        
        [~ , dorLOC] = max(snr(:,3));
        dorSN = snr(dorLOC,:);
        
        if strcmp(BAhemi,'R')
            [~ , latLOC] = max(snr(:,1));
            latSN = snr(latLOC,:);
        else
            [~ , latLOC] = min(snr(:,1));
            latSN = snr(latLOC,:);
        end
%         scatter3(latSN(1),latSN(2),latSN(3),50,'b','filled')
        
        insideLoc = nan;
        for anI = 1:3
            switch anI
                case 1
                    tri = delaunayn(stn); % Generate delaunay triangulization
                    tn = tsearchn(stn, tri, XYZ_depLoc); % Determine which triangle point is within
                    IsInside = ~isnan(tn); % Convert to logical vector
                    if IsInside
                        insideLoc = 'STN';
                    end
                case 2
                    tri = delaunayn(snr); % Generate delaunay triangulization
                    tn = tsearchn(snr, tri, XYZ_depLoc); % Determine which triangle point is within
                    IsInside = ~isnan(tn); % Convert to logical vector
                    if IsInside
                        insideLoc = 'SNR';
                    end
                case 3
                    tri = delaunayn(snc); % Generate delaunay triangulization
                    tn = tsearchn(snc, tri, XYZ_depLoc); % Determine which triangle point is within
                    IsInside = ~isnan(tn); % Convert to logical vector
                    if IsInside
                        insideLoc = 'SNC';
                    end
            end
        end
        
        % Regional analysis
        % Distance from centroid of SN
        % Distance from anterior pole of SN
        % Distance from lateral pole of SN
        
        distCen = pdist([cenSNr ; XYZ_depLoc]);
        distAntP = pdist([antSN ; XYZ_depLoc]);
        distLatP = pdist([latSN ; XYZ_depLoc]);
        distDorP = pdist([dorSN ; XYZ_depLoc]);
        
        distTable = table(distCen,distAntP,distLatP,distDorP,'VariableNames',...
            {'Centroid','AnteriorP','LateralP','DorsalP'});
        
        regID = cell(1,3);
        regLOC = zeros(1,3);
        for di3 = 1:3
            
            if strcmp(BAhemi,'R')
                switch di3
                    case 1
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'L';
                        else
                            regID{di3} = 'M';
                        end
                        regLOC(di3) = cenSNr(di3) - XYZ_depLoc(di3); % Negative = Lateral
                    case 2
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'A';
                        else
                            regID{di3} = 'P';
                        end
                        regLOC(di3) = cenSNr(di3) - XYZ_depLoc(di3); % Negative = Anterior
                    case 3
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'D';
                        else
                            regID{di3} = 'V';
                        end
                        regLOC(di3) = cenSNr(di3) - XYZ_depLoc(di3); % Negative = Dorsal
                end
            else
                switch di3
                    case 1
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'M';
                        else
                            regID{di3} = 'L';
                        end
                        regLOC(di3) = XYZ_depLoc(di3) - cenSNr(di3); % Negative = Lateral
                    case 2
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'A';
                        else
                            regID{di3} = 'P';
                        end
                        regLOC(di3) = cenSNr(di3) - XYZ_depLoc(di3); % Negative = Anterior
                    case 3
                        if XYZ_depLoc(di3) > cenSNr(di3)
                            regID{di3} = 'D';
                        else
                            regID{di3} = 'V';
                        end
                end
            end
        end
        
        % Calculate distance of recording locaiton from closest point of
        % SNc
        SNCrecdist = min(pdist2(XYZ_depLoc,  snc));

        regTABLE = cell2table(regID,'VariableNames',{'X','Y','Z'});
        regDLTABLE = array2table(regLOC,'VariableNames',{'ML','AP','DV'});
        
        reclocOUT.(recLocS{pi}).trackNum = r_dtab.recTrkN(pi);
        reclocOUT.(recLocS{pi}).XYZ = XYZ_depLoc;
        reclocOUT.(recLocS{pi}).mmFromSNc = SNCrecdist;
        reclocOUT.(recLocS{pi}).ioBrainRg = r_dtab.ioLoc{pi};
        reclocOUT.(recLocS{pi}).distLOCs = distTable;
        reclocOUT.(recLocS{pi}).regionLOCs = regTABLE;
        reclocOUT.(recLocS{pi}).regionLDsts = regDLTABLE;
        reclocOUT.(recLocS{pi}).wire3D = tmpWIRE;
        
        if isnan(insideLoc)
            reclocOUT.(recLocS{pi}).recBrainRg = nan;
        else
            reclocOUT.(recLocS{pi}).recBrainRg = insideLoc;
        end
    end
end


end



function [cIndex] = getCindex(allcS , cOFi)

set1 = cellfun(@(x) strsplit(x,'_'),allcS,'UniformOutput',false);
set2 = cellfun(@(x) str2double(x{2}), set1, 'UniformOutput', true);
cIndex = allcS{set2 == cOFi};

end




function [XYZ_new , recSAME] = reOrientTrk(orgXYZ , impTRK , recTRK , baHEMI)
% IF RIGHT brain ADD to go lateral and SUBTRACT to go medial
% IF LEFT brain SUBTRACT to go lateral and ADD to go medial
if strcmp(impTRK , recTRK)
    XYZ_new = orgXYZ;
    recSAME = 1;
    return
end
recSAME = 0;

XYZ_new = orgXYZ;

switch impTRK
    case 'Center' % DONE
        switch recTRK
            case 'Anterior'
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Posterior'
                XYZ_new(:,2) = orgXYZ(:,2) - 2;
            case 'Medial'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
            case 'Lateral'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
        end
        
    case 'Anterior' % DONE
        switch recTRK
            case 'Center'
                XYZ_new(:,2) = orgXYZ(:,2) - 2;
            case 'Posterior'
                XYZ_new(:,2) = orgXYZ(:,2) - 4;
            case 'Medial'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) - 2;
            case 'Lateral'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) - 2;
        end
        
    case 'Posterior' % DONE
        switch recTRK
            case 'Center'
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Anterior'
                XYZ_new(:,2) = orgXYZ(:,2) + 4;
            case 'Medial'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Lateral'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
        end
        
    case 'Medial' % DONE
        switch recTRK
            case 'Center'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
            case 'Anterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Posterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) - 2;
            case 'Lateral'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) - 4;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) + 4;
                end
        end
        
    case 'Lateral'
        switch recTRK
            case 'Center'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
            case 'Anterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Posterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 2;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Medial'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,1) = orgXYZ(:,1) + 4;
                else
                    XYZ_new(:,1) = orgXYZ(:,1) - 4;
                end
        end
end

end
