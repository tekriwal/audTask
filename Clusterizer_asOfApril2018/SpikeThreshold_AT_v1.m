function varargout = SpikeThreshold_AT_v1(varargin)
% SPIKETHRESHOLD_AT_V1 MATLAB code for SpikeThreshold_AT_v1.fig
%      SPIKETHRESHOLD_AT_V1, by itself, creates a new SPIKETHRESHOLD_AT_V1 or raises the existing
%      singleton*.
%
%      H = SPIKETHRESHOLD_AT_V1 returns the handle to a new SPIKETHRESHOLD_AT_V1 or the handle to
%      the existing singleton*.
%
%      SPIKETHRESHOLD_AT_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKETHRESHOLD_AT_V1.M with the given input arguments.
%
%      SPIKETHRESHOLD_AT_V1('Property','Value',...) creates a new SPIKETHRESHOLD_AT_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SpikeThreshold_AT_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpikeThreshold_AT_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SpikeThreshold_AT_v1

% Last Modified by GUIDE v2.5 20-Mar-2018 15:12:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SpikeThreshold_AT_v1_OpeningFcn, ...
    'gui_OutputFcn',  @SpikeThreshold_AT_v1_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SpikeThreshold_AT_v1 is made visible.
function SpikeThreshold_AT_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpikeThreshold_AT_v1 (see VARARGIN)

% Choose default command line output for SpikeThreshold_AT_v1
handles.output = hObject;


handles.clusterSpk.Enable = 'off';
handles.threshold.Enable = 'off';
handles.deleteTrace.Enable = 'off';
handles.template.Enable = 'off';
handles.combineClus.Enable = 'off';
handles.delClusts.Enable = 'off';
handles.expClus.Enable = 'off';
handles.subTask.Enable = 'off';

handles.posTh.Value = 0;
handles.negTh.Value = 0;

handles.posNegT.Visible = 'off';

handles.minSPdist = 1.5;
handles.sd_Th.String = 15;

set(handles.manualThresh,'Min',1);
set(handles.manualThresh,'Max',6);
set(handles.manualThresh,'Value',4);
set(handles.manualThresh,'SliderStep',[1/10 , 1/3])

handles.manThval.String = '';

handles.manualThresh.Enable = 'off';
handles.actManThresh.Enable = 'off';

handles.combineTog.Enable = 'off';
handles.deleteTog.Enable = 'off';
handles.refineTog.Enable = 'off';


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SpikeThreshold_AT_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = SpikeThreshold_AT_v1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function loadTest_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
% hObject    handle to loadTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

loadSEL = 'a';

switch loadSEL
    case 's'
        
       
    case 'a'
        
        [rawDataFile,rawDataLoc,~] = uigetfile('','LOAD CELL MAT file');
        
        % Load location with Spike Files to Cluster - RAW_Ephys_Files
        handles.LoadLoc = rawDataLoc;
        
        cd(handles.LoadLoc)
        
        file2load = rawDataFile;
        
        load(file2load, 'CSPK_01','CSPK_02','CSPK_03','mer','ttlInfo');
        
        % handles.fNAME = CaseNum;
        
        filePARTS = strsplit(rawDataFile,{'_','.'});
        
        handles.DepthID = str2double(filePARTS{3});%#ok<*USENS>
        if strcmp(filePARTS{1}(1),'B')
            handles.DepthID = handles.DepthID*-1;
        end
        
        handles.DepthIND =  str2double(filePARTS{2});
        
        % Go to folder location
        % Load in first electrode
        
        handles.spikeDataRaw = CSPK_01;
        handles.spkFS = mer.sampFreqHz;
        handles.startT = mer.timeStart;
        
        % UpdateINFO
        handles.Elnum = 1;
        handles.ddepNUM.String = file2load;
        handles.eleNUM.String = 'Elec_1';
        
end

handles.infotext.String = 'Loading files...';
handles.infotext.ForegroundColor = 'r';
drawnow;

handles.infotext.String = 'File Loaded!!';
handles.infotext.ForegroundColor = [0 0.4980 0];
drawnow;

handles.oriFload = file2load;



switch loadSEL
    case 's'
        

        
    case 'a'
        
        plotRastWaves(handles, 'new')
        
        % INITIATE buttons
        % handles.threshold.Enable = 'on';
        handles.posNegT.Visible = 'on';
        handles.loadTest.Enable = 'off';
        
        
        if handles.posTh.Value == 1
            handles.pnFlag = 1;
        elseif handles.negTh.Value == 1
            handles.pnFlag = 0;
        end
        
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in expClus.
function expClus_Callback(hObject, eventdata, handles)
% hObject    handle to expClus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If current file is equal to the total number of files then shut down
% program and re-initate load file button

% (1) Export DATA
%     (a) Export location
%     (b) Export name
%     (c) Bundle up export data
%     (d) Save data

% (a)

loadSEL = 'a';

switch loadSEL
    
    case 's'
        

    case 'a'
        SaveLoc = uigetdir;
        cd(SaveLoc);
        
        eleNUMs = handles.eleNUM.String(length(handles.eleNUM.String));
        eleNUM = str2double(handles.eleNUM.String(length(handles.eleNUM.String)));
        
        abNparts = strsplit(handles.oriFload,{'.','_'});
        
        depthN = abNparts{3};
        
        if strcmp(abNparts{1}(1),'A')
            abNUM = ['a',abNparts{2}];
        else
            abNUM = ['b',abNparts{2}];
        end
        
        saveNAME = ['threshData_',abNUM,'_',depthN,'_',eleNUMs,'_clzD.mat'];
        

        % (ii)
        spikeDATA.waveforms = handles.waveForms;
        % (iii)
        spikeDATA.thresholdINFO.thresholdSD = handles.threshUsed;
        % (v)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [ xFeats ] = createSpkFeatures( spikeDATA.waveforms.allWaves.waves,  handles.spkFS  );

        spikeDATA.features = xFeats;
        spikeDATA.merFs = handles.spkFS;
        % (vi)
        
        spikeDATA.fileINFO.abNUM = abNUM;
        spikeDATA.fileINFO.depthN = depthN;
        spikeDATA.fileINFO.eleNUM = eleNUM;
        spikeDATA.fileINFO.analyzDATE = date;

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ADD output for Andy Auditory taskbase
        % need time, threshold points well isolated
        spikeDATA.atIO.spFS = handles.spkFS;
        spikeDATA.atIO.sptimeST = handles.startT;
        spikeDATA.atIO.timestamps = handles.waveForms.allWavesInfo.alllocs;

        % (d)
        save(saveNAME,'spikeDATA');
        
        % (2) Modify buttons - to reset threshold and cluster
        handles.threshold.Enable = 'on';
        handles.clusterSpk.Enable = 'off';
        handles.deleteTrace.Enable = 'off';
        handles.expClus.Enable = 'off';
        handles.subTask.Enable = 'off';
        
        % (3) Update table, append table to save file
        cd(handles.LoadLoc)
        
        if eleNUM == 3
            
            loadNEXTh(handles)

        else
            
            % (4) Load next file
            
            curName = handles.oriFload;
            handles.Elnum = handles.Elnum + 1;
            
            handles.infotext.String = 'Loading next cell...';
            handles.infotext.ForegroundColor = 'r';
            drawnow;
            
            cd(handles.LoadLoc);
            load(handles.oriFload, 'CSPK_01','CSPK_02','CSPK_03','mer','ttlInfo');
            handles.spkFS = mer.sampFreqHz;
            
            handles.spikeDataRaw = eval(['CSPK_0',num2str(handles.Elnum)]);
            
            handles.infotext.String = 'Next File Loaded!!';
            handles.infotext.ForegroundColor = [0 0.4980 0];
            
            drawnow;
            
            
            handles.eleNUM.String = ['Elec_',num2str(handles.Elnum)];
            % Clear figures
            
            clearWavePlots(handles)
            
            % PLOT Wave data
            
            plotRastWaves(handles, 'new')
            
        end
        
end

% Update handles structure
guidata(hObject, handles);



function handles = loadNEXTh(handles)

handles.allClust.Visible = 'off';


handles.threshold.Enable = 'off';
handles.deleteTrace.Enable = 'off';
handles.subTask.Enable = 'off';
handles.loadTest.Enable = 'on';

handles.manualThresh.Enable = 'off';
handles.actManThresh.Value = 0;
handles.manualThresh.Value = 4;
handles.manThval.String = '4';

clearWavePlots(handles)

handles.ddepNUM.String = 'DONE';
handles.eleNUM.String = 'LOAD NEXT!';
handles.infotext.String = 'LOAD NEXT!';





% --------------------------------------------------------------------
function threshold_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sampData = handles.spikeDataRaw;
spkData = double(sampData);
sampLen = round(handles.spkFS/1000);

handles.infotext.String = 'Estimating Threshold...';
handles.infotext.ForegroundColor = 'r';
drawnow;

% was threshEstimate_v2

[ thresh2use , Knum2use ] = threshEstimate_v2b( sampData , spkData,  handles.spkFS , handles.pnFlag);

handles.infotext.String = 'Finding Peaks...';
handles.infotext.ForegroundColor = 'm';
drawnow;

thresh = (round(std(double(sampData)) * thresh2use) + mean(double(sampData)));
noise = (round(std(double(sampData)) * 20) + mean(double(sampData)));
minDist = round(handles.spkFS/1000) * handles.minSPdist; % was 1.5

tic;
[ waveData ] = extractWaveforms_Clz_v05(spkData, thresh, noise, minDist, handles.spkFS, handles.pnFlag);
handles.waveForms = waveData;

handles.infotext.String = 'Waves Extracted...';
handles.infotext.ForegroundColor = 'b';
drawnow;

waveForms = waveData.allWaves.waves;
waveLocs = waveData.allWavesInfo.alllocs;
handles.peakIndex = waveLocs;

totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.8)-1));
handles.XLIMa = totLen;

timeDone = toc;

handles.threshUsed = thresh2use;
handles.kmeansNUsed = Knum2use;
handles.spkData = spkData;
handles.voltThresh = thresh;
handles.minSepDist = minDist;

plotRastWaves(handles, 'threshold')

handles.infotext.String = ['Thresholding Done!' , '  time elapsed: ', num2str(round(timeDone)), ' s'] ;
handles.infotext.ForegroundColor = [0 0.4980 0];
drawnow;

%%% Following Thresholding
% 1. Make Clustering available
% 2. Manual Thresholing available
% 3. Abort analysis on bad cell

% Initiate buttons
handles.threshold.Enable = 'off';
handles.clusterSpk.Enable = 'on';
handles.template.Enable = 'off';
handles.combineClus.Enable = 'off';
handles.expClus.Enable = 'on';
% Indicate threshold in window

handles.manThval.String = num2str(thresh2use);
handles.manualThresh.Value = thresh2use;
% Activate manual override

handles.actManThresh.Enable = 'on';

% Activate emergency delete

handles.deleteTrace.Enable = 'on';

% Update handles structure
guidata(hObject, handles);







% --- Executes on slider movement.
function manualThresh_Callback(hObject, eventdata, handles)
% hObject    handle to manualThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



handles.manThval.String = num2str(handles.manualThresh.Value);
drawnow;
% Recompute threshold

sampData = handles.spikeDataRaw;
spkData = double(sampData);
% spkFS = mer.sampFreqHz;
sampLen = round(handles.spkFS/1000);

handles.infotext.String = 'Using MANUAL threshold...';
handles.infotext.ForegroundColor = 'r';
drawnow;

[ ~ , Knum2use ] = threshEstimate_v2b( sampData , spkData,  handles.spkFS , handles.pnFlag);

handles.infotext.String = 'Finding Peaks...';
handles.infotext.ForegroundColor = 'm';
drawnow;

thresh2use = handles.manualThresh.Value;

thresh = (round(std(double(sampData)) * thresh2use) + mean(double(sampData)));
noise = (round(std(double(sampData)) * 20) + mean(double(sampData)));
minDist = round(handles.spkFS/1000) * handles.minSPdist;

tic;
% [ waveData ] = extractWaveforms_Clz_v02(spkData, thresh, noise, minDist, handles.spkFS);
[ waveData ] = extractWaveforms_Clz_v05(spkData, thresh, noise, minDist, handles.spkFS, handles.pnFlag);

handles.infotext.String = 'Waves Extracted...';
handles.infotext.ForegroundColor = 'b';
drawnow;

waveForms = waveData.allWaves.waves;
waveLocs = waveData.allWavesInfo.alllocs;


totLen = length(1 - (sampLen/2):1 + (round(sampLen*0.8)-1));

% Consider Transparent

titleStr = ['All waveforms = ' , num2str(size(waveForms,2))];
title(titleStr);

timeDone = toc;

handles.threshUsed = thresh2use;
handles.kmeansNUsed = Knum2use;
handles.spkData = spkData;
handles.voltThresh = thresh;
handles.minSepDist = minDist;
handles.waveForms = waveData;
handles.XLIMa = totLen;
handles.peakIndex = waveLocs;

handles.infotext.String = ['Thresholding Done!' , '  time elapsed: ',...
    num2str(round(timeDone)), ' s'] ;
handles.infotext.ForegroundColor = [0 0.4980 0];
drawnow;

% Initiate buttons
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.threshold.Enable = 'off';


clearWavePlots(handles);

plotRastWaves(handles, 'new')
plotRastWaves(handles, 'threshold')

handles.actManThresh.Enable = 'on';

% handles.clusterSpk.Enable = 'on';
% handles.deleteTrace.Enable = 'on';

drawnow;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function manualThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in actManThresh.
function actManThresh_Callback(hObject, eventdata, handles)
% hObject    handle to actManThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of actManThresh

% Activating Manual turns off Automatic

chkTog = get(hObject,'Value');

if chkTog == 0
    handles.manualThresh.Enable = 'off';
    handles.threshold.Enable = 'on';
    
elseif chkTog == 1
    handles.manualThresh.Enable = 'on';
    handles.threshold.Enable = 'off';
    set(handles.manualThresh,'Value',str2double(handles.manThval.String));
    
end





%%% --------------------------------------------------------------------%%%
% UTILITIES
%%% --------------------------------------------------------------------%%%


function handles = clearWavePlots(handles)


    

% cla(handles.clust1)
% handles.clust1.Color = [0.9412 0.9412 0.9412];
% handles.clust1.Title = [];
% 
% cla(handles.clust2)
% handles.clust2.Color = [0.9412 0.9412 0.9412];
% handles.clust2.Title = [];
% 
% cla(handles.clust3)
% handles.clust3.Color = [0.9412 0.9412 0.9412];
% handles.clust3.Title = [];
% 
% cla(handles.clust4)
% handles.clust4.Color = [0.9412 0.9412 0.9412];
% handles.clust4.Title = [];
% 
% cla(handles.clust5)
% handles.clust5.Color = [0.9412 0.9412 0.9412];
% handles.clust5.Title = [];
% 
% cla(handles.clust6)
% handles.clust6.Color = [0.9412 0.9412 0.9412];
% handles.clust6.Title = [];



cla(handles.spikeDact)
handles.spikeDact.Color = [0.9412 0.9412 0.9412];

% cla(handles.allClust)
% handles.allClust.Color = [0.9412 0.9412 0.9412];
% handles.allClust.Title = [];


function handles = plotRastWaves(handles, stage)


switch stage
    
    case 'new'
        
        cla(handles.spikeDact);
        axes(handles.spikeDact)
        
        % TIME
        timeDurSpk = round(length(handles.spikeDataRaw)/handles.spkFS,2);
        handles.timeDur.String = [num2str(timeDurSpk) , ' seconds'];
        
        cla(handles.allClust)
        handles.allClust.Color = [0.9412 0.9412 0.9412];
        handles.allClust.Title = [];
        
        sampData = handles.spikeDataRaw;
        mSamp = mean(double(sampData));
        sdSamp = std(double(sampData));
        
        % SD Threshold
        sd_Thresh = str2double(handles.sd_Th.String);
        
        minT = (mSamp + (sdSamp*sd_Thresh))*-1;
        maxT = mSamp + (sdSamp*sd_Thresh);
        
        ylim([minT maxT]);
        xlim([0 length(sampData)]);
        handles.spikeDact.XTick = [];
        handles.spikeDact.YTick = [];
        
    case 'threshold'
        
        cla(handles.spikeDact);
        cla(handles.allClust)
        
        % TIME
        timeDurSpk = round(length(handles.spikeDataRaw)/handles.spkFS,2);
        handles.timeDur.String = [num2str(timeDurSpk) , ' seconds'];

        handles.allClust.Color = [0.9412 0.9412 0.9412];
        handles.allClust.Title = [];
        
        sampData = handles.spikeDataRaw;
        waveLocs = handles.peakIndex;
        waveForms = handles.waveForms.allWaves.waves;
        totLen = handles.XLIMa;
        
        axes(handles.spikeDact)

        hold on
        plot(waveLocs,sampData(waveLocs),'r.','MarkerFaceColor','r');
        mSamp = mean(double(sampData));
        sdSamp = std(double(sampData));
        % SD Threshold
        sd_Thresh = str2double(handles.sd_Th.String);
        
        minT = (mSamp + (sdSamp*sd_Thresh))*-1;
        maxT = mSamp + (sdSamp*sd_Thresh);
        
        ylim([minT maxT]);
        xlim([0 length(sampData)]);
        handles.spikeDact.XTick = [];
        handles.spikeDact.YTick = [];
        
        if handles.pnFlag == 1
            axes(handles.spikeDact)
            line([0 length(sampData)] , [handles.voltThresh handles.voltThresh],'Color', 'c', 'LineStyle','--','LineWidth',2);
        elseif handles.pnFlag == 0
            axes(handles.spikeDact)
            line([0 length(sampData)] , [handles.voltThresh*-1 handles.voltThresh*-1],'Color', 'c', 'LineStyle','--','LineWidth',2);
        end
        
        axes(handles.allClust)
        mWf = mean(waveForms,2);
        sWf = std(waveForms, [], 2);
        pmWf = mWf + sWf;
        mmWf = mWf - sWf;
        plot(mWf,'k-');
        hold on
        plot(pmWf,'k--');
        plot(mmWf,'k--');
        xlim([1 totLen]);
        
        if isempty(waveForms)
            ylim([-1500 1500])
        else
            ylim([min(waveForms(:)) max(waveForms(:))]);
        end
        
        handles.allClust.XTick = [];
        handles.allClust.YTick = [];
        titleStr = ['All waveforms = ' , num2str(size(waveForms,2))];
        title(titleStr);
        
        

        
end






% --- Executes when selected object is changed in posNegT.
function posNegT_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in posNegT
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = get(hObject);

if strcmp(selection.String,'Positive') && selection.Value == 1
    handles.pnFlag = 1;
    handles.thTag.String = 'Positive';
    handles.thTag.ForegroundColor = 'r';
    handles.threshold.Enable = 'on';
elseif strcmp(selection.String,'Negative') && selection.Value == 1
    handles.pnFlag = 0;
    handles.thTag.String = 'Negative';
    handles.thTag.ForegroundColor = 'm';
    handles.threshold.Enable = 'on';
end
guidata(hObject , handles);


% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
SpikeThreshold_AT_v1;







% --- Executes during object creation, after setting all properties.
function loadSel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadSel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function adv_opts_Callback(hObject, eventdata, handles)
% hObject    handle to adv_opts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function minDIST_Callback(hObject, eventdata, handles)
% hObject    handle to minDIST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Min Distance btwn spikes (ms)'};
dlg_title = 'Min Dist.';
num_lines = [1 35];
defaultans = {num2str(handles.minSPdist)};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

handles.minSPdist = str2double(answer{1});

guidata(hObject , handles);



function sd_Th_Callback(hObject, eventdata, handles)
% hObject    handle to sd_Th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd_Th as text
%        str2double(get(hObject,'String')) returns contents of sd_Th as a double
sd_Thresh = str2double(handles.sd_Th.String);

axes(handles.spikeDact)

sampData = handles.spikeDataRaw;
% plot(sampData,'k');
mSamp = mean(double(sampData));
sdSamp = std(double(sampData));

minT = (mSamp + (sdSamp*sd_Thresh))*-1;
maxT = mSamp + (sdSamp*sd_Thresh);

ylim([minT maxT]);

% --- Executes during object creation, after setting all properties.
function sd_Th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd_Th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
