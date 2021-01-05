% Stock code

% TO DO
% ADD in SOUNDS
% FIX Delay time jitter
% DOUBLE CHECK LEFT and RIGHT DESIGNATIONS
% 

% Initiate Controller
a = arduino();
addrs = scanI2CBus(a);
nC1 = i2cdev(a, char(addrs) , 'bus' , 0);

joyXoffset = 127;
joyYoffset = 128;

% Load in sounds
load('AT_IO_sounds.mat','tone1_fs','tone1_sound','tone2_fs','tone2_sound',...
    'tone3_fs','tone3_sound','tone4_fs','tone4_sound','tone5_fs','tone5_sound',...
    'gobeep_fs','gobeep_sound','sound_hellomynameisdaisy','sound_hellomynameisdaisy_fs',...
    'sound_whenyouareready_fs','sound_whenyouareready','sound_next_fs',...
    'sound_next','sound_correctbeep_fs','sound_correctbeep','sound_incorrectbeep_fs',...
    'sound_incorrectbeep','sound_pleasecontinuetoholduntil_fs',...
    'sound_pleasecontinuetoholduntil')

% Load in inputMatrix
load('input_matrix_rndm_March15.mat', 'input_matrix_rndm') %full input
% input_matrix_rndm = [1,2,301,302,4,5]'; %abridged input
% input_matrix_rndm = [5,5]'; %abridged input
% load('inputshorten.mat', 'inputshorten') %
% input_matrix_rndm = inputshorten;

input_fss = zeros(length(input_matrix_rndm),1);
input_tones =  cell(length(input_matrix_rndm),1);
input_correct = zeros(length(input_matrix_rndm),1);
s = struct('in',input_matrix_rndm,'fs',input_fss,'tones',input_tones,'correct',input_correct);
% extending input_matrix_rndm variable into a structure we will subsequently pull from
for i = 1:length(input_matrix_rndm)
    if input_matrix_rndm(i,1) == 1
        s(i).in = input_matrix_rndm(i);
        s(i).fs = tone1_fs;
        s(i).tones = mat2cell(tone1_sound,2,44101);
        s(i).correct = 1;%means left is correct response
        %input_fss(i) = tone1_fs; %keeping these just as example of another
        %way to execute code if need be
        %tone1_holder = mat2cell(tone1_sound,2,44101);
        %input_tones(i) = {tone1_holder};
        %input_correct(i) = 1;
    elseif input_matrix_rndm(i,1) == 2
        s(i).in = input_matrix_rndm(i);s(i).fs = tone2_fs;s(i).tones = mat2cell(tone2_sound,2,44101);s(i).correct = 1;
    elseif input_matrix_rndm(i,1) == 301
        s(i).in = input_matrix_rndm(i);s(i).fs = tone3_fs;s(i).tones = mat2cell(tone3_sound,2,44101);s(i).correct = 1;
    elseif input_matrix_rndm(i,1) == 302
        s(i).in = input_matrix_rndm(i);s(i).fs = tone3_fs;s(i).tones = mat2cell(tone3_sound,2,44101);s(i).correct = 2;
    elseif input_matrix_rndm(i,1) == 4
        s(i).in = input_matrix_rndm(i);s(i).fs = tone4_fs;s(i).tones = mat2cell(tone4_sound,2,44101);s(i).correct = 2;
    elseif input_matrix_rndm(i,1) == 5
        s(i).in = input_matrix_rndm(i);s(i).fs = tone5_fs;s(i).tones = mat2cell(tone5_sound,2,44101);s(i).correct = 2;
    end
end






% moveD = zeros(size(sampTrialMat));
% endchoiT = zeros(size(sampTrialMat));
% corT = zeros(size(sampTrialMat));
% relsT = zeros(size(sampTrialMat));

moveD = zeros(10,1);
endchoiT = zeros(10,1);
corT = zeros(10,1);
relsT = zeros(10,1);


delayMat = rand(72,1);

for i = 1:10
    % Check for start of Trial
    disp('To START trial press UP')
    checkUP = 1;
    while checkUP
        write(nC1, 0, 'uint8');
        data = read(nC1, 6, 'uint8');
        write(nC1, 0, 'uint8');
        data2 = read(nC1, 6, 'uint8');
        
        joyYval = int16(data2(2)) - int16(joyYoffset);
        if joyYval == 127 % If controller is UP
            % SEND TTL
            disp('PlayTone/Send TTL/start trial clock')
            % PLAY TONE
            startTr  = tic; %%%%%%%%%%%%%%%%% AT ADDED TO IO CODE
            delayTot = delayMat(i);
            checkWait = 1;%%%%%%%%%%%%%%%%% AT ADDED TO IO CODE
            while checkWait%%%%%%%%%%%%%%%%% AT ADDED TO IO CODE
                tCheckW = toc(startTr);%%%%%%%%%%%%%%%%% AT ADDED TO IO CODE
                
                write(nC1, 0, 'uint8');
                data = read(nC1, 6, 'uint8');
                write(nC1, 0, 'uint8');
                data2 = read(nC1, 6, 'uint8');
                
                joyYval = int16(data2(2)) - int16(joyYoffset);
                joyXval = int16(data2(1)) - int16(joyXoffset);
                if joyYval ~= 127 && tCheckW < delayTot % OUT EARLY % IS NOT UP AND DELAY NOT MET % Y Axis
                    moveD(i) = nan;
                    corT(i) = nan;
                    endchoiT(i) = nan; % GET CHOICE ANYWAY
                    if joyXval < 0 % X axis
                        moveD(i) = 1;
                    else
                        moveD(i) = 2;
                    end
                    disp('outEarly')
                    relsT(i) = tCheckW;
                    checkWait = 0;
                    checkUP = 0;
                elseif joyYval == 127 && tCheckW > delayTot % IS UP and DELAY EXPIRED % Y Axis
                    % PLAY GO CUE
                    startChoice = 1;
                    relsT(i) = tCheckW;
                    while startChoice
                        write(nC1, 0, 'uint8');
                        data = read(nC1, 6, 'uint8');
                        write(nC1, 0, 'uint8');
                        data2 = read(nC1, 6, 'uint8');
                        
                        joyYval = int16(data2(2)) - int16(joyYoffset);
                        joyXval = int16(data2(1)) - int16(joyXoffset);
                        
                        tCheckC = toc(startTr);
                        if joyYval ~= 127 % IF NOT UP
                            endchoiT(i) = tCheckC;
                            if joyXval < 0 % IS LEFT % Query X Axis
                                moveD(i) = 1;
                                disp('Left')
                            else
                                moveD(i) = 2;
                                disp('Right')
                            end
                            if moveD(i) == s(i).correct
                                corT(i) = 0;
                            else
                                corT(i) = 0;
                            end
                            startChoice = 0;
                            checkWait = 0;
                            checkUP = 0;
                        end
                    end
                end
            end
        end
    end
end











