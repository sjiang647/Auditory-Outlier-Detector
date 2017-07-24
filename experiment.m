%% Experiment 5: Auditory Outlier Detection

clear all;
close all;
clc;

%% General Setups (vars, tone ramp, screen, etc.)

% Screen('Preference', 'SkipSyncTests', 1);
% [window, rect] = Screen('OpenWindow', 0);
% Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% HideCursor();
rng('shuffle');

numTrial = 10;
outlierRange = [6 10 14 16];
outlierPos = 1;
toneLength = 0.2;
tonePause = 0.1;
trialPause = 0.5;
toneRange = [2 4 6];
meanPos = 1;
tones = [];
data = {};
subjectData = {};

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

%% Task instructions

%% Counterbalancing
highlow = mod(randperm(numTrial), 2);%1 if high, 0 if low
outlierDiff = outlierRange(mod(randperm(numTrial), 4) + 1);
outlierPos = mod(randperm(numTrial), 7) + 1;
counterbalance = [highlow;outlierDiff;outlierPos];


%% Actual experiment

handle = PsychPortAudio('Open', [], [], 0, 44100, 2); 

for trial = 1:numTrial
    outlier_data = counterbalance(trial,:);
    
    
    PsychPortAudio('FillBuffer', handle, mytone);
    PsychPortAudio('Start', handle, 1, 0, 1);
    WaitSecs(tonePause);
    PsychPortAudio('Stop', handle);
    
    WaitSecs(trialPause);
end

PsychPortAudio('Close', handle);

%% Asking whether high or low

%% Saving response

%% Repeat #6-#8 nIter times

%% Save result

