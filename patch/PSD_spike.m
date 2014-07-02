function [f,p,tspk]=PSD_spike(t)

t=round(t);

tspk=zeros(t(end)+1,1);

tspk(t)=1;

[p,f]=pwelch(detrend(tspk),2000,1000,2^17,1000);