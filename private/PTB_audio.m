function stimuli = PTB_audio(HOME, list)

    PsychPortAudio('Close');
    PsychPortAudio('DeleteBuffer', [], 1); %delete all buffers
    InitializePsychSound;

    stimuli = struct();
    stimuli = addStructure(HOME, stimuli, list);

    sampleRate = 44100;
    numChannels = 2;
    stimuli.pahandle = PsychPortAudio('Open', [], [], 0, sampleRate, numChannels);

    for i = 1 : stimuli.NUM_STIMULI
        file = stimuli.AudioFile{i};
        [y, sample] = audioread(file);
        channels = size(y, 2); % Number of rows == number of channels
        if sampleRate ~= sample
            y = resample(y, sampleRate, sample);
        end
        
        if numChannels ~= channels
            y = repmat(y, 1, numChannels);
        end
        stimuli.buffers(i) = PsychPortAudio('CreateBuffer', [], y');
    end
end
