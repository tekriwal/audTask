tic
%Key for figures - need to go through and make sure things obey this
%if starts with '1__' then figure for reference/checking
%if starts with '2__' then figure prelim analysis (spectrogram, stairs)
%if starts with '3__' then figure more advanced (quantifying PSD, newer stuff)
%if starts with '4__' then figure is for publication 

epochs = 1075; %import Index_PTX up to this #, rest we don't have LFPs for, try and automate epoch detection - refer to the evalepochs function for this line 21-23
PT = 10;
input_string = 'lfp12';
%input_lfp = lfp12; % NEED TO ADJUST DOWNSTREAM! ~ line 542
%line 2170 NEED TO CHANGE ALL THESE
%% cell contains parameters that can be adjusted (but probably don't have to be)
scale_big1 = 0; %scale for y axis of spectrogram
scale_big2 = 100;  %scale for y axis of spectrogram
scale_sm1 = 0; %scale for y axis of eeg/emg
scale_sm2 = 5; %scale for y axis of eeg/emg

scale_wake_WITH = 100; %where stair plot corresponds to each stage (divided by 10 for sm plots?)
scale_wake_wOUT = 90;
scale_wake_all = 99; 
scale_REM = 90;
scale_N1 = 80;
scale_N2 = 70;
scale_N3 = 60;
%PSD related function parameters
window = [];
noverlap = [];
f = window; %mathworks tutorial said that its safest to set to 'window'
%parameters notch filter for 60 Hz - notch might be overdone
tubs = 10000; 
f1 = 0.1165;
f2 = 0.1175;
%% load LFP & EEG/EMG/accelerometer channels
fs = 1024;
Fs = fs;
save('epochs.mat','epochs')
if exist(['Patient_',num2str(PT),'(2)_Sleep_LFP.mat'],'file') ~= 0 %loads most recent recordings sent by Ilknur
    load(['Patient_',num2str(PT),'(2)_Sleep_LFP.mat'])
else load(['Patient_',num2str(PT),'_Sleep_LFP.mat'])
end

if size(data) == [1 2] %automatically computes whether data in one or two (PT9 and 10) pieces
    lfpData1 = data(1).data(:,31:34);
lfpData2 = data(2).data(:,31:34); %this is right
allLFPs = [lfpData1 ; lfpData2];
clear lfpData1
clear lfpData2
lfplead0 = allLFPs(:,1);
lfplead1 = allLFPs(:,2);
lfplead2 = allLFPs(:,3);
lfplead3 = allLFPs(:,4);
clear allLfPs
x = 1;
FDC_1 = (data(1).data(:,x))-(data(1).data(:,x+11));
FDC_2 = (data(2).data(:,x))-(data(2).data(:,x+11));
FDC = [FDC_1 ; FDC_2];
clear FDC_1
clear FDC_2
x = 2;
bicep_1 = (data(1).data(:,x))-(data(1).data(:,x+11));
bicep_2 = (data(2).data(:,x))-(data(2).data(:,x+11));
bicep = [bicep_1 ; bicep_2];
clear bicep_1
clear bicep_2
x = 3;
tricep_1 = (data(1).data(:,x))-(data(1).data(:,x+11));
tricep_2 = (data(2).data(:,x))-(data(2).data(:,x+11));
tricep = [tricep_1 ; tricep_2];
clear tricep_1
clear tricep_2
x = 4;
EDC_1 = (data(1).data(:,x))-(data(1).data(:,x+11));
EDC_2 = (data(2).data(:,x))-(data(2).data(:,x+11));
EDC = [EDC_1 ; EDC_2];
clear EDC_1
clear EDC_2
x=25;
Chin_referenced_1 = data(1).data(:,x)-data(1).data(:,x+1);
Chin_referenced_2 = data(2).data(:,x)-data(2).data(:,x+1); 
Chin_referenced = [Chin_referenced_1 ; Chin_referenced_2];
clear Chin_referenced_1
clear Chin_referenced_2
x=27;
ant_tibia_1 = data(1).data(:,x)-data(1).data(:,x+1);
ant_tibia_2 = data(2).data(:,x)-data(2).data(:,x+1); 
ant_tibia = [ant_tibia_1 ; ant_tibia_2];
clear ant_tibia_1
clear ant_tibia_2
x = 35;
UL_Ax_1 = (data(1).data(:,x));
UL_Ax_2 = (data(2).data(:,x));
UL_Ax = [UL_Ax_1 ; UL_Ax_2];
clear UL_Ax_1
clear UL_Ax_2
x = 36;
UL_Ay_1 = (data(1).data(:,x));
UL_Ay_2 = (data(2).data(:,x));
UL_Ay = [UL_Ay_1 ; UL_Ay_2];
clear UL_Ay_1
clear UL_Ay_2
x = 37;
UL_Az_1 = (data(1).data(:,x));
UL_Az_2 = (data(2).data(:,x));
UL_Az = [UL_Az_1 ; UL_Az_2];
clear UL_Az_1
clear UL_Az_2
x = 38;
LL_Ax_1 = (data(1).data(:,x));
LL_Ax_2 = (data(2).data(:,x));
LL_Ax = [LL_Ax_1 ; LL_Ax_2];
clear LL_Ax_1
clear LL_Ax_2
x = 39;
LL_Ay_1 = (data(1).data(:,x));
LL_Ay_2 = (data(2).data(:,x));
LL_Ay = [LL_Ay_1 ; LL_Ay_2];
clear LL_Ay_1
clear LL_Ay_2
x = 40;
LL_Az_1 = (data(1).data(:,x));
LL_Az_2 = (data(2).data(:,x));
LL_Az = [LL_Az_1 ; LL_Az_2];
clear LL_Az_1
clear LL_Az_2

else allLFPs = data.data(1:(epochs*30720),31:34); %need to restrict LFP's up front
lfplead0 = allLFPs(:,1);
lfplead1 = allLFPs(:,2);
lfplead2 = allLFPs(:,3);
lfplead3 = allLFPs(:,4);
clear allLfPs
x = 1;
FDC = (data.data(:,x))-(data.data(:,x+11));
x = 2;
bicep = (data.data(:,x))-(data.data(:,x+11));
x = 3;
tricep = (data.data(:,x))-(data.data(:,x+11));
x = 4;
EDC = (data.data(:,x))-(data.data(:,x+11));
x=25;
Chin_referenced = data.data(:,x)-data.data(:,x+1);
x=27;
ant_tibia = data.data(:,x)-data.data(:,x+1);
x = 35;
UL_Ax = (data.data(:,x));
x = 36;
UL_Ay = (data.data(:,x));
x = 37;
UL_Az = (data.data(:,x));
x = 38;
LL_Ax = (data.data(:,x));
x = 39;
LL_Ay = (data.data(:,x));
x = 40;
LL_Az = (data.data(:,x));
end
clear x
%%
input_string_key   = 'lfp';
input_string_index = strfind(input_string, input_string_key);
input_str = sscanf(input_string(input_string_index(1) + length(input_string_key):end), '%g', 1);
if (input_str) == 1 %of use if lfp01 used
    input_str = sprintf('%02d',input_str);
end

% plot to visualize raw LFP's if desired
%figure(100) 
%subplot(4,1,1)
%plot(lfplead3)
%title('Raw LFPs - lfplead3')
%subplot(4,1,2)
%plot(lfplead2)
%title('Raw LFPs - lfplead2')
%subplot(4,1,3)
%plot(lfplead1)
%title('Raw LFPs - lfplead1')
%subplot(4,1,4)
%plot(lfplead0)
%title('Raw LFPs - lfplead0')

% stair plots for 5 groups - so wake not differentiated into moving/not
Index_load = load (['IndexPT',num2str(PT)]);
IndexPT0 = Index_load.(['IndexPT',num2str(PT)]); 
IndexPT0 = IndexPT0(1:epochs,:); %IndexPT0 to be kept unchanged, used as reference for Dr. Wu's staging directly
IndexPTX = IndexPT0;
% for spectrogram stairs, x axis is per hour (time, fs depedendent)
IndexPTX_bigfigure_score = IndexPT0(:,3);%this should not be IndexPTX_bigfigure_score but I guess it works
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==0 )=scale_wake_all; % Wake
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==5 )=scale_REM;  % REM
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==1 )=scale_N1;  % N1
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==2 )=scale_N2;  % N2
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==3 )=scale_N3;  % N3
IndexPTX_1 = IndexPTX(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
IndexPTX_2 = IndexPTX(:,2)/(1024*60*60);
IndexPTX = [IndexPTX_1,IndexPTX_2,IndexPTX_bigfigure_score];
clear IndexPTX_1 
clear IndexPTX_2 
clear IndexPTX_score
% for EMG/EEG/accelerometer stairs, x axis is per sample
IndexPTX_score_sm = IndexPT0(:,3); %score_sm keeps sleep scoring small numbers
IndexPTX_score_sm( IndexPTX_score_sm==0 )=4.9; % Wake
IndexPTX_score_sm( IndexPTX_score_sm==5 )=3.8;  % REM
IndexPTX_score_sm( IndexPTX_score_sm==1 )=2.9;  % N1
IndexPTX_score_sm( IndexPTX_score_sm==2 )=1.6;  % N2
IndexPTX_score_sm( IndexPTX_score_sm==3 )=0.3;  % N3
IndexPT_EMG = [IndexPT0(:,1),IndexPT0(:,2),IndexPTX_score_sm]; %xaxis is by sample number and y is small numbers
IndexPTX_persample = [IndexPT_EMG(:,1),IndexPT_EMG(:,2),IndexPTX(:,3)];% %xaxis is by sample number and y is large numbers
clear IndexPTX_score_sm
% for spectrogram stairs on subplots, x axis is per hour (time, fs depedendent)
IndexPTX_bigfigure_score = IndexPT0(:,3);
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==0 )=98; % Wake
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==5 )=80;  % REM
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==1 )=60;  % N1
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==2 )=30;  % N2
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==3 )=5;  % N3
IndexPTX_bigfigure_1 = IndexPT0(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
IndexPTX_bigfigure_2 = IndexPT0(:,2)/(1024*60*60);
IndexPTX_bigfigure = [IndexPTX_bigfigure_1,IndexPTX_bigfigure_2,IndexPTX_bigfigure_score];
% plot check to make sure only difference between Index's are scales - important check to keep in code
figure(101)
subplot(4,1,1)
stairs(IndexPTX(:,1), IndexPTX(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- check that indexes match for 5 sleep stage grouping ']);
subplot(4,1,2)
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','b' );
%set(gca, 'YLim', [0 5]);
subplot(4,1,3)
stairs(IndexPTX_persample(:,1), IndexPTX_persample(:,3),'LineWidth',2, 'Color','k' );
subplot(4,1,4)
stairs(IndexPTX_bigfigure(:,1), IndexPTX_bigfigure(:,3),'LineWidth',2, 'Color','g' );

%% lfp0
signal = lfplead0; %input
outData = evalGoodEpochsLFP(signal, 1024, 30);
eventDet = outData.events; %boolean vector, use for logical indexing
Boolean0 = eventDet;
signal_block = zeros(epochs,30720); 
for k = 1:epochs; 
    signal_block(k,:) = signal( 1+(k-1)*30*1024 : k*30*1024);
end
eventDet_block = repmat(eventDet,1,30720); %extends boolean array to match dimensions
signal_block(~eventDet_block) = 0; %logical index
signal_blockT = signal_block';
signal_2 = reshape(signal_blockT,[(epochs*30720),1]);
notch = fir1(tubs,[f1 f2], 'stop'); %notch filter 
signal_3 = filter(notch, 1, signal_2); %signal_3 is post notch
[b,a] = butter(2,1/512,'high'); %butter filter
signal_3B=filter(b,a,signal_3); %signal_3B is post notch&butter
signal_3_lead0 = signal_3B; 
A = length(signal)/30720; %check that this (prob) went well
Aa = floor(A);
AaA = length(signal_3B)/30720;
if Aa ~= AaA
    disp 'ERROR lfp0'
else
    disp 'GOOD lfp0'
end
clear A
clear Aa
clear AaA
clear signal
clear signal_block
clear signal_blockT
clear signal_2
clear a
clear b
clear signal_3
clear signal_block_3
clear signal_3B
clear outData
clear eventDet_block
clear eventDet
%% lfp1
signal = lfplead1;
outData = evalGoodEpochsLFP(signal, 1024, 30);
eventDet = outData.events; %boolean vector, use for logical indexing
Boolean1 = eventDet;
signal_block = zeros(epochs,30720); 
for k = 1:epochs; 
    signal_block(k,:) = signal( 1+(k-1)*30*1024 : k*30*1024);
end
eventDet_block = repmat(eventDet,1,30720); %extends boolean array to match dimensions
signal_block(~eventDet_block) = 0; %logical index
signal_blockT = signal_block';
signal_2 = reshape(signal_blockT,[(epochs*30720),1]);
notch = fir1(tubs,[f1 f2], 'stop'); %notch filter 
signal_3 = filter(notch, 1, signal_2); %signal_3 is post notch
[b,a] = butter(2,1/512,'high'); %butter filter
signal_3B=filter(b,a,signal_3); %signal_3B is post notch&butter
signal_3_lead1 = signal_3B;
A = length(signal)/30720; %check that this (prob) went well
Aa = floor(A);
AaA = length(signal_3B)/30720;
if Aa ~= AaA
    disp 'ERROR lfp1'
else
    disp 'GOOD lfp1'
end
clear A
clear Aa
clear AaA
clear signal
clear signal_block
clear signal_blockT
clear signal_2
clear a
clear b
clear signal_3
clear signal_block_3
clear signal_3B
clear outData
clear eventDet_block
clear eventDet
%% lfp2
signal = lfplead2;
outData = evalGoodEpochsLFP(signal, 1024, 30);
eventDet = outData.events; %boolean vector, use for logical indexing
Boolean2 = eventDet;
signal_block = zeros(epochs,30720); 
for k = 1:epochs; 
    signal_block(k,:) = signal( 1+(k-1)*30*1024 : k*30*1024);
end
eventDet_block = repmat(eventDet,1,30720); %extends boolean array to match dimensions
signal_block(~eventDet_block) = 0; %logical index
signal_blockT = signal_block';
signal_2 = reshape(signal_blockT,[(epochs*30720),1]);
notch = fir1(tubs,[f1 f2], 'stop'); %notch filter 
signal_3 = filter(notch, 1, signal_2); %signal_3 is post notch
[b,a] = butter(2,1/512,'high'); %butter filter
signal_3B=filter(b,a,signal_3); %signal_3B is post notch&butter
signal_3_lead2 = signal_3B;
A = length(signal)/30720; %check that this (prob) went well
Aa = floor(A);
AaA = length(signal_3B)/30720;
if Aa ~= AaA
    disp 'ERROR lfp2'
else
    disp 'GOOD lfp2'
end
clear A
clear Aa
clear AaA
clear signal
clear signal_block
clear signal_blockT
clear signal_2
clear a
clear b
clear signal_3
clear signal_block_3
clear signal_3B
clear outData
clear eventDet_block
clear eventDet
%% lfp3
signal = lfplead3;
outData = evalGoodEpochsLFP(signal, 1024, 30);
eventDet = outData.events; %boolean vector, use for logical indexing
Boolean3 = eventDet;
signal_block = zeros(epochs,30720); 
for k = 1:epochs; 
    signal_block(k,:) = signal( 1+(k-1)*30*1024 : k*30*1024);
end
eventDet_block = repmat(eventDet,1,30720); %extends boolean array to match dimensions
signal_block(~eventDet_block) = 0; %logical index
signal_blockT = signal_block';
signal_2 = reshape(signal_blockT,[(epochs*30720),1]);
notch = fir1(tubs,[f1 f2], 'stop'); %notch filter 
signal_3 = filter(notch, 1, signal_2); %signal_3 is post notch
[b,a] = butter(2,1/512,'high'); %butter filter
signal_3B=filter(b,a,signal_3); %signal_3B is post notch&butter
signal_3_lead3 = signal_3B;
A = length(signal)/30720; %check that this (prob) went well
Aa = floor(A);
AaA = length(signal_3B)/30720;
if Aa ~= AaA
    disp 'ERROR lfp3'
else
    disp 'GOOD lfp3'
end
clear A
clear Aa
clear AaA
clear signal
clear signal_block
clear signal_blockT
clear signal_2
clear a
clear b
clear signal_3
clear signal_block_3
clear signal_3B
clear outData
clear eventDet_block
clear eventDet
%% must combine boolean output from each channel to create one with all outliers identified
fB0 = find(Boolean0==0);
fB1 = find(Boolean1==0);
fB2 = find(Boolean2==0);
fB3 = find(Boolean3==0);
fB_all = [fB0; fB1; fB2; fB3];
ufB_all = unique(fB_all); % unique epoches to index out
Boolean_master = ones(epochs,1);
Boolean_master(ufB_all) = 0;
FbT = find(Boolean_master==0); % so use BooleanT to index out
if ufB_all ~= FbT;
    disp('ERROR Boolean master compile');
else
     disp('GOOD Boolean master compile');
end
clear Boolean0
clear Boolean1
clear Boolean2
clear Boolean3
clear Fb0
clear Fb1
clear Fb2
clear Fb3
clear FbC
clear uFbC

signalblock_3_lead0 = zeros(epochs,30720); 
for k = 1:epochs;
    signalblock_3_lead0(k,:) = signal_3_lead0( 1+(k-1)*30*1024 : k*30*1024);
end
signalblock_3_lead1 = zeros(epochs,30720); 
for k = 1:epochs; 
    signalblock_3_lead1(k,:) = signal_3_lead1( 1+(k-1)*30*1024 : k*30*1024);
end
signalblock_3_lead2 = zeros(epochs,30720);
for k = 1:epochs; 
    signalblock_3_lead2(k,:) = signal_3_lead2( 1+(k-1)*30*1024 : k*30*1024);
end
signalblock_3_lead3 = zeros(epochs,30720);
for k = 1:epochs; 
    signalblock_3_lead3(k,:) = signal_3_lead3( 1+(k-1)*30*1024 : k*30*1024);
end
%Need below to match Boolean output from eval.epoch across each LFP
Boolean_master_block = repmat(Boolean_master,1,30720); %7/14/16 changed eventDet to Boolean_master
signalblock_3_lead0(~Boolean_master_block) = 0;
signalblock_3_lead1(~Boolean_master_block) = 0;
signalblock_3_lead2(~Boolean_master_block) = 0;
signalblock_3_lead3(~Boolean_master_block) = 0;

fBsb1 = find(signalblock_3_lead1==0);
fBsb3 = find(signalblock_3_lead0==0); 
if fBsb1 ~= fBsb3; %self check
    disp('ERROR - Boolean master compile II')
else
    disp('GOOD - Boolean master compile II')
end
clear fBsb1
clear fBsb3
%
BlockT0 = signalblock_3_lead0';
Signal0 = reshape(BlockT0,[(epochs*30720),1]);
BlockT1 = signalblock_3_lead1';
Signal1 = reshape(BlockT1,[(epochs*30720),1]);
BlockT2 = signalblock_3_lead2';
Signal2 = reshape(BlockT2,[(epochs*30720),1]);
BlockT3 = signalblock_3_lead3';
Signal3 = reshape(BlockT3,[(epochs*30720),1]);
clear BlockT0
clear BlockT1
clear BlockT2
clear BlockT3
A = length(find(Signal3==0)); %self check
Aa = length(ufB_all)*30720;
if A ~= Aa
    disp ('ERROR - Boolean master compile III')
else
    disp ('GOOD - Boolean master compile III')
end
clear A
clear Aa
%figure(103) %plot to visualize raw LFP's vs pre-processed if desired
%subplot(4,1,1)
%plot(lfplead3)
%hold on
%plot(Signal3)
%title('Raw vs. Pre-processed LFPs - lfplead3')
%subplot(4,1,2)
% plot(lfplead2)
% hold on
% plot(Signal2)
% title('Raw vs. Pre-processed LFPs -  lfplead2')
% subplot(4,1,3)
% plot(lfplead1)
% hold on
% plot(Signal1)
% title('Raw vs. Pre-processed LFPs - lfplead1')
% subplot(4,1,4)
% plot(lfplead0)
% hold on
% plot(Signal0)
% title('Raw vs. Pre-processed LFPs - lfplead0')
lfp01 = Signal0 - Signal1;
lfp12 = Signal1 - Signal2;
lfp23 = Signal2 - Signal3;
clear Signal0
clear Signal1
clear Signal2
clear Signal3
%%
sleepstages_five=['N3  ';'N2  ';'N1  ';'REM ';'Wake'];
window_lfp = 100000;
noverlap_lfp = 60000;

figure(203)
subplot(3,1,3) 
spectrogram(lfp01,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX(:,1), IndexPTX(:,3),'LineWidth',2, 'Color','r' );
title(['LFP0-LFP1 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 11],'YTick',7:11,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(3,1,2) 
spectrogram(lfp12,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX(:,1), IndexPTX(:,3),'LineWidth',2, 'Color','r' );
title(['LFP1-LFP2 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 11],'YTick',7:11,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(3,1,1) 
spectrogram(lfp23,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX(:,1), IndexPTX(:,3),'LineWidth',2, 'Color','r' );
title(['LFP2-LFP3 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 11],'YTick',7:11,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
%N = length(lfp01); % can use to optimize window length
%figure(115)
%for len = 100000:100000:N; %starts at first numb, increased by next till N
%    spectrogram(lfp01,len,0, 0:100, fs, 'yaxis')
%    hold on
%    stairs(IndexPTX,'LineWidth',2, 'Color','r' );    
%    title(sprintf('Hamming Window Size :: %d', len))
%    pause();
%end

%% Index by sleep stage
%Literature supports using 4-10, 13-30, and 60-80 Hz bands as these have greatest differences in ON vs OFF DA-drug 
input_lfp = lfp12; %important to keep in mind there are still zeros here from boolean indexing
Signal0_block = zeros(epochs,30720);  
for k = 1:epochs; 
    Signal0_block(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
end
if input_lfp(30721,1) == Signal0_block(2,1)
    disp('GOOD line ~600')
else 
    disp('ERROR line ~600');
end
if input_lfp(614401,1) == Signal0_block(21,1)
    disp('GOOD line ~600')
else 
    disp('ERROR line ~600');
end
Signal0_block_index = [Signal0_block, IndexPTX(:,3)]; %epochs with indexing at end
%% Grouping by sleep score 
Signal0_block_1 = zeros(epochs, 30720); %Wake
%this is probably just a bad way to index
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_wake_all
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
%
Signal0_block_2 = Signal0_block_1; %
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros
if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR Wake')
end
[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_Wake = reshape(Signal0_block_2T,[needed_rows,1]); %back in vector form
%^ is it okay to lump everything together? cause pwelch's window might
%overlap on data from separate bouts of a given PSG stage

%need to make some kind of if/then statement to determine whether analysis
%proceeds, if no values for a sleep stage need to not compute it
Signal0_block_1 = zeros(epochs, 30720); %REM
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_REM
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros
if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR REM')
end
[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_REM = reshape(Signal0_block_2T,[needed_rows,1]);
Signal0_block_1 = zeros(epochs, 30720); %N1
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_N1
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros
if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR N1')
end
[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N1 = reshape(Signal0_block_2T,[needed_rows,1]);
Signal0_block_1 = zeros(epochs, 30720); %N2
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_N2
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros
if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR N2')
end
[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N2 = reshape(Signal0_block_2T,[needed_rows,1]);
Signal0_block_1 = zeros(epochs, 30720); %N3
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_N3
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros
if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR N3')
end
[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N3 = reshape(Signal0_block_2T,[needed_rows,1]);
Wake = PTX_Wake;
REM = PTX_REM; 
N1 = PTX_N1;
N2 = PTX_N2;
N3 = PTX_N3; 
%sanity check
Aa = length(input_lfp);
A1 = length(Wake);
A2 = length(REM);
A3 = length(N1);
A4 = length(N2);
A5 = length(N3);
AaA = length(find(input_lfp==0));
if Aa-(sum(A1+A2+A3+A4+A5)) ~= AaA
    disp 'ERROR, see Indexing' %possible to get error if there is a 0 in the actual data, check to see whether if statement is off by just a few values or many, if few they don't worry about error message
else
    disp 'GOOD Indexing 657'
    clear Aa
    clear A1
    clear A2
    clear A3
    clear A4
    clear A5
    clear AaA
end
%% plot total LFP vs LFP indexed by sleep stage
Ry1 = -0.05; %y axis range start
Ry2 = 0.05;
figure(104)
subplot(6,1,1)
plot(input_lfp)
set(gca, 'YLim', [Ry1 Ry2]);
title(['LFP',num2str(input_str)])
subplot(6,1,2)
plot(Wake)
set(gca, 'YLim', [Ry1 Ry2]);
title('Wake')
subplot(6,1,3)
plot(REM)
set(gca, 'YLim', [Ry1 Ry2]);
title('REM')
subplot(6,1,4)
plot(N1)
set(gca, 'YLim', [Ry1 Ry2]);
title('N1')
subplot(6,1,5)
plot(N2)
set(gca, 'YLim', [Ry1 Ry2]);
title('N2')
subplot(6,1,6)
plot(N3)
set(gca, 'YLim', [Ry1 Ry2]);
title('N3')
%% plot total LFP pwelch vs LFP indexed by sleep stage pwelch
Ry1 = -100; %y axis range start
Ry2 = 0;
Rx1 = 0; %x axis range start
Rx2 = 30;
figure(105)
subplot(6,1,1)
pwelch(input_lfp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title(['LFP',num2str(input_str)])
subplot(6,1,2)
pwelch(Wake,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('Wake')
subplot(6,1,3)
pwelch(REM,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('REM')
subplot(6,1,4)
pwelch(N1,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N1')
subplot(6,1,5)
pwelch(N2,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N2')
subplot(6,1,6)
pwelch(N3,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N3')
%% 4-10 Hz Band
band_start = 4;
band_end = 10;
band = [band_start band_end];
%Each PSG stage powers
% need to plot something meaningful here
% come back and automate the 4to10 with band_start/end
[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_4to10 = bandpower(Pxx,F,band,'psd');
% ptot0_4to10 = bandpower(Pxx,F,'psd');
% per_power0_4to10 = 100*(pband0_4to10/ptot0_4to10);

[Pxx,F] = periodogram(Wake,rectwin(length(Wake)),length(Wake),Fs);
pband1_4to10 = bandpower(Pxx,F,band,'psd');
ptot1_4to10 = bandpower(Pxx,F,'psd');
per_power1_4to10 = 100*(pband1_4to10/ptot1_4to10);

[Pxx,F] = periodogram(REM,rectwin(length(REM)),length(REM),Fs);
pband2_4to10 = bandpower(Pxx,F,band,'psd');
ptot2_4to10 = bandpower(Pxx,F,'psd');
per_power2_4to10 = 100*(pband2_4to10/ptot2_4to10);

[Pxx,F] = periodogram(N1,rectwin(length(N1)),length(N1),Fs);
pband3_4to10 = bandpower(Pxx,F,band,'psd');
ptot3_4to10 = bandpower(Pxx,F,'psd');
per_power3_4to10 = 100*(pband3_4to10/ptot3_4to10);

[Pxx,F] = periodogram(N2,rectwin(length(N2)),length(N2),Fs);
pband4_4to10 = bandpower(Pxx,F,band,'psd');
ptot4_4to10 = bandpower(Pxx,F,'psd');
per_power4_4to10 = 100*(pband4_4to10/ptot4_4to10);

[Pxx,F] = periodogram(N3,rectwin(length(N3)),length(N3),Fs);
pband5_4to10 = bandpower(Pxx,F,band,'psd');
ptot5_4to10 = bandpower(Pxx,F,'psd');
per_power5_4to10 = 100*(pband5_4to10/ptot5_4to10);

Per_Power_4to10 = per_power1_4to10+per_power2_4to10+per_power3_4to10+per_power4_4to10+per_power5_4to10;
disp(Per_Power_4to10);

if ptot1_4to10>ptot4_4to10
    disp('ptot1_4to10 larger')
else
    disp('ptot4_4to10 larger')
end

figure(30000)
y_pband_4to10 = [pband0_4to10,pband1_4to10,pband2_4to10,pband3_4to10,pband4_4to10,pband5_4to10];
bar(y_pband_4to10);
grid on
l = cell(1,6);
l{1}='All'; l{2}='Wake'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';   
set(gca,'xticklabel', l) 
title(['PT' num2str(PT) 'LFP' num2str(input_str) ': power bands for' num2str(band_start),'-',num2str(band_end),'Hz'])
%
window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(210) %subplots for each PSG stage for 'band'
subplot(5,1,1)
pwelch(Wake,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,2)
pwelch(REM,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,3)
pwelch(N1,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,4)
pwelch(N2,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,5)
pwelch(N3,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%pwelch overlay chaos
%window = (band_end - band_start)*50;
%noverlap = (band_end - band_start)*25;

figure(211) 
[pxx_1, f] = pwelch(Wake,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake','REM','N1', 'N2', 'N3') %need to change if not all channels
legend('boxoff')

%% 13- 30 Hz Band
band_start = 13;
band_end = 30;
band = [band_start band_end];

[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_13to30 = bandpower(Pxx,F,band,'psd');
% ptot0_13to30 = bandpower(Pxx,F,'psd');
% per_power0_13to30 = 100*(pband0_13to30/ptot0_13to30);

[Pxx,F] = periodogram(Wake,rectwin(length(Wake)),length(Wake),Fs);
pband1_13to30 = bandpower(Pxx,F,band,'psd');
ptot1_13to30 = bandpower(Pxx,F,'psd');
per_power1_13to30 = 100*(pband1_13to30/ptot1_13to30);

[Pxx,F] = periodogram(REM,rectwin(length(REM)),length(REM),Fs);
pband2_13to30= bandpower(Pxx,F,band,'psd');
ptot2_13to30 = bandpower(Pxx,F,'psd');
per_power2_13to30 = 100*(pband2_13to30/ptot2_13to30);

[Pxx,F] = periodogram(N1,rectwin(length(N1)),length(N1),Fs);
pband3_13to30 = bandpower(Pxx,F,band,'psd');
ptot3_13to30 = bandpower(Pxx,F,'psd');
per_power3_13to30 = 100*(pband3_13to30/ptot3_13to30);

[Pxx,F] = periodogram(N2,rectwin(length(N2)),length(N2),Fs);
pband4_13to30 = bandpower(Pxx,F,band,'psd');
ptot4_13to30 = bandpower(Pxx,F,'psd');
per_power4_13to30 = 100*(pband4_13to30/ptot4_13to30);

[Pxx,F] = periodogram(N3,rectwin(length(N3)),length(N3),Fs);
pband5_13to30 = bandpower(Pxx,F,band,'psd');
ptot5_13to30 = bandpower(Pxx,F,'psd');
per_power5_13to30 = 100*(pband5_13to30/ptot5_13to30);

Per_Power_13to30 = per_power1_13to30+per_power2_13to30+per_power3_13to30+per_power4_13to30+per_power5_13to30;
disp(Per_Power_13to30);

if ptot1_13to30>ptot4_13to30
    disp('ptot1_13to30 larger')
else
    disp('ptot4_13to30 larger')
end

figure(30001)
y_pband_13to30 = [pband0_13to30,pband1_13to30,pband2_13to30,pband3_13to30,pband4_13to30,pband5_13to30];
bar(y_pband_13to30);
grid on
l = cell(1,6);
l{1}='All'; l{2}='Wake'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';    %funky because of N2
set(gca,'xticklabel', l) 
title(['PT' num2str(PT) 'LFP',num2str(input_str) ': power bands for',num2str(band_start),'-',num2str(band_end),'Hz'])
%
window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(220) %subplots for each PSG stage for 'band'
subplot(5,1,1)
pwelch(Wake,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,2)
pwelch(REM,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,3)
pwelch(N1,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,4)
pwelch(N2,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,5)
pwelch(N3,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%pwelch overlay chaos
%window = (band_end - band_start)*50;
%noverlap = (band_end - band_start)*25;

figure(221) 
[pxx_1, f] = pwelch(Wake,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake','REM','N1', 'N2', 'N3')
legend('boxoff')

%% 60-80 Hz Band
band_start = 60;
band_end = 80;
band = [band_start band_end];

%Each PSG stage powers'
[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_60to80 = bandpower(Pxx,F,band,'psd');
% ptot0_60to80 = bandpower(Pxx,F,'psd');
% per_power0_60to80 = 100*(pband0_60to80/ptot0_60to80);

[Pxx,F] = periodogram(Wake,rectwin(length(Wake)),length(Wake),Fs);
pband1_60to80= bandpower(Pxx,F,band,'psd');
ptot1_60to80 = bandpower(Pxx,F,'psd');
per_power1_60to80= 100*(pband1_60to80/ptot1_60to80);

[Pxx,F] = periodogram(REM,rectwin(length(REM)),length(REM),Fs);
pband2_60to80 = bandpower(Pxx,F,band,'psd');
ptot2_60to80= bandpower(Pxx,F,'psd');
per_power2_60to80 = 100*(pband2_60to80/ptot2_60to80);

[Pxx,F] = periodogram(N1,rectwin(length(N1)),length(N1),Fs);
pband3_60to80 = bandpower(Pxx,F,band,'psd');
ptot3_60to80 = bandpower(Pxx,F,'psd');
per_power3_60to80 = 100*(pband3_60to80/ptot3_60to80);

[Pxx,F] = periodogram(N2,rectwin(length(N2)),length(N2),Fs);
pband4_60to80= bandpower(Pxx,F,band,'psd');
ptot4_60to80 = bandpower(Pxx,F,'psd');
per_power4_60to80 = 100*(pband4_60to80/ptot4_60to80);

[Pxx,F] = periodogram(N3,rectwin(length(N3)),length(N3),Fs);
pband5_60to80 = bandpower(Pxx,F,band,'psd');
ptot5_60to80 = bandpower(Pxx,F,'psd');
per_power5_60to80 = 100*(pband5_60to80/ptot5_60to80);

Per_Power_60to80 = per_power1_60to80+per_power2_60to80+per_power3_60to80+per_power4_60to80+per_power5_60to80;
disp(Per_Power_60to80);

if ptot1_60to80>ptot4_60to80
    disp('ptot1_60to80 larger')
else
    disp('ptot4_60to80larger')
end

figure(30003)
y_pband_60to80 = [pband0_60to80,pband1_60to80,pband2_60to80,pband3_60to80,pband4_60to80,pband5_60to80];
bar(y_pband_60to80);
grid on
l = cell(1,6);
l{1}='All'; l{2}='Wake'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';    %funky because of N2
set(gca,'xticklabel', l) 
title(['PT' num2str(PT) 'LFP',num2str(input_str) ': power bands for',num2str(band_start),'-',num2str(band_end),'Hz'])

%
window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(230) %subplots for each PSG stage for 'band'
subplot(5,1,1)
pwelch(Wake,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,2)
pwelch(REM,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,3)
pwelch(N1,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,4)
pwelch(N2,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

subplot(5,1,5)
pwelch(N3,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%pwelch overlay chaos
%window = (band_end - band_start)*50;
%noverlap = (band_end - band_start)*25;

figure(231) 
[pxx_1, f] = pwelch(Wake,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake','REM','N1', 'N2', 'N3')
legend('boxoff')
%%
% for spectrogram stairs, x axis is per hour (time, fs depedendent)
IndexPTX_bigfigure_score = IndexPT0(:,3);
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==0 )=98; % Wake
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==5 )=80;  % REM
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==1 )=60;  % N1
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==2 )=30;  % N2
IndexPTX_bigfigure_score( IndexPTX_bigfigure_score==3 )=5;  % N3
IndexPTX_bigfigure_1 = IndexPT0(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
IndexPTX_bigfigure_2 = IndexPT0(:,2)/(1024*60*60);
IndexPTX_bigfigure = [IndexPTX_bigfigure_1,IndexPTX_bigfigure_2,IndexPTX_bigfigure_score];
%%
figure(3970)
subplot(7,1,1) 
spectrogram(input_lfp,100000, 60000, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX_bigfigure(:,1), IndexPTX_bigfigure(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) 'LFP',num2str(input_str)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')% EEG/EMG comparison
set(gca, 'YLim', [scale_big1 (scale_big2+5)]);
subplot(7,1,2) 
plot(FDC)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced FDC ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,3) 
plot(bicep)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced bicep ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,4) 
plot(tricep)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced tricep ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,5) 
plot(EDC)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced EDC ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,6) 
plot(Chin_referenced)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) ' - referenced chin ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,7) 
plot(ant_tibia)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced anterior tibia']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);

%%
figure(3971)
subplot(7,1,1) 
spectrogram(input_lfp,window_lfp, noverlap_lfp, 0:100, fs, 'yaxis')
hold on
stairs(IndexPTX_bigfigure(:,1), IndexPTX_bigfigure(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) 'LFP',num2str(input_str)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
% adding in subplots to determine optimal comparison
subplot(7,1,2)
plot(UL_Ax)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : UL Ax']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(7,1,3)  
plot(UL_Ay)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : UL Ay']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(7,1,4)  
plot(UL_Az)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : UL Az']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(7,1,5)  
plot(LL_Ax)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : LL Ax']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(7,1,6)  
plot(LL_Ay)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : LL Ay']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(7,1,7)  
plot(LL_Az)
hold on
stairs(IndexPT_EMG(:,1), IndexPT_EMG(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : LL Az']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 5],'YTick',1:5,'YTickLabel',sleepstages_five, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')

%% block signal into epochs 
Signal0_block_wake_diff = zeros(epochs, 30720); %
%this is probably just a bad way to index
for k = 1:epochs; 
    if Signal0_block_index(k,30721) == scale_wake_all
     Signal0_block_wake_diff(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
%%
Wake_diff_average = zeros(epochs, 6);
Wake_diff_boolean = zeros(epochs, 6); 

UL_Ax_abs = abs(UL_Ax);
col = 1;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(UL_Ax_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_UL_Ax_abs = mean(UL_Ax_abs);
sdSeg_UL_Ax_abs = std(UL_Ax_abs);
% Compute threshold 
thrseg_UL_Ax_abs = mSeg_UL_Ax_abs + (sdSeg_UL_Ax_abs * 2);
%thrseg_UL_Ax_abs = mSeg_UL_Ax_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_UL_Ax_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end


%%

UL_Ay_abs = abs(UL_Ay);
col = 2;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(UL_Ay_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_UL_Ay_abs = mean(UL_Ay_abs);
sdSeg_UL_Ay_abs = std(UL_Ay_abs);
% Compute threshold 
thrseg_UL_Ay_abs = mSeg_UL_Ay_abs + (sdSeg_UL_Ay_abs * 2);
%thrseg_UL_Ay_abs = mSeg_UL_Ay_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_UL_Ay_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end
%%
UL_Az_abs = abs(UL_Az);
col = 3;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(UL_Az_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_UL_Az_abs = mean(UL_Az_abs);
sdSeg_UL_Az_abs = std(UL_Az_abs);
% Compute threshold 
thrseg_UL_Az_abs = mSeg_UL_Az_abs + (sdSeg_UL_Az_abs * 2);
%thrseg_UL_Az_abs = mSeg_UL_Az_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_UL_Az_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end

%%
LL_Ax_abs = abs(LL_Ax);
col = 4;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(LL_Ax_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_LL_Ax_abs = mean(LL_Ax_abs);
sdSeg_LL_Ax_abs = std(LL_Ax_abs);
% Compute threshold 
thrseg_LL_Ax_abs = mSeg_LL_Ax_abs + (sdSeg_LL_Ax_abs * 2);
%thrseg_LL_Ax_abs = mSeg_LL_Ax_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_LL_Ax_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end

%%
LL_Ay_abs = abs(LL_Ay);
col = 5;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(LL_Ay_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_LL_Ay_abs = mean(LL_Ay_abs);
sdSeg_LL_Ay_abs = std(LL_Ay_abs);
% Compute threshold 
thrseg_LL_Ay_abs = mSeg_LL_Ay_abs + (sdSeg_LL_Ay_abs * 2);
%thrseg_LL_Ay_abs = mSeg_LL_Ay_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_LL_Ay_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end
%%
LL_Az_abs = abs(LL_Az);
col = 6;

for k = 1:epochs;
    if sum(Signal0_block_wake_diff(k,:)) ~= 0
        Wake_diff_average(k,col) = mean(LL_Az_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean(k,col) = 1;
    end
end

mSeg_LL_Az_abs = mean(LL_Az_abs);
sdSeg_LL_Az_abs = std(LL_Az_abs);
% Compute threshold 
thrseg_LL_Az_abs = mSeg_LL_Az_abs + (sdSeg_LL_Az_abs * 2);
%thrseg_LL_Az_abs = mSeg_LL_Az_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average(k,col) > thrseg_LL_Az_abs;
              Wake_diff_boolean(k,col) = 9;
        end
end

%%
Index_movementORno = zeros(epochs, 1);
for k = 1:epochs
    if sum(Wake_diff_boolean(k,:)) ~= 0
        Index_movementORno(k,:) = 7;
        if sum(Wake_diff_boolean(k,:)) > 9
            Index_movementORno(k,:) = 9;
        end
    end
end


%%
Index_sixgroups = zeros(epochs,1);
for k = 1:epochs
    if Index_movementORno(k,1) ~= 0
        Index_sixgroups(k,1) = Index_movementORno(k,1);
    else Index_movementORno(k,1) = 0;
        Index_sixgroups(k,1) = IndexPT0(k,3);
    end
end
%% looks good so far, now we want to re-run code but with an additional group in all plots


% stair plots for 6 groups - so wake  differentiated into moving/not
IndexPTX_6grp = IndexPT0;
% for spectrogram stairs, x axis is per hour (time, fs depedendent)
% IndexPTX_6grp_score = Index_sixgroups; %this should not be IndexPTX_bigfigure_score but I guess it works
% IndexPTX_6grp_score( IndexPTX_6grp_score==9 )=scale_wake_WITH_6grp; % Wake w/ movement
% IndexPTX_6grp_score( IndexPTX_6grp_score==7 )=scale_wake_wOUT_6grp; % Wake w/out movement
% IndexPTX_6grp_score( IndexPTX_6grp_score==5 )=scale_REM_6grp;  % REM
% IndexPTX_6grp_score( IndexPTX_6grp_score==1 )=scale_N1_6grp;  % N1
% IndexPTX_6grp_score( IndexPTX_6grp_score==2 )=scale_N2_6grp;  % N2
% IndexPTX_6grp_score( IndexPTX_6grp_score==3 )=scale_N3_6grp;  % N3
% IndexPTX_6grp_score_1 = IndexPTX_6grp(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
% IndexPTX_6grp_score_2 = IndexPTX_6grp(:,2)/(1024*60*60);
% IndexPTX_6grp = [IndexPTX_6grp_score_1,IndexPTX_6grp_score_2,IndexPTX_6grp_score];
% clear IndexPTX_6grp_score_1
% clear IndexPTX_6grp_score_2

%%
% for EMG/EEG/accelerometer stairs, x axis is per sample

% Index_6grp_score_sm = Index_sixgroups; %score_sm keeps sleep scoring small numbers
% Index_6grp_score_sm( Index_6grp_score_sm==9 )=4.9; % Wake w/ movement
% Index_6grp_score_sm( Index_6grp_score_sm==7 )=4.1; % Wake w/out movement
% Index_6grp_score_sm( Index_6grp_score_sm==5 )=3.2;  % REM
% Index_6grp_score_sm( Index_6grp_score_sm==1 )=2.3;  % N1
% Index_6grp_score_sm( Index_6grp_score_sm==2 )=1.3;  % N2
% Index_6grp_score_sm( Index_6grp_score_sm==3 )=.3;  % N3
% %should rename variable below and see what the deal is, should be used much
% %more downstream than indicated
% IndexPT_6grp_EMG = [IndexPT0(:,1),IndexPT0(:,2),Index_6grp_score_sm]; 
% IndexPTX_6grp_persample = [IndexPT_6grp_EMG(:,1),IndexPT_6grp_EMG(:,2),IndexPTX_6grp_score];% %xaxis is by sample number and y is large numbers
 %%
% for spectrogram stairs on subplots, x axis is per hour (time, fs depedendent)
% IndexPTX_6grp_bigfigure_score = Index_sixgroups;
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==9 )=98; % Wake
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==7 )=80; % Wake
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==5 )=60;  % REM
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==1 )=40;  % N1
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==2 )=20;  % N2
% IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==3 )=4;  % N3
% IndexPTX_6grp_bigfigure_1 = IndexPT0(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
% IndexPTX_6grp_bigfigure_2 = IndexPT0(:,2)/(1024*60*60);
% IndexPTX_6grp_bigfigure = [IndexPTX_6grp_bigfigure_1,IndexPTX_6grp_bigfigure_2,IndexPTX_6grp_bigfigure_score];

%%
% figure(1011)
% subplot(4,1,1)
% stairs(IndexPTX_6grp(:,1), IndexPTX_6grp(:,3),'LineWidth',2, 'Color','r' );
% title(['PT' num2str(PT) '- check that indexes match for 6 sleep stage grouping ']);
% subplot(4,1,2)
% stairs(IndexPT_6grp_EMG(:,1), IndexPT_6grp_EMG(:,3),'LineWidth',2, 'Color','b' );
% %set(gca, 'YLim', [0 5]);
% subplot(4,1,3)
% stairs(IndexPTX_6grp_persample(:,1), IndexPTX_6grp_persample(:,3),'LineWidth',2, 'Color','k' );
% subplot(4,1,4)
% stairs(IndexPTX_6grp_bigfigure(:,1), IndexPTX_6grp_bigfigure(:,3),'LineWidth',2, 'Color','g' );
 %%
Signal0_block_index_sixgroups = [Signal0_block, Index_sixgroups]; %epochs with indexing at end

%% Grouping by sleep score CONTINUE HERE
%% Wake w/ movement
Signal0_block_1 = zeros(epochs, 30720); %Wake w/ movement
%this is probably just a bad way to index
for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 9
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
%
Signal0_block_2 = Signal0_block_1; %
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros


if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_Wake_wMovement = reshape(Signal0_block_2T,[needed_rows,1]); %back in vector form

%% Wake w/out Movement

Signal0_block_1 = zeros(epochs, 30720); %Wake w/OUT movement
%this is probably just a bad way to index
for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 7
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
%
Signal0_block_2 = Signal0_block_1; %
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros


if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_Wake_wOUTMovement = reshape(Signal0_block_2T,[needed_rows,1]); %back in vector form

%% self-check
if length(PTX_Wake) ~= length(PTX_Wake_wMovement) + length(PTX_Wake_wOUTMovement)
    disp 'ERROR with Movement Indexing 1571'
else
    disp ' GOOD with Movement Indexing 1574'
end
%% REM, N1, N2, N3

%need to make some kind of if/then statement to determine whether analysis
%proceeds, if no values for a sleep stage need to not compute it

Signal0_block_1 = zeros(epochs, 30720); %REM

for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 5
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end

Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros

if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_REM = reshape(Signal0_block_2T,[needed_rows,1]);

Signal0_block_1 = zeros(epochs, 30720); %N1

for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 1
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end

Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros

if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N1 = reshape(Signal0_block_2T,[needed_rows,1]);

Signal0_block_1 = zeros(epochs, 30720); %N2

for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 2
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end

Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros

if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N2 = reshape(Signal0_block_2T,[needed_rows,1]);

Signal0_block_1 = zeros(epochs, 30720); %N3

for k = 1:epochs; 
    if Signal0_block_index_sixgroups(k,30721) == 3
     Signal0_block_1(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end

Signal0_block_2 = Signal0_block_1;
Signal0_block_2( ~any(Signal0_block_2,2), : ) = [];  % delete rows made of zeros

if sum(Signal0_block_2) ~= sum(Signal0_block_1)
    disp('ERROR')
end

[m,n]  = size(Signal0_block_2);
needed_rows = m*n;
Signal0_block_2T = Signal0_block_2';
PTX_N3 = reshape(Signal0_block_2T,[needed_rows,1]);

%all of the following values have their zeros indexed out
Wake_WITH_6grp = PTX_Wake_wMovement;
Wake_wOUT_6grp = PTX_Wake_wOUTMovement;
REM_6grp = PTX_REM; 
N1_6grp = PTX_N1;
N2_6grp = PTX_N2;
N3_6grp = PTX_N3;
%% self-check
check1 = length(find(Index_movementORno==0)); % #epochs NOT wake after movement processing
check2 = epochs-(((length(Wake_WITH_6grp))/30720) + ((length(Wake_wOUT_6grp))/30720)); %epchs aside from wake

if check1 ~= check2
    disp 'ERROR Wake Move/Not 1673'
else
    disp 'GOOD Wake Move/Not 1675'
end

%%
Aa = length(input_lfp);
A1 = length(Wake_WITH_6grp);
A1_5 = length(Wake_wOUT_6grp);
A2 = length(REM_6grp);
A3 = length(N1_6grp);
A4 = length(N2_6grp);
A5 = length(N3_6grp);

AaA = length(find(input_lfp==0));

if Aa-(sum(A1+A1_5+A2+A3+A4+A5)) ~= AaA
    disp 'ERROR, see Indexing 1690' %possible to get error if there is a 0 in the actual data, check to see whether if statement is off by just a few values or many, if few they don't worry about error message
else
    disp 'GOOD'
    clear Aa
    clear A1
    clear A1_5
    clear A2
    clear A3
    clear A4
    clear A5
    clear AaA
end

%% plot total LFP vs LFP indexed by sleep stage
%Ry1 = -0.05; %y axis range start
%Ry2 = 0.05;
figure(1041)
subplot(7,1,1)
plot(input_lfp)
set(gca, 'YLim', [Ry1 Ry2]);
title(['LFP',num2str(input_str)])
subplot(7,1,2)
plot(Wake_WITH_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('Wake with movement')
subplot(7,1,3)
plot(Wake_wOUT_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('Wake without movement')
subplot(7,1,4)
plot(REM_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('REM')
subplot(7,1,5)
plot(N1_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('N1')
subplot(7,1,6)
plot(N2_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('N2')
subplot(7,1,7)
plot(N3_6grp)
set(gca, 'YLim', [Ry1 Ry2]);
title('N3')

clear Ry1
clear Ry2
%% plot total LFP pwelch vs LFP indexed by sleep stage pwelch
Ry1 = -100; %y axis range start
Ry2 = 0;
Rx1 = 0; %x axis range start
Rx2 = 30;
figure(1051)
subplot(7,1,1)
pwelch(input_lfp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title(['LFP',num2str(input_str)])
subplot(7,1,2)
pwelch(Wake_WITH_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('Wake with movement')
subplot(7,1,3)
pwelch(Wake_wOUT_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('Wake without movement')
subplot(7,1,4)
pwelch(REM_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('REM')
subplot(7,1,5)
pwelch(N1_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N1')
subplot(7,1,6)
pwelch(N2_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N2')
subplot(7,1,7)
pwelch(N3_6grp,window,noverlap,f,fs)
set(gca, 'XLim', [Rx1 Rx2]);
%set(gca, 'YLim', [Ry1 Ry2]);
title('N3')
%% 4-10 Hz Band
band_start = 4;
band_end = 10;
band = [band_start band_end];

%Each PSG stage powers
% need to plot something meaningful here
% come back and automate the 4to10 with band_start/end
[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_4to10 = bandpower(Pxx,F,band,'psd');
ptot0_4to10 = bandpower(Pxx,F,'psd');
per_power0_4to10 = 100*(pband0_4to10/ptot0_4to10);

[Pxx,F] = periodogram(Wake_wOUT_6grp,rectwin(length(Wake_wOUT_6grp)),length(Wake_wOUT_6grp),Fs);
pband1_4to10 = bandpower(Pxx,F,band,'psd');
ptot1_4to10 = bandpower(Pxx,F,'psd');
per_power1_4to10 = 100*(pband1_4to10/ptot1_4to10);

[Pxx,F] = periodogram(Wake_WITH_6grp,rectwin(length(Wake_WITH_6grp)),length(Wake_WITH_6grp),Fs);
pband9_4to10 = bandpower(Pxx,F,band,'psd');
ptot9_4to10 = bandpower(Pxx,F,'psd');
per_power9_4to10 = 100*(pband9_4to10/ptot9_4to10);

[Pxx,F] = periodogram(REM_6grp,rectwin(length(REM_6grp)),length(REM_6grp),Fs);
pband2_4to10 = bandpower(Pxx,F,band,'psd');
ptot2_4to10 = bandpower(Pxx,F,'psd');
per_power2_4to10 = 100*(pband2_4to10/ptot2_4to10);

[Pxx,F] = periodogram(N1_6grp,rectwin(length(N1_6grp)),length(N1_6grp),Fs);
pband3_4to10 = bandpower(Pxx,F,band,'psd');
ptot3_4to10 = bandpower(Pxx,F,'psd');
per_power3_4to10 = 100*(pband3_4to10/ptot3_4to10);

[Pxx,F] = periodogram(N2_6grp,rectwin(length(N2_6grp)),length(N2_6grp),Fs);
pband4_4to10 = bandpower(Pxx,F,band,'psd');
ptot4_4to10 = bandpower(Pxx,F,'psd');
per_power4_4to10 = 100*(pband4_4to10/ptot4_4to10);

[Pxx,F] = periodogram(N3_6grp,rectwin(length(N3_6grp)),length(N3_6grp),Fs);
pband5_4to10 = bandpower(Pxx,F,band,'psd');
ptot5_4to10 = bandpower(Pxx,F,'psd');
per_power5_4to10 = 100*(pband5_4to10/ptot5_4to10);

Per_Power_4to10 = per_power1_4to10+per_power2_4to10+per_power3_4to10+per_power4_4to10+per_power5_4to10+per_power9_4to10;
disp(Per_Power_4to10);

figure(300001)
y_pband_4to10 = [pband0_4to10,pband9_4to10,pband1_4to10,pband2_4to10,pband3_4to10,pband4_4to10,pband5_4to10];
bar(y_pband_4to10);
grid on
l = cell(1,7);
l{1}='All'; l{2}='Wake with movement'; l{3}='Wake without movement'; l{4}='REM'; l{5}='N1'; l{6}='N2'; l{7}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) 'LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
%%

window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(2101) %subplots for each PSG stage for 'band'
subplot(6,1,1)
pwelch(Wake_WITH_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake with movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,2)
pwelch(Wake_wOUT_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake without movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,3)
pwelch(REM_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,4)
pwelch(N1_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,5)
pwelch(N2_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,6)
pwelch(N3_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%%
figure(2111)
[pxx_9, f] = pwelch(Wake_WITH_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_9))
hold on
[pxx_1, f] = pwelch(Wake_wOUT_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake w.movement','Wake w.out movement','REM','N1', 'N2', 'N3') %need to change if not all channels
legend('boxoff')

%% 13-30 Hz Band
band_start = 13;
band_end = 30;
band = [band_start band_end];

%Each PSG stage powers
% need to plot something meaningful here
% come back and automate the 4to10 with band_start/end
[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_13to30 = bandpower(Pxx,F,band,'psd');
ptot0_13to30 = bandpower(Pxx,F,'psd');
per_power0_13to30 = 100*(pband0_13to30/ptot0_13to30);

[Pxx,F] = periodogram(Wake_wOUT_6grp,rectwin(length(Wake_wOUT_6grp)),length(Wake_wOUT_6grp),Fs);
pband1_13to30 = bandpower(Pxx,F,band,'psd');
ptot1_13to30 = bandpower(Pxx,F,'psd');
per_power1_13to30 = 100*(pband1_13to30/ptot1_13to30);

[Pxx,F] = periodogram(Wake_WITH_6grp,rectwin(length(Wake_WITH_6grp)),length(Wake_WITH_6grp),Fs);
pband9_13to30 = bandpower(Pxx,F,band,'psd');
ptot9_13to30 = bandpower(Pxx,F,'psd');
per_power9_13to30 = 100*(pband9_13to30/ptot9_13to30);

[Pxx,F] = periodogram(REM_6grp,rectwin(length(REM_6grp)),length(REM_6grp),Fs);
pband2_13to30 = bandpower(Pxx,F,band,'psd');
ptot2_13to30 = bandpower(Pxx,F,'psd');
per_power2_13to30 = 100*(pband2_13to30/ptot2_13to30);

[Pxx,F] = periodogram(N1_6grp,rectwin(length(N1_6grp)),length(N1_6grp),Fs);
pband3_13to30 = bandpower(Pxx,F,band,'psd');
ptot3_13to30 = bandpower(Pxx,F,'psd');
per_power3_13to30 = 100*(pband3_13to30/ptot3_13to30);

[Pxx,F] = periodogram(N2_6grp,rectwin(length(N2_6grp)),length(N2_6grp),Fs);
pband4_13to30 = bandpower(Pxx,F,band,'psd');
ptot4_13to30 = bandpower(Pxx,F,'psd');
per_power4_13to30 = 100*(pband4_13to30/ptot4_13to30);

[Pxx,F] = periodogram(N3_6grp,rectwin(length(N3_6grp)),length(N3_6grp),Fs);
pband5_13to30 = bandpower(Pxx,F,band,'psd');
ptot5_13to30 = bandpower(Pxx,F,'psd');
per_power5_13to30 = 100*(pband5_13to30/ptot5_13to30);

Per_Power_13to30 = per_power1_13to30+per_power2_13to30+per_power3_13to30+per_power4_13to30+per_power5_13to30+per_power9_13to30;
disp(Per_Power_13to30);

figure(300002)
y_pband_13to30 = [pband0_13to30,pband9_13to30,pband1_13to30,pband2_13to30,pband3_13to30,pband4_13to30,pband5_13to30];
bar(y_pband_13to30);
grid on
l = cell(1,7);
l{1}='All'; l{2}='Wake with movement'; l{3}='Wake without movement'; l{4}='REM'; l{5}='N1'; l{6}='N2'; l{7}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) 'LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
%

window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(2102) %subplots for each PSG stage for 'band'
subplot(6,1,1)
pwelch(Wake_WITH_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake with movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,2)
pwelch(Wake_wOUT_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake without movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,3)
pwelch(REM_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,4)
pwelch(N1_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,5)
pwelch(N2_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,6)
pwelch(N3_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%
figure(2112)
[pxx_9, f] = pwelch(Wake_WITH_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_9))
hold on
[pxx_1, f] = pwelch(Wake_wOUT_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake w.movement','Wake w.out movement','REM','N1', 'N2', 'N3') %need to change if not all channels
legend('boxoff')


%% 60-80 Hz Band
band_start = 60;
band_end = 80;
band = [band_start band_end];

%Each PSG stage powers
% need to plot something meaningful here
[Pxx,F] = periodogram(input_lfp,rectwin(length(input_lfp)),length(input_lfp),Fs);
pband0_60to80 = bandpower(Pxx,F,band,'psd');
ptot0_60to80 = bandpower(Pxx,F,'psd');
per_power0_60to80 = 100*(pband0_60to80/ptot0_60to80);

[Pxx,F] = periodogram(Wake_wOUT_6grp,rectwin(length(Wake_wOUT_6grp)),length(Wake_wOUT_6grp),Fs);
pband1_60to80 = bandpower(Pxx,F,band,'psd');
ptot1_60to80 = bandpower(Pxx,F,'psd');
per_power1_60to80 = 100*(pband1_60to80/ptot1_60to80);

[Pxx,F] = periodogram(Wake_WITH_6grp,rectwin(length(Wake_WITH_6grp)),length(Wake_WITH_6grp),Fs);
pband9_60to80 = bandpower(Pxx,F,band,'psd');
ptot9_60to80 = bandpower(Pxx,F,'psd');
per_power9_60to80 = 100*(pband9_60to80/ptot9_60to80);

[Pxx,F] = periodogram(REM_6grp,rectwin(length(REM_6grp)),length(REM_6grp),Fs);
pband2_60to80 = bandpower(Pxx,F,band,'psd');
ptot2_60to80 = bandpower(Pxx,F,'psd');
per_power2_60to80 = 100*(pband2_60to80/ptot2_60to80);

[Pxx,F] = periodogram(N1_6grp,rectwin(length(N1_6grp)),length(N1_6grp),Fs);
pband3_60to80 = bandpower(Pxx,F,band,'psd');
ptot3_60to80 = bandpower(Pxx,F,'psd');
per_power3_60to80 = 100*(pband3_60to80/ptot3_60to80);

[Pxx,F] = periodogram(N2_6grp,rectwin(length(N2_6grp)),length(N2_6grp),Fs);
pband4_60to80 = bandpower(Pxx,F,band,'psd');
ptot4_60to80 = bandpower(Pxx,F,'psd');
per_power4_60to80 = 100*(pband4_60to80/ptot4_60to80);

[Pxx,F] = periodogram(N3_6grp,rectwin(length(N3_6grp)),length(N3_6grp),Fs);
pband5_60to80 = bandpower(Pxx,F,band,'psd');
ptot5_60to80 = bandpower(Pxx,F,'psd');
per_power5_60to80 = 100*(pband5_60to80/ptot5_60to80);

Per_Power_60to80 = per_power1_60to80+per_power2_60to80+per_power3_60to80+per_power4_60to80+per_power5_60to80+per_power9_60to80;
disp(Per_Power_60to80);

figure(300003)
y_pband_60to80 = [pband0_60to80,pband9_60to80,pband1_60to80,pband2_60to80,pband3_60to80,pband4_60to80,pband5_60to80];
bar(y_pband_60to80);
grid on
l = cell(1,7);
l{1}='All'; l{2}='Wake with movement'; l{3}='Wake without movement'; l{4}='REM'; l{5}='N1'; l{6}='N2'; l{7}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) 'LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
%

window = 30720;
noverlap = 0;
f = window; %mathworks tutorial said that its safest to set to 'window'

figure(2103) %subplots for each PSG stage for 'band'
subplot(6,1,1)
pwelch(Wake_WITH_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake with movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,2)
pwelch(Wake_wOUT_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for Wake without movement ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,3)
pwelch(REM_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power')
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for REM ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,4)
pwelch(N1_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N1 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,5)
pwelch(N2_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N2 ' num2str(band_start) '-' num2str(band_end) ' Hz'])
subplot(6,1,6)
pwelch(N3_6grp,window,noverlap,f,fs);
%set(gca, 'YLim', []);
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for N3 ' num2str(band_start) '-' num2str(band_end) ' Hz'])

%
figure(2113)
[pxx_9, f] = pwelch(Wake_WITH_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_9))
hold on
[pxx_1, f] = pwelch(Wake_wOUT_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_1))
hold on
[pxx_2, f] = pwelch(REM_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_2))
hold on
[pxx_3, f] = pwelch(N1_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_3))
hold on
[pxx_4, f] = pwelch(N2_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_4))
hold on
[pxx_5, f] = pwelch(N3_6grp,window,noverlap,window,fs);
plot(f, 10*log10(pxx_5))
set(gca, 'XLim', band);
xlabel('Frequency (Hz)')
ylabel('Power');
title(['PT' num2str(PT) 'LFP',num2str(input_str) ', power spectrum for freqencies ' num2str(band_start) ' - ' num2str(band_end) 'Hz'])
legend('Wake w.movement','Wake w.out movement','REM','N1', 'N2', 'N3') %need to change if not all channels
legend('boxoff')

%% NEED TO CHANGE THESE VALUES FOR EACH INDIVIDUAL PATIENT
y_pband_4to10_PT10 = y_pband_4to10;
y_pband_13to30_PT10 = y_pband_13to30;
y_pband_60to80_PT10 = y_pband_60to80;
pxx_9_PT10 = pxx_9;
pxx_1_PT10 = pxx_1;
pxx_2_PT10 = pxx_2;
pxx_3_PT10 = pxx_3;
pxx_4_PT10 = pxx_4;
pxx_5_PT10 = pxx_5;

save(['pband_6grp_PT', num2str(PT) '.mat'],'y_pband_4to10_PT10','y_pband_13to30_PT10','y_pband_60to80_PT10')
save(['pxx_6grp_PT', num2str(PT) '.mat'],'pxx_9_PT10','pxx_1_PT10','pxx_2_PT10','pxx_3_PT10','pxx_4_PT10','pxx_5_PT10')

%% self-check
length_input = (length(input_lfp))/30720;
length_segments_total = ((length(Wake_WITH_6grp))/30720)+((length(Wake_wOUT_6grp))/30720)+((length(REM_6grp))/30720)+((length(N1_6grp))/30720)+((length(N2_6grp))/30720)+((length(N3_6grp))/30720);
length_boolean=length(find(Boolean_master==0));

if length_input~=length_segments_total+length_boolean
    disp 'ERROR, mismatch line 2180'
else
    disp 'GOOD, no mismatch line 2182'
end
 
%% re-doing indexing because prior calculations resulted in indexing out of epochs based on evalepoch by the time we got to wake movement/no movement - definitely a more efficient way to do this but don't want to mess with upstream components (used too many of the same variable names)
Index_sixgroup_no_boolean = Index_load.(['IndexPT',num2str(PT)]);
Wake_diff_average_no_Boolean = zeros(epochs, 6);
Wake_diff_boolean_no_Boolean = zeros(epochs, 6); 

UL_Ax_abs = abs(UL_Ax);
col = 1;

for k = 1:epochs;
    if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(UL_Ax_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_UL_Ax_abs = mean(UL_Ax_abs);
sdSeg_UL_Ax_abs = std(UL_Ax_abs);
% Compute threshold 
thrseg_UL_Ax_abs = mSeg_UL_Ax_abs + (sdSeg_UL_Ax_abs * 2);
%thrseg_UL_Ax_abs = mSeg_UL_Ax_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_UL_Ax_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end


%

UL_Ay_abs = abs(UL_Ay);
col = 2;

for k = 1:epochs;
     if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(UL_Ay_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_UL_Ay_abs = mean(UL_Ay_abs);
sdSeg_UL_Ay_abs = std(UL_Ay_abs);
% Compute threshold 
thrseg_UL_Ay_abs = mSeg_UL_Ay_abs + (sdSeg_UL_Ay_abs * 2);
%thrseg_UL_Ay_abs = mSeg_UL_Ay_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_UL_Ay_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end
%
UL_Az_abs = abs(UL_Az);
col = 3;

for k = 1:epochs;
     if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(UL_Az_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_UL_Az_abs = mean(UL_Az_abs);
sdSeg_UL_Az_abs = std(UL_Az_abs);
% Compute threshold 
thrseg_UL_Az_abs = mSeg_UL_Az_abs + (sdSeg_UL_Az_abs * 2);
%thrseg_UL_Az_abs = mSeg_UL_Az_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_UL_Az_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end

%
LL_Ax_abs = abs(LL_Ax);
col = 4;

for k = 1:epochs;
     if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(LL_Ax_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_LL_Ax_abs = mean(LL_Ax_abs);
sdSeg_LL_Ax_abs = std(LL_Ax_abs);
% Compute threshold 
thrseg_LL_Ax_abs = mSeg_LL_Ax_abs + (sdSeg_LL_Ax_abs * 2);
%thrseg_LL_Ax_abs = mSeg_LL_Ax_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_LL_Ax_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end

%
LL_Ay_abs = abs(LL_Ay);
col = 5;

for k = 1:epochs;
     if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(LL_Ay_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_LL_Ay_abs = mean(LL_Ay_abs);
sdSeg_LL_Ay_abs = std(LL_Ay_abs);
% Compute threshold 
thrseg_LL_Ay_abs = mSeg_LL_Ay_abs + (sdSeg_LL_Ay_abs * 2);
%thrseg_LL_Ay_abs = mSeg_LL_Ay_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_LL_Ay_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end
%
LL_Az_abs = abs(LL_Az);
col = 6;

for k = 1:epochs;
     if Index_sixgroup_no_boolean(k,3) == 0
        Wake_diff_average_no_Boolean(k,col) = mean(LL_Az_abs( 1+(k-1)*30*1024 : k*30*1024));
        Wake_diff_boolean_no_Boolean(k,col) = 1;
    end
end

mSeg_LL_Az_abs = mean(LL_Az_abs);
sdSeg_LL_Az_abs = std(LL_Az_abs);
% Compute threshold 
thrseg_LL_Az_abs = mSeg_LL_Az_abs + (sdSeg_LL_Az_abs * 2);
%thrseg_LL_Az_abs = mSeg_LL_Az_abs*10;

for k = 1:epochs; %change below, need better thresholding
        if Wake_diff_average_no_Boolean(k,col) > thrseg_LL_Az_abs;
              Wake_diff_boolean_no_Boolean(k,col) = 9;
        end
end

UL_Ave_abs = (UL_Ax_abs + UL_Ay_abs + UL_Az_abs)/3;
LL_Ave_abs = (LL_Ax_abs + LL_Ay_abs + LL_Az_abs)/3;

%%
Index_movementORno_no_Boolean = zeros(epochs, 1);

for k = 1:epochs
    if sum(Wake_diff_boolean_no_Boolean(k,:)) ~= 0
        Index_movementORno_no_Boolean(k,:) = 7;
        if sum(Wake_diff_boolean_no_Boolean(k,:)) > 9
            Index_movementORno_no_Boolean(k,:) = 9;
        end
    end
end

%%
for k = 1:epochs
    if Index_movementORno_no_Boolean(k,1) == 0
        Index_movementORno_no_Boolean(k,1) = IndexPT0(k,3); %good! this makes index transformed into wake w/ w/out movement without any zeros from boolean indexing
    end
end

Index_movementORno_no_Boolean_6grp_score = Index_movementORno_no_Boolean; %change this input and all the names
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==9 )=99; % Wake w/ movement
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==7 )=91; % Wake w/out movement
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==5 )=83;  % REM
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==1 )=73;  % N1
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==2 )=63;  % N2
Index_movementORno_no_Boolean_6grp_score( Index_movementORno_no_Boolean_6grp_score==3 )=55;  % N3
IndexPTX_1_no_Boolean = IndexPT0(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
IndexPTX_2_no_Boolean = IndexPT0(:,2)/(1024*60*60);
IndexPTX_no_6grp_Boolean = [IndexPTX_1_no_Boolean,IndexPTX_2_no_Boolean,Index_movementORno_no_Boolean_6grp_score];
        
%%
Index_sixgroups_score__no_Boolean_6grp_sm = Index_movementORno_no_Boolean; %score_sm keeps sleep scoring small numbers
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==9 )= 4.9; % Wake w/ movement
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==7 )= 4.0;  % Wake w/out movement
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==5 )= 3.1;  % REM
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==1 )= 2.1;  % N1
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==2 )= 1.2;  % N2
Index_sixgroups_score__no_Boolean_6grp_sm( Index_sixgroups_score__no_Boolean_6grp_sm==3 )= 0.3;  % N3
IndexPT_EMG_6grp_no_Boolean = [IndexPT0(:,1),IndexPT0(:,2),Index_sixgroups_score__no_Boolean_6grp_sm];%should be sample number on xaxis and small yaxis 

IndexPTX_persample_6grp_no_Boolean = [IndexPT_EMG_6grp_no_Boolean(:,1),IndexPT_EMG_6grp_no_Boolean(:,2),IndexPTX_no_6grp_Boolean(:,3)]; %should be sample number on x and large yaxis 

IndexPTX_6grp_bigfigure_score = Index_movementORno_no_Boolean;
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==9 )=99; % Wake w/movement
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==7 )=80; % Wake w/movement
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==5 )=61;  % REM
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==1 )=40;  % N1
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==2 )=20;  % N2
IndexPTX_6grp_bigfigure_score( IndexPTX_6grp_bigfigure_score==3 )=2;  % N3
IndexPTX_bigfigure_1 = IndexPT0(:,1)/(1024*60*60); % adjust scale to match that of 'spectrogram' output
IndexPTX_bigfigure_2 = IndexPT0(:,2)/(1024*60*60);
IndexPTX_6grp_bigfigure = [IndexPTX_bigfigure_1,IndexPTX_bigfigure_2,IndexPTX_6grp_bigfigure_score];

%%
figure(10111)
subplot(4,1,1)
stairs(IndexPTX_no_6grp_Boolean(:,1), IndexPTX_no_6grp_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- check that indexes match for 6 sleep stage grouping ']);
subplot(4,1,2)
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','b' );
%set(gca, 'YLim', [0 5]);
subplot(4,1,3)
stairs(IndexPTX_persample_6grp_no_Boolean(:,1), IndexPTX_persample_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','k' );
subplot(4,1,4)
stairs(IndexPTX_6grp_bigfigure(:,1), IndexPTX_6grp_bigfigure(:,3),'LineWidth',2, 'Color','g' );

%%
sleepstages_six=['N3             ';'N2             ';'N1             ';'REM            ';'Wake w.out move';'Wake w.move    ' ];

figure(2031)
subplot(3,1,3) 
spectrogram(lfp01,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX_no_6grp_Boolean(:,1), IndexPTX_no_6grp_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['LFP0-LFP1 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 12],'YTick',7:12,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(3,1,2) 
spectrogram(lfp12,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX_no_6grp_Boolean(:,1), IndexPTX_no_6grp_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['LFP1-LFP2 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 12],'YTick',7:12,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
subplot(3,1,1) 
spectrogram(lfp23,window_lfp, noverlap_lfp, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX_no_6grp_Boolean(:,1), IndexPTX_no_6grp_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['LFP2-LFP3 PT' num2str(PT) ' window size:' num2str(window_lfp) ' overlap size:' num2str(noverlap_lfp)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 12],'YTick',7:12,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')


figure(397010)
subplot(7,1,1) 
spectrogram(input_lfp,100000, 60000, scale_big1:scale_big2, fs, 'yaxis')
hold on
stairs(IndexPTX_6grp_bigfigure(:,1), IndexPTX_6grp_bigfigure(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) 'LFP',num2str(input_str)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')% EEG/EMG comparison
set(gca, 'YLim', [scale_big1 (scale_big2+5)]);
subplot(7,1,2) 
plot(FDC)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced FDC ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,3) 
plot(bicep)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced bicep ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,4) 
plot(tricep)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced tricep ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,5) 
plot(EDC)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced EDC ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,6) 
plot(Chin_referenced)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) ' - referenced chin ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);
subplot(7,1,7) 
plot(ant_tibia)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) '- referenced anterior tibia']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
set(gca, 'YLim', [scale_sm1 scale_sm2]);

%%

figure(20319)
subplot(3,1,1) 
spectrogram(input_lfp,window_lfp, noverlap_lfp, 0:100, fs, 'yaxis')
hold on
stairs(IndexPTX_6grp_bigfigure(:,1), IndexPTX_6grp_bigfigure(:,3),'LineWidth',2, 'Color','r' );
title(['PT' num2str(PT) 'LFP',num2str(input_str)]);
colorbar off
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')

subplot(3,1,2) 
plot(UL_Ave_abs)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : Upper limb average readouts from three x,y,z axes ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')

subplot(3,1,3) 
plot(LL_Ave_abs)
hold on
stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
set(gca, 'YLim', [scale_sm1 scale_sm2]);
title(['PT' num2str(PT) ' : Lower limb average readouts from three x,y,z axes ']);
yyaxis right
ylabel('Sleep Stage', 'Color','r')
set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
yyaxis left
ylabel('Frequency (Hz)')
 %% this is a good figure but very hard to resize image to see properly
% figure(397101)
% subplot(7,1,1) 
% spectrogram(input_lfp,window_lfp, noverlap_lfp, 0:100, fs, 'yaxis')
% hold on
% stairs(IndexPTX_6grp_bigfigure(:,1), IndexPTX_6grp_bigfigure(:,3),'LineWidth',2, 'Color','r' );
% title(['PT' num2str(PT) 'LFP',num2str(input_str)]);
% colorbar off
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% % adding in subplots to determine optimal comparison
% subplot(7,1,2)
% plot(UL_Ax)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : UL Ax']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% subplot(7,1,3)  
% plot(UL_Ay)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : UL Ay']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% subplot(7,1,4)  
% plot(UL_Az)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : UL Az']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% subplot(7,1,5)  
% plot(LL_Ax)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : LL Ax']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% subplot(7,1,6)  
% plot(LL_Ay)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : LL Ay']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')
% subplot(7,1,7)  
% plot(LL_Az)
% hold on
% stairs(IndexPT_EMG_6grp_no_Boolean(:,1), IndexPT_EMG_6grp_no_Boolean(:,3),'LineWidth',2, 'Color','r' );
% set(gca, 'YLim', [scale_sm1 scale_sm2]);
% title(['PT' num2str(PT) ' : LL Az']);
% yyaxis right
% ylabel('Sleep Stage', 'Color','r')
% set(gca,'YLim',[1 6],'YTick',1:6,'YTickLabel',sleepstages_six, 'YColor', 'r')
% yyaxis left
% ylabel('Frequency (Hz)')

%% first 1/4 vs 4/4 

%%
epoch_quart = ((epochs)/4);
epochs_1stquart = floor(epoch_quart);
epochs_2ndquart = floor(epoch_quart*2);
epochs_3rdquart = floor(epoch_quart*3);
epochs_4thquart = epochs;

wakeWITH_1stquart = zeros(epochs_1stquart, 30720);
for k = (1:epochs_1stquart)
    if Signal0_block_index_sixgroups(k,30721) == 9
        wakeWITH_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
wakeWITH_1stquart_2 = wakeWITH_1stquart;
wakeWITH_1stquart_2( ~any(wakeWITH_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(sum(wakeWITH_1stquart)) ~= sum(sum(wakeWITH_1stquart_2))
    disp('ERROR wakeWITH_1stquart')
end

wakeWITH_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 9
        wakeWITH_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
wakeWITH_4thquart_2 = wakeWITH_4thquart;
wakeWITH_4thquart_2( ~any(wakeWITH_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(wakeWITH_4thquart) ~= sum(wakeWITH_4thquart_2)
    disp('ERROR wakeWITH_4thquart')
end

wake_wOUT_1stquart = zeros(epochs_1stquart, 30720);
for k = (1:epochs_1stquart)
    if Signal0_block_index_sixgroups(k,30721) == 7
        wake_wOUT_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
wake_wOUT_1stquart_2 = wake_wOUT_1stquart;
wake_wOUT_1stquart_2( ~any(wake_wOUT_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(wake_wOUT_1stquart) ~= sum(wake_wOUT_1stquart_2)
    disp('ERROR wake_wOUT_1stquart')
end

wake_wOUT_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 7
        wake_wOUT_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
wake_wOUT_4thquart_2 = wake_wOUT_4thquart;
wake_wOUT_4thquart_2( ~any(wake_wOUT_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(wake_wOUT_4thquart) ~= sum(wake_wOUT_4thquart_2)
    disp('ERROR wake_wOUT_4thquart')
end
   
REM_1stquart = zeros(epochs_1stquart, 30720);
for k = (1:epochs_1stquart)
    if Signal0_block_index_sixgroups(k,30721) == 5
        REM_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
REM_1stquart_2 = REM_1stquart;
REM_1stquart_2( ~any(REM_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(REM_1stquart) ~= sum(REM_1stquart_2)
    disp('ERROR REM_1stquart')
end
    
REM_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 5
        REM_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
REM_4thquart_2 = REM_4thquart;
REM_4thquart_2( ~any(REM_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(REM_4thquart) ~= sum(REM_4thquart_2)
    disp('ERROR REM_4thquart')
end

N1_1stquart = zeros(epochs_1stquart, 30720);
for k = (1:epochs_1stquart)
    if Signal0_block_index_sixgroups(k,30721) == 1
        N1_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N1_1stquart_2 = N1_1stquart;
N1_1stquart_2( ~any(N1_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(N1_1stquart) ~= sum(N1_1stquart_2)
    disp('ERROR N1_1stquart')
end
    

N1_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 1
        N1_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N1_4thquart_2 = N1_4thquart;
N1_4thquart_2( ~any(N1_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(N1_4thquart) ~= sum(N1_4thquart_2)
    disp('ERROR N1_4thquart')
end

N2_1stquart = zeros(epochs_1stquart, 30720);
for k = 1:epochs_1stquart
    if Signal0_block_index_sixgroups(k,30721) == 2
        N2_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N2_1stquart_2 = N2_1stquart;
N2_1stquart_2( ~any(N2_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(N2_1stquart) ~= sum(N2_1stquart_2)
    disp('ERROR N2_1stquart')
end
    
N2_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 2
        N2_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N2_4thquart_2 = N2_4thquart;
N2_4thquart_2( ~any(N2_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(N2_4thquart) ~= sum(N2_4thquart_2)
    disp('ERROR N2_4thquart')
end

N3_1stquart = zeros(epochs_1stquart, 30720);
for k = (1:epochs_1stquart)
    if Signal0_block_index_sixgroups(k,30721) == 3
        N3_1stquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N3_1stquart_2 = N3_1stquart;
N3_1stquart_2( ~any(N3_1stquart_2,2), : ) = [];  % delete rows made of zeros
if sum(N3_1stquart) ~= sum(N3_1stquart_2)
    disp('ERROR N3_1stquart')
end
    

N3_4thquart = zeros((epochs-epochs_3rdquart), 30720);
for k = (epochs_3rdquart:epochs)
    if Signal0_block_index_sixgroups(k,30721) == 3
        N3_4thquart(k,:) = input_lfp( 1+(k-1)*30*1024 : k*30*1024);
    end
end
N3_4thquart_2 = N3_4thquart;
N3_4thquart_2( ~any(N3_4thquart_2,2), : ) = [];  % delete rows made of zeros

if sum(N3_4thquart) ~= sum(N3_4thquart_2)
    disp('ERROR N3_4thquart')
end
%%

% num_rows = size(XXX,1);
% XXX_3 = XXX;
% XXX_4 = XXX_3';
% XXX_5 = reshape(XXX_4,[(num_rows*30720),1]);

num_rows = size(wakeWITH_1stquart_2,1);
wakeWITH_1stquart_3 = wakeWITH_1stquart_2;
wakeWITH_1stquart_4 = wakeWITH_1stquart_3';
wakeWITH_1stquart_5 = reshape(wakeWITH_1stquart_4,[(num_rows*30720),1]);

num_rows = size(wakeWITH_4thquart_2,1);
wakeWITH_4thquart_3 = wakeWITH_4thquart_2;
wakeWITH_4thquart_4 = wakeWITH_4thquart_3';
wakeWITH_4thquart_5 = reshape(wakeWITH_4thquart_4,[(num_rows*30720),1]);

num_rows = size(wake_wOUT_1stquart_2,1);
wake_wOUT_1stquart_3 = wake_wOUT_1stquart_2;
wake_wOUT_1stquart_4 = wake_wOUT_1stquart_3';
wake_wOUT_1stquart_5 = reshape(wake_wOUT_1stquart_4,[(num_rows*30720),1]);

num_rows = size(wake_wOUT_4thquart_2,1);
wake_wOUT_4thquart_3 = wake_wOUT_4thquart_2;
wake_wOUT_4thquart_4 = wake_wOUT_4thquart_3';
wake_wOUT_4thquart_5 = reshape(wake_wOUT_4thquart_4,[(num_rows*30720),1]);

num_rows = size(REM_1stquart_2,1);
REM_1stquart_3 = REM_1stquart_2;
REM_1stquart_4 = REM_1stquart_3';
REM_1stquart_5 = reshape(REM_1stquart_4,[(num_rows*30720),1]);

num_rows = size(REM_4thquart_2,1);
REM_4thquart_3 = REM_4thquart_2;
REM_4thquart_4 = REM_4thquart_3';
REM_4thquart_5 = reshape(REM_4thquart_4,[(num_rows*30720),1]);

num_rows = size(N1_1stquart_2,1);
N1_1stquart_3 = N1_1stquart_2;
N1_1stquart_4 = N1_1stquart_3';
N1_1stquart_5 = reshape(N1_1stquart_4,[(num_rows*30720),1]);

num_rows = size(N1_4thquart_2,1);
N1_4thquart_3 = N1_4thquart_2;
N1_4thquart_4 = N1_4thquart_3';
N1_4thquart_5 = reshape(N1_4thquart_4,[(num_rows*30720),1]);

num_rows = size(N2_1stquart_2,1);
N2_1stquart_3 = N2_1stquart_2;
N2_1stquart_4 = N2_1stquart_3';
N2_1stquart_5 = reshape(N2_1stquart_4,[(num_rows*30720),1]);

num_rows = size(N2_4thquart_2,1);
N2_4thquart_3 = N2_4thquart_2;
N2_4thquart_4 = N2_4thquart_3';
N2_4thquart_5 = reshape(N2_4thquart_4,[(num_rows*30720),1]);


num_rows = size(N3_1stquart_2,1);
N3_1stquart_3 = N3_1stquart_2;
N3_1stquart_4 = N3_1stquart_3';
N3_1stquart_5 = reshape(N3_1stquart_4,[(num_rows*30720),1]);

num_rows = size(N3_4thquart_2,1);
N3_4thquart_3 = N3_4thquart_2;
N3_4thquart_4 = N3_4thquart_3';
N3_4thquart_5 = reshape(N3_4thquart_4,[(num_rows*30720),1]);


if isempty(wakeWITH_1stquart_5) == 1;
    wakeWITH_1stquart_5 = ones(size(input_lfp));
end

if isempty(wakeWITH_4thquart_5) == 1;
    wakeWITH_4thquart_5 = ones(size(input_lfp));
end

if isempty(wake_wOUT_1stquart_5) == 1;
    wake_wOUT_1stquart_5 = ones(size(input_lfp));
end

if isempty(wake_wOUT_4thquart_5) == 1;
    wake_wOUT_4thquart_5 = ones(size(input_lfp));
end

if isempty(REM_1stquart_5) == 1;
    REM_1stquart_5 = ones(size(input_lfp));
end

if isempty(REM_4thquart_5) == 1;
    REM_4thquart_5 = ones(size(input_lfp));
end

if isempty(N1_1stquart_5) == 1;
    N1_1stquart_5 = ones(size(input_lfp));
end

if isempty(N1_4thquart_5) == 1;
    N1_4thquart_5 = ones(size(input_lfp));
end


if isempty(N2_1stquart_5) == 1;
    N2_1stquart_5 = ones(size(input_lfp));
end

if isempty(N2_4thquart_5) == 1;
    N2_4thquart_5 = ones(size(input_lfp));
end


if isempty(N3_1stquart_5) == 1;
    N3_1stquart_5 = ones(size(input_lfp));
end

if isempty(N3_4thquart_5) == 1;
    N3_4thquart_5 = ones(size(input_lfp));
end
%%

window2 = 1024;
noverlap2 = 512;

band_start = 4;
band_end = 10;

figure(3051)
subplot(2,1,1) 
spectrogram(wakeWITH_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wakeWITH_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(3052)
subplot(2,1,1) 
spectrogram(wake_wOUT_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wake_wOUT_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(3053)
subplot(2,1,1) 
spectrogram(REM_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(REM_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(3054)
subplot(2,1,1) 
spectrogram(N1_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N1_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(3055)
subplot(2,1,1) 
spectrogram(N2_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N2_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(3056)
subplot(2,1,1) 
spectrogram(N3_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N3_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

%%
band_start = 13;
band_end = 30;

figure(30512)
subplot(2,1,1) 
spectrogram(wakeWITH_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wakeWITH_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30522)
subplot(2,1,1) 
spectrogram(wake_wOUT_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wake_wOUT_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30532)
subplot(2,1,1) 
spectrogram(REM_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(REM_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30542)
subplot(2,1,1) 
spectrogram(N1_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N1_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30552)
subplot(2,1,1) 
spectrogram(N2_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N2_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30562)
subplot(2,1,1) 
spectrogram(N3_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N3_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

%%
band_start = 60;
band_end = 80;

figure(30513)
subplot(2,1,1) 
spectrogram(wakeWITH_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wakeWITH_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30523)
subplot(2,1,1) 
spectrogram(wake_wOUT_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(wake_wOUT_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' Wake w/out movement from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30533)
subplot(2,1,1) 
spectrogram(REM_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(REM_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' REM from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30543)
subplot(2,1,1) 
spectrogram(N1_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N1_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N1 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30553)
subplot(2,1,1) 
spectrogram(N2_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N2_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N2 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off

figure(30563)
subplot(2,1,1) 
spectrogram(N3_1stquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 1st quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off
subplot(2,1,2) 
spectrogram(N3_4thquart_5,window2, noverlap2, band_start:band_end, fs, 'yaxis')
title(['PT' num2str(PT) ' N3 from 4th quarter of Recording, LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
colorbar off     
%% Quantification of power bands comparing 1st quarter and 4th quarter of recording
band_start = 4;
band_end = 10;
band = [band_start band_end];

pband_04to10_6grp_1stquart = zeros(6,1);
pband_04to10_6grp_4thquart = zeros(6,1);

[Pxx,F] = periodogram(wakeWITH_1stquart_5,rectwin(length(wakeWITH_1stquart_5)),length(wakeWITH_1stquart_5),Fs);
pband_04to10_wakeWITH_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(1) = pband_04to10_wakeWITH_1stquart_5;
[Pxx,F] = periodogram(wakeWITH_4thquart_5,rectwin(length(wakeWITH_4thquart_5)),length(wakeWITH_4thquart_5),Fs);
pband_04to10_wakeWITH_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(1) = pband_04to10_wakeWITH_4thquart_5;

[Pxx,F] = periodogram(wake_wOUT_1stquart_5,rectwin(length(wake_wOUT_1stquart_5)),length(wake_wOUT_1stquart_5),Fs);
pband_04to10_wake_wOUT_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(2) = pband_04to10_wake_wOUT_1stquart_5;
[Pxx,F] = periodogram(wake_wOUT_4thquart_5,rectwin(length(wake_wOUT_4thquart_5)),length(wake_wOUT_4thquart_5),Fs);
pband_04to10_wake_wOUT_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(2) = pband_04to10_wake_wOUT_4thquart_5;


[Pxx,F] = periodogram(REM_1stquart_5,rectwin(length(REM_1stquart_5)),length(REM_1stquart_5),Fs);
pband_04to10_REM_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(3) = pband_04to10_REM_1stquart_5;
[Pxx,F] = periodogram(REM_4thquart_5,rectwin(length(REM_4thquart_5)),length(REM_4thquart_5),Fs);
pband_04to10_REM_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(3) = pband_04to10_REM_4thquart_5;

[Pxx,F] = periodogram(N1_1stquart_5,rectwin(length(N1_1stquart_5)),length(N1_1stquart_5),Fs);
pband_04to10_N1_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(4) = pband_04to10_N1_1stquart_5;
[Pxx,F] = periodogram(N1_4thquart_5,rectwin(length(N1_4thquart_5)),length(N1_4thquart_5),Fs);
pband_04to10_N1_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(4) = pband_04to10_N1_4thquart_5;

[Pxx,F] = periodogram(N2_1stquart_5,rectwin(length(N2_1stquart_5)),length(N2_1stquart_5),Fs);
pband_04to10_N2_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(5) = pband_04to10_N2_1stquart_5;
[Pxx,F] = periodogram(N2_4thquart_5,rectwin(length(N2_4thquart_5)),length(N2_4thquart_5),Fs);
pband_04to10_N2_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(5) = pband_04to10_N2_4thquart_5;

[Pxx,F] = periodogram(N3_1stquart_5,rectwin(length(N3_1stquart_5)),length(N3_1stquart_5),Fs);
pband_04to10_N3_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_1stquart(6) = pband_04to10_N3_1stquart_5;
[Pxx,F] = periodogram(N3_4thquart_5,rectwin(length(N3_4thquart_5)),length(N3_4thquart_5),Fs);
pband_04to10_N3_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_04to10_6grp_4thquart(6) = pband_04to10_N3_4thquart_5;
%
figure (312)
bar(1:6, [pband_04to10_6grp_1stquart, pband_04to10_6grp_4thquart]);

grid on
l = cell(1,6);
l{1}='Wake w/motion'; l{2}='Wake w/out motion'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) ' LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
ylabel('Band Power');
legend('1st Quarter', '4th Quarter');

%%

band_start = 13;
band_end = 30;
band = [band_start band_end];

pband_13to30_6grp_1stquart = zeros(6,1);
pband_13to30_6grp_4thquart = zeros(6,1);

[Pxx,F] = periodogram(wakeWITH_1stquart_5,rectwin(length(wakeWITH_1stquart_5)),length(wakeWITH_1stquart_5),Fs);
pband_13to30_wakeWITH_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(1) = pband_13to30_wakeWITH_1stquart_5;
[Pxx,F] = periodogram(wakeWITH_4thquart_5,rectwin(length(wakeWITH_4thquart_5)),length(wakeWITH_4thquart_5),Fs);
pband_13to30_wakeWITH_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(1) = pband_13to30_wakeWITH_4thquart_5;

[Pxx,F] = periodogram(wake_wOUT_1stquart_5,rectwin(length(wake_wOUT_1stquart_5)),length(wake_wOUT_1stquart_5),Fs);
pband_13to30_wake_wOUT_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(2) = pband_13to30_wake_wOUT_1stquart_5;
[Pxx,F] = periodogram(wake_wOUT_4thquart_5,rectwin(length(wake_wOUT_4thquart_5)),length(wake_wOUT_4thquart_5),Fs);
pband_13to30_wake_wOUT_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(2) = pband_13to30_wake_wOUT_4thquart_5;


[Pxx,F] = periodogram(REM_1stquart_5,rectwin(length(REM_1stquart_5)),length(REM_1stquart_5),Fs);
pband_13to30_REM_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(3) = pband_13to30_REM_1stquart_5;
[Pxx,F] = periodogram(REM_4thquart_5,rectwin(length(REM_4thquart_5)),length(REM_4thquart_5),Fs);
pband_13to30_REM_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(3) = pband_13to30_REM_4thquart_5;

[Pxx,F] = periodogram(N1_1stquart_5,rectwin(length(N1_1stquart_5)),length(N1_1stquart_5),Fs);
pband_13to30_N1_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(4) = pband_13to30_N1_1stquart_5;
[Pxx,F] = periodogram(N1_4thquart_5,rectwin(length(N1_4thquart_5)),length(N1_4thquart_5),Fs);
pband_13to30_N1_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(4) = pband_13to30_N1_4thquart_5;

[Pxx,F] = periodogram(N2_1stquart_5,rectwin(length(N2_1stquart_5)),length(N2_1stquart_5),Fs);
pband_13to30_N2_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(5) = pband_13to30_N2_1stquart_5;
[Pxx,F] = periodogram(N2_4thquart_5,rectwin(length(N2_4thquart_5)),length(N2_4thquart_5),Fs);
pband_13to30_N2_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(5) = pband_13to30_N2_4thquart_5;

[Pxx,F] = periodogram(N3_1stquart_5,rectwin(length(N3_1stquart_5)),length(N3_1stquart_5),Fs);
pband_13to30_N3_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_1stquart(6) = pband_13to30_N3_1stquart_5;
[Pxx,F] = periodogram(N3_4thquart_5,rectwin(length(N3_4thquart_5)),length(N3_4thquart_5),Fs);
pband_13to30_N3_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_13to30_6grp_4thquart(6) = pband_13to30_N3_4thquart_5;

figure (313)
bar(1:6, [pband_13to30_6grp_1stquart pband_13to30_6grp_4thquart]);
grid on
l = cell(1,6);
l{1}='Wake w/motion'; l{2}='Wake w/out motion'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) ' LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
ylabel('Band Power');
legend('1st Quarter', '4th Quarter');

%%
band_start = 60;
band_end = 80;
band = [band_start band_end];

pband_60to80_6grp_1stquart = zeros(6,1);
pband_60to80_6grp_4thquart = zeros(6,1);

[Pxx,F] = periodogram(wakeWITH_1stquart_5,rectwin(length(wakeWITH_1stquart_5)),length(wakeWITH_1stquart_5),Fs);
pband_60to80_wakeWITH_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(1) = pband_60to80_wakeWITH_1stquart_5;
[Pxx,F] = periodogram(wakeWITH_4thquart_5,rectwin(length(wakeWITH_4thquart_5)),length(wakeWITH_4thquart_5),Fs);
pband_60to80_wakeWITH_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(1) = pband_60to80_wakeWITH_4thquart_5;

[Pxx,F] = periodogram(wake_wOUT_1stquart_5,rectwin(length(wake_wOUT_1stquart_5)),length(wake_wOUT_1stquart_5),Fs);
pband_60to80_wake_wOUT_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(2) = pband_60to80_wake_wOUT_1stquart_5;
[Pxx,F] = periodogram(wake_wOUT_4thquart_5,rectwin(length(wake_wOUT_4thquart_5)),length(wake_wOUT_4thquart_5),Fs);
pband_60to80_wake_wOUT_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(2) = pband_60to80_wake_wOUT_4thquart_5;


[Pxx,F] = periodogram(REM_1stquart_5,rectwin(length(REM_1stquart_5)),length(REM_1stquart_5),Fs);
pband_60to80_REM_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(3) = pband_60to80_REM_1stquart_5;
[Pxx,F] = periodogram(REM_4thquart_5,rectwin(length(REM_4thquart_5)),length(REM_4thquart_5),Fs);
pband_60to80_REM_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(3) = pband_60to80_REM_4thquart_5;

[Pxx,F] = periodogram(N1_1stquart_5,rectwin(length(N1_1stquart_5)),length(N1_1stquart_5),Fs);
pband_60to80_N1_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(4) = pband_60to80_N1_1stquart_5;
[Pxx,F] = periodogram(N1_4thquart_5,rectwin(length(N1_4thquart_5)),length(N1_4thquart_5),Fs);
pband_60to80_N1_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(4) = pband_60to80_N1_4thquart_5;

[Pxx,F] = periodogram(N2_1stquart_5,rectwin(length(N2_1stquart_5)),length(N2_1stquart_5),Fs);
pband_60to80_N2_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(5) = pband_60to80_N2_1stquart_5;
[Pxx,F] = periodogram(N2_4thquart_5,rectwin(length(N2_4thquart_5)),length(N2_4thquart_5),Fs);
pband_60to80_N2_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(5) = pband_60to80_N2_4thquart_5;

[Pxx,F] = periodogram(N3_1stquart_5,rectwin(length(N3_1stquart_5)),length(N3_1stquart_5),Fs);
pband_60to80_N3_1stquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_1stquart(6) = pband_60to80_N3_1stquart_5;
[Pxx,F] = periodogram(N3_4thquart_5,rectwin(length(N3_4thquart_5)),length(N3_4thquart_5),Fs);
pband_60to80_N3_4thquart_5 = bandpower(Pxx,F,band,'psd');
pband_60to80_6grp_4thquart(6) = pband_60to80_N3_4thquart_5;

figure (314)
bar(1:6, [pband_60to80_6grp_1stquart pband_60to80_6grp_4thquart]);
grid on
l = cell(1,6);
l{1}='Wake w/motion'; l{2}='Wake w/out motion'; l{3}='REM'; l{4}='N1'; l{5}='N2'; l{6}='N3';   
set(gca,'xticklabel', l, 'XTickLabelRotation' , 45) 
title(['PT' num2str(PT) ' LFP' num2str(input_str) ': power bands for ' num2str(band_start),'-',num2str(band_end),' Hz'])
ylabel('Band Power');
legend('1st Quarter', '4th Quarter');

sleepstages_six = 1;
toc