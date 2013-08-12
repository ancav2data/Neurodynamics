function mutual=mutualinfo(signalA,signalB,dt)

if length(signalA)==length(signalB)
   sig_length=length(signalA); 
else
   error('Length of sequences must be equal');
end

% get distributions
P_sigA_sigB=getBivarDist(signalA,signalB,dt);

signalA=signalA(1:sig_length-dt);
P_sigA=getUnivarDist(signalA);

signalB=signalB(dt+1:sig_length);
P_sigB=getUnivarDist(signalB);

% get entropies
entropy_sigA_sigB=getEntropy(P_sigA_sigB);
entropy_sigA=getEntropy(P_sigA);
entropy_sigB=getEntropy(P_sigB);

% calculating mutual information
mutual = entropy_sigA + entropy_sigB - entropy_sigA_sigB;

% according to definition
if mutual<0
   mutual=0;
end

if mutual>1
   mutual=1;
end


