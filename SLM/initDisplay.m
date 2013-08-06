function initDisplay(AI,x,X,dBA,Fs,C)

% INITDISPLAY Initializes SLM figure window.
%    INITDISPLAY Creates display window for
%    the sound level meter (SLM) program.
%
% Author: Douglas R. Lanman, 11/21/05

% Create figure window.
figWindow = figure(1); clf;
set(gcf,'Name','Sound Level Meter');
set(gcf,'NumberTitle','off','MenuBar','none');

% Determine FFT frequencies.
f = (Fs/length(x))*[0:(length(X)-1)];

% Plot FFT magnitude.
subplot(2,1,1);
fftPlot = plot(f,X);
title('A-weighted Frequency Magnitude Spectrum');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
xlim([0 Fs/2]); ylim([-100 60]);
grid on;

% Plot data window.
subplot(2,2,3);
samplePlot = plot([1:length(x)],x);
title('Input Data');
xlabel('Sample Index');
ylabel('Input Voltage');
axis([0 length(x) -1 1]);
grid on;

% Convert dBA estimate to string.
dBA_str = sprintf('%5.1f%s',dBA,' dBA');

% Plot current dBA estimate.
subplot(2,2,4); axis off;
dBA_text = text(1.0,0.5,dBA_str,...
    'FontSize',38,'HorizontalAlignment','Right');

% Create start/stop pushbutton.
uiButton = uicontrol('Style','pushbutton',...
   'Units', 'normalized',...
   'Position',[0.0150 0.0111 0.1 0.0556],...
   'Value',1,'String','Stop',...
   'Callback',@stopSoundCard);

% Store global variables in figure data field.
% Note: This is used to pass variables between functions.
figData.figureWindow = figWindow;
figData.uiButton     = uiButton;
figData.samplePlot   = samplePlot;
figData.fftPlot      = fftPlot;
figData.dBA_text     = dBA_text;
figData.AI           = AI;
figData.C            = C;
set(gcf,'UserData',figData);
set(AI,'UserData',figData);