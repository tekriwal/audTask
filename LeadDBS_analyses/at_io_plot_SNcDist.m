function [] = at_io_plot_SNcDist()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cd('D:\Neuroimaging\dataForPlotting')
load('ai_io_plotting09032020d.mat','datCell')


distMat = zeros(13*3,1);
lic = 1;
for li = 1:length(datCell)
    
    fNames = fieldnames(datCell{li});
    
    for fi = 1:length(fNames)
        distMat(lic,:) = datCell{li}.(fNames{fi}).mmFromSNc;
        lic = lic + 1;      
    end
end

% Clean up empty rows
distMat2 = distMat(distMat(:,1) ~= 0,:);

histogram(distMat2, 15)
xlabel('Distance from SNc border in mm')
ylabel('Neuron number')


end
