% Markus Hilscher
% Pyr.m
% Model of a pyramidal cell

clear;
tic

%% User Input
EndOfSimulation = 700; % Simulation time in ms
dt = 0.01;             % step for Euler
Stimulus = 1;          % stimulus in uA/cm^2
Starttime = 100;       % starting time of the stimulus in ms
Endtime = 600;         % ending time of the stimulus in ms
V = -64;               % membrane voltage at the beginning in mV
Isyn = 0;              % synaptic current in uA/cm^2

%% Constants
ENa = 50;              % reversal potential of the Na+ current in mV
EK = -100;             % reversal potential of the K+ current in mV
EL = -67;              % reversal potential of the leak current in mV

gNa = 100;             % conductance of the Na+ current in mS/cm^2
gK = 80;               % conductance of the K+ current in mS/cm^2
gL = 0.1;              % conductance of the leak current in mS/cm^2

Cmem = 1;              % membrane capacitance density in uF/cm^2

xh = 0;                % inactivation variable h
xn = 0;                % activation variable n

t_rec = 0;
x_plot = zeros(1,EndOfSimulation/dt+1);
y_plot = zeros(1,EndOfSimulation/dt+1);

%% Program
for t=0:dt:EndOfSimulation
 
    if t>=Starttime; 
        Iapp = Stimulus; 
    else
        Iapp = 0; 
    end
    if t>Endtime; 
        Iapp = 0; 
    end     

    alpham = 0.32*(V+54)/(1-exp(-(V+54)/4));  % alpha m
    alphah = 0.128*exp(-(V+50)/18);           % alpha h
    alphan = 0.032*(V+52)/(1-exp(-(V+52)/5)); % alpha n

    betam = 0.28*(V+27)/(exp((V+27)/5)-1);    % beta m
    betah = 4/(1+exp(-(V+27)/5));             % beta h
    betan = 0.5*exp(-(V+57)/40);              % beta n

    taum = 1/(alpham+betam);                  % taum
    x_0m = alpham*taum;                       % minf

    xh = xh + dt* (alphah*(1-xh) - betah*xh); % dh/dt
    xn = xn + dt* (alphan*(1-xn) - betan*xn); % dn/dt  

    INa = gNa*x_0m^3*xh*(V-ENa);              % Na+ current
    IK = gK*xn^4*(V-EK);                      % K+ current
    IL = gL*(V-EL);                           % leak current

    Iion = INa + IK + IL;                     % ionic current

    V = V+dt*(-Iion -Isyn + Iapp) / Cmem;     % membrane voltage         

    t_rec = t_rec+1;
    x_plot(t_rec) = t;
    y_plot(t_rec) = V;
    
end

toc

%% Plotting
figure()
set(gcf,'color','white')
set(gca,'fontsize',14)
cell = plot(x_plot,y_plot,'r');
legend('cell',2);
hold on;
y_plot_stim(1:Starttime/dt) = -105;
y_plot_stim(Starttime/dt+1:Endtime/dt+1) = -103;
y_plot_stim(Endtime/dt+2:EndOfSimulation/dt+1) = -105;
stimulus = plot(x_plot,y_plot_stim,'--k');
hold off;
legend([cell,stimulus],'cell','stimulus',2);
axis([0 EndOfSimulation -115 60]);
xlabel('Time (ms)');
ylabel('Voltage (mV)');