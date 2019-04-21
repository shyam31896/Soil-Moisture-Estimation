clc
close all
r = [];
snrdb = [];
sm = [];
count = 1;
disp('Please place the Receiver on the top tray');
disp('Count value Reference:');
disp('1: LOS Signal (Top Tray)');
disp('2:Reflected Signal (Bottom Tray)');
ch1=input('Enter the correct Count Value:');
if ch1 == 1
    % Discover Radio
    connectedRadios = findsdru;
    if strncmp(connectedRadios(1).Status, 'Success', 7)
        radioFound = true;
        platform = connectedRadios(1).Platform;
        switch connectedRadios(1).Platform
            case {'B200','B210'}
                address = connectedRadios(1).SerialNum;
            case {'N200/N210/USRP2','X300','X310'}
                address = connectedRadios(1).IPAddress;
        end
    else
        radioFound = false;
        address = '192.168.10.2';
        platform = 'N200/N210/USRP2';
    end
    
    % Initialization
    
    fmRxParams = getParamsSdruFMExample(platform)
    
    % Configuration of Receiver Object
    
    switch platform
        case {'B200','B210'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'SerialNum', address, ...
                'MasterClockRate', fmRxParams.RadioMasterClockRate);
        case {'X300','X310'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'IPAddress', address, ...
                'MasterClockRate', fmRxParams.RadioMasterClockRate);
        case {'N200/N210/USRP2'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'IPAddress', address);
    end
    
    %
    radio.CenterFrequency  = 1575.42e6;
    radio.Gain = fmRxParams.RadioGain;
    radio.DecimationFactor = fmRxParams.RadioDecimationFactor;
    radio.FrameLength = fmRxParams.RadioFrameLength;
    radio.OutputDataType = 'single'
    
    %
    hwInfo = info(radio)
    
    % FM Demodulation
    scope = dsp.SpectrumAnalyzer('SampleRate',fmRxParams.RadioSampleRate);
    fmBroadcastDemod = comm.FMBroadcastDemodulator(...
        'SampleRate', fmRxParams.RadioSampleRate, ...
        'FrequencyDeviation', fmRxParams.FrequencyDeviation, ...
        'FilterTimeConstant', fmRxParams.FilterTimeConstant, ...
        'AudioSampleRate', fmRxParams.AudioSampleRate, ...
        'PlaySound', true, ...
        'BufferSize', fmRxParams.BufferSize, ...
        'Stereo', true);
    
    % Stream Processing Loop
    % Check for the status of the USRP(R) radio
    if radioFound
        % Loop until the example reaches the target stop time, which is 10
        % seconds.
        timeCounter = 0;
        show(scope)
        while timeCounter < fmRxParams.StopTime
            [x, len] = step(radio);
            if len > 0
                % FM demodulation
                step(fmBroadcastDemod, x);
                % Update counter
                timeCounter = timeCounter + fmRxParams.AudioFrameTime;
                step(scope,x)
            end
            
        end
        release(scope)
    else
        warning(message('sdru:sysobjdemos:MainLoop'))
    end
    x1 = real(x);
    r(count) = (mean(x1)/std(x1));
    snrdb(count) = 10*log(abs(r(count)));
    count = count+1;
    
    release(fmBroadcastDemod)
    release(radio)
end  

disp('Please place the Receiver on the bottom tray');
disp('Count value Reference:');
disp('1: LOS Signal (Top Tray)');
disp('2:Reflected Signal (Bottom Tray)');
ch2 = input('Enter the correct Count Value:');
if ch2 == 2
    % Discover Radio
    connectedRadios = findsdru;
    if strncmp(connectedRadios(1).Status, 'Success', 7)
        radioFound = true;
        platform = connectedRadios(1).Platform;
        switch connectedRadios(1).Platform
            case {'B200','B210'}
                address = connectedRadios(1).SerialNum;
            case {'N200/N210/USRP2','X300','X310'}
                address = connectedRadios(1).IPAddress;
        end
    else
        radioFound = false;
        address = '192.168.10.2';
        platform = 'N200/N210/USRP2';
    end
    
    % Initialization
    
    fmRxParams = getParamsSdruFMExample(platform)
    
    % Configuration of Receiver Object
    
    switch platform
        case {'B200','B210'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'SerialNum', address, ...
                'MasterClockRate', fmRxParams.RadioMasterClockRate);
        case {'X300','X310'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'IPAddress', address, ...
                'MasterClockRate', fmRxParams.RadioMasterClockRate);
        case {'N200/N210/USRP2'}
            radio = comm.SDRuReceiver(...
                'Platform', platform, ...
                'IPAddress', address);
    end
    
    %
    radio.CenterFrequency  = 1575.42e6;
    radio.Gain = fmRxParams.RadioGain;
    radio.DecimationFactor = fmRxParams.RadioDecimationFactor;
    radio.FrameLength = fmRxParams.RadioFrameLength;
    radio.OutputDataType = 'single'
    
    %
    hwInfo = info(radio)
    
    % FM Demodulation
    scope = dsp.SpectrumAnalyzer('SampleRate',fmRxParams.RadioSampleRate);
    fmBroadcastDemod = comm.FMBroadcastDemodulator(...
        'SampleRate', fmRxParams.RadioSampleRate, ...
        'FrequencyDeviation', fmRxParams.FrequencyDeviation, ...
        'FilterTimeConstant', fmRxParams.FilterTimeConstant, ...
        'AudioSampleRate', fmRxParams.AudioSampleRate, ...
        'PlaySound', true, ...
        'BufferSize', fmRxParams.BufferSize, ...
        'Stereo', true);
    
    % Stream Processing Loop
    % Check for the status of the USRP(R) radio
    if radioFound
        % Loop until the example reaches the target stop time, which is 10
        % seconds.
        timeCounter = 0;
        show(scope)
        while timeCounter < fmRxParams.StopTime
            [x, len] = step(radio);
            if len > 0
                % FM demodulation
                step(fmBroadcastDemod, x);
                % Update counter
                timeCounter = timeCounter + fmRxParams.AudioFrameTime;
                step(scope,x)
            end
            
        end
        release(scope)
    else
        warning(message('sdru:sysobjdemos:MainLoop'))
    end
    x2 = real(x);
    r(count) = (mean(x2)/std(x2));
    snrdb(count) = 10*log(abs(r(count)));
    
    clear count;
    release(fmBroadcastDemod)
    release(radio)
end

A = 1;
H0 = 2;
theta = 30;
lambda = (3*100000000)/(radio.CenterFrequency);
if r(1) > r(2)
    diff = r(1)-r(2);
else
    diff = r(2)-r(1);
end
if snrdb(1) > snrdb(2)
    diffsnr = snrdb(1)-snrdb(2);
else
    diffsnr = snrdb(2)-snrdb(1);
end
phi = acosd(diff/A)-((4*pi*H0/lambda)*sind(theta));
text1 = ['The LOS Signal SNR is ', num2str(snrdb(1)),'db and the Received Signal SNR is ', num2str(snrdb(2)),'db'];
disp(text1);
text2 = ['The Phase Difference calculated from the difference SNR is ', num2str(phi),'o'];
disp(text2);
load moisture.mat
for i = 1:length(moisttable)
    if phi > moisttable(i,1) && phi < moisttable(i+1,1)
        k = i;
        sm = moisttable(k,2);
    end
end
text3 = ['The Corresponding Volumetric Soil Moisture to the Phase Difference is ',num2str(sm),'vol(m3)/ vol(m3)'];
disp(text3);
ch3 = input('Do you want to add the Soil Moisture Value into a Matrix File: (Yes --> 1 ; No --> 2)');
if ch3 == 1
    ch4 = input('Do you want to create or update the file: (Create --> 1 ; Update --> 2)');
    if ch4 == 1
        load count.mat;
        c1=1;
        save count.mat c1;
        delete volsoilmoist.mat;
    else
        load count.mat;
        c1=c1+1;
        save count.mat c1;
        load volsoilmoist.mat;
    end
    volsoilmoist(c1,1) = phi;
    volsoilmoist(c1,2) = sm;
    save volsoilmoist.mat volsoilmoist;
    disp('                                   Values');
    disp('                                            Saved....!!!');
end