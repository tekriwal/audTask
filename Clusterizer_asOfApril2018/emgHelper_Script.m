

%% Step 1 Process EMG data
% When prompted navigate to the io_neural_data folder for specific case
emgPROCESS_V1('toPlot',1)

%% Step 2 Analyze EMG data
emgAnalyze_v2('caseNum',8)

%% Step 3 Plot data [SEE FUNCTION for explanation of INPUTS]
emgSummarizePlot_V1('caseNum',8, 'Param',2, 'plotN',2,'userPC','AT')