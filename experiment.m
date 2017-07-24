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
toneLength = [0:1/44100:.300];
tonePause = 0.1;
toneFrequency = 0;
trialPause = 0.5;
toneRange = [2 4 6];
meanPos = 1;
tones = [];
data = {};
subjectData = {};
%% Input subject name & save

% inputWindow = inputdlg({'Name','Gender','Age'},...
%               'Customer', [1 50; 1 12; 1 7]);
          
% int = input('Participant Initial: ','s');
% nameID = upper(int);
% 
% if ~isdir([current, '/Participant_Data/', nameID])
%     mkdir([current, '/Participant_Data/', nameID]);
% end

%% Tuning sound (Convert Hz to MIDI semitones)
for midiVal = 1:128
    toneFrequency = 440*2^((midiVal - 69)/12);
    midiTones(midiVal) = sin(2*pi* toneFrequency * toneLength(midiVal));
end 

offset = (1+siin(2*pi*Freq_ramp*rampvector./fs + (pi/2)))/2;
onset = (1+siin(2*pi*Freq_ramp*rampvector./fs + (-pi/2)))/2;

%% Task instructions 

%     Screen('DrawText', window, 'You will listen to 7 audio tones. 1 tone is an outlier. If the outlier is a higher tone, press the ?H? key. If the outlier is a lower tone, press the ?L? key.', x1, y1-25);
%     Screen('Flip',window); 

%% Counterbalancing 

%% Actual experiment 

%% Asking whether high or low

%% Saving response

%% Repeat #6-#8 nIter times 

%% Save result

