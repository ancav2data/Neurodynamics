IntFName='Animal_M1_Salina_60minAfter_151126_210840.int';
[t,amps,y,aux] = read_intan_data_leao(IntFName);

%%
% Calculate PSD for all channels
data1000=double(y(:,1:25:end));
for ii=1:16
    [p(:,ii)  f]=pwelch(detrend(data1000(ii,:)),4000,3000,2^17,1000);
    subplot(4,4,ii), plot(f,p(:,ii))
    xlim([3 12])
end

%%
% Hilbert for 2 thetas all channels
for ii=1:16
    tt2(ii,:) = eegfilt(data1000(ii,:),1000,4,6);
    tt1(ii,:) = eegfilt(data1000(ii,:),1000,7,9);
    Xt1(ii,:)=hilbert(tt1(ii,:));
    Xt2(ii,:)=hilbert(tt2(ii,:));
end

%%
% Plot all PSDs
figure(1)

for ii=1:16
    subplot(4,4,ii), plot(f,p(:,ii))
    xlim([2 12])
    title(['Channel ',int2str(ii)])
end

%%
t1Ch=2;
t2Ch=4;

subplot(2,1,1),plot(abs(Xt1(t1Ch,:)))
title('Theta 1')

subplot(2,1,2),plot(abs(Xt2(t2Ch,:)))
title('Theta 2')

%%
% Calculate distance and speed
FrameRate=15;
CoorFName=[IntFName(1:end-4),'_Coord.mat'];
load(CoorFName);
D(1)=0;
for ii=2:size(Coord,1)
D(ii-1)=sqrt((Coord(ii,1)-Coord(ii-1,1))^2+(Coord(ii,2)-Coord(ii-1,2))^2);
end

V=smooth(abs(diff(D)));
tVideo = (1:size(Coord,1));
tLFP = (1:length(data1000))/1000;

%%
% Correlate theta 1 and 2 with Speed
for ii=1:16
    t1=resample(smooth(abs(Xt1(ii,:)),100),FrameRate,1000);
    LenV=min([length(t1) length(V)]);
    R=corrcoef(t1(1:LenV),V(1:LenV));
    rT1(ii)=R(2,1);
    
    t2=resample(smooth(abs(Xt2(ii,:)),100),FrameRate,1000);
    LenV=min([length(t2) length(V)]);
    R=corrcoef(t2(1:LenV),V(1:LenV));
    rT2(ii)=R(2,1);
end

%%
% Plot PSDs and correlation coefficients
figure(1)

for ii=1:16
    subplot(4,4,ii), plot(f,p(:,ii))
    xlim([2 12])
    title(['r = ',num2str(rT1(ii))])
end