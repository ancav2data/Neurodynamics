function [ ThetaPeaks, DeltaPeaks ] = ThetaPSD( data, L_pre, L_on, L_pos, srate )
% Plots 16 panels with and without light and calculates the peak in theta
% and delta
% Usage:
% [ ThetaPeaks, DeltaTheta ] = ThetaPSD(data, L_pre, L_on, L_pos, srate);
% data is the 16ch matrix, samples in rows
% L_On is the time for the first trace in seconds [Start End]
% L_Off is the time for the second trace in seconds[Start End]
% srate is the sampling rate

t1=[round(L_pre(1)*srate) round(L_pre(2)*srate)];
t2=[round(L_on(1)*srate) round(L_on(2)*srate)];
t3=[round(L_pos(1)*srate) round(L_pos(2)*srate)];

dp=[0 2.8];
tp=[2.8 12];
for ii=1:16
    [p f]=pwelch(data(t1(1):t1(2),ii),[4*srate],[1.9*srate],[2^14],srate);
    subplot(4,4,ii),plot(f,p,'k')
    ThetaPeaks(ii,1) = max(p(find(f>tp(1) & f<tp(2))));
    DeltaPeaks(ii,1) = max(p(find(f>dp(1) & f<dp(2))));
    hold on
    
    [p f]=pwelch(data(t2(1):t2(2),ii),[4*srate],[1.9*srate],[2^14],srate);
    subplot(4,4,ii),plot(f,p,'r')
    ThetaPeaks(ii,2) = max(p(find(f>tp(1) & f<tp(2))));
    DeltaPeaks(ii,2) = max(p(find(f>dp(1) & f<dp(2))));
    
    [p f]=pwelch(data(t3(1):t3(2),ii),[4*srate],[1.9*srate],[2^14],srate);
    subplot(4,4,ii),plot(f,p,'g')
    ThetaPeaks(ii,3) = max(p(find(f>tp(1) & f<tp(2))));
    DeltaPeaks(ii,3) = max(p(find(f>dp(1) & f<dp(2))));
    
    hold off
    
    xlim([0 20])
end