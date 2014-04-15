s = serial('COM15');
set(s,'BaudRate',57600);
fopen(s);
readData=fscanf(s)
fwrite(s,'s','char');

cnt=1;
Loop=1;

while Loop==1
    out = fscanf(s);
    [msg,v]=str2vec(out);
    dOut(cnt,:)=v;
    disp(out);
    cnt=cnt+1;
    if v(1,3) == 4
        Loop=0;
    end
end

plot(dOut(:,1),dOut(:,2))
hold on
plot(dOut(dOut(:,3)==2,1),dOut(dOut(:,3)==2,2),'ro')
hold off

fclose(s);