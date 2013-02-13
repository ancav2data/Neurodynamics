function [ ThetaPeaks, DeltaTheta ] = ThetaPSD( data, L_On, L_Off, srate )
% Plots 16 panels with and without light and calculates the peak in theta
% and delta
% Usage:
% [ ThetaPeaks, DeltaTheta ] = ThetaPSD( data, L_On, L_Off, srate );
% data is the 16ch matrix, samples in rows
% L_On is the time for the first trace in seconds [Start End]
% L_Off is the time for the second trace in seconds[Start End]
% srate is the sampling rate

t1=[round(L_on(1)*srate) round(L_on(2)*srate)];
t2=[round(L_off(1)*srate) round(L_off(2)*srate)];

end

