%% During Recordings


behavDays = {'AT_Oct20.mat','BP_Oct24.mat','DC_Oct24.mat','NB_Oct20.mat','TD_Oct20.mat'};

fit1 = zeros(41,length(behavDays));
for numDs = 1:length(behavDays)

    tempN = behavDays{numDs};
    
    [per_L, yf] = figure_5_atJNM(tempN);
    fit1(:,numDs) = yf;

close all
end
        
  

%%

xAxisM = [1,2,3,4,5];
x_axis = (0:40);
yfm1 = mean(fit1,2);

% the fit
figure;
p2 = plot(x_axis, yfm1', 'Color',[0.6 1 0.6]);
set(p2, 'LineWidth', 1);
hold on

p4 = plot(x_axis, reSortfit2, 'Color', [0.91 0.91 0.91]);
set(p4, 'LineWidth', 1);

p3 = plot(x_axis, yfm1, 'Color', [0 0.8 0.2]);
set(p3, 'LineWidth', 8);

p5 = plot(x_axis, yfm2, 'k');
set(p5, 'LineWidth', 4);

% Labeling commands
xlabel('% Odor A', 'FontSize', 16);
ylabel('Fraction Right choices', 'FontSize', 16);
% axis square


