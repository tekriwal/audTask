function [] = checkAdj_AT_v1(cNum , impLoc , recLocS , BAhemi , xyzADJ)

cd('D:\Neuroimaging\FinalCheck\')

fiNs = dir('*.mat');

fNames = {fiNs.name};

[cIndex] = getCindex(fNames , cNum);

load(cIndex , 'finalMesh')

bAs = {'STN','SNR'};
siDes = {'L','R'};

for i = 1:2
    for ii = 1:2
        hold on
        baU = bAs{i};
        siU = siDes{ii};
        
        d = drawMesh(finalMesh.(baU).(siU).vertices,finalMesh.(baU).(siU).faces);
        if i == 1
            d.FaceColor = 'k';
        else
            d.FaceColor = 'm';
        end
        d.FaceAlpha = 0.3;
        d.EdgeColor = 'none';

        [~ , mXloc] = max(finalMesh.(baU).(siU).vertices(:,3));
        mXpnt = finalMesh.(baU).(siU).vertices(mXloc,:);
        
        tmpTxt = [baU , ' ', siU];
        
        text(mXpnt(1),mXpnt(2),mXpnt(3),tmpTxt,'FontSize',20,'Color','g')
    end
end

XYZadj = finalMesh.LeadDat;

for ai = 1:3
   
    XYZadj(:,ai) = XYZadj(:,ai) + xyzADJ(ai);
    
end

plot3(XYZadj(:,1),XYZadj(:,2),XYZadj(:,3),'LineWidth',3)

colORs = 'rg';
for pi = 1:length(recLocS)
    
    [XYZ_new] = reOrientTrk(XYZadj , impLoc , recLocS{pi} , BAhemi);
    
    plot3(XYZ_new(:,1),XYZ_new(:,2),XYZ_new(:,3),'LineWidth',3,'Color',colORs(pi))
    
    text(XYZ_new(50,1),XYZ_new(50,2),XYZ_new(50,3),recLocS{pi},'FontSize',20,'Color','k')
    
end

keyboard

end



function [cIndex] = getCindex(allcS , cOFi)

set1 = cellfun(@(x) strsplit(x,'_'),allcS,'UniformOutput',false);
set2 = cellfun(@(x) str2double(x{2}), set1, 'UniformOutput', true);
cIndex = allcS{set2 == cOFi};

end



function [XYZ_new] = reOrientTrk(orgXYZ , impTRK , recTRK , baHEMI)
% IF RIGHT brain ADD to go lateral and SUBTRACT to go medial
% IF LEFT brain SUBTRACT to go lateral and ADD to go medial
if strcmp(impTRK , recTRK)
    XYZ_new = orgXYZ;
    return
end

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
                    XYZ_new(:,2) = orgXYZ(:,2) + 2;
                else
                    XYZ_new(:,2) = orgXYZ(:,2) - 2;
                end
            case 'Anterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,2) = orgXYZ(:,2) + 2;
                else
                    XYZ_new(:,2) = orgXYZ(:,2) - 2;
                end
                XYZ_new(:,2) = orgXYZ(:,2) + 2;
            case 'Posterior'
                if strcmp(baHEMI,'L')
                    XYZ_new(:,2) = orgXYZ(:,2) + 2;
                else
                    XYZ_new(:,2) = orgXYZ(:,2) - 2;
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


