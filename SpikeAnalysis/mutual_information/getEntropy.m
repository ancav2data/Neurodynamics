function entropy=getEntropy(P_array)

EPS=1.0E-08;
K2=size(P_array,2);
K1=size(P_array,1);
K=K1*K2;
P=reshape(P_array,K,1);

% check normalization
Z=sum(P);
if Z<=0
   P_array
   error('Zero sum of probabilities ?')
elseif Z~=1
   P=P/Z;	
end

entropy=0;
for k=1:K
    if P(k)<EPS
	dH=0;
    else
	dH=P(k)*log(P(k));
    end
    entropy=entropy-dH;	
end

% entropy=entropy/(N*log(K));
