%% GetPhysioGlobals
%% Central location where global variables are defined for coordination across
%% analyses.
%% Based on GetSCGlobals, originally written 1/8/08 by GF.
%% $ Generalized for use with awake behaving recording data 12/3/12 by GF.

function GetPhysioGlobals

%%% ESTABLISH THE GLOBAL VARIABLES

global RESOLUTION; % set to 1000 to plot spike times to 1 msec resolution
global TRIAL_EVENTS; % numbers in saved raster_info corresponding to the trial events

global MAX_MOVEMENT_TIME_TO_WATER; % max time from odorpokeout to waterpokein (discard trials where time is longer than this)
global MAX_MOVEMENT_TIME_TO_ODOR; % max time from waterpokeout to nextodorpokein
global MAX_TONERESPONSE_TIME; % max time from gotoneon to odorpokeout
global INTERPOKE_DIST; % in cm; distance between center and side ports 

global FIRING_RATE_MIN; % minimum firing rate (per "category"); cells below this will be excluded
global NUM_TRIALS_MIN; % minimum number of trials (per "category"); cells below this will be excluded


%% Other potential global variables to reincorporate in the future

% global PREFERENCE_BATCHFILE; % the file containing all of the preference calculations for each cell (generally the most recent one calculated)

% % for epoch definitions (for selectivity analyses)
% global PREMOVEMENT_TIME;
% global PREGOTONE_TIME;
% global POSTWATER_TIME;
% global PREODORPOKE_TIME;

% global epochs; % define epochs for selectivity analyses

% global INVALID_VALUE_FLAG;  % flag for trials to be marked invalid (e.g., b/c of early waterpokeout (before epoch start))


%%% SET THE VALUES FOR THE GLOBAL VARIABLES

RESOLUTION = 1000; % plot spike times to 1 msec resolution

MAX_MOVEMENT_TIME_TO_WATER = 1.5; % in sec
MAX_MOVEMENT_TIME_TO_ODOR = 1.5; % in sec
MAX_TONERESPONSE_TIME = 0.3; % in sec

INTERPOKE_DIST = 9999; % in cm; distance between center and side ports
% - WHAT IS THIS FOR THE MOUSE BOXES?

FIRING_RATE_MIN = 2; % spks/sec
NUM_TRIALS_MIN = 4;

% Define the trial events
TRIAL_EVENTS.OdorPokeIn = 1;
TRIAL_EVENTS.OdorValveOn = 2;
TRIAL_EVENTS.OdorPokeOut = 3;
TRIAL_EVENTS.WaterPokeIn = 4;
TRIAL_EVENTS.WaterValveOn = 5;
TRIAL_EVENTS.WaterPokeOut = 6;
TRIAL_EVENTS.NextOdorPokeIn = 7;
TRIAL_EVENTS.GoSignal = 8; % NOTE: not chronological!


%% Other potential global variables to reincorporate in the future

% PREFERENCE_BATCHFILE = (path and filename for the batchfile)

% % for epoch definitions (for selectivity analyses)
% PREMOVEMENT_TIME = 0.1; % in sec
% PREGOTONE_TIME = 0.5; % in sec
% POSTWATER_TIME = 1; % in sec
% PREODORPOKE_TIME = 0.5; % in sec


% %% Define the epochs here - note that they are no longer chronological, due
% %% to cue addition in TRIAL_EVENTS
% epochs{1} = [888 -PREODORPOKE_TIME TRIAL_EVENTS.OdorPokeIn]; %Pre-OdorPoke (to test for bias)
% epochs{2} = [TRIAL_EVENTS.OdorValveOn TRIAL_EVENTS.OdorPokeOut]; %Stimulus: OdorValveOn to OdorPokeOut
% epochs{3} = [888 -PREMOVEMENT_TIME TRIAL_EVENTS.OdorPokeOut]; %Pre-movement: The PREMOVEMENT_TIME msec preceding OdorPokeOut
% epochs{4} = [TRIAL_EVENTS.OdorPokeOut TRIAL_EVENTS.WaterPokeIn]; % Movement: OdorPokeOut to WaterPokeIn
% epochs{5} = [999 TRIAL_EVENTS.WaterPokeIn POSTWATER_TIME]; % Reward: WaterPokeIn to POSTWATER_TIME
% epochs{6} = [TRIAL_EVENTS.WaterPokeIn TRIAL_EVENTS.WaterPokeOut]; % Reward (alternative): WaterPokeIn to WaterPokeOut
% epochs{7} = [888 -PREMOVEMENT_TIME TRIAL_EVENTS.WaterPokeOut]; % Pre-reinitiation movement: The PREMOVEMENT_TIME msec preceding WaterPokeOut
% epochs{8} = [TRIAL_EVENTS.WaterPokeOut TRIAL_EVENTS.NextOdorPokeIn]; % Reinitiation movement: WaterPokeOut to NextOdorPokeIn
% 
% epochs{9} = [TRIAL_EVENTS.OdorValveOn TRIAL_EVENTS.cue]; % mvmt planning activity: odorvalveon to gotoneon
% epochs{10} = [888 -PREGOTONE_TIME TRIAL_EVENTS.cue]; % mvmt planning activity: PREGOTONE_TIME to gotoneon
% epochs{11} = [TRIAL_EVENTS.cue TRIAL_EVENTS.OdorPokeOut]; % mvmt initiation activity: gotoneon to odorpokeout
% epochs{12} = [888 -1 TRIAL_EVENTS.cue 888 -0.5 TRIAL_EVENTS.cue]; % 1000-500 ms before gotone
%     % (specific for short vs. long delay comparisons)

% INVALID_VALUE_FLAG = 99999;

