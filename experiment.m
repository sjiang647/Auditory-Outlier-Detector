%% Experiment 5: Auditory Outlier Detection

clear all;
close all;
clc;
%% General Setups (variables, tone ramp, screen, etc.)

% Screen('Preference', 'SkipSyncTests', 1);
% [window, rect] = Screen('OpenWindow', 0);
% Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% HideCursor();
rng('shuffle');

% windowX = rect(3);
% windowY = rect(4); 
% center = [windowX/2, windowY/2];
numTrial = 10;
outlierRange = [6, 8, 10, 12];
outlierPos = 1;
tonePause = 0.1;
% toneFrequency = 0;
trialPause = 0.5;
toneRange = [2 4 6];
meanPos = 1;
tones = [];
data = {};
subjectData = {};
surrDistST = [-6,-4,-2,2,4,6];
%% Input subject name & save

% 
% inputWindow = inputdlg({'Name','Gender','Age'},...
%     'Customer', [1 50; 1 12; 1 7]);
% int = input('Participant Initial: ','s');
% nameID = upper(int);
%
% if ~isdir([current, '/Participant_Data/', nameID])
%     mkdir([current, '/Participant_Data/', nameID]);
% end

%% Tuning sound (Convert Hz to MIDI semitones)

% surrTonesSTs = zeros(1,length(surrDistST));
fs = 44100;
toneLength = [0:(1/fs):.300];
toneDuration = toneLength(1:end-1);
freqRamp = 1/(2*(.10));
rampVector = [1:141];
numTones = 7;

for midiVal = 1:numTones
    toneFrequency = 440*2^((midiVal - 69)/12);
    midiTones = sin(2*pi * toneFrequency * toneDuration);
    
    offset = (1+sin(2*pi*freqRamp*rampVector./fs + (pi/2)))/2;
    onset = (1+sin(2*pi*freqRamp*rampVector./fs + (-pi/2)))/2;
    
    tones = (onset .* midiTones .* offset);
    
    stereo = repmat(tones,2,1);
    
    handle = PsychPortAudio('Open', [], [], 0, 44100,2);
    PsychPortAudio('FillBuffer', handle, stereo);
    PsychPortAudio('Start', handle,1,0,1);
    WaitSecs(.300);
    PsychPortAudio('Stop', handle);
    PsychPortAudio('Close', handle);
end 

 



%% Task instructions
%     Screen('DrawText', window, 'You will listen to 7 audio tones. 1 tone is an outlier. If the outlier is a higher tone, press the ?H? key. If the outlier is a lower tone, press the ?L? key.', x1, y1-25);
%     Screen('Flip',window); 
%% Counterbalancing
highlow = mod(randperm(numTrial), 2);%1 if high, 0 if low
outlierDiff = outlierRange(mod(randperm(numTrial), 4) + 1);
outlierPos = mod(randperm(numTrial), 7) + 1;
for i = 1:numTrial
    if highlow(i) == 0
    outlierDiff(i) = -outlierDiff(i);
    end
end

counterbalancing = [outlierDiff; outlierPos];



%% Actual experiment

%% Asking whether high or low

%% Saving response

%% Repeat #6-#8 nIter times

%% Save result

