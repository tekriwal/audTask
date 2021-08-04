%% if looking for VTA only  
function [] = dbs_meshExtract(patIN, patLOC, illinsky, dbsType)
allobj = findall(gcf, 'Type', 'Patch');


% Motor Thalamus Illinksy

if illinsky
    
    switch dbsType
        case 'abbottLR'
            roiInds = [17,18 , 81, 82, 85:111 , 119:145];
        case 'abbottR'
            roiInds = [17,18 , 81, 82, 85:111];
        case 'medtronic'
            roiInds = [17,18 , 81, 82, 85:93 , 101:109];
        case 'boston'
            roiInds = [17,18 , 81, 82, 85:109 , 117:141];
            
    end
    
else
    % DBS targets Middlebrooks
    switch dbsType
        case 'abbottLR'
            roiInds = [5:8 , 55, 56, 63:89 , 97:123];
        case 'abbottR'
            roiInds = [5:8 , 55, 56, 63:89];
        case 'medtronic'
            roiInds = [5:8 , 55, 56, 63:71 , 79:87];
        case 'boston'
            roiInds = [5:8 , 55, 56, 63:87 , 95:119];
            
    end
    
end

outputmesh = struct;
for i = roiInds
    tmpobj = allobj(i);
    tmptag = tmpobj.Tag;
    
    outputmesh.(tmptag).vertices = tmpobj.Vertices;
    outputmesh.(tmptag).faces = tmpobj.Faces;

%     hold on
%     drawMesh(outputmesh.(tmptag).vertices,outputmesh.(tmptag).faces)
end


%%

saveLOC = ['D:\Neuroimaging\Neuroimaging\',patLOC,'\NIFTI\LEADDBS\meshes'];

cd(saveLOC)

if illinsky
    saveNAME = [patIN , '_dbsMesh_SNall.mat'];
    save(saveNAME,'outputmesh');
else
    saveNAME = [patIN , '_dbsMesh_SNcSNr.mat'];
    save(saveNAME,'outputmesh');
end

end