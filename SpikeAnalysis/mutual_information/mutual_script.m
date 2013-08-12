
clear;

train1 = [1 0 0 1 0 1 1 1 0];
train2 = [0 0 0 1 0 0 1 0 1];

figure()
plot(train1,'g')
hold on;
plot(train2,'b')
hold off;
ylim([-1 2])

P1 = [];
P2 = [];
mutualInformation = [];

spiketimes1=train1;
spiketimes2=train2;

    i=0;
    for dt=0:0
        i=i+1;
        P_1_2=getBivarDist(spiketimes1,spiketimes2,dt);
        P_1=getUnivarDist(spiketimes1);
        P_2=getUnivarDist(spiketimes2);
        entropy_sigA=getEntropy(P_1);
        entropy_sigB=getEntropy(P_2);
        entropy_sigA_sigB=getEntropy(P_1_2);
        mutualInformation=mutualinfo(spiketimes1,spiketimes2,dt);
    end
    
    P1 = [P1;entropy_sigA];
    P2 = [P2;entropy_sigB];

disp(mutualInformation);








