function [] = wavePlotfun_Clz(waveData)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% Assess all, neg and pos separately

allW = waveData.allWaves.waves;
posW = waveData.posWaveInfo.waves;
negW = waveData.negWaveInfo.waves;

mSpk = mean(allW,2);
mPspk = mean(posW,2);
mNspk = mean(negW,2);


figure;
plot(allW,'k');
hold on
plot(mSpk,'r','LineWidth',3);
plot(mPspk,'g','LineWidth',3);
plot(mNspk,'b','LineWidth',3);
legend('All','mean','pos','neg')


end

