function error_bar(x,y,ylo,yup,ww,ms)
% error_bar(ce,lo,up)
% add a plot to current figure at location x along the x-axis.
% y = estimate of central tendency
% ylo = lower bound of error bar
% yup = upper bound of error bar
% ww = whisker width, in departure from x - default = 0.1
% ms = marker size - default = 10
% 
% example
% figure('Color','w','NumberTitle','off')
% hold on
% x = 1;y = 90;ylo = 80;yup = 100;
% error_bar(x,y,ylo,yup)
% x = 2;y = 90;ylo = 85;yup = 95;
% error_bar(x,y,ylo,yup)
% x = 3;y = 70;ylo = 50;yup = 90;
% error_bar(x,y,ylo,yup)

% Guillaume Rousselet - University of Glasgow - 27/05/2016

if nargin < 5
    ww = 0.1;
    ms = 10;
end

plot(x,y,'ko','MarkerSize',ms,'MarkerFaceColor','k') % central tendency
plot([x x],[y yup],'k','LineWidth',2) % whisker 1
plot([x-ww x+ww],[yup yup],'k','LineWidth',2)
plot([x x],[y ylo],'k','LineWidth',2) % whisker 2
plot([x-ww x+ww],[ylo ylo],'k','LineWidth',2)

