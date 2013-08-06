function SLM

% SLM Implements a basic sound level meter.
%    SLM Uses the Data Acquisition Toolbox to estimate
%    the windowed FFT of the microphone input signal.
%    A-weighting is applied to the frequency spectrum
%    to measure sound level in dBA. Results are
%    displayed in real-time for fast/slow responses.
%
% Author: Douglas R. Lanman, 11/21/05

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set sound level meter (SLM) options.

% Set sampling rate (in Hz).
% Typical rates: {8.000, 11.025, 22.050, 44.100} kHz
Fs = 44.1e3;

% Choose response type.
% Note: {'fast' = ~125 ms, 'slow' = ~1.0 s}
responseType = 'fast';

% Set calibration constant.
% Note: A quite location will be ~55 dBA.
C = 50;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reset Matlab display.
clc;

% Initialize sound card acquisition.
[AI,Fs,N] = initSoundCard(Fs,responseType);

% Process initial sound card sample.
x = getdata(AI);
[X,dBA] = estimateLevel(x,Fs,C);

% Initialize display window.
initDisplay(AI,x,X,dBA,Fs,C);

% Start real-time data acquisition.
set(AI,'TimerFcn',@updateDisplay);