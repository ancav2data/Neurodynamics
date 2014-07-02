function [d,t,Header]=wcpload(FName)

Fid = fopen(FName,'r');
Version = fread(Fid,[1,1024],'char');

Version(Version==0)=[];

l10=find(Version==10); % newline (\n)
l13=find(Version==13); % return (\r)

if (length(l10)==length(l13))
    cnt=1;
    for ii=1:length(l13)
        Str=char(Version(cnt:l13(ii)));
        Header{ii} = cellstr(Str);
        cnt = l13(ii)+2;
    end
end

eval(char(Header{6}))
eval(char(Header{7}))
eval(char(Header{10}))
eval(char(Header{11}))
eval(char(Header{12}))

clear Header

fclose(Fid);

Fid = fopen(FName,'r');

HeaderSize = ((round(NC-1)/8)+1)*1024;

Version = fread(Fid,[1,HeaderSize],'char');
l10=find(Version==10); % newline (\n)
l13=find(Version==13); % return (\r)

if (length(l10)==length(l13))
    cnt=1;
    for ii=1:length(l13)
        Str=char(Version(cnt:l13(ii)));
        Header{ii} = cellstr(Str);
        cnt = l13(ii)+2;
    end
end

Data = fread(Fid,'int16');

Data = (Data/ADCMAX)*AD;

fclose(Fid)

for ii=1:numel(Header)
Str = char(Header{ii});
a=strfind(Str,'YG');
if(not(isempty(a)))
    eval(Str)
end;
end



for ii=1:NC
    dd=Data(2+((ii-1)*2):(ii-1)*2+2:end);
    dd=reshape(dd,[length(dd)/NR,NR]);
d(ii).Ch=dd;
g=length(dd);

end

t=(1:length(dd))*DT;