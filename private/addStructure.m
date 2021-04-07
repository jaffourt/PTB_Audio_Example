function stimuli = addStructure(STIMULI_AUDIO, stimuli, run)
    nSentences = 54;
    fixationDuration = 12;
    stimuli.NUM_STIMULI = nSentences;
    stimuli.fixationDuration = fixationDuration;

    # TODO:
    # depending on session and run, we populate stimuli.AudioFile with full path to each file
    # add functionality for fixation trials

end
