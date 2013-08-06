function analyzeSignal(x,Fs)

% ANALYZESIGNAL Evaluates dBA level of input signal.
%    ANALYZESIGNAL Uses a sliding window to evaluate the
%    signal level (in dBA). Results are graphed for 
%    comparison to known dBA level values.
%
% Author: Douglas R. Lanman, 11/22/05

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set analysis options.

% Choose response type.
% Note: {'fast' = ~125 ms, 'slow' = ~1.0 s}
responseType = 'slow';

% Set calibration constant.
% Note: A quite location will be ~55 dBA.
C = 72;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part I: Analyze input signal.

% Load default wave sound file (if none provided).
% See: http://www.swarthmore.edu/NatSci/sciproject/noise/noisequant.html
if ~exist('x')
   [x,Fs,nBits] = wavread('./examples/trashtruck.wav');
   t = (1/Fs)*[0:(length(x)-1)]; t = t+81;
else
   % Determine sample times.
   t = (1/Fs)*[0:(length(x)-1)];
end

% Determine FFT window size.
% Note: Use nearest power of two for response type.
if strcmp(responseType,'slow')
   duration = 1.0;
else
   duration = 0.125;
end
N = ceil(duration*Fs);
N = 2^nextpow2(N);

% Estimate signal level (within each windowed segment).
windowStart = [1:N:(length(x)-N)];
dBA = zeros(length(windowStart),1);
windowTime = t(windowStart+round((N-1)/2));
for i = [1:length(windowStart)]
   [X,dBA(i)] = estimateLevel(x(windowStart(i)-1+[1:N]),Fs,C);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part II: Plot results.

% Plot input signal.
figure(2); clf;
plot(t,x);
title('Input Signal');
xlabel('Elapsed Time (sec.)');
ylabel('Normalized Voltage');
xlim([t(1) t(end)]);
grid on;

% Plot estimated signal level.
figure(3); clf;
plot(windowTime,dBA,'LineWidth',2);
title('A-weighted Signal Level');
xlabel('Elapsed Time (sec.)');
ylabel('Signal Level (dBA)');
xlim([t(1) t(end)]);
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%