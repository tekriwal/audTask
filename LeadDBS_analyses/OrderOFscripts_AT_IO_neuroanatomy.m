% ORDER of SCRIPTS for IO AT Neuroanatomy 

%% Step 1 % Extract blobs
% A. Open Lead DBS and view 3D
dbs_meshExtract;

%% Step 2 % Denote top of wire and center of bottom contact
obtainLeadWire2botCon

%% Step 3 % If new Lead is used
% This creates the .mat files contained in Neuroimaing/FinalCheck
% %%%% NEED TO ADD - SNc
% createFinalMeshAT_v3() 

createFinalMeshAT_both_v3

%% Step 4::: CHECK NEW CASES ---- 1, 3, 4, 11
close all; checkAdj_AT_v1(8,'Center',{},'R',[0,0,0])
close all; checkAdj_AT_v1(10,'Center',{},'R',[0,0,0])
close all; checkAdj_AT_v1(6,'Center',{'Lateral'},'R',[0,0,0])
close all; checkAdj_AT_v1(13,'Medial',{'Center'},'L',[3,-2,0])
close all; checkAdj_AT_v1(1,'Medial',{'Lateral','Center'},'R',[-1,0,0])


%% Step 5 - Loop through this to create D:\Neuroimaging\dataForPlotting
close all;
datCell = cell(13,1);
for ci = 1:13
    
%     datCell{ci} = final_AT_DBSrecLoc_v2(ci);
    datCell{ci} = final_AT_DBSrecLoc_v3(ci);
    title(['Case ',num2str(ci)]);

    disp(['Case ' , num2str(ci)]);
    close all;

end
%% IF STEP 5 is run - RE SAVE
cd('D:\Neuroimaging\dataForPlotting')
save('ai_io_plotting09142020.mat','datCell')
% final_AT_DBSrecLoc_v1fp
% final_AT_DBSrecLoc_v1fp(2)

%% Step 6a - Create Final plots
close all
% at_io_finalPlots_bilat_v1
at_io_finalPlots_ATLAS_Fuse_v2

%% Step 6b - LAD distance scatter
at_io_plotLAD

%% Step 6c - SNc distance bar
at_io_plot_SNcDist
