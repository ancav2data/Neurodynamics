% Markus Hilscher
% Basket_cell.m
% Model of a fast-spiking interneuron

clear;
tic

%% User Input
EndOfSimulation = 700; % Simulation time in ms
dt = 0.05;             % step for Euler
phi = 3.33;            % Wang and Buszaki (1996) show phi = 5, 3.33 and 2 
                       % smaller phi -> IK is slower, AHP amplitude more negative
Stimulus = 0.25;       % Wang and Buszaki (1996) show Stimulus = 1, 1.2 and 1.4 uA/cm^2
Starttime = 100;       % starting time of the stimulus in ms
Endtime = 600;         % ending time of the stimulus in ms
V = -64;               % membrane voltage at the beginning in mV
Isyn = 0;              % synaptic current in uA/cm^2

%% Constants
ENa = 55;              % reversal potential of the Na+ current in mV
EK = -90;              % reversal potential of the K+ current in mV
EL = -65;              % reversal potential of the leak current in mV

gNa = 35;              % conductance of the Na+ current in mS/cm^2
gK = 9;                % conductance of the K+ current in mS/cm^2
gL = 0.1;              % conductance of the leak current in mS/cm^2

Cmem = 1;              % membrane capacitance density in uF/cm^2

xh = 0;                % inactivation variable h
xn = 0;                % activation variable n
xs = 0;                % gating variable s of open synaptic ion channels

gsyn = 0;              % synaptic conductance in mS/cm^2
value = load( 'Basket.dat' ) / 10000; % load weights for the synapse
cntAMP = 999;          % counter for the ampitude
spkCNT = 1;            % counter for file reading
Isynpost = 0;          % post synaptic current density in uA/cm^2

t_rec = 0;
x_plot = zeros(1,EndOfSimulation/dt+1);
y_plot = zeros(1,EndOfSimulation/dt+1);
y_plot_syn = zeros(1,EndOfSimulation/dt+1);

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

    alpham = -0.1*(V+35)/(exp(-0.1*(V+35))-1);    % alpha m
    alphah = 0.07*exp(-(V+58)/20);                % alpha h
    alphan = -0.01*(V+34)/(exp(-0.1*(V+34))-1);   % alpha n

    betam = 4*exp(-(V+60)/18);                    % beta m
    betah = 1/(exp(-0.1*(V+28))+1);               % beta h
    betan = 0.125*exp(-(V+44)/80);                % beta n

    taum = 1/(alpham+betam);                      % taum
    x_0m = alpham*taum;                           % minf

    xh = xh + dt* phi*(alphah*(1-xh) - betah*xh); % dh/dt
    xn = xn + dt* phi*(alphan*(1-xn) - betan*xn); % dn/dt  

    INa = gNa*x_0m^3*xh*(V-ENa);                  % Na+ current
    IK = gK*xn^4*(V-EK);                          % K+ current
    IL = gL*(V-EL);                               % leak current

    Iion = INa + IK + IL;                         % ionic current
        
    V = V + dt*(-Iion -Isyn + Iapp) / Cmem;       % membrane voltage         

    Vpre = V;
    
    [ Isynpost, xs ] = Basket_syn(Vpre, dt, xs);  % calculates the synaptic current
    % [ Isynpost, gsyn, cntAMP, spkCNT ] = Basket_syn_dat( Vpre, dt, gsyn, value, cntAMP, spkCNT ); 
    % calculates the synaptic current with lookup table
    
    t_rec = t_rec+1;
    x_plot(t_rec) = t;
    y_plot(t_rec) = V;
    y_plot_syn(t_rec) = -Isynpost;
    
end

toc

%% Plotting
figure()
set(gcf,'color','white')
set(gca,'fontsize',14)
cell = plot(x_plot,y_plot,'b');
legend('cell',2);
hold on;
y_plot_stim(1:Starttime/dt) = -80;
y_plot_stim(Starttime/dt+1:Endtime/dt+1) = -78;
y_plot_stim(Endtime/dt+2:EndOfSimulation/dt+1) = -80;
stimulus = plot(x_plot,y_plot_stim,'--k');
hold off;
legend([cell,stimulus],'cell','stimulus',2);
axis([0 EndOfSimulation -90 50]);
xlabel('Time (ms)');
ylabel('Voltage (mV)');

figure()
set(gcf,'color','white')
set(gca,'fontsize',14)
synapse = plot(x_plot,y_plot_syn,'b');
legend(synapse,'synapse',2);
axis([0 EndOfSimulation -2.5 0.5]);
xlabel('Time (ms)');
ylabel('Current density (\muA/cm^2)');
