%AT this fx is only for adapting case 4, which is the only case that is the
%'V2' version of the rsp data output

function [rData] = Case03_behavior_adapter(rData)


% challenging to work with struct so putting relevant variables from Matlab behavioral output into a matrix so we can index out the 'f' or '0' trials
for i = 1:length(rData)
    
    rData(i).Writeread_UP1 = 0;
    rData(i).Writeread_UP2 = 0;
    rData(i).Postholdtime_UPheld = 0;
    rData(i).Writeread_response = 0;
    rData(i).timeoffeedback = 0;

end



end