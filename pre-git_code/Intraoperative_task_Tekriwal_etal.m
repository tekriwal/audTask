function [rsp] = AT_task_fortroubleshooting_noDatapixx()
dbstop if error


% Arduino controller responses:
% When joystick in 'up start position' readout is,[ x, 127, x, x, x, x, x, x ]
% When joystick is to the left, the first digit becomes -127
% When joystick is to the right, the first digit becomes 128

%VOICE is 'daisy' from http://www.fromtexttospeech.com/, medium paced

%  Datapixx('Open'); %in our task, we use Datapixx for TTL generation but
%  if Datapixx is not connected to your system, running these commands will
%  throw errors. 
%  DatapixxAOttl() %FOR TTL 

%The script VBLSyncTest() allows you to assess the timing of Psychtoolbox on your specific setup in a variety of conditions. It expects many parameters and displays a couple of plots at the end, so there is no way around reading the 'help VBLSyncTest' if you want to use it.
wholetrial = tic;
opening = tic;

%% loading in audio files (not all used. depends on iteration)
%130Hz
[data, fs] = audioread('audiocheck.net_sin_130.8Hz_-3dBFS_1s.wav'); 
tone1_fs = fs;
data_conc = data';
tone1_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%233Hz
[data, fs] = audioread('audiocheck.net_sin_233Hz_-3dBFS_1s.wav');
tone2_fs = fs;
data_conc = data';
tone2_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%261.6Hz
[data, fs] = audioread('audiocheck.net_sin_261.6Hz_-3dBFS_1s.wav'); 
tone3_fs = fs;
data_conc = data';
tone3_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%293Hz
[data, fs] = audioread('audiocheck.net_sin_293Hz_-3dBFS_1s.wav');
tone4_fs = fs;
data_conc = data';
tone4_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%523Hz
[data, fs] = audioread('audiocheck.net_sin_523Hz_-3dBFS_1s.wav');
tone5_fs = fs;
data_conc = data';
tone5_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%Go Beep, 2 sin wave @ 523 and 130Hz
[data, fs] = audioread('audiochecknet_130Hz_-7dBFS_523Hz_-7dBFS_05s.wav');
gobeep_fs = fs;
data_conc = data';
gobeep_sound = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%hellomynameisdaisy
[data, fs] = audioread('hellomynameisdaisy.mp3');
sound_hellomynameisdaisy_fs = fs;
data_conc = data';
sound_hellomynameisdaisy = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%pleasebeginafterthefollowingtone
[data, fs] = audioread('whenyouareready_.mp3');
sound_whenyouareready_fs = fs;
data_conc = data';
sound_whenyouareready = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%next
[data, fs] = audioread('next_.mp3');
sound_next_fs = fs;
data_conc = data';
sound_next = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%correctbeep
[data, fs] = audioread('correctbeep.mp3');
sound_correctbeep_fs = fs;
data_conc = data';
sound_correctbeep = data_conc;
%incorrectbeep
[data, fs] = audioread('incorrectbeep.mp3');
sound_incorrectbeep_fs = fs;
data_conc = data';
sound_incorrectbeep = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%pleasecontinuetoholduntil
[data, fs] = audioread('pleasecontinuetoholduntil.mp3');
sound_pleasecontinuetoholduntil_fs = fs;
data_conc = data';
sound_pleasecontinuetoholduntil = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%then
[data, fs] = audioread('then.mp3');
sound_then_fs = fs;
data_conc = data';
sound_then = [data_conc;data_conc];
clear data;clear data_conc;clear fs
%% load('input_matrix_rndm.mat')
load('input_matrix_rndm.mat', 'input_matrix_rndm') %full input, this file is generated from 'randomizer_inputmatrix_IO' found on github in same respository as this script
%input_matrix_rndm = [1,2,4,5]'; %abridged input for testing


input_fss = zeros(length(input_matrix_rndm),1);
input_tones =  cell(length(input_matrix_rndm),1);
input_correct = zeros(length(input_matrix_rndm),1);
s = struct('in',input_matrix_rndm,'fs',input_fss,'tones',input_tones,'correct',input_correct);
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
%% call arduino
a = arduino();
addrs = scanI2CBus(a);
nC1 = i2cdev(a, char(addrs) , 'bus' , 0);

joyXoffset = 127;
joyYoffset = 128;
%acceloffset = 512;
%%
%ListenChar(2); %turns keyboard output to command window off 'ListenChar(0)' turns it on
KbName('UnifyKeyNames');
InitializePsychSound
repetitions = 1;
Screen('Preference', 'SkipSyncTests', 0); 
PsychDefaultSetup(2);
screenNumber = 1; %screen number will vary based on setup
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
% grey = white / 2;

pahandle = PsychPortAudio('Open',[],[],0,sound_hellomynameisdaisy_fs, 2);%0 is for no latency
PsychPortAudio('FillBuffer', pahandle, sound_hellomynameisdaisy);
PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
%WaitSecs(length(sound_hellomynameisdaisy)/sound_hellomynameisdaisy_fs);
PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
PsychPortAudio('Close', pahandle);

rez = Screen('Resolution',screenNumber);
width = (rez.width)/3;
height = (rez.height)/3;
newrect = [0,0,width,height];

[window, ~] = PsychImaging('OpenWindow', screenNumber, white, newrect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[~, screenYpixels] = Screen('WindowSize', window);
% [xCenter, yCenter] = RectCenter(windowRect);
  
rsp = struct();

% DatapixxAOttl() %FOR TTL 
%LeftArrow = KbName('leftarrow');RighArrow = KbName('rightarrow');UpArrow = KbName('uparrow');
Opening = toc(opening);

%% below starts more active code
for i = 1:length(input_matrix_rndm)
%     DatapixxAOttl() %FOR TTL
    start_loop = tic;
    responsedelay_base = 0.25;
    startrndm = responsedelay_base*(0.9);
    endrndm = responsedelay_base*(1.1);
    lineup = linspace(startrndm, endrndm);
    lineup_RNDM = lineup(randperm(length(lineup)));
    hatpick = lineup_RNDM(1); 
    responsedelay = hatpick; 
    rsp(i).responsedelay = hatpick;

        if i == 1
        pahandle = PsychPortAudio('Open',[],[],0,sound_whenyouareready_fs, 2);%0 is for no latency
        PsychPortAudio('FillBuffer', pahandle, sound_whenyouareready);
        PsychPortAudio('Start', pahandle, repetitions, 0, 1);
        WaitSecs(length(sound_whenyouareready)/sound_whenyouareready_fs);
        PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
        PsychPortAudio('Close', pahandle);
        elseif i ~= 1
        pahandle = PsychPortAudio('Open',[],[],0,sound_next_fs, 2);%0 is for no latency
        PsychPortAudio('FillBuffer', pahandle, sound_next);
        PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
        WaitSecs(length(sound_next)/sound_next_fs);
        PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
        PsychPortAudio('Close', pahandle);
        end
    

    percentcomplete = floor(100*(i/length(input_matrix_rndm)));
    linea = 'Push up to start.';
    lineb = ([' TIME:  ' num2str(toc(wholetrial)) ' seconds elapsed']); %
    linec = ([' Percent complete:   ' num2str(percentcomplete)]); %
    Screen('TextSize', window, 35);
    DrawFormattedText(window, [linea lineb linec],...
        'center', screenYpixels * 0.25, black);
    Screen('Flip', window)
    
 
%%
        check = 1;
        while check == 1
            WaitSecs(0.001)
            write(nC1, 0, 'uint8');
            data = read(nC1, 6, 'uint8');
            joyYval = int16(data(2)) - int16(joyYoffset);
            if  (joyYval == 127)
                write(nC1, 0, 'uint8');
                data = read(nC1, 6, 'uint8');
                joyYval = int16(data(2)) - int16(joyYoffset);
                if  (joyYval == 127)
                    %WaitSecs(0.001)
                    %PsychPortAudio('Stop', pahandle);
                    %PsychPortAudio('Close', pahandle);
%                    DatapixxAOttl() %FOR TTL
                    break
                end
%             elseif joyYval ~= 127
%                 check = 1;
            end
        end

%% querying arduino for thumbstick position        
    Start_loop = toc(start_loop);
    hold = tic;
%     DatapixxAOttl() %FOR TTL 

    linea = (['Trial' num2str(i)]);
    lineb = (['\n TIME:  ' num2str(toc(wholetrial)) ' seconds elapsed']); %
    linec = (['\n Percent complete:' num2str(percentcomplete)]); %
    Screen('TextSize', window, 35);
    DrawFormattedText(window, [linea lineb linec],...
    'center', screenYpixels * 0.25, black);
    Screen('Flip', window)
%     DatapixxAOttl() %FOR TTL 
    pahandle = PsychPortAudio('Open',[],[],0, (s(i).fs), 2);%0 is for no latency
    PsychPortAudio('FillBuffer', pahandle, cell2mat(s(i).tones));
    PsychPortAudio('Start', pahandle, repetitions, 0, 1);
    stimbeepduration = tic;
%     DatapixxAOttl() %FOR TTL 
    WaitSecs(0.25);   
    PsychPortAudio('Stop', pahandle, 0); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact)
    Stimbeepduration = toc(stimbeepduration);
%     DatapixxAOttl() %FOR TTL 

    rsp(i).Stimbeepduration = Stimbeepduration;
    PsychPortAudio('Close', pahandle);
    waitdur_fraction = 10;%how many times during the waitduration do you want to check key status?
        for iii = 1:waitdur_fraction
            
            write(nC1, 0, 'uint8');
            data = read(nC1, 6, 'uint8');
            joyYval = int16(data(2)) - int16(joyYoffset);
             if joyYval ~= 127 % (start position coordinate)
%                  DatapixxAOttl() %FOR TTL 
                     linee = 'Too soon! Wait till after tone.';
                     linee2 = '\n Press any key to continue.';
                     rsp(i).ERROR = 'ERROR';
                     % Draw all the text in one go
                     Screen('TextSize', window, 35);
                      DrawFormattedText(window, [linee linee2],...
                     'center', screenYpixels * 0.25, black);
                      Screen('Flip', window)
                    pahandle = PsychPortAudio('Open',[],[],0,sound_pleasecontinuetoholduntil_fs, 2);%0 is for no latency
                    PsychPortAudio('FillBuffer', pahandle, sound_pleasecontinuetoholduntil);
                    PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                    WaitSecs(length(sound_pleasecontinuetoholduntil)/sound_pleasecontinuetoholduntil_fs);
                    PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                    PsychPortAudio('Close', pahandle);
                    pahandle = PsychPortAudio('Open',[],[],0,gobeep_fs, 2);%0 is for no latency
                    PsychPortAudio('FillBuffer', pahandle, gobeep_sound);
                    PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.     
                    WaitSecs(0.5)
                    PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                    PsychPortAudio('Close', pahandle);
                    pahandle = PsychPortAudio('Open',[],[],0,sound_then_fs, 2);%0 is for no latency
                    PsychPortAudio('FillBuffer', pahandle, sound_then);
                    PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                    WaitSecs(length(sound_then)/sound_then_fs); %this gives audio enough time to play without bumping into the 'Next' audio
                    PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                    PsychPortAudio('Close', pahandle);
                    %because we're skipping a bunch of stuff, need to put in values so
                      %struct at ends computes properly (see below)
                      hold_time = toc(hold);
                      posthold = tic;
                      pressedKey = 'f';
                      reactionTime = 0;
                      postholdt = toc(posthold);
                      writeup = tic;
                   if i == 1
                         rsp(i).Opening = Opening;
                   elseif i ~= 1
                          rsp(i).Opening = 0;
                   end
                 rsp(i).Start_loop = Start_loop;
                 rsp(i).Hold_time = hold_time;
                 rsp(i).Response = pressedKey;
                 rsp(i).Postholdtime = postholdt;
                 rsp(i).actual = 'f'; %f for fail
                 rsp(i).rtime = reactionTime;
                 Writeuptime = toc(writeup);
                 rsp(i).Writeuptime = Writeuptime;
%                  Wholetrial = toc(wholetrial);
%                  rsp(i).Wholetrial = Wholetrial;
                  break
             elseif joyYval == 127
%                   DatapixxAOttl() %FOR TTL 
                  WaitSecs(responsedelay*((iii-iii+1)/waitdur_fraction)) %split up the response delay into parts so we can query in the middle of it as to the position of the participants joystick
                    if iii == waitdur_fraction
%                         DatapixxAOttl() %FOR TTL 
                        rsp(i).ERROR = 'GOOD';                       
                        pahandle = PsychPortAudio('Open',[],[],0,gobeep_fs, 2);%0 is for no latency
                        PsychPortAudio('FillBuffer', pahandle, gobeep_sound);
                        PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
%                         PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
%                         PsychPortAudio('Close', pahandle);
%                         
                        hold_time = toc(hold);
%                         DatapixxAOttl() %FOR TTL 
                        posthold = tic;
%                         DatapixxAOttl() %FOR TTL 
                        check = 1;
                        startTime = GetSecs(); %GetSecs uses highest precision clock on each OS
                            while check == 1
                                WaitSecs(0.001)
                                write(nC1, 0, 'uint8');
                                data = read(nC1, 6, 'uint8');
%                                 ZBut = ~(bitget(data(6),1));
%                                 CBut = ~(bitget(data(6),2));
                                joyXval = int16(data(1)) - int16(joyXoffset);
                                if joyXval == -127
%                                      DatapixxAOttl() %FOR TTL 
                                    pressedKey = 1; %1 is for low/left
                                    pressedSecs = GetSecs();
                                    reactionTime = pressedSecs-startTime;
                                    break
                                elseif joyXval == 128
%                                      DatapixxAOttl() %FOR TTL 
                                    pressedKey = 2; %2 stands for right/high 
                                    pressedSecs = GetSecs();
                                    reactionTime = pressedSecs-startTime;
                                    break
                                elseif joyXval ~= -127 || 128
                                    check = 1;
                                end
                            end 
   
                        postholdt = toc(posthold);
                        writeup = tic;
                                if i == 1
                                     rsp(i).Opening = Opening;
                                elseif i ~= 1
                                     rsp(i).Opening = 0;
                                end
                            rsp(i).Start_loop = Start_loop;
                        rsp(i).Hold_time = hold_time;
                        rsp(i).Response = pressedKey;
                        rsp(i).Postholdtime = postholdt;
                        rsp(i).actual = s(i).correct;
                        rsp(i).rtime = reactionTime;
                            if (s(i).correct == 2 && rsp(i).Response == 2)
                                pahandle = PsychPortAudio('Open',[],[],0,sound_correctbeep_fs, 2);%0 is for no latency
                                PsychPortAudio('FillBuffer', pahandle, sound_correctbeep);
                                PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
%                                 DatapixxAOttl() %FOR TTL
                                PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                                PsychPortAudio('Close', pahandle);
                                % keyCode(82) is UpArrow, keyCode(81) is DownArrow, keyCode(24) is u, keyCode(7) is d
                                DrawFormattedText(window, 'Correct', 'center', 'center', black);
                                Screen('Flip', window);
                        clear PsychPortAudio
                            elseif (s(i).correct == 1 && rsp(i).Response == 1)
                                  pahandle = PsychPortAudio('Open',[],[],0,sound_correctbeep_fs, 2);%0 is for no latency
                                  PsychPortAudio('FillBuffer', pahandle, sound_correctbeep);
                                  PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
%                                   DatapixxAOttl() %FOR TTL
                                  PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                                  PsychPortAudio('Close', pahandle);
                                  DrawFormattedText(window, 'Correct', 'center', 'center', black);
                                  Screen('Flip', window);
                        clear PsychPortAudio
                            else
                                  pahandle = PsychPortAudio('Open',[],[],0,sound_incorrectbeep_fs, 2);%0 is for no latency
                                  PsychPortAudio('FillBuffer', pahandle, sound_incorrectbeep);
                                  PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                                  PsychPortAudio('Stop', pahandle, 3); %0 tells fx to stop as soon as convenient (as quickly as possible w/out artifact) but a '3' would mean run until completion and then stop audio playback
                                  PsychPortAudio('Close', pahandle);
                                  DrawFormattedText(window, 'Incorrect', 'center', 'center', black);
                                  Screen('Flip', window);
                        clear PsychPortAudio
                            end
%                       FlushEvents('keyDown') % clears keyboard queue for Char fx's
                        Writeuptime = toc(writeup);
                        rsp(i).Writeuptime = Writeuptime;
%                         DatapixxAOttl() %FOR TTL 
                    end
             end
        end
       % Clear the screen
        % sca;
      Wholetrial = toc(wholetrial);
      rsp(i).Wholetrial = Wholetrial;
end
%% RESTART point (correct and incorrect converge here)
%     RestrictKeysForKbCheck([]);
    % final 'report': rsp(i).truetotal % everything
for i = 1:length(rsp)
    if i == 1
        rsp(i).Sumoftictocs = rsp(i).Opening+rsp(i).Start_loop+rsp(i).Hold_time+rsp(i).Postholdtime+rsp(i).Writeuptime;
    elseif i ~= 1
        rsp(i).Sumoftictocs = rsp(i).Start_loop+rsp(i).Hold_time+rsp(i).Postholdtime+rsp(i).Writeuptime;
    end 
end

for i = 1:length(rsp)

    
    a = rsp(length(rsp)).Wholetrial;
    sprintf('%.4f',a);
    b = rsp(i).Opening+rsp(i).Start_loop+rsp(i).Hold_time+rsp(i).Postholdtime+rsp(i).Writeuptime;
    sprintf('%.4f',a);

    if a <= b
        disp ('ERROR, see total calculator');
    else
        disp ('GOOD, total calculator time check');
    end
    
    a = rsp(i).Sumoftictocs;
    sprintf('%.4f',a);
    b = rsp(i).Opening+rsp(i).Start_loop+rsp(i).Hold_time+rsp(i).Postholdtime+rsp(i).Writeuptime;
    sprintf('%.4f',b);

    if a ~= b
        disp (['ERROR, see individual calculator for i = ' num2str(i)]);
    else
        disp (['GOOD, individual calculator for i = ' num2str(i)]);
    end
        
    %rsp(i).Date = datestr(datetime('now','Timezone','local','Format','d-MMM-y HH:mm:ss Z'));
    %above for recent matlab version only
    
    rsp(i).Date = now;
    rsp = renameStructField(rsp,'correct','actual'); % I HAVE NO IDEA WHY THIS IS NECESSARY (field name changes depending on whether high or low pitched cue, if calling low tone ends up as fieldname(correct) but for high tone its (fieldname(actual))
    %STR = renameStructField(STR, OLDFIELDNAME, NEWFIELDNAME)
    
    %changes order of struct fieldnames, imo makes reading output easier
    s = rsp;
    s2 = struct('Date',{'zero'}, 'ERROR', 0, 'Stimbeepduration', 0, 'responsedelay', 0, 'Wholetrial', 0,'Sumoftictocs', 0, 'Response', {'zero'},'rtime',0,'actual', {'zero'}, 'Opening', 0,'Start_loop', 0,'Hold_time',0, 'Postholdtime',0,'Writeuptime',0);
    snew = orderfields(s, s2);
    rsp = snew;
    
    if exist ('rsp_master.mat', 'file') == 0
        rsp_master = rsp;
    else
        load('rsp_master');
        rsp_master = renameStructField(rsp_master,'correct','actual');
        rsp_newmaster = [rsp_master, rsp];
        clear 'rsp_master'
        rsp_master = rsp_newmaster;
    end
    
    s = rsp;
    s2 = struct('Date',{'zero'}, 'ERROR', 0,  'Stimbeepduration', 0, 'responsedelay', 0,'Wholetrial', 0,'Sumoftictocs', 0, 'Response', {'zero'},'rtime',0,'actual', {'zero'}, 'Opening', 0,'Start_loop', 0,'Hold_time',0, 'Postholdtime',0,'Writeuptime',0);
    snew = orderfields(s, s2);
    rsp = snew;
    save('rsp_master.mat', 'rsp_master')
%     DatapixxAOttl() %FOR TTL 
    %ListenChar(0); %turns keyboard output to command window off 'ListenChar(0)' turns it on

    
end
sca;
end