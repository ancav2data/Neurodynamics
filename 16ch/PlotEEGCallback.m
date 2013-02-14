
%Callback for plotting FT and signal from an image series
function PlotEEGCallback(obj,  event, data,samples,ID, m, n,flag)

    % find axes associated with calling window
    global curr_point
    axes_handle = findobj(obj, 'Type', 'axes');
    % Format the text string
    curr_point      = get(axes_handle, 'CurrentPoint');
    position        = [curr_point(1, 1) curr_point(1, 2)];
    
    RP = [round(curr_point(1,1)) round(curr_point(1,2)/ID)];
    
    if RP(2)>16 
        RP(2)=16;
    end
 
    if RP(2)<1 
        RP(2)=1;
    end
    
    if RP(1)<(samples+1)
        S1=1;
    else
        S1=RP(1)-samples;
    end
    
    if (RP(1)+samples)>m
        S2=m;
    else
        S2=RP(1)+samples;
    end
  
    [p f] = pwelch(data(S1:S2,RP(2)),[],[],[2^13],1000);
    
    h2=figure(2);
    
    subplot(3,1,1),plot(data(S1:S2,RP(2)))
    axis('tight');
    title(['Channel ',int2str(RP(2))]);
    subplot(3,1,2),plot(f,p)
    xlim([0 20]);
    subplot(3,1,3),plot(f,p)
    xlim([20 90]);