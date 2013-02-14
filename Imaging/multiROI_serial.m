function [mm,mBleach,X,Y]=multiROI_serial(fname,xIn,yIn,Draw);

%Load KLS files from the new andor scmos cam
%Calculate the pixel values of several ROIs
%Usage 
%[mm,mBleach,X,Y]=multiROI_serial(fname,xIn,yIn);
%set Draw to 0 to draw new ROIs
%Version 0.3
%15/01/2013

fp=fopen(fname,'r');
%Width and Height
dim=fread(fp,2,'int16');
%	FrameNo;
%	FrameRate;
%   exposure;
imSpex=fread(fp,3,'int32');
imSpex(3)=imSpex(3)/10000;

imS(:,:)=fread(fp,[dim(1),dim(2)],'int16') ;
m=dim(1);
n=dim(2);

if Draw==0
imagesc(imS);
loop=1;
cnt=1;
noROI = input('Number of ROIs?');
X.noROI = noROI;

for jj=1:noROI
while loop==1
    [xX,yY,button]=ginput(1);
    if button==1
        x(cnt)=xX;
        y(cnt)=yY;
     if cnt>1
        a=line([x(cnt-1) x(cnt)],[y(cnt-1) y(cnt)]);
        set(a,'linewidth',2)
        set(a,'color','w')
     end
    cnt=cnt+1;
    end


    if button==3
        z=1
        a=line([x(1) x(cnt-1)],[y(1) y(cnt-1)]);
        set(a,'linewidth',2)
        set(a,'color','w')
        loop=0;
        eval(['X.x',int2str(jj),'=x;']);
        eval(['Y.y',int2str(jj),'=y;']);
        clear x y
        jj
    end
end
cnt=1;
     loop=1;
end
else
    X = xIn;
    Y = yIn;
    noROI = xIn.noROI;
end

for jj=1:noROI
    xx(:,:,jj)=ones(m,n);
    yy(:,:,jj)=ones(m,n);
for ii=1:n
    xx(:,ii,jj)=ii*xx(:,ii,jj);
end
for ii=1:m
    yy(ii,:,jj)=ii*yy(ii,:,jj);
end

eval(['xx1=X.x',int2str(jj),';']);
eval(['yy1=Y.y',int2str(jj),';']);

IN(:,:,jj) = inpolygon(xx(:,:,jj),yy(:,:,jj),xx1,yy1);

gg=find(IN(:,:,jj)==1);
gg=length(gg);

gG(:,jj)=gg;
    M=sum(sum(IN(:,:,jj).*double(imS)));
    mm(1,jj)=M/gg;
end

for ii=2:imSpex(1)
  imS=fread(fp,[dim(1),dim(2)],'int16') ;
  for jj=1:noROI
    M=sum(sum(IN(:,:,jj).*double(imS)));
    mm(ii,jj)=M/gG(:,jj);
  end
end

N = 1:imSpex(1);

K=7; %polynomial order

for jj=1:noROI
    P=polyfit(N',mm(:,jj),K);
    mBleach(:,jj)=mm(:,jj)-polyval(P,N');
end

fclose(fp);