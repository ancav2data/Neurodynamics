%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Or use the routine below to make a comodulogram using ModIndex_v1; this takes longer than
%% the method outlined above using ModIndex_v2 because in this routine multiple filtering of the same
%% frequency range is employed (the Amp frequencies are filtered multiple times, one
%% for each phase frequency). This routine might be the only choice though
%% for computers with low memory, because it does not create the matrices
%% AmpFreqTransformed and PhaseFreqTransformed as the routine above

tic

% Already defined above    RL
% PhaseFreqVector=2:2:50;
% AmpFreqVector=10:5:200;
% 
% PhaseFreq_BandWidth=4;
% AmpFreq_BandWidth=10;

Comodulogram=zeros(length(PhaseFreqVector),length(AmpFreqVector));

counter1=0;
for Pf1=PhaseFreqVector
    counter1=counter1+1;
    Pf1 % just to check the progress
    Pf2=Pf1+PhaseFreq_BandWidth;
    
    counter2=0;
    for Af1=AmpFreqVector
        counter2=counter2+1;
        Af2=Af1+AmpFreq_BandWidth;
        
[MI,MeanAmp]=ModIndex_v1(lfp,srate,Pf1,Pf2,Af1,Af2);

Comodulogram(counter1,counter2)=MI;


    end
    
end

toc

%%

clf
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram',30,'lines','none')
set(gca,'fontsize',14)
ylabel('Amplitude Frequency (Hz)')
xlabel('Phase Frequency (Hz)')
colorbar

