function [d,si] = load_abf(fname, traces);
% load abf files with fixed intervals (not gap free)
% Input: fname and the number of traces

[d1,si]=abfload(fname);

a=size(d1);

if a(2)==1
    d=zeros(a(1),a(3));
for ii=1:a(3)
d(:,ii)=d1(:,1,ii);
end

n=a(3)/traces;

d2=zeros(a(1),a(3)/n);
for ii=1:n
    for j=1:a(3)/n
        d2(:,j)=d2(:,j)+d(:,(ii-1)*(a(3)/n)+j);
    end
end
d=d2/n;

else
    
    for k=1:a(2)
        
        for ii=1:a(3)
            eval(['d.d',int2str(k),'(:,ii)=d1(:,k,ii);']);
        end

n=a(3)/traces;

d2=zeros(a(1),a(3)/n);
for ii=1:n
    for j=1:a(3)/n
        eval(['d2(:,j)=d2(:,j)+d.d',int2str(k),'(:,(ii-1)*(a(3)/n)+j);']);
    end
end

eval(['d.d',int2str(k),'=d2/n;']);

    end
end