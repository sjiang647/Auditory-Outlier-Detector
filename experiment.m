%% Experiment 5: Auditory Outlier Detection

clear all;
close all;
clc;

%% General Setups (variables, tone ramp, screen, etc.)

% Screen('Preference', 'SkipSyncTests', 1);
% [window, rect] = Screen('OpenWindow', 0);
% Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% HideCursor();
% window_w = rect(3);
% window_h = rect(4); 
% 
% x1 = window_w/2;
% y1 = window_h/2;

rng('shuffle');

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

<<<<<<< HEAD
% inputWindow = inputdlg({'Name','Gender','Age'},...
%               'Customer', [1 50; 1 12; 1 7]);
          
=======
inputWindow = inputdlg({'Name','Gender','Age'},...
    'Customer', [1 50; 1 12; 1 7]);

>>>>>>> 47140f0d07a7e526d26dc533bdfb298ce573c135
% int = input('Participant Initial: ','s');
% nameID = upper(int);
%
% if ~isdir([current, '/Participant_Data/', nameID])
%     mkdir([current, '/Participant_Data/', nameID]);
% end

%% Tuning sound (Convert Hz to MIDI semitones)
midiTones = zeros(1,128);
for midiVal = 1:128
    toneFrequency = 440*2^((midiVal - 69)/12);
    midiTones(midiVal) = sin(2*pi* toneFrequency * toneLength(midiVal));
end 


%% Task instructions

%% Counterbalancing
highlow = mod(randperm(numTrial), 2);%1 if high, 0 if low
outlierDiff = outlierRange(mod(randperm(numTrial), 4) + 1);
outlierPos = mod(randperm(numTrial), 7) + 1;
for i = 1:numTrial
    if highlow(i) == 0
    outlierDiff(i) = -outlierDiff(i);
    end
end


%% Actual experiment

%% Asking whether high or low

%% Saving response

%% Repeat #6-#8 nIter times

%% Save result

