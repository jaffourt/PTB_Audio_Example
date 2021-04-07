function stimuli = PTB_audio(run, HOME)

    stimuli = struct()
    STIMULI_AUDIO = fullfile(HOME, 'stimuli');
    stimuli = addStructure(STIMULI_AUDIO, stimuli, run)
    stimuli._audio_iter = 1;

    sampleRate = 44100;
    numChannels = 2;
    stimuli.pahandle = PsychPortAudio('Open', [], [], 0, sampleRate, numChannels);

    for i = 1 : stimuli.NUM_STIMULI
        file = stimuli.AudioFile(i);
        [y, sample] = audioread(file);
        wavedata = y';
        channels = size(wavedata, 1); % Number of rows == number of channels
        if (sampleRate ~= sample || numChannels ~= channels)
            warning('Assumed a sample rate or a number of channels which was incorrect.')
            fprintf('File: %s, Channels: %d, Sample Rate: %d', file, channels, sample)
        end
        audioDur = length(y)/freq;
        stimuli.buffers(i) = PsychPortAudio('CreateBuffer', [], wavedata);
    end

    return stimuli
end
