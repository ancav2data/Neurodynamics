% Markus Hilscher
% Basket_syn.m
% Model of a fast-spiking interneuron synapse

% function [ Isynpost ] = Basket_syn( Vpre, dt, xs )
% 
% Contains the equations to calculate the synaptic current of a fast-spiking
% interneuron
%
% Input:
%   scalar "Vpre"
%   contains the value of the membrane potential of the simulated cell
%
%   scalar "dt"
%   contains the Euler step
%
%   scalar "xs"
%   contains the value of the gating variable s of open synaptic ion
%   channels from the previous Euler step
%
% Output:
%   scalar "Isynpost"
%   contains the value of the post synaptic current density in uA/cm^2
%
%   scalar "xs"
%   contains the value of the gating variable s of open synaptic ion
%   channels from the actual Euler step

function [ Isynpost, xs ] = Basket_syn( Vpre, dt, xs )

    %% Constants
    Esyn = -75;   % synaptic reversal potential in mV
    gsyn = 0.1;   % synaptic conductance in mS/cm^2
    thetasyn = 0; % mV
    alphas = 12;  % channel opening rate in msec^-1
    betas = 0.1;  % channel closing rate in msec^-1
    Vpost = -64;  % post membrane potential in mV

    %% Program 
    FVpre = 1/(1+exp(-(Vpre-thetasyn)/2));        % transmitter-receptor complex
    xs = xs + dt* (alphas*FVpre*(1-xs)-betas*xs); % ds/dt
    Isynpost = gsyn*xs*(Vpost-Esyn);              % synaptic current at the postsynaptic cell

end