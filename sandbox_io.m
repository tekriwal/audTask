%started 2/16/20, sandbox for io related work
%%



%% Look at R, choice (active decision making) trials %%%
% aka L choices made during SG
trial_inds = find((taskbase_io.response == 1) & (choice_trials == 2));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event
ax_R_choice_event1_l = ax_L_choice_event1_l;
ax_R_choice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107;
ax_R_choice_event1_h = (num_trials / length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_R_choice_event1_u = ax_L_nochoice_event1_u - inter_raster_space - ax_L_choice_event1_h;


dimension_R = ax_L_choice_event1_pos(2) - ax_L_choice_event1_h;
ax_R_choice_event1_pos = [ax_R_choice_event1_l dimension_R ax_R_choice_event1_w ax_L_choice_event1_h];


h = axes('Position', ax_R_choice_event1_pos);

hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
ylabel({'Contra.'});
%title('Stimulus guided');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

trial_inds = find((taskbase_io.response == 1) & (choice_trials == 2));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


%AT 2/17/20; editting below
% now calculate psth
% now calculate psth
[ref_psth.R.choice.event1, junk, ref_psth_info.R.choice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);


%% Look at R, no-choice trials %%%
% aka R choices made during IS
trial_inds = find((taskbase_io.response == 2) & (nochoice_trials_R == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';


trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';



% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

%% only plot a certain number of trials in the raster (but psth should be
%% average of all trials)
if length(trial_start_times) > NUM_TRIALS_TO_PLOT
    r = randperm(length(trial_start_times));
    trials_to_plot = sort(r(1:NUM_TRIALS_TO_PLOT));
else
    trials_to_plot = 1:length(trial_start_times);
end

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);


% sort trials by rxn
[y, trials_to_plot] = sort(submitsResponse_times - stimDelivered_times);

trialStart_times = trialStart_times(trials_to_plot);
upPressed_times = upPressed_times(trials_to_plot);
stimDelivered_times = stimDelivered_times(trials_to_plot);
goCue_times = goCue_times(trials_to_plot);
leftUP_times = leftUP_times(trials_to_plot);
submitsResponse_times = submitsResponse_times(trials_to_plot);
feedback_times = feedback_times(trials_to_plot);

%% plot rasters aligned to first desired event


ax_R_nochoice_event1_l = ax_L_choice_event1_l + 0.25;
ax_R_nochoice_event1_w = ax_L_choice_event1_w;
num_trials = NUM_TRIALS_TO_PLOT;
% num_trials = 107; AT 2/13/19 editted out
ax_R_nochoice_event1_h = (num_trials / length(taskbase_io.events.trialStart)) * available_rasters_h;
ax_R_nochoice_event1_u = ax_R_choice_event1_u - inter_raster_space - ax_R_nochoice_event1_h;

% ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l ax_R_choice_event1_u ax_R_nochoice_event1_w ax_R_nochoice_event1_h];
ax_R_nochoice_event1_pos = [ax_R_nochoice_event1_l dimension_R ax_R_nochoice_event1_w ax_R_nochoice_event1_h]; %2/13/19 AT editted from '0.655' to 'dimension_R'

h = axes('Position', ax_R_nochoice_event1_pos);



hold on;

% spike_times;%in seconds already
% trial_start_times; %in seconds already

[ref_spike_times, trial_inds, plot_handle] = raster_io_V1(spike_times, trialStart_times',...
    eval(align_event1_times), window_event1,...
    [upPressed_times; stimDelivered_times; goCue_times; leftUP_times; submitsResponse_times; feedback_times]);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times]
%     [ ovo_times; gt_times; opo_times])

% Change colors of secondary event symbols
% set(plot_handle.secondary_events(:, 1), 'Color', odorvalveon_col);
% set(plot_handle.secondary_events(:, 2), 'Color', gotone_col);
% set(plot_handle.secondary_events(:, 3), 'Color', odorportout_col);

set(plot_handle.secondary_events(:, 1), 'Color', upPressed_color);
set(plot_handle.secondary_events(:, 2), 'Color', stimDelivered_color);
set(plot_handle.secondary_events(:, 3), 'Color', goCue_color);
set(plot_handle.secondary_events(:, 4), 'Color', leftUP_color);
set(plot_handle.secondary_events(:, 5), 'Color', submitsResponse_color);
set(plot_handle.secondary_events(:, 6), 'Color', feedback_color);

set(gca, 'xticklabel', []);
set(gca, 'ytick', []);
%ylabel({'Ipsi.'});
%title('Internally specified');

% recalculate raster, w/ all 'well-behaved' trials included, for psth - aligned to odorportout
% % % % trial_inds = find((taskbase.choice == 1) & (choice_trials == 1));
% % % % trial_start_times = taskbase.start_nlx(trial_inds)';
% % % % opi_times = taskbase.OdorPokeIn(trial_inds)';
% % % % ovo_times = taskbase.DIO(trial_inds)';
% % % % gt_times = taskbase.cue(trial_inds)';
% % % % opo_times = taskbase.OdorPokeOut(trial_inds)';
% % % % wpi_times = taskbase.WaterPokeIn(trial_inds)';
% % % % wvo_times = taskbase.WaterDeliv(trial_inds)';

trial_inds = find((taskbase_io.response == 2) & (nochoice_trials_R == 1));
trial_start_times = taskbase_io.events.trialStart(trial_inds)';
% trial_start_times_AO = taskbase_io.trialStart_AO(trial_inds)';
trialStart_times = (taskbase_io.trialStart_AO(trial_inds)')/(Ephys_struct.mer.sampFreqHz);
upPressed_times = taskbase_io.events.upPressed(trial_inds)';
stimDelivered_times = taskbase_io.events.stimDelivered(trial_inds)';
goCue_times = taskbase_io.events.goCue(trial_inds)';
leftUP_times = taskbase_io.events.leftUP(trial_inds)';
submitsResponse_times = taskbase_io.events.submitsResponse(trial_inds)';
feedback_times = taskbase_io.events.feedback(trial_inds)';





[ref_spike_times, trial_inds, plot_handle] = raster(spike_times, trial_start_times',...
    eval(align_event1_times), window_event1,...
    [ stimDelivered_times; goCue_times; leftUP_times], no_plot_flag);

%     [opi_times; ovo_times; gt_times; opo_times; wpi_times], no_plot_flag);


% now calculate psth
[ref_psth.R.nochoice.event1, junk, ref_psth_info.R.nochoice.event1] =...
    psth(ref_spike_times, trial_inds, init_psth_window_event1, PSTH_SMOOTH_FACTOR, no_plot_flag);










%%
%%

fs = 44000;
for i = 1:97
    
test(i,1) = taskbase_io.trialStart_AO(i)/fs;
test(i,2) =taskbase_io.trialStart(i);

end