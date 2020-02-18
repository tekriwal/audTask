%% During Recordings


behavDays = {'rData_PT1.mat','rData_PT2.mat'};

fit1 = zeros(41,length(behavDays));
for numDs = 1:length(behavDays)

    tempN = behavDays{numDs};
    
    [per_L, yf] = grouped_figure_5_atJNM(tempN);
    fit1(:,numDs) = yf;

close all
end
        
  

%

% xAxisM = [1,2,3,4,5];
x_axis = (0:40);
yfm1 = mean(fit1,2);

% the fit
figure;
p2 = plot(repmat(transpose(x_axis),1,5), fit1, 'Color',[0.5 0.5 0.5]);
set(p2, 'LineWidth', 1);
hold on

p5 = plot(x_axis, yfm1, 'k');
set(p5, 'LineWidth', 4);

% Labeling commands
xlabel('Tone frequencey', 'FontSize', 16);
ylabel('Fraction Left choices', 'FontSize', 16);
xticks(linspace(0,40,5))
xticklabels(num2cell('12345'))
axis square


