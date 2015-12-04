IntFName='Animal_M5_90minAfter_salina_151123_220400.int';
[t,amps,y,aux] = read_intan_data_leao(IntFName);

%%
data1000=double(y(:,1:25:end));
for ii=1:16
    [p(:,ii)  f]=pwelch(detrend(data1000(ii,:)),4000,3000,2^17,1000);
    subplot(4,4,ii), plot(f,p(:,ii))
    xlim([3 12])
end

%%

for ii=1:16
    tt2(ii,:) = eegfilt(data1000(ii,:),1000,4.5,6);
    tt1(ii,:) = eegfilt(data1000(ii,:),1000,7,9);
end

%%
figure(1)

for ii=1:16
    subplot(4,4,ii), plot(f,p(:,ii))
    xlim([2 12])
    title(['Channel ',int2str(ii)])
end

%%
t1Ch=2;
t2Ch=4;

Xt1=hilbert(tt1(t1Ch,:));
Xt2=hilbert(tt2(t2Ch,:));

subplot(2,1,1),plot(abs(Xt1))
subplot(2,1,2),plot(abs(Xt2))