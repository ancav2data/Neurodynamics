function stopSoundCard(obj,event)

% STOPSOUNDCARD Closes sound card device.
%    STOPSOUNDCARD is used by SLM to finalize
%    real-time data acquisition from the sound
%    card. The analog input device is closed.
%
% Author: Douglas R. Lanman, 11/21/05

% Obtain analog input device from data field.
figData = get(gcbf,'UserData');
AI = figData.AI;

% Stop/restart input device (if currently running).
if isrunning(AI)
   stop(AI);
   set(figData.uiButton,'string','Restart');
else
   delete(AI); SLM;
end