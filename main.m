%%%
% This experiment plays audio of spoken sentences or nonword, waiting for
% a space bar press to continue to the next sentence.

% There are four lists. Each participant should do all four lists, 1 run
% each.
% With quick presses of the spacebar, each list is under 4 minutes. It will
% take ~16 minutes at least to run all 4 lists.

% Modified by Hannah Small for use in U01 experiments
% January 6, 2021

%ABOUT THESE INPUTS
%subjID -   string, should match across all runs for a given participant
%list -      1,2,3, or 4: indicates the particular run of the set we are
%           currently on, ideally, we want 1 run of every set of materials


function U01_Expt6_ANNsentSET1(subjID, run)

HOME=fileparts(mfilename('fullpath'))
PsychDefaultSetup(2);

%% Initialize Window %%
oldLevel = Screen('Preference', 'Verbosity', 0);
java; %clear java cache
AssertOpenGL;
Screen('Preference', 'VisualDebugLevel',    0);
Screen('Preference', 'SuppressAllWarnings', 1);
Screen('Preference', 'TextRenderer',        0);
Screen('Preference', 'SkipSyncTests',       1);
Screen('CloseAll')
screensAll = Screen('Screens'); %Get the screen numbers
screenNumber = max(screensAll); % Which screen you want to use. "1" is external monitor, "0" is this screen. use external if it is present
[windowPtr, ~]=PsychImaging('OpenWindow',screenNumber, [0 0 0]); %, [0 0 1440 900]
[~, screenYpixels] = Screen('WindowSize', windowPtr);
% Get the centre coordinate of the window
priorityLevel = MaxPriority(windowPtr);
Priority(priorityLevel);

%% Initialize sound driver and load stimuli %%
InitializePsychSound;
stimuliStruct = PTB_audio(run);

%% Begin waiting for scanner %%
DrawFormattedText(windowPtr, "+", 'center', 'center', 0);
Screen('Flip', windowPtr);
WaitSecs(0.5); %some buffer time for key press to work

%% Begin waiting for scanner %%
KbName('UnifyKeyNames');
trigger_key = [KbName('+=')];
trigger_response_keys = [KbName('1!'), KbName('2@')];
escapeKey = KbName('ESCAPE');
HideCursor;
while 1
    [keyIsDown, sec, keyCode] = KbCheck(-3);
    if keyCode(escapeKey)
        Screen('CloseAll');
        fprintf('Experiment quit by pressing ESCAPE\n');
        return;
    elseif ismember(find(keyCode,1), trigger_key)
        break;
    end
    WaitSecs(0.001);
end

%% Initialize output table %%
outputPath = fullfile(HOME, 'output', sprintf('ANNsent_%s_run%d.csv',subjID, run));
outputTable=table();
outputTable.Subject = cell(stimuliStruct.NUM_TRIALS,1);
outputTable.Subject(:,1) = subjID;
outputTable.Run = cell(stimuliStruct.NUM_TRIALS,1);
outputTable.Run(:,1) = run;
outputTable.TrialOnset = zeros(stimuliStruct.NUM_TRIALS,1);
outputTable.AudioStart = zeros(stimuliStruct.NUM_TRIALS,1);
outputTable.Condition = stimuliStruct.Trial;
outputTable.File = cell(stimuliStruct.NUM_TRIALS,1);

%% Experiment %%
startTime = GetSecs();
stimIter = 1;
for j = 1 : stimuliStruct.NUM_TRIALS

    outputTable.TrialOnset(j) = GetSecs() - startTime; % Save the onset time of the trial

    if strcmp(stimuliStruct.Trial{i},'FIXATION')
        waitWithFixation(stimuliStruct.fixationDuration, windowPtr);
        outputTable.AudioStart(j) = 'NaN';
        outputTable.File(j) = 'NaN';
    else

        % grey screen
        Screen(windowPtr, 'Flip');

        % PLAY AUDIO
        PsychPortAudio('FillBuffer', pahandle, stimuliStruct.buffers(stimIter));
        PsychPortAudio('Start', stimuliStruct.pahandle, 1, 0, 1);


        % while the audio plays, now is a good time to save whatever output we have
        % and do a few quick computations
        outputTable.AudioStart(j) = PsychPortAudio('GetStatus', stimuliStruct.pahandle).StartTime - startTime;
        outputTable.File(j) = stimuli.AudioFile(stimIter);
        stimIter = stimIter + 1;
        writetable(outputTable, outputPath)

        % wait for audio to finish
        while 1
            if PsychPortAudio('GetStatus', pahandle).Active == 0
                break;
            else
                WaitSecs(0.005);
            end
        end

        % 4 second fixation, regardless of audio duration (?)
        waitWithFixation(4, windowPtr);
end

PsychPortAudio('Close');
ShowCursor;
Screen('CloseAll');

%clear the keyboard
KbQueueRelease();
KbReleaseWait();

end

function waitWithFixation(seconds, windowPtr)
    % made this a function to allow for customization
    DrawFormattedText(windowPtr, '+', 'center', 'center', 0);
    Screen(windowPtr, 'Flip');
    WaitSecs(4);
end


