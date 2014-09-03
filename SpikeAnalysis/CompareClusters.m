%%
%Put all clusters in a single variable
SpkFiles=dir('times_*');

for ii=1:numel(SpkFiles)
    load (SpkFiles(ii).name);
    str1=SpkFiles(ii).name;
    SpkCh(ii,1)=str2num(str1(strfind(SpkFiles(ii).name,'ch_')+3:strfind(SpkFiles(ii).name,'.mat')-1));
    SpkCh(ii,2)=max(cluster_class(:,1))+1;
    cluster_class(:,1)=cluster_class(:,1)+1;
    if (ii==1)
        TotalClusterClass=cluster_class;
        TotalSpikes=spikes;
    else
        SpkNo=max(TotalClusterClass(:,1));
        cluster_class(:,1)=cluster_class(:,1)+SpkNo;
        TotalClusterClass=[TotalClusterClass; cluster_class];
        TotalSpikes=[TotalSpikes; spikes];
    end
end

CondNo = 1;

Condition(CondNo).ClusterClass = TotalClusterClass;
Condition(CondNo).Spikes = TotalSpikes;
Condition(CondNo).SpkCh = SpkCh;

%%

ConditionNumbers = 2;



for ii=1:ConditionNumbers
    disp(['Condition ',num2str(ii),' --> Number of Units =  ',num2str(max(Condition(ii).ClusterClass))]);
    disp(['Condition ',num2str(ii)]);
    disp('Channel/Number of Units');
    Condition(ii).SpkCh
    TotalSpks(ii)=sum(Condition(ii).SpkCh(:,2));
    NoChannels(ii)=size(Condition(ii).SpkCh,1);
    
    cnt=0;
    
    for jj=1:NoChannels(ii)
        Condition(ii).Indice(jj,:)=[cnt+1,Condition(ii).SpkCh(jj,2)+cnt];
        cnt=cnt+Condition(ii).SpkCh(jj,2);
    end
    
end

%%


for ii=1:NoChannels(1)
    CondNo = 1;
    figure(CondNo);
    clf
    for jj=1:Condition(CondNo).SpkCh(ii,2)
        %Condition(CondNo).SpkCh(ii,2)
        %jj+Condition(CondNo).Indice(ii,1)-1
    SpkIndex=find(Condition(CondNo).ClusterClass(:,1)==jj-1+Condition(CondNo).Indice(ii,1));
    subplot(2,3,jj),plot(mean(Condition(CondNo).Spikes(SpkIndex,:)))
    title(['No. of APs ',num2str(size(Condition(CondNo).Spikes(SpkIndex,:),1))]);
    axis('tight');
    end
    
    Ch = Condition(CondNo).SpkCh(ii,1)
    
    CondNo = 2;
    figure(CondNo);
    clf
    
    ChIndex = find(Condition(CondNo).SpkCh(:,1) == Ch);
    
    if not(isempty(ChIndex))
        for jj=1:Condition(CondNo).SpkCh(ChIndex,2)
            SpkIndex=find(Condition(CondNo).ClusterClass(:,1)==jj-1+Condition(CondNo).Indice(ChIndex,1));
            subplot(2,3,jj),plot(mean(Condition(CondNo).Spikes(SpkIndex,:)))
            title(['No. of APs ',num2str(size(Condition(CondNo).Spikes(SpkIndex,:),1))]);
            axis('tight');
        end
    else
        disp('No spikes in the second condition');
    end
    
    pause
    

end
