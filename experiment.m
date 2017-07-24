%% Experiment 5: Auditory Outlier Detection

clear all;
close all;
clc;
%% General Setups (variables, tone ramp, screen, etc.)

% Screen('Preference', 'SkipSyncTests', 1);
% [window, rect] = Screen('OpenWindow', 0);
% Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% HideCursor();

% 
% window_w = rect(3);
% window_h = rect(4); 
% 
% x1 = window_w/2;
% y1 = window_h/2;


numTrial = 10;
numTones = 7;
outlierRange = [6, 8, 10, 12];
<<<<<<< HEAD
outlierPos = 1;
test = toneLength(1:end-1);
=======
toneLength = 0:1/44100:.300;
>>>>>>> master
tonePause = 0.1;
toneFrequency = 0;
trialPause = 0.5;
toneRange = [2 4 6];
meanPos = 1;
tones = [];
data = zeros(1, numTrial);
subjectData = {};
surrDistST = [-6,-4,-2,2,4,6];
%% Input subject name & save


inputWindow = inputdlg({'Name','Gender','Age'},...
    'Customer', [1 50; 1 12; 1 7]);
% int = input('Participant Initial: ','s');
% nameID = upper(int);
%
% if ~isdir([current, '/Participant_Data/', nameID])
%     mkdir([current, '/Participant_Data/', nameID]);
% end

%% Tuning sound (Convert Hz to MIDI semitones)

% surrTonesSTs = zeros(1,length(surrDistST));

toneLength = 0:(1/44100):.300;

midiTones = zeros(1,128);
for midiVal = 1:128
    toneFrequency = 440*2^((midiVal - 69)/12);
    midiTones = sin(2*pi* toneFrequency * test);
end
handle = PsychPortAudio('Open', [], [], 0, 44100,2);
PsychPortAudio('FillBuffer', handle, midiTones);
PsychPortAudio('Start', handle,1,0,1);
WaitSecs(.300);
PsychPortAudio('Stop', handle);
PsychPortAudio('Close', handle);

% offset = (1+sin(2*pi*Freq_ramp*rampvector./fs + (pi/2)))/2;
% onset = (1+sin(2*pi*Freq_ramp*rampvector./fs + (-pi/2)))/2;



%% Task instructions
%     Screen('DrawText', window, 'You will listen to 7 audio tones. 1 tone is an outlier. If the outlier is a higher tone, press the ?H? key. If the outlier is a lower tone, press the ?L? key.', x1, y1-25);
%     Screen('Flip',window); 
%% Counterbalancing

highlow = mod(randperm(numTrial), 2); %1 if high, 0 if low
outlierDiff = outlierRange(mod(randperm(numTrial), 4) + 1);
outlierPos = mod(randperm(numTrial), 7) + 1;

for i = 1:numTrial
    if highlow(i) == 0
    outlierDiff(i) = -outlierDiff(i);
    end
end

counterbalancing = [outlierDiff; outlierPos];

%% Repeat #6-#8 nIter times

handle = PsychPortAudio('Open', [], [], 0, 44100, 2); 

for trial = 1:numTrial
    %% Actual experiment
    
    Screen('Flip', window);
    
    % Generate semitone numbers
    outlierData = counterbalance(trial,:);
    nonOutliers = randsample([-toneRange toneRange], numTones - 1);
    
    % Randomly shuffle tones to be played
    pos = nonOutliers(2);
    allTones = [nonOutliers(1:(pos - 1)) outlierData(1) nonOutliers(pos:end)];
    toneVectors = midiTones(allTones + meanTone);
    
    % Loop through and play all tones
    for toneNum = 1:numTones
        PsychPortAudio('FillBuffer', handle, toneVectors(toneNum));
        PsychPortAudio('Start', handle, 1, 0, 1);
        WaitSecs(tonePause);
        PsychPortAudio('Stop', handle);
    end
    
    %% Asking whether high or low
    
    % Give instructions
    msg1 = 'Press h if the outlier tone is higher than the mean.';
    msg2 = 'Press l if the outlier tone is lower than the mean.';
    
    % Display instructions
    Screen('DrawText', window, msg1, window_w/2 - 250, window_h/2 - 25);
    Screen('DrawText', window, msg2, window_w/2 - 250, window_h/2);
    Screen('Flip', window);
    
    %% Saving response
    
    KbName('UnifyKeyNames');

    while true
        % Check which key was pressed
        [keyDown, secs, keyCode, deltaSecs] = KbCheck(-1); % -1 represents the defaut device
        key = KbName(find(keyCode));
        
        % Record response if one of the two keys is pressed
        if strcmp(key, 'h')
            response = 'h';
            break;
        end
        if strcmp(key, 'l')
            response = 'l';
            break;
        end
    end
    
    % Check accuracy of response
    if (response == 'h' && outlierData(1) > 0) || (response == 'l' && outlierData(1) < 0)
        data(trial) = 1;
    end
    
    WaitSecs(trialPause);
end

PsychPortAudio('Close', handle);
Screen('CloseAll');

%% Save result

