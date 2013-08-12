function P_out=getBivarDist(signalA,signalB,dt)

% shift range for sequences containing negative values
minNum=min([min(signalA),min(signalB)]);
if minNum<1
   signalA=signalA-minNum+1;
   signalB=signalB-minNum+1;
end

% output range
K=max([max(signalA),max(signalB)]);

P_out=zeros(K);

% signal length
if length(signalA)==length(signalB)
   sig_length=length(signalA)-dt; 
else
   error('Length of sequences must be equal');
end

for t=1:sig_length
    i=signalA(t);
    k=signalB(t+dt);
    P_out(i,k)= P_out(i,k)+1;
end

P_out=P_out/sig_length;
