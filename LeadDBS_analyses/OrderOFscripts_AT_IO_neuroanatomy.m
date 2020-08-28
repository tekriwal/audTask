% ORDER of SCRIPTS for IO AT Neuroanatomy 

%% Step 1 % Extract blobs
% A. Open Lead DBS and view 3D
dbs_meshExtract;

%% Step 2 % If new Lead is used
% This creates the .mat files contained in Neuroimaing/FinalCheck
% %%%% NEED TO ADD - SNc
createFinalMeshAT_v3() 

%% Step 3 - Loop through this to create D:\Neuroimaging\dataForPlotting
close all;
datCell = cell(13,1);
for ci = 1:13
    
    datCell{ci} = final_AT_DBSrecLoc_v2(ci);
    title(['Case ',num2str(ci)]);
    pause
    close all;

end
%%
cd('D:\Neuroimaging\dataForPlotting')
save('ai_io_plotting08062020.mat','datCell')
% final_AT_DBSrecLoc_v1fp
% final_AT_DBSrecLoc_v1fp(2)



%% Step 4 - Create Final plot
close all
at_io_finalPlots_v2

%%
close all; checkAdj_AT_v1(2,'Center',{'Anterior','Lateral'},'R',[-0.5,0,0])
close all; checkAdj_AT_v1(2,'Center',{'Anterior','Lateral'},'R',[-0.5,-0.5,0])
close all; checkAdj_AT_v1(3,'Center',{'Anterior','Lateral'},'L',[0,0,0])
close all; checkAdj_AT_v1(3,'Center',{'Anterior','Lateral'},'L',[1,0,0])