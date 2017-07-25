%% Experiment 5: Auditory Outlier Detection

clear all;
close all;
clc;

%% General Setups (variables, tone ramp, screen, etc.)

Screen('Preference', 'SkipSyncTests', 1);
[window, rect] = Screen('OpenWindow', 0);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
HideCursor();
rng('shuffle');

windowX = rect(3);
windowY = rect(4); 
center = [windowX/2, windowY/2];
numTrial = 10;
numTones = 7;
outlierRange = [6, 8, 10, 12];
outlierPos = 1;
toneLength = 0:1/44100:.300;
test = toneLength(1:end-1);
tonePause = 0.1;
toneFrequency = 0;
trialPause = 0.5;
toneRange = [2 4 6];
meanRange = 50:80;
meanPos = 1;
tones = [];
data = zeros(1, numTrial);
subjectData = {};%first is name, second gender, third age

%% Input subject name & save

subjectData{1} = Ask(window,'Name: ',[],[],'GetChar',RectLeft,RectTop);
subjectData{2} = Ask(window,'Gender(M/F): ',[],[],'GetChar',RectLeft,RectTop);
subjectData{3} = Ask(window,'Age: ',[],[],'GetChar',RectLeft,RectTop);

%% Task instructions
 
Screen('DrawText', window, 'You will listen to 7 audio tones. 1 tone is an outlier.', center(1)-275, center(2)-60);
Screen('DrawText', window, 'If the outlier is a higher tone than the average tone, press the "H" key.', center(1)-350, center(2)-30);
Screen('DrawText', window, 'If the outlier is a lower tone than the average tone, press the "L" key.', center(1)-350, center(2));
Screen('DrawText', window, 'Press any button to continue', center(1)-170, center(2)+66);
Screen('Flip', window); 
WaitSecs(5);
KbWait;


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

% Tuning sound (Convert Hz to MIDI semitones)
handle = PsychPortAudio('Open', [], [], 0, 44100, 2); 
toneLength = 0:(1/44100):.300; %use when to play the actual tones 
toneDur = .300;
midiTones = zeros(1,128);
freqRamp = 1/(2*(.10));
rampVector = [1:141];
fs = 44100;
offset = (1+sin(2*pi*freqRamp*rampVector./fs + (pi/2)))/2;
onset = (1+sin(2*pi*freqRamp*rampVector./fs + (-pi/2)))/2;


for k = 1:127 
    toneFrequency = 440*2^((k-69)/12);
    midiTones = sin(2*pi* toneFrequency * toneLength);
    tones = [onset midiTones offset];
    finalTones = repmat(tones, 2, 1);
    freq{k} = finalTones;
end  

for trial = 1:numTrial
    %% Actual experiment
    
    Screen('Flip', window);
    
    % Define mean tone
    meanTone = randsample(meanRange, 1);

    % Generate semitone numbers
    outlierData = counterbalancing(trial,:); %the outlier should be a set distance away
    nonOutliers = randsample([-toneRange toneRange], numTones - 1); 
    

    
    % Randomly shuffle tones to be played
    pos = nonOutliers(2);
    allTones = [nonOutliers(1:(pos - 1)) outlierData(1) nonOutliers(pos:end)];
    toneVectors = midiTones(allTones + meanTone, :);


   
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
    Screen('DrawText', window, msg1, center(1) - 250, center(2) - 25);
    Screen('DrawText', window, msg2, center(1) - 250, center(2));
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
subjectData{4} = counterbalancing;
cd(['./Participant_Data/', subjectData{1}{1}]);
save('subjectData');
cd ..
