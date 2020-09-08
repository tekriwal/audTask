% Stock SN block
cd('D:\Neuroimaging\FinalCheck')
nd = dir('*.mat');
nd2 = {nd.name};
tmpN = nd2{1};
load(tmpN,'finalMesh')

% X (column 1) adjustment to bring sides closer together
xColCor = 5;

% Left data
ucor_LSNR = finalMesh.SNR.L;
ucor_LSNC = finalMesh.SNC.L;
ucor_LSTN = finalMesh.STN.L;

cor_LSNR = finalMesh.SNR.L;
cor_LSNC = finalMesh.SNC.L;
cor_LSTN = finalMesh.STN.L;

cor_LSNR.vertices(:,1) = ucor_LSNR.vertices(:,1) + xColCor;
cor_LSNC.vertices(:,1) = ucor_LSNC.vertices(:,1) + xColCor;
cor_LSTN.vertices(:,1) = ucor_LSTN.vertices(:,1) + xColCor;

figure;
hold on
d = drawMesh(cor_LSNR.vertices, cor_LSNR.faces);
d.FaceColor = 'k';
d.FaceAlpha = 0.125;
d.EdgeColor = 'none';
