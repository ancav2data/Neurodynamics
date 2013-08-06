function [AI,Fs,N] = initSoundCard(Fs,responseType)

% INITSOUNDCARD Initializes the sound card.
%    INITSOUNDCARD is used by SLM to initialize
%    real-time data acquisition from the sound
%    card. The analog input device is returned.
%
% Author: Douglas R. Lanman, 11/21/05

% Create an analog input object for the sound card.
AI = analoginput('winsound');
channel = addchannel(AI,1);

% Set sampling rate.
% Note: Use closest rate supported by hardware.
set(AI,'SampleRate',Fs);
Fs = get(AI,'SampleRate');

% Determine FFT window size.
% Note: Use nearest power of two for response type.
if strcmp(responseType,'slow')
   duration = 1.0;
else
   duration = 0.125;
end
N = ceil(duration*Fs);
N = 2^nextpow2(N);

% Set samples per trigger.
% Note: Use closest length supported by hardware.
set(AI,'SamplesPerTrigger',N);
N = get(AI,'SamplesPerTrigger');

% Set acquisition options.
set(AI,'TriggerType','Manual');
set(AI,'TriggerRepeat',1);
set(AI,'TimerPeriod',duration/4);

% Begin acquisition.
start(AI); trigger(AI);