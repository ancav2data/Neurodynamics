function runCalibration

% RUNCALIBRATION Estimates the calibration constant.
%    RUNCALIBRATION Generates several test tones to
%    verify the sound level meter implementation.
%    Several test tones are used to verify the FFT
%    display, as well as estimate the appropriate
%    calibration constant.
%
% Author: Douglas R. Lanman, 11/29/05

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set calibaration parameters.

% Set sampling rate for test signals.
% Typical rates: {8.000, 11.025, 22.050, 44.100} kHz
Fs = 44.1e3; 

% Set test tone durations (in seconds).
dT = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part I: Test FFT (Frequency Spectrum).

% Determine sample times.
t = (1/Fs)*[1:round(dT*Fs)];

% Generate 1000 Hz test tone.
fc = 1000; A = 0.5;
y = sin(2*pi*fc*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;

% Generate 2000 Hz test tone.
fc = 2000; A = 0.25;
y = sin(2*pi*fc*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part II: Determine/Verify Calibaration Constant.

% Generate white noise test signal #1.
fc = (Fs/2)*rand(size(t)); A  = 0.1;
y = sin(2*pi*fc.*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;

% Generate white noise test signal #2.
fc = (Fs/2)*rand(size(t)); A  = 0.2;
y = sin(2*pi*fc.*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;

% Generate white noise test signal #3.
fc = (Fs/2)*rand(size(t)); A  = 0.4;
y = sin(2*pi*fc.*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;

% Generate white noise test signal #4.
fc = (Fs/2)*rand(size(t)); A  = 1.0;
y = sin(2*pi*fc.*t); sound(A*y,Fs); 
disp('Press any key to continue.'); pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%