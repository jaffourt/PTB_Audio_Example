function stimuli = addStructure(HOME, stimuli, list)
    nSentences = 56;
    fixationDuration = 12;
    nFixations = 3;
    fixationIndices = [29]; % array if needed

    stimuli.NUM_STIMULI = nSentences;
    stimuli.fixationDuration = fixationDuration;
    stimuli.NUM_TRIALS = nSentences + nFixations;
    
    % TODO:
    % depending on session and run, we populate stimuli.AudioFile with full path to each file
    % add functionality for fixation trials
    
    data = readtable(fullfile(HOME, 'stimuli_orders.csv'));
    data = data(data.list == list, :);
    
    stimuli.AudioFile = fullfile(HOME, 'stimuli', data.filename);
    trials = ['FIXATION'; data.condition; 'FIXATION'];
    
    for idx = fixationIndices % iterate for situations of more than 1
        trials = [trials(1:idx); 'FIXATION'; trials(idx+1:end)];
    end
    
    stimuli.Trial = trials;
end
