entry_cnt=1;
t=30:0.001:120;
windows=1; %use windows?
power=1; %envelope or spectroramm power

for fcnt=1:3
    %iterating over filtered theta amplitude envelope
    for chnl=1:16
    
        if(power==0)
            lfp=squeeze(ThethaEnv(fcnt,chnl,:));
            srate_lfp=1000;
            t=30:0.001;120;
        else
            P=squeeze(TFDall(fcnt,chnl,:,:));
            thetaIndex = find(F>5 & F <10);   
            lfp = (mean(P(thetaIndex,:)));
            srate_lfp=2;
            t=T;
        end
    
        dt_Loco =  180/length(V);
        srate_Loco = 1/dt_Loco;
        time_Loco = dt_Loco*(1:length(V));

        for light=0:2

        if light==0
          T1=30;
          T2=60;
        end

        if light==1
          T1=60;
          T2=90;
        end


        if light==2
          T1=90;
          T2=120;
        end



          I1=find(t>=T1 & t<=T2);
          I2=find(time_Loco>T1 & time_Loco<T2);

          LFP = lfp(I1);
          Loco = V(I2);

       %    subplot(211)
       %    plot(t(I1),LFP)
        %   
       %    subplot(212)
       %    plot(time_Loco(I2),Loco)


        if(windows==1)
        winlength = .5; %in seconds

        for  nwindow = 1:60

        %   window = [1:srate_Loco*winlength] + round((nwindow-1)*winlength*srate_Loco);


        if nwindow==1
          window = [1:srate_Loco*winlength];
          window2 = [1:srate_lfp*winlength];
        else
         window = window(end):(window(end)+winlength*srate_Loco);
         window2 = window2(end):(window2(end)+winlength*srate_lfp);
        end


          %TT(nwindow)=median(time_Loco(I2(window)));
          meanLoco(nwindow)=mean(V(I2(window)));
          %plot(lfp(I1(window2)));
          %if(window2(end)>length(I1))
            meanEnvelope(nwindow)=mean(lfp(I1(window2(1):length(I1))));
          %else
            %meanEnvelope(nwindow)=mean(lfp(I1(window2)));
          %end

        end
        else
            %no windows -> comparson with upsampled V
            meanLoco=Loco;
            meanEnvelope=LFP;
            
        end

            if light == 0
                muhl=corrcoef(meanEnvelope,meanLoco);
                corr1(entry_cnt)=muhl(1,2);
            elseif light == 1
                muhl=corrcoef(meanEnvelope,meanLoco);
                corr2(entry_cnt)=muhl(1,2);
            elseif light == 2
                muhl=corrcoef(meanEnvelope,meanLoco);
                corr3(entry_cnt)=muhl(1,2);
            end



        end
        entry_cnt=entry_cnt+1;
    end
end
%boxplot([corr1; corr2; corr3]');

boxplot([abs(corr1); abs(corr2); abs(corr3)]');
cor1=[0.05 0.07 0.1 0.12 0.13]
cor2=[0.06 0.08 0.09 0.11 0.12]
cor3=[0.04 0.09 0.07 0.13 0.11]
boxplot([cor1; cor2; cor3]')

boxplot([abs(corr1); abs(corr2); abs(corr3)]');
cor1=[0.04 0.08 0.1 0.13 0.15]
cor2=[0.07 0.08 0.06 0.12 0.09]
cor3=[0.07 0.03 0.04 0.12 0.10]
boxplot([cor1; cor2; cor3]')


[h,p1]=ttest2(corr1,corr2)
[h,p2]=ttest2(corr1,corr3)
[h,p3]=ttest2(corr3,corr2)