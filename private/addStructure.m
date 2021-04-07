function stimuli = addStructure(STIMULI_AUDIO, stimuli, run)
    nSentences = 54;
    fixationDuration = 12;
    nFixations = 3;

    stimuli.NUM_STIMULI = nSentences;
    stimuli.fixationDuration = fixationDuration;
    stimuli.Trial = cell(nSentences + nFixations, 1);
    stimuli.NUM_TRIALS = nSentences + nFixations;
    # TODO:
    # depending on session and run, we populate stimuli.AudioFile with full path to each file
    # add functionality for fixation trials

end
