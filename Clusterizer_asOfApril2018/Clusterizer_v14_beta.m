function varargout = Clusterizer_v14_beta(varargin)
% CLUSTERIZER_V14_BETA MATLAB code for Clusterizer_v14_beta.fig
%      CLUSTERIZER_V14_BETA, by itself, creates a new CLUSTERIZER_V14_BETA or raises the existing
%      singleton*.
%
%      H = CLUSTERIZER_V14_BETA returns the handle to a new CLUSTERIZER_V14_BETA or the handle to
%      the existing singleton*.
%
%      CLUSTERIZER_V14_BETA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTERIZER_V14_BETA.M with the given input arguments.
%
%      CLUSTERIZER_V14_BETA('Property','Value',...) creates a new CLUSTERIZER_V14_BETA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Clusterizer_v14_beta_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Clusterizer_v14_beta_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Clusterizer_v14_beta

% Last Modified by GUIDE v2.5 21-Feb-2020 16:01:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Clusterizer_v14_beta_OpeningFcn, ...
    'gui_OutputFcn',  @Clusterizer_v14_beta_OutputFcn, ...
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


% --- Executes just before Clusterizer_v14_beta is made visible.
function Clusterizer_v14_beta_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Clusterizer_v14_beta (see VARARGIN)

% Choose default command line output for Clusterizer_v14_beta
handles.output = hObject;

for ci = 1:6
    handles.(['Clu',num2str(ci)]).Enable = 'off';
    handles.(['Clu',num2str(ci)]).ForegroundColor = 'k';
end

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

handles.combineTog.Enable = 'off';
handles.deleteTog.Enable = 'off';
handles.refineTog.Enable = 'off';


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Clusterizer_v14_beta wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Clusterizer_v14_beta_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






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

saveNAME = ['spkData_',abNUM,'_',depthN,'_',eleNUMs,'_clzD.mat'];

% (i)
spikeDATA.clustIDS = handles.clustID;
% (ii)
spikeDATA.waveforms = handles.waveForms;
% (iii)
spikeDATA.thresholdINFO.thresholdSD = handles.threshUsed;
spikeDATA.thresholdINFO.kmeansN = handles.kmeansNUsed;
% (iv)
spikeDATA.clustMetrics = handles.cluMets;
% (v)
spikeDATA.features = handles.features;
spikeDATA.merFs = handles.spkFS;
% (vi)

spikeDATA.fileINFO.abNUM = abNUM;
spikeDATA.fileINFO.depthN = depthN;
spikeDATA.fileINFO.eleNUM = eleNUM;
spikeDATA.fileINFO.analyzDATE = date;
% (vii)
spikeDATA.numClusts = handles.numClusts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADD output for Andy Auditory taskbase
% need time, threshold points well isolated
spikeDATA.atIO.spFS = handles.spkFS;
spikeDATA.atIO.sptimeST = handles.startT;
spikeDATA.atIO.timestamps = handles.waveForms.allWavesInfo.alllocs;
spikeDATA.atIO.clustIDs = handles.clustID;
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

% Update handles structure
guidata(hObject, handles);



function handles = loadNEXTh(handles)

handles.allClust.Visible = 'off';
handles.clust1.Visible = 'off';
handles.clust2.Visible = 'off';
handles.clust3.Visible = 'off';
handles.clust4.Visible = 'off';
handles.clust5.Visible = 'off';
handles.clust6.Visible = 'off';
handles.clust7.Visible = 'off';
handles.clust8.Visible = 'off';
handles.meanClusts.Visible = 'off';
handles.expClus.Enable = 'off';
handles.template.Enable = 'off';
handles.clusterSpk.Enable = 'off';
handles.delClusts.Enable = 'off';
handles.threshold.Enable = 'off';
handles.deleteTrace.Enable = 'off';
handles.subTask.Enable = 'off';
handles.loadTest.Enable = 'on';

handles.manualThresh.Enable = 'off';
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

% [ thresh2use , Knum2use ] = threshEstimate_v2b( sampData , spkData,  handles.spkFS , handles.pnFlag);

% handles.infotext.String = 'Finding Peaks...';
% handles.infotext.ForegroundColor = 'm';
% drawnow;

thresh = (round(std(double(sampData)) * 3) + mean(double(sampData)));
noise = (round(std(double(sampData)) * 20) + mean(double(sampData)));
minDist = round(handles.spkFS/1000) * handles.minSPdist; % was 1.5

tic;
[ waveData ] = extractWaveforms_Clz_v06(spkData, thresh, noise, minDist, handles.spkFS, handles.pnFlag);
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

handles.threshUsed = 3;
handles.kmeansNUsed = 3;
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

% Indicate threshold in window

handles.manThval.String = num2str(3);
handles.manualThresh.Value = 3;
handles.manualThresh.Enable = 'on';
% Activate manual override

% Activate emergency delete

handles.deleteTrace.Enable = 'on';

% Update handles structure
guidata(hObject, handles);




% --------------------------------------------------------------------
function clusterSpk_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to clusterSpk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.infotext.String = 'Clustering...';
handles.infotext.ForegroundColor = 'r';
drawnow;

waveForms = handles.waveForms.allWaves.waves;

if size(waveForms,2) >= 5
    
    [ xFeats ] = createSpkFeatures( waveForms,  handles.spkFS  );
    
    [idxF,Cen] = kmeans(xFeats,handles.kmeansNUsed,'Distance','cityblock',...
        'Replicates',6);
    
    [ nidx , handles.cluMets , ~] = spkClusterQual( xFeats, idxF, Cen, 2 );
    
    numClusts = numel(unique(nidx));
    handles.numClusts = numClusts;
    
    cluID = unique(nidx);
    handles.actClIDS = cluID;
    
    cfilt = nidx;
    handles.clustID = cfilt;
    handles.features = xFeats;
else
    handles.numClusts = 1;
    handles.actClIDS = 1;
    handles.clustID = 1;
    handles.features = nan;
end

cla(handles.meanClusts);

clearWavePlots(handles)

plotRastWaves(handles, '3', 'cluster')

handles.infotext.String = 'Clusters Found!';
handles.infotext.ForegroundColor = [0 0.4980 0];
drawnow;

%%% Following Thresholding
% 1. Make Combine available
% 2. Make Delete available
% 3. Make Template available
% 4. Close cluster

% INITIATE BUTTONS

handles.expClus.Enable = 'on';
handles.threshold.Enable = 'off';
handles.clusterSpk.Enable = 'off';
handles.template.Enable = 'off';
handles.combineClus.Enable = 'off';
handles.delClusts.Enable = 'off';


handles.subTask.Enable = 'on';
% Update handles structure
guidata(hObject, handles);



% --- Executes on slider movement.
function manualThresh_Callback(hObject, eventdata, handles)
% hObject    handle to manualThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.clusterSpk.Enable = 'on';
handles.expClus.Enable = 'off';
handles.combineTog.Enable = 'off';
handles.deleteTog.Enable = 'off';
handles.refineTog.Enable = 'off';

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

% [ ~ , Knum2use ] = threshEstimate_v2b( sampData , spkData,  handles.spkFS , handles.pnFlag);

handles.infotext.String = 'Finding Peaks...';
handles.infotext.ForegroundColor = 'm';
drawnow;

thresh2use = handles.manualThresh.Value;

thresh = (round(std(double(sampData)) * thresh2use) + mean(double(sampData)));
noise = (round(std(double(sampData)) * 20) + mean(double(sampData)));
minDist = round(handles.spkFS/1000) * handles.minSPdist;

tic;
% [ waveData ] = extractWaveforms_Clz_v02(spkData, thresh, noise, minDist, handles.spkFS);
[ waveData ] = extractWaveforms_Clz_v06(spkData, thresh, noise, minDist, handles.spkFS, handles.pnFlag);

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
handles.kmeansNUsed = 3;
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
% handles.clusterSpk.Enable = 'on';
% handles.deleteTrace.Enable = 'on';
handles.expClus.Enable = 'off';

clearWavePlots(handles);

plotRastWaves(handles, 'new')
plotRastWaves(handles, 'threshold')

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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     set(handles.manualThresh,'Value',str2double(handles.manThval.String));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% --------------------------------------------------------------------
function deleteTrace_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to deleteTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clean GUI - prepare for next trace

% handles.fedTable;

tempTable = handles.fedTable;

eleUPdateNum = handles.fedTable.ElNum{handles.activeFileNum};

keepInd = true(height(tempTable),1);

keepInd(handles.activeFileNum) = false;

handles.fedTable = tempTable(keepInd,:);

cd(handles.LoadLoc)
% Update table

% load in old table
% compare and save

%%%%%
% UPDATE
% DepthID
% DepthIND

depUPdateInd = ismember(handles.DepthID,handles.activeFileName);
% eleUPdateNum = handles.fedTable.ElNum{handles.activeFileNum};
ele2ch = str2double(eleUPdateNum(length(eleUPdateNum)));

handles.DepthIND{depUPdateInd,1}(ele2ch) = 0;

% activefileNum
% activefileName
% fedtable

% Resave file with appended table
fedTable = handles.fedTable;
DepthIND = handles.DepthIND;
save(handles.oriFload, 'fedTable','DepthIND','-append');

%%%% UPDATE

% (4) Load next file

handles.activeFileNum = handles.activeFileNum;

if handles.activeFileNum > length(handles.fedTable.Depth)
    
    handles.allClust.Visible = 'off';
    handles.clust1.Visible = 'off';
    handles.clust2.Visible = 'off';
    handles.clust3.Visible = 'off';
    handles.clust4.Visible = 'off';
    handles.clust5.Visible = 'off';
    handles.clust6.Visible = 'off';
    
    handles.meanClusts.Visible = 'off';
    handles.expClus.Enable = 'off';
    handles.template.Enable = 'off';
    handles.clusterSpk.Enable = 'off';
    handles.delClusts.Enable = 'off';
    handles.threshold.Enable = 'off';
    handles.deleteTrace.Enable = 'off';
    handles.loadTest.Enable = 'on';
    
    handles.manualThresh.Enable = 'off';
    handles.manualThresh.Value = 4;
    handles.manThval.String = '4';
    
    clearWavePlots(handles)
    
    handles.ddepNUM.String = 'DONE';
    handles.eleNUM.String = 'LOAD NEXT!';
    handles.infotext.String = 'LOAD NEXT!';
    
else
    
    handles.activeFileName = handles.fedTable.Depth{handles.activeFileNum};
    
    handles.infotext.String = 'Loading next cell...';
    handles.infotext.ForegroundColor = 'r';
    drawnow;
    
    cd(handles.RAWfilesLOC);
    load(handles.activeFileName);
    handles.spkFS = mer.sampFreqHz;
    
    handles.spikeDataRaw = eval(handles.fedTable.ElNum{handles.activeFileNum});
    
    handles.infotext.String = 'Next File Loaded!!';
    handles.infotext.ForegroundColor = [0 0.4980 0];
    
    drawnow;
    
    handles.ddepNUM.String = handles.activeFileName;
    handles.eleNUM.String = handles.fedTable.ElNum{handles.activeFileNum};
    
    clearWavePlots(handles)
    plotRastWaves(handles, 'new')
end

% Reset Manual Threshold
handles.manualThresh.Enable = 'off';
handles.manualThresh.Value = 4;
handles.manThval.String = '4';

% Reset Buttons
handles.threshold.Enable = 'on';
handles.clusterSpk.Enable = 'off';
handles.deleteTrace.Enable = 'off';

% Update handles structure
guidata(hObject, handles);


%%% --------------------------------------------------------------------%%%
% UTILITIES
%%% --------------------------------------------------------------------%%%


function handles = clearWavePlots(handles)

for ci = 1:6
    tmpClustIa = ['clust' , num2str(ci)];
    tmpClustIb = ['sdC' , num2str(ci)];
    cla(handles.(tmpClustIa))
    handles.(tmpClustIa).Color = [0.9412 0.9412 0.9412];
    handles.(tmpClustIa).Title = [];
    
    cla(handles.(tmpClustIb))
    handles.(tmpClustIa).Color = [0.9412 0.9412 0.9412];
end


cla(handles.meanClusts)
handles.meanClusts.Color = [0.9412 0.9412 0.9412];





function handles = plotRastWaves(handles, stage, sub)


switch stage
    
    case 'new'
        
        
        % TIME
        timeDurSpk = round(length(handles.spikeDataRaw)/handles.spkFS,2);
        handles.timeDur.String = [num2str(timeDurSpk) , ' seconds'];
        
        cla(handles.allClust)
        handles.allClust.Color = [0.9412 0.9412 0.9412];
        handles.allClust.Title = [];
        
%         sampData = handles.spikeDataRaw;
%         plotSampData = decimate(double(sampData),10);

%         mSamp = mean(double(sampData));
%         sdSamp = std(double(sampData));
        
        % SD Threshold
%         sd_Thresh = str2double(handles.sd_Th.String);
        
%         minT = (mSamp + (sdSamp*sd_Thresh))*-1;
%         maxT = mSamp + (sdSamp*sd_Thresh);
        
        
    case 'threshold'
        
%         cla(handles.spikeDact);
        cla(handles.allClust)
        
        % TIME
        timeDurSpk = round(length(handles.spikeDataRaw)/handles.spkFS,2);
        handles.timeDur.String = [num2str(timeDurSpk) , ' seconds'];
        
        handles.allClust.Color = [0.9412 0.9412 0.9412];
        handles.allClust.Title = [];
        
%         sampData = handles.spikeDataRaw;
%         waveLocs = handles.peakIndex;
        waveForms = handles.waveForms.allWaves.waves;
        totLen = handles.XLIMa;
        
        
        hold on

        %%%%% USE DECIMATE
%         plotSampData = decimate(double(sampData),10);
%         plot(plotSampData,'k');

%         mSamp = mean(double(sampData));
%         sdSamp = std(double(sampData));
%         % SD Threshold
%         sd_Thresh = str2double(handles.sd_Th.String);
%         
%         minT = (mSamp + (sdSamp*sd_Thresh))*-1;
%         maxT = mSamp + (sdSamp*sd_Thresh);
%         
%         voltthresh = (round(std(double(sampData)) * handles.threshUsed) + mean(double(sampData)));
        
        % handles.voltThresh

        
        axes(handles.allClust)
        %         p = plot(waveForms,'k');
        
        hold on
        
        if size(waveForms,2) > 200
           
            rwInd = randi(size(waveForms,2),1,200);
            
        else
            
            rwInd = 1:size(waveForms,2);
            
        end
        
        for k = 1:length(rwInd)
            tmpW = rwInd(k);
            patchline(1:size(waveForms,1),waveForms(:,tmpW),'linestyle','-','edgecolor','k','linewidth',1,'edgealpha',0.05)
        end
        
        
        %         p.Color(4) = 0.5;
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
        
    case '3'
        
        switch sub
            case 'cluster'
                
                % Set up data to plot
                numClusts = handles.numClusts; % Single value with number of clusters
                cluID = handles.actClIDS; % Index vector (length of samples) with cluster IDs
                cfilt = handles.clustID; % Vector with actual cluster IDs
                waveForms = handles.waveForms.allWaves.waves; % Waveforms
                
                handles.infotext.String = 'Clusters Done!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'temp-sing'
                
                % Set up data to plot
                numClusts = handles.numClusts;
                cluID = handles.actClIDS;
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Templates Done!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'combine-clus'
                
                numClusts = handles.numClusts;
                cluID = unique(handles.clustID(handles.clustID > 0));
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Clusters Combined!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'delete-clus'
                
                numClusts = handles.numClusts;
                cluID = unique(handles.clustID(handles.clustID > 0));
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Clusters Combined!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'temp-inc'
                
                numClusts = handles.numClusts;
                cluID = unique(handles.clustID(handles.clustID > 0));
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Template Inclusive!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'temp-exc'
                
                numClusts = handles.numClusts;
                cluID = unique(handles.clustID(handles.clustID > 0));
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Template Exclusive!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
            case 'clust-sing'
                
                numClusts = handles.numClusts;
                cluID = unique(handles.clustID(handles.clustID > 0));
                cfilt = handles.clustID;
                waveForms = handles.waveForms.allWaves.waves;
                
                handles.infotext.String = 'Re-Clustered!';
                handles.infotext.ForegroundColor = [0 0.6 0];
                drawnow;
                
                
        end
        
        colors2 = [1 0 0 ;...
            0 0 1 ;...
            0 0.5 0 ;...
            0.4941 0.1843 0.5569 ;...
            0.8706 0.4902 0 ;...
            1 0 1];
        cla(handles.meanClusts)
        tyMax = 100;
        tyMin = -100;
        sdMAX = 100;
        sdMIN = -100;
        for ni = 1:numClusts
            
            cluN = cluID(ni);
            
            cla(handles.(strcat('clust',num2str(ni))))
            axes(handles.(strcat('clust',num2str(ni))))
            
            c1Waves = waveForms(:,cfilt == cluN);
            
            mW = mean(c1Waves,2);
            sW = std(c1Waves,[],2);
            uW = mW + (sW*2);
            dW = mW - (sW*2);
            
            % Plot outliers
            allc1Wvs = transpose(c1Waves);
            
            if size(allc1Wvs,1) < 30
                toPlotOut = 1:size(allc1Wvs,1);
            else
                toPlotOut = randi(size(allc1Wvs,1),1,30);
            end
            
            plot(transpose(allc1Wvs(logical(toPlotOut),:)),'k','LineWidth',0.09)
            hold on
            plot(mW,'Color',colors2(ni,:) ,'LineWidth',4)
            plot(uW,'Color',colors2(ni,:) ,'LineStyle','--','LineWidth',2)
            plot(dW,'Color',colors2(ni,:) ,'LineStyle','--','LineWidth',2)
            
            
            tWaveforms = waveForms(:,cfilt == cluN);
            
            if isempty(tWaveforms)
                ylim([-300 300])
            else
                ylim([min(tWaveforms(:)) max(tWaveforms(:))]);
            end
            
            % AXIS INFO FOR Individual cluster plots
            xlim([1 handles.XLIMa]);
            handles.(strcat('clust',num2str(ni))).XTick = [];
            handles.(strcat('clust',num2str(ni))).YTick = [];
            
            numWaves = sum(cfilt == cluN);
            
            titleStr = ['Clust ', num2str(ni) , ' = '  , num2str(numWaves)];
            title(titleStr,'Color',colors2(ni,:));
            
            axes(handles.meanClusts)  %#ok<*LAXES>
            hold on
            plot(mean(waveForms(:,cfilt == cluN),2),'Color',colors2(ni,:),'LineWidth',2.5)
            % UPDATED min and max
            aveWave = mean(waveForms(:,cfilt == cluN),2);
            sdWave = std(waveForms(:,cfilt == cluN),[],2);
            UPwave = aveWave + sdWave;
            DNwave = aveWave - sdWave;
            
            baseX = 1:1:length(aveWave);
            patX = [baseX fliplr(baseX)];
            patY = [transpose(DNwave) fliplr(transpose(UPwave))];
            
            if min(aveWave) < tyMin
                tyMin = min(aveWave);
            end
            
            if max(aveWave) > tyMax
                tyMax = max(aveWave);
            end
            
            if min(patY) < sdMIN
                sdMIN = min(patY);
            end
            
            if max(patY) > sdMAX
                sdMAX = max(patY);
            end
            
            % AXIS INFO FOR Mean plot
            ylim([tyMin tyMax]);
            xlim([1 handles.XLIMa]);
            handles.(strcat('clust',num2str(ni))).XTick = [];
            handles.(strcat('clust',num2str(ni))).YTick = [];
            
            cla(handles.(strcat('sdC',num2str(ni))))
            axes(handles.(strcat('sdC',num2str(ni))))
            
            patch(patX,patY,colors2(ni,:),'EdgeColor','none','FaceAlpha',0.7);
            
            %             ylim([min(tWaveforms(:)) max(tWaveforms(:))])
            ylim([sdMIN sdMAX])
            xlim([1 handles.XLIMa])
            handles.(strcat('sdC',num2str(ni))).XTick = [];
            handles.(strcat('sdC',num2str(ni))).YTick = [];
            
        end
        hold off
        
        % Update Spike Trace
%         spkData = handles.spkData;
%         pks = handles.peakIndex;
% 
% 
%         mSamp = mean(double(spkData));
%         sdSamp = std(double(spkData));
%         SD Threshold
%         sd_Thresh = str2double(handles.sd_Th.String);
%         
%         minT = (mSamp + (sdSamp*sd_Thresh))*-1;
%         maxT = mSamp + (sdSamp*sd_Thresh);
%         
%         hold on
%         for nii = 1:numClusts
%             
%             cluN = cluID(nii);
%             
%             
%             if isfield(handles.waveForms,'posWaveInfo')
%                 
%                 
%                 line(handles.waveForms.posWaveInfo.positions(:,cfilt == cluN),...
%                     handles.waveForms.posWaveInfo.waves(:,cfilt == cluN),'Color',colors2(nii,:))
%                 
%             else
%                 
%                 line(handles.waveForms.negWaveInfo.positions(:,cfilt == cluN),...
%                     handles.waveForms.negWaveInfo.waves(:,cfilt == cluN),'Color',colors2(nii,:))
%                 
%                 
%             end
%             
%             %             scatter(pks(cfilt == cluN),spkData(pks(cfilt == cluN)),6,colors2(nii,:),'filled');
%             
%             hold on
%         end

        
end


% --- Executes on button press in Clu1.
function Clu1_Callback(hObject, eventdata, handles)
% hObject    handle to Clu1 (see GCBO)

% --- Executes on button press in Clu2.
function Clu2_Callback(hObject, eventdata, handles)
% hObject    handle to Clu2 (see GCBO)

% --- Executes on button press in Clu3.
function Clu3_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to Clu3 (see GCBO)

% --- Executes on button press in Clu4.
function Clu4_Callback(hObject, eventdata, handles)
% hObject    handle to Clu4 (see GCBO)

% --- Executes on button press in Clu5.
function Clu5_Callback(hObject, eventdata, handles)
% hObject    handle to Clu5 (see GCBO)

% --- Executes on button press in Clu6.
function Clu6_Callback(hObject, eventdata, handles)
% hObject    handle to Clu6 (see GCBO)

% --- Executes on button press in tExlTog.
function tExlTog_Callback(hObject, eventdata, handles)
% hObject    handle to tExlTog (see GCBO)

% --- Executes on button press in cluSinTog.
function cluSinTog_Callback(hObject, eventdata, handles)
% hObject    handle to cluSinTog (see GCBO)

% --- Executes on button press in tExC1.
function tExC1_Callback(hObject, eventdata, handles)
% hObject    handle to tExC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tExC1

% --- Executes on button press in clsC1.
function clsC1_Callback(hObject, eventdata, handles)
% hObject    handle to clsC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clsC1

% --- Executes on selection change in subTask.
function subTask_Callback(hObject, eventdata, handles)
% hObject    handle to subTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subTask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subTask

subSELECT = handles.subTask.String{handles.subTask.Value};
subSELECT = (strtrim(subSELECT));

if strcmp(subSELECT,'Select...')
    return
end

for uci = 1:6
    
    handles.(['Clu',num2str(uci)]).Value = 0;
    handles.(['Clu',num2str(uci)]).Enable = 'off';
    handles.(['Clu',num2str(uci)]).ForegroundColor = 'k';
    
end

colorS = [1 0 0 ;...
    0 0 1 ;...
    0 0.4980 0 ;...
    0.4941 0.1843 0.5569 ;...
    0.8706 0.4902 0 ;...
    1 0 1];

for nii = 1:handles.numClusts
    
    handles.(['Clu',num2str(nii)]).Enable = 'on';
    handles.(['Clu',num2str(nii)]).ForegroundColor = colorS(nii,:);
    
end

% INITIATE BUTTONS
handles.expClus.Enable = 'on';
handles.threshold.Enable = 'off';
handles.clusterSpk.Enable = 'on';

switch subSELECT
    
    case 'COMBINE'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'Combine Clusters';
        handles.ACTION.ForegroundColor = 'k';
        
    case 'DELETE'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'Delete Clusters';
        handles.ACTION.ForegroundColor = [0.529 0.318 0.318];
        
    case 'TEMPLATE-Single'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'T-Refine Clusters';
        handles.ACTION.ForegroundColor = [0.0 0.447 0.741];
        
    case 'TEMPLATE-Inclusive'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'T-Inclusive (0&1)';
        handles.ACTION.ForegroundColor = [0.467 0.675 0.188];
        
    case 'TEMPLATE-Exclusive'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'T-Exclusive (1)';
        handles.ACTION.ForegroundColor = [0.0 0.6 0.6];
        
    case 'CLUSTER-Single'
        
        handles.ACTION.Enable = 'on';
        handles.ACTION.String = 'Cluster';
        handles.ACTION.ForegroundColor = [1 0.1 0.1];
        
        
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function subTask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subTask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ACTION.
function ACTION_Callback(hObject, eventdata, handles)
% hObject    handle to ACTION (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

subSELECT = handles.subTask.String{handles.subTask.Value};
subSELECT = (strtrim(subSELECT));

if strcmp(subSELECT,'Select...')
    return
end

rdiOButons = zeros(6,1);

for i = 1:6
    
    val = handles.(['Clu',num2str(i)]).Value;
    if val
        rdiOButons(i) = 1;
    end
end

if sum(rdiOButons) == 0
    
    % INITIATE BUTTONS
    handles.expClus.Enable = 'on';
    handles.threshold.Enable = 'off';
    handles.clusterSpk.Enable = 'on';
    
    return
    
else
    
    for uci = 1:6
        
        handles.(['Clu',num2str(uci)]).Value = 0;
        handles.(['Clu',num2str(uci)]).Enable = 'off';
        handles.(['Clu',num2str(uci)]).ForegroundColor = 'k';
        
    end
    
end


switch subSELECT
    
    case 'COMBINE'
        % Combine waveforms with indicies that match the two selected clusters
        % Plot in the n - 1 window number
        % Actual clusterIDS
        
        actClus = handles.actClIDS;
        cluAcom = [transpose(1:length(actClus)) , actClus];
        
        % First combine clusters
        cmINDs2 = logical(rdiOButons(1:length(actClus)));
        inds2com = cluAcom(cmINDs2,2);
        
        newClu = max(actClus) + 1;
        
        newClID = handles.clustID;
        for ii = 1:length(inds2com)
            
            curIndsT = handles.clustID == inds2com(ii);
            
            newClID(curIndsT) = newClu;
            
        end
        
        handles.clustID = newClID;
        handles.numClusts = numel(unique(newClID(newClID > 0)));
        handles.actClIDS = unique(newClID(newClID > 0));
        
        % REPLOT SPIKE STUFF
        handles.infotext.String = 'UPDATING clusters...';
        handles.infotext.ForegroundColor = 'r';
        drawnow;
        
        cla(handles.meanClusts);
        
        clearWavePlots(handles)
        
        plotRastWaves(handles, '3', 'combine-clus')
        
        handles.infotext.String = 'Clusters Combined!';
        
        
    case 'DELETE'
        
        % Combine waveforms with indicies that match the two selected clusters
        % Plot in the n - 1 window number
        % Actual clusterIDS
        actClus = handles.actClIDS;
        cluAcom = [transpose(1:length(actClus)) , actClus];
        
        % First combine clusters
        delINDs2 = logical(rdiOButons(1:length(actClus)));
        inds2del = cluAcom(delINDs2,2);
        
        newClID = handles.clustID;
        for ii = 1:length(inds2del)
            
            curIndsT = handles.clustID == inds2del(ii);
            
            newClID(curIndsT) = 0;
            
        end
        
        handles.clustID = newClID;
        handles.numClusts = numel(unique(newClID(newClID > 0)));
        handles.actClIDS = unique(newClID(newClID > 0));
        
        % REPLOT SPIKE STUFF
        handles.infotext.String = 'UPDATING clusters...';
        handles.infotext.ForegroundColor = 'r';
        drawnow;
        
        cla(handles.meanClusts);
        
        clearWavePlots(handles)
        
        plotRastWaves(handles, '3', 'delete-clus')
        
        handles.infotext.String = 'Clusters Deleted!';
        
    case 'TEMPLATE-Single'
        
        % Available Cluster IDS
        actClus = handles.actClIDS;
        % Get Cluster ID to change
        cmINDs2 = logical(rdiOButons(1:length(actClus)));
        inds2refine = actClus(cmINDs2);
        num2refine = numel(inds2refine);
        
        % Actual index for first block
        
        for cci = 1:num2refine
            curIndsT = find(handles.clustID == inds2refine(cci));
            
            % Actual waves
            actwaves = handles.waveForms.allWaves.waves(:,handles.clustID == inds2refine(cci));
            
            
            handles.infotext.String = 'Template Matching...';
            handles.infotext.ForegroundColor = 'r';
            drawnow;
            
            
            newcluInds = handles.clustID;
            
            
            [corInds] = computeASCI_Clz_v05(actwaves); % was v2
            keepInds = curIndsT(corInds);
            excluInds = curIndsT(~(corInds));
            
            newcluInds(keepInds) = inds2refine(cci);
            nActClu = max(actClus) + 1;
            newcluInds(excluInds) = nActClu;
            actClus = [actClus ; nActClu]; %#ok<AGROW>
            
            
            nuClid1 = unique(newcluInds);
            nuClid2 = nuClid1(nuClid1 ~= 0);
            % Overwrite DATA
            % Cluster IDS
            
            % CHECK cluster NUMBER
            if numel(nuClid2) >= 6
                
                cla(handles.meanClusts);
                
                plotRastWaves(handles, '3', 'temp-sing')
                warndlg('Too many clusters')
                break
                
                
            else
                
                handles.clustID = newcluInds;
                handles.actClIDS = nuClid2;
                handles.numClusts = numel(nuClid2);
                
                cla(handles.meanClusts);
                
                plotRastWaves(handles, '3', 'temp-sing')
            end
            
        end
        
        
        
        
        
        handles.infotext.String = 'Templates Refined!';
        
        
    case 'TEMPLATE-Inclusive'
        
        actClus = handles.actClIDS;
        addClust = max(actClus) + 1;
        % First combine clusters
        cmINDs2 = logical(rdiOButons(1:length(actClus)));
        keepClusts = actClus(~cmINDs2);
        
        inds2refine = actClus(cmINDs2);
        
        allwaves = handles.waveForms.allWaves.waves;
        
        tmpCluInds = handles.clustID;
        tmpCluInds(tmpCluInds == 0) = addClust;
        
        cInds2INCrefine = [addClust ; inds2refine];
        tINC_cIND = tmpCluInds;
        tINC_cIND(~ismember(tINC_cIND,cInds2INCrefine)) = 0;
        
        [corInds] = computeASCI_Clz_v01a(allwaves, tINC_cIND);
        
        % Get indices for kept clusters
        keptTemp = handles.clustID;
        keptTemp(~ismember(keptTemp,keepClusts)) = 0;
        
        % Combine
        newTSingCls = keptTemp;
        newTSingCls(corInds ~= 0) = corInds(corInds ~= 0);
        
        handles.clustID = newTSingCls;
        handles.actClIDS = unique(newTSingCls(newTSingCls ~= 0));
        handles.numClusts = numel(handles.actClIDS);
        
        cla(handles.meanClusts);
        
        plotRastWaves(handles, '3', 'temp-inc') %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        handles.infotext.String = 'Templates-INC Refined!';
        
        
    case 'TEMPLATE-Exclusive'
        
        actClus = handles.actClIDS;
        
        cmINDs2 = logical(rdiOButons(1:length(actClus)));
        
        keepClusts = actClus(~cmINDs2);
        
        inds2refine = actClus(cmINDs2);
        
        allwaves = handles.waveForms.allWaves.waves;
        tmpCluInds = handles.clustID;
        
        tINC_cIND = tmpCluInds;
        tINC_cIND(~ismember(tINC_cIND,inds2refine)) = 0;
        
        [corInds] = computeASCI_Clz_v01ex(allwaves, tINC_cIND);
        
        % Get indices for kept clusters
        keptTemp = handles.clustID;
        keptTemp(~ismember(keptTemp,keepClusts)) = 0;
        
        % Combine
        newTSingCls = keptTemp;
        newTSingCls(corInds ~= 0) = corInds(corInds ~= 0);
        
        handles.clustID = newTSingCls;
        handles.actClIDS = unique(newTSingCls(newTSingCls ~= 0));
        handles.numClusts = numel(handles.actClIDS);
        
        cla(handles.meanClusts);
        
        plotRastWaves(handles, '3', 'temp-exc') %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        handles.infotext.String = 'Templates-EXC Refined!';
        
    case 'CLUSTER-Single'
        
        actClus = handles.actClIDS;
        
        cmINDs2 = logical(rdiOButons(1:length(actClus)));
        
        keepClusts = actClus(~cmINDs2);
        
        inds2refine = actClus(cmINDs2);
        
        allwaves = handles.waveForms.allWaves.waves;
        
        tmpCluInds = handles.clustID;
        
        Fs = handles.spkFS;
        
        %         [ newIndex ] = clusterSingle_v1( allwaves, tmpCluInds, inds2refine, Fs);
        
        [ newIndex , exceedflag ] = clusterSingle_v2( allwaves, tmpCluInds, inds2refine, Fs);
        
        if ~exceedflag
            
            handles.clustID = newIndex;
            handles.actClIDS = unique(newIndex(newIndex ~= 0));
            handles.numClusts = numel(handles.actClIDS);
            
            cla(handles.meanClusts);
            
            plotRastWaves(handles, '3', 'clust-sing') %%%%%%%%%%%%%%%%%%%%%%%%%%
            
            handles.infotext.String = 'New clusters created!';
            
        else
            
            warndlg('Too many clusters')
            
        end
        
end

handles.subTask.Value = 1;
handles.ACTION.String = 'Waiting...';
handles.ACTION.ForegroundColor = 'k';
handles.ACTION.Enable = 'off';

% Update handles structure
guidata(hObject, handles);


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
Clusterizer_v14_beta;




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


function loadTest_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
% hObject    handle to loadTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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

handles.infotext.String = 'Loading files...';
handles.infotext.ForegroundColor = 'r';
drawnow;

handles.infotext.String = 'File Loaded!!';
handles.infotext.ForegroundColor = [0 0.4980 0];
drawnow;

handles.oriFload = file2load;


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


% Update handles structure
guidata(hObject, handles);