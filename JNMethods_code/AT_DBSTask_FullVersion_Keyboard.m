function [rsp] = AT_DBSTask_FullVersion_Keyboard()

%Point is to include other tones in this demo

% As of 10/10/17 9:00AM; this code functions reasonably well on Mac, running
% 2017a with PST installed. Uses arrow keys, have participant listen with
% headphones in at volume 2

%NOTE: old 'rsp.master' are 12 fields, new rsp is 13, delete the old rsp
%masters!

%idea, for training video, have the screen going and display sad or happy
%faces with right and wrong, or just play montage of happy/sad cues with
%sound to associate it

%VOICE is 'daisy' from http://www.fromtexttospeech.com/, medium paced

%Arduino controller responses:
% when joystick in 'down start position' readout is:
%[ x, -128, x, x, x, x, x, x)
% when joystick in 'up start position' readout is:
%[ x, 127, x, x, x, x, x, x)
% For up-left or down-left, the first digit becomes -127
% For up-right or down-right, the first digit becomes 128

%TODO: need to include GUI, include clock
%include some kind of on the fly analysis for individual neurons and then
%make a custom script for that type of neuron

%we should really make this so if the pt 'errors' too many times, we go to
%an 'easier' mode where they're not kept to the 'keep your finger in the
%'ready position' until the cue tone' standard, just to the respond at time
%of cue standard

% t = timer('TimerFcn', 'stat=false; disp('    'Timer!'')',... 
% 'StartDelay',100);
% start(t)
% stat=true;
% dispTime = 1;
% while(stat==true)
%   disp(dispTime)
%   pause(1)
% dispTime = dispTime + 1; 
% end


%Datapixx('Open'); 
%DatapixxAOttl() %FOR TTL 

%The script OSXCompositorIdiocyTest() is a "must run" for OSX users, to make sure their system doesn't have the OSX compositor bug, especially on OSX 10.8 and later. If that test fails then visual stimulation timing must be considered not trustworthy.
%The script VBLSyncTest() allows you to assess the timing of Psychtoolbox on your specific setup in a variety of conditions. It expects many parameters and displays a couple of plots at the end, so there is no way around reading the 'help VBLSyncTest' if you want to use it.
wholetrial = tic;
opening = tic;

%note: some of the sounds need to be doubled up for stereo, some don't -
%depends on the mp3 file
%%
%130Hz
[data, fs] = audioread('audiocheck.net_sin_130.8Hz_-3dBFS_1s.wav'); %this specific cue is 5 seconds long, so can be used for the 'aversive' idea, which would be having the cue keep going until a response is inputted.
tone1_fs = fs;
data_conc = data';
tone1_sound = [data_conc;data_conc];
clear data 
clear data_conc
clear fs

%233Hz
[data, fs] = audioread('audiocheck.net_sin_233Hz_-3dBFS_1s.wav');
tone2_fs = fs;
data_conc = data';
tone2_sound = [data_conc;data_conc];
clear data
clear data_conc
clear fs

%261.6Hz
[data, fs] = audioread('audiocheck.net_sin_261.6Hz_-3dBFS_1s.wav'); %this specific cue is 5 seconds long, so can be used for the 'aversive' idea, which would be having the cue keep going until a response is inputted.
tone3_fs = fs;
data_conc = data';
tone3_sound = [data_conc;data_conc];
clear data 
clear data_conc
clear fs

%293Hz
[data, fs] = audioread('audiocheck.net_sin_293Hz_-3dBFS_1s.wav');
tone4_fs = fs;
data_conc = data';
tone4_sound = [data_conc;data_conc];
clear data
clear data_conc
clear fs

%523Hz
[data, fs] = audioread('audiocheck.net_sin_523Hz_-3dBFS_1s.wav');
tone5_fs = fs;
data_conc = data';
tone5_sound = [data_conc;data_conc];
clear data
clear data_conc
clear fs

%Go Beep, 2 sin wave @ 523 and 130Hz
[data, fs] = audioread('audiochecknet_130Hz_-7dBFS_523Hz_-7dBFS_05s.wav');
gobeep_fs = fs;
data_conc = data';
gobeep_sound = [data_conc;data_conc];
clear data
clear data_conc
clear fs

%% load('input_matrix_rndm.mat')
%load('input_matrix_rndm.mat', 'input_matrix_rndm')
input_matrix_rndm = [1,2,301,302,4,5]';
input_fss = zeros(length(input_matrix_rndm),1);
input_tones =  cell(length(input_matrix_rndm),1);
input_correct = zeros(length(input_matrix_rndm),1);
s = struct('in',input_matrix_rndm,'fs',input_fss,'tones',input_tones,'correct',input_correct);

% input_fss =  cell(length(input_matrix_rndm),1);
% input_tones =  cell(length(input_matrix_rndm),1);
% input_correct =  cell(length(input_matrix_rndm),1);

%% extending input_matrix_rndm variable into a structure we will subsequently pull from
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
%%
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

%ListenChar(2); %turns keyboard output to command window off 'ListenChar(0)' turns it on
KbName('UnifyKeyNames');
InitializePsychSound
repetitions = 1;
%Screen('Preference', 'SkipSyncTests', 1); %messy workaround, timing is prob off, turn 1 to 0 to make screen timing accurtate
Screen('Preference', 'SkipSyncTests', 0); %messy workaround, timing is prob off, turn 1 to 0 to make screen timing accurtate
PsychDefaultSetup(2);
% screens = Screen('Screens'); might want to query OR computer
screenNumber = 0;
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
% grey = white / 2;

pahandle = PsychPortAudio('Open',[],[],0,sound_hellomynameisdaisy_fs, 2);%0 is for no latency
PsychPortAudio('FillBuffer', pahandle, sound_hellomynameisdaisy);
PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
WaitSecs(length(sound_hellomynameisdaisy)/sound_hellomynameisdaisy_fs);
rez = Screen('Resolution',screenNumber);
width = (rez.width)/3;
height = (rez.height)/3;
newrect = [0,0,width,height];

[window, ~] = PsychImaging('OpenWindow', screenNumber, white, newrect);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[~, screenYpixels] = Screen('WindowSize', window);
% [xCenter, yCenter] = RectCenter(windowRect);
  
rsp = struct();

LeftArrow = KbName('leftarrow');RighArrow = KbName('rightarrow');UpArrow = KbName('uparrow');
% DownArrow = KbName('d');% UpArrow = KbName('u');% waitkey = KbName('w');
Opening = toc(opening);
%below starts more active code
for i = 1:length(input_matrix_rndm)
    start_loop = tic;
    %trialnum = input_matrix_rndm(i,2);
    responsedelay_base = .5; %want things clustered around 0.5 seconds for response delay
    startrndm = responsedelay_base*(0.9);
    endrndm = responsedelay_base*(1.1);
    lineup = linspace(startrndm, endrndm);
    lineup_RNDM = lineup(randperm(length(lineup)));
    hatpick = lineup_RNDM(1); %kept this simplified in case there's reason to give responses some type of distribution (gaussian or something)
    responsedelay = hatpick; 
    rsp(i).responsedelay = hatpick;

        if i == 1
        pahandle = PsychPortAudio('Open',[],[],0,sound_whenyouareready_fs, 2);%0 is for no latency
        PsychPortAudio('FillBuffer', pahandle, sound_whenyouareready);
        PsychPortAudio('Start', pahandle, repetitions, 0, 1);
        elseif i ~= 1
        pahandle = PsychPortAudio('Open',[],[],0,sound_next_fs, 2);%0 is for no latency
        PsychPortAudio('FillBuffer', pahandle, sound_next);
        PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
        end
    
    RestrictKeysForKbCheck([]); %JS should be able to delete
    RestrictKeysForKbCheck(UpArrow);%JS should be able to delete
    percentcomplete = floor(100*(i/length(input_matrix_rndm)));
    linea = 'Push up to start.';
    lineb = (['\n TIME:  ' num2str(wholetrial) ' seconds elapsed']); %
    linec = (['\nn Percent complete:' num2str(percentcomplete)]); %
        
    % Draw all the text in one go
    Screen('TextSize', window, 35);
    DrawFormattedText(window, [linea lineb linec],...
        'center', screenYpixels * 0.25, black);
    Screen('Flip', window)
    
 
    FlushEvents('keyDown') %JS should be able to delete
    %this was added in addition to one after KbPressWait before there was error that would occur on first trial otherwise
    
    t2wait = 10; %how long before audio prompts them
    % get the time stamp at the start of waiting for key input 
    tStart = GetSecs;
    timedout = false;
    rsptemp.RT = NaN; rsptemp.keyCode = []; rsptemp.keyName = [];
    %WILL NEED TO CHANGE ABOVE FOR CONTROLLER, and below. basically keycode and
    %keyname should be substituted out for whatever axis we use for start
    %position and Kbcheck subbed for 'read'

        while ~timedout
         % check if a key is pressed
        % only keys specified in activeKeys are considered valid
        [ keyIsDown, keyTime, keyCode ] = KbCheck; 
          if(keyIsDown)
          PsychPortAudio('Stop', pahandle);
          PsychPortAudio('Close', pahandle);
          WaitSecs(.2);
          break; 
          end
      
         if( (keyTime - tStart) > t2wait) 
         pahandle = PsychPortAudio('Open',[],[],0,sound_whenyouareready_fs, 2);%0 is for no latency
         PsychPortAudio('FillBuffer', pahandle, sound_whenyouareready);
         PsychPortAudio('Start', pahandle, repetitions, 0, 1);
         timedout = true; 
         KbPressWait
         end
        end
         % store code for key pressed and reaction time (not saving it out at the
         % moment)
     if(~timedout)
         rsptemp.RT      = keyTime - tStart;
         rsptemp.keyCode = keyCode;
         rsptemp.keyName = KbName(rsptemp.keyCode);
      end

    
    FlushEvents('keyDown') % clears keyboard queue for Char fx
    %JS should be able to delete
    
    Start_loop = toc(start_loop);
    hold = tic;
    %DatapixxAOttl() %FOR TTL 

    
    linea = (['Trial' num2str(i)]);
    lineb = ([' TIME:  ' num2str(wholetrial) ' seconds elapsed']); %
    linec = ([' Percent complete:' num2str(percentcomplete)]); %
    Screen('TextSize', window, 35);
    DrawFormattedText(window, [linea lineb linec],...
    'center', screenYpixels * 0.25, black);
    Screen('Flip', window)
    
    pahandle = PsychPortAudio('Open',[],[],0, (s(i).fs), 2);%0 is for no latency
    PsychPortAudio('FillBuffer', pahandle, cell2mat(s(i).tones));
    PsychPortAudio('Start', pahandle, repetitions, 0, 1);
    WaitSecs(1) %can compute based off length(cell2mat...) / s(i).fs
    PsychPortAudio('Stop', pahandle);
    PsychPortAudio('Close', pahandle);
        
        
    waitdur_fraction = 10;%how many times during the waitduration do you want to check key status?
        for iii = 1:waitdur_fraction
            CharAvaila = CharAvail;%JS change to confirm it is in start position
             if CharAvaila == 1 %this will change to ~= (start position coordinate)
                 
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
                    WaitSecs(5.6)
                    
                    pahandle = PsychPortAudio('Open',[],[],0,gobeep_fs, 2);%0 is for no latency
                    PsychPortAudio('FillBuffer', pahandle, gobeep_sound);
                    PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                    
                    WaitSecs(0.5)
                    pahandle = PsychPortAudio('Open',[],[],0,sound_then_fs, 2);%0 is for no latency
                    PsychPortAudio('FillBuffer', pahandle, sound_then);
                    PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
% 
%                      linee = 'Too soon! Wait till after tone.';
%                      linee2 = '\n Press any key to continue.';
%                      rsp(i).ERROR = 'ERROR';
%                      % Draw all the text in one go
%                      Screen('TextSize', window, 35);
%                       DrawFormattedText(window, [linee linee2],...
%                      'center', screenYpixels * 0.25, black);
%                       Screen('Flip', window)
%         
                     WaitSecs(9.5); %this gives audio enough time to play without bumping into the 'Next' audio

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
             elseif CharAvaila ~= 1
                  WaitSecs(responsedelay*((iii-iii+1)/waitdur_fraction)) %split up the response delay into parts so we can query in the middle of it as to the position of the participants joystick
                    if iii == waitdur_fraction
                        rsp(i).ERROR = 'GOOD';
                                            
                        pahandle = PsychPortAudio('Open',[],[],0,gobeep_fs, 2);%0 is for no latency
                        PsychPortAudio('FillBuffer', pahandle, gobeep_sound);
                        PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                               
                        KbReleaseWait; %JS delete and replace with some loop that waits till start position is left
                        hold_time = toc(hold);
                        %DatapixxAOttl() %FOR TTL 

                        posthold = tic;
                        RestrictKeysForKbCheck([]);%JS delete
                        activeKeys = [RighArrow LeftArrow UpArrow];%JS delete
                        RestrictKeysForKbCheck(activeKeys);%JS delete
    
                         %DatapixxAOttl() %FOR TTL 

                        startTime = GetSecs(); %GetSecs uses highest precision clock on each OS
                        keyIsDown = 0;%JS delete'replace
    
                        while ~keyIsDown
                           [ keyIsDown, pressedSecs, keyCode ] = KbCheck(-1); %the -1 means its querying all keyboards, changing this value should all we need to do for incorporating keypad/keyboards
                        end
                        %DatapixxAOttl() %FOR TTL 

                        pressedKey = KbName(find(keyCode));
                        reactionTime = pressedSecs-startTime;
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
                                
    
                           FlushEvents('keyDown') % clears keyboard queue for Char fx's
                           % rsp(1).pretime = preloadtime;
                           rsp(i).rtime = reactionTime;
    
                            if (s(i).correct == 2 && keyCode(RighArrow) == 1)
                                pahandle = PsychPortAudio('Open',[],[],0,sound_correctbeep_fs, 2);%0 is for no latency
                                PsychPortAudio('FillBuffer', pahandle, sound_correctbeep);
                                PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.

                                % keyCode(82) is UpArrow, keyCode(81) is DownArrow, keyCode(24) is u, keyCode(7) is d
                                DrawFormattedText(window, 'Correct', 'center', 'center', black);
                                Screen('Flip', window);
                                WaitSecs(1);
        
        
                             elseif (s(i).correct == 1 && keyCode(LeftArrow) == 1)
                                  pahandle = PsychPortAudio('Open',[],[],0,sound_correctbeep_fs, 2);%0 is for no latency
                                  PsychPortAudio('FillBuffer', pahandle, sound_correctbeep);
                                  PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.

                                  DrawFormattedText(window, 'Correct', 'center', 'center', black);
                                  Screen('Flip', window);
                                  WaitSecs(1);
        
                            else
                                  pahandle = PsychPortAudio('Open',[],[],0,sound_incorrectbeep_fs, 2);%0 is for no latency
                                  PsychPortAudio('FillBuffer', pahandle, sound_incorrectbeep);
                                  PsychPortAudio('Start', pahandle, repetitions, 0, 1); % Start audio playback for 'repetitions' repetitions of the sound data,start it immediately (0) and wait for the playback to start, return onset timestamp.
                                  DrawFormattedText(window, 'Incorrect', 'center', 'center', black);
                                  Screen('Flip', window);
                                  WaitSecs(1);
        
                            end
    
                        FlushEvents('keyDown') % clears keyboard queue for Char fx's
                        Writeuptime = toc(writeup);
                        rsp(i).Writeuptime = Writeuptime;
                        %DatapixxAOttl() %FOR TTL 

                    end
             end
        end



       % Clear the screen
        % sca;

      Wholetrial = toc(wholetrial);
      rsp(i).Wholetrial = Wholetrial;

end


% RESTART point (correct and incorrect converge here)
    RestrictKeysForKbCheck([]);
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
    s2 = struct('Date',{'zero'}, 'ERROR', 0, 'responsedelay', 0, 'Wholetrial', 0,'Sumoftictocs', 0, 'Response', {'zero'},'rtime',0,'actual', {'zero'}, 'Opening', 0,'Start_loop', 0,'Hold_time',0, 'Postholdtime',0,'Writeuptime',0);
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
    
    %following changes order of the structure output fields, will need to
    %adjust if adding more outputs to 'rsp'
    % (sample code:b = 20; c = 10; a = 500;
    %s = struct('b', 20, 'c', 30, 'a', 10);
    %s2 = struct('c', 3, 'a', 1, 'b', 2);
    %snew = orderfields(s, s2);
    s = rsp;
    s2 = struct('Date',{'zero'}, 'ERROR', 0,  'responsedelay', 0,'Wholetrial', 0,'Sumoftictocs', 0, 'Response', {'zero'},'rtime',0,'actual', {'zero'}, 'Opening', 0,'Start_loop', 0,'Hold_time',0, 'Postholdtime',0,'Writeuptime',0);
    snew = orderfields(s, s2);
    rsp = snew;
    save('rsp_master.mat', 'rsp_master')
    %DatapixxAOttl() %FOR TTL 
    %ListenChar(0); %turns keyboard output to command window off 'ListenChar(0)' turns it on

    
end
sca;
end