function [m,x,y]=mROI_serial(fname,x,y);

%Load KLS files from the new andor scmos cam

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

if length(x)<2
imagesc(imS);
loop=1;
cnt=1;
while loop==1
    [xx,yy,button]=ginput(1);
    if button==1
        x(cnt)=xx;
        y(cnt)=yy;
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
        while z==1
        r=input('Redo (1=yes, 2=no)');
        if r==1 | r==2
            z=0;
        end
        end
        if r==2
            loop=0;
        end
        if r==1
            image(Img(:,:,first_pic),'CDataMapping','scaled')
            x=[];
            y=[];
            cnt==1;
        end
    end
end
end

Y=ones(m,n);
X=ones(m,n);
for ii=1:n
    X(:,ii)=ii*X(:,ii);
end
for ii=1:m
    Y(ii,:)=ii*Y(ii,:);
end
IN = inpolygon(X,Y,x,y);

image(IN.*double(imS),'CDataMapping','scaled');
gg=sum(sum(IN==1));
    M=sum(sum(IN.*double(imS)));
    m(1)=M/gg;

for ii=2:imSpex(1)
  imS=fread(fp,[dim(1),dim(2)],'int16') ;
  M=sum(sum(IN.*double(imS)));
  m(ii)=M/gg;
end

fclose(fp);