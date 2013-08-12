function P_out=getUnivarDist(signal)

minNum=min(signal);
if minNum<1
   signal=signal-minNum+1;
end

% output range
K=max(signal);

P_out=zeros(1,K);

% signal length
sig_length=length(signal);

for t=1:sig_length
    i=signal(t);
    P_out(i)=P_out(i)+1;
end

P_out= P_out/sig_length;
