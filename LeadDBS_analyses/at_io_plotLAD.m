function [] = at_io_plotLAD()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cd('D:\Neuroimaging\dataForPlotting')
load('ai_io_plotting09032020d.mat','datCell')


distMat = zeros(13*3,4);
lic = 1;
for li = 1:length(datCell)
    
    fNames = fieldnames(datCell{li});
    
    for fi = 1:length(fNames)
        distMat(lic,:) = table2array(datCell{li}.(fNames{fi}).distLOCs);
        lic = lic + 1;      
    end
end

% Clean up empty rows
distMat2 = distMat(distMat(:,1) ~= 0,:);

scatter3(distMat2(:,1),distMat2(:,2),distMat2(:,3),20,'r','filled')
xlabel('ED from Center of SN in mm')
ylabel('ED from Anterior pole of SN in mm')
zlabel('ED from Lateral pole of SN in mm')

end

