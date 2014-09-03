muh=daq.createSession('ni');
    muh.addAnalogOutputChannel('Dev1','ao0','Voltage');
    muh.addAnalogOutputChannel('Dev1','ao1','Voltage');
    Rate = 1000;
    muh.Rate=Rate
    
    
    %%
    
    tstim=10;
    stim=zeros(50000,2);
    
    Freq=2;
    
    PulseNo=Freq*tstim;
    
    Period = (1/Freq)*Rate;
    
    Duration = 10;
    
    for ii=1:PulseNo
        
        stim(ii*Period:ii*Period+Duration,1)=4;
        stim(ii*Period:ii*Period+Duration,1)=5;
        
    end