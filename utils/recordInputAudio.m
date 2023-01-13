function recordInputAudio(recordedAudioLocation)
    ar = audiorecorder(44100,16,1);
  
    % Define callbacks to show when
    % recording starts and completes.
    ar.StartFcn = 'disp(''Start speaking.'')';
    ar.StopFcn = 'disp(''End of recording.'')';
    
    recordblocking(ar, 5);

    myQuestion = getaudiodata(ar);
    
    audiowrite(recordedAudioLocation,myQuestion,44100)
