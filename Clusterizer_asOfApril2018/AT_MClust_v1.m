function varargout = AT_MClust_v1(varargin)
% AT_MCLUST_V1 MATLAB code for AT_MClust_v1.fig
%      AT_MCLUST_V1, by itself, creates a new AT_MCLUST_V1 or raises the existing
%      singleton*.
%
%      H = AT_MCLUST_V1 returns the handle to a new AT_MCLUST_V1 or the handle to
%      the existing singleton*.
%
%      AT_MCLUST_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AT_MCLUST_V1.M with the given input arguments.
%
%      AT_MCLUST_V1('Property','Value',...) creates a new AT_MCLUST_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AT_MClust_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AT_MClust_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AT_MClust_v1

% Last Modified by GUIDE v2.5 19-Mar-2018 12:56:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AT_MClust_v1_OpeningFcn, ...
    'gui_OutputFcn',  @AT_MClust_v1_OutputFcn, ...
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


% --- Executes just before AT_MClust_v1 is made visible.
function AT_MClust_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AT_MClust_v1 (see VARARGIN)

% Choose default command line output for AT_MClust_v1
handles.output = hObject;

handles.feature1.Enable = 'off';
handles.feature2.Enable = 'off';
handles.pScatter.Enable = 'off';

handles.mScat.XTick = [];
handles.mScat.YTick = [];
handles.clust1.XTick = [];
handles.clust1.YTick = [];
handles.clust2.XTick = [];
handles.clust2.YTick = [];
handles.noise.XTick = [];
handles.noise.YTick = [];
handles.timePlot.XTick = [];
handles.timePlot.YTick = [];



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AT_MClust_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% TO DO
% 1. CREATE THRESHOLD PROGRAM
% 2. Compute cluster quality metrics
% 3. Create time series plot for occurance of clusters
% 4. Export data




% --- Outputs from this function are returned to the command line.
function varargout = AT_MClust_v1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%% LOAD FILE
% --------------------------------------------------------------------
function loadF_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to loadF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[rawDataFile,rawDataLoc,~] = uigetfile('','LOAD CELL MAT file');

% Load location with Spike Files to Cluster - RAW_Ephys_Files
handles.LoadLoc = rawDataLoc;

cd(handles.LoadLoc)

file2load = rawDataFile;

handles.features = {'peak','valley','energy','totalWidth','FDmin','SDmax','SDmin'};

load(file2load, 'spikeDATA');
handles.AllWaves = spikeDATA.waveforms.allWaves.waves;
handles.NOwaves = spikeDATA.waveforms.allWaves.waves;
handles.spTime = (spikeDATA.waveforms.allWavesInfo.alllocs)/44000;
handles.allPeaks = max(spikeDATA.waveforms.allWaves.waves);

% Turn off Load button
% Turn on Feature 1

handles.loadF.Enable = 'off';
handles.feature1.Enable = 'on';
handles.feature1.String = handles.features;
handles.spikeDATA = spikeDATA;

guidata(hObject, handles);



% --- Executes on selection change in feature1.
function feature1_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns feature1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from feature1

featsAll = handles.feature1.String;
featVal = handles.feature1.Value;
featSel = featsAll{featVal};

handles.xScat.Value = handles.spikeDATA.features(:,featVal);
handles.xScat.Label = featSel;

% Set up Feature 2
handles.feature1.Enable = 'off';
handles.feature2.Enable = 'on';
handles.feature2.String = handles.features;


guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function feature1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feature1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in feature2.
function feature2_Callback(hObject, eventdata, handles)
% hObject    handle to feature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns feature2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from feature2


featsAll = handles.feature2.String;
featVal = handles.feature2.Value;
featSel = featsAll{featVal};

handles.yScat.Value = handles.spikeDATA.features(:,featVal);
handles.yScat.Label = featSel;

handles.allCdata = [handles.xScat.Value , handles.yScat.Value , zeros(size(handles.yScat.Value))];
% Set up Feature 2

handles.feature2.Enable = 'off';
handles.pScatter.Enable = 'on';

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function feature2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feature2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pScatter.
function pScatter_Callback(hObject, eventdata, handles)
% hObject    handle to pScatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.mScat)
axes(handles.mScat)

handles.AllIndicies = [handles.xScat.Value , handles.yScat.Value];

% Plot scatter
plotRastWaves(handles, 'main-new')

handles.feature1.Enable = 'on';
handles.feature1.String = handles.features;

% Plot noise waves
plotRastWaves(handles, 'noise-new')

guidata(hObject, handles);


% --- Executes on button press in drawNew1.
function drawNew1_Callback(hObject, eventdata, handles)
% hObject    handle to drawNew1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw1.x = vertices(:,1);
handles.draw1.y = vertices(:,2);

% Create Cluster 1
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw1.x,handles.draw1.y);

% handles = makeClust(handles, 1 , inVals);

handles = modifyClust(handles, 1 , inVals , 'make');

plotRastWaves(handles, 'update-c1')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);


% --- Executes on button press in resetC1.
function resetC1_Callback(hObject, eventdata, handles)
% hObject    handle to resetC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

changeIND = handles.AllIndicies(:,3) == 1;

% handles = resetClust(handles, 1, changeIND);

handles = modifyClust(handles, 1 , changeIND , 'reset');

plotRastWaves(handles, 'update-c1')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);


% --- Executes on button press in addP1.
function addP1_Callback(hObject, eventdata, handles)
% hObject    handle to addP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw1.x = vertices(:,1);
handles.draw1.y = vertices(:,2);

% Add to Cluster 1
% notC1 = handles.AllIndicies(:,3) ~= 1;
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw1.x,handles.draw1.y);

handles = modifyClust(handles, 1 , inVals , 'add');

plotRastWaves(handles, 'update-c1')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);



% --- Executes on button press in trim1.
function trim1_Callback(hObject, eventdata, handles)
% hObject    handle to trim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw1.x = vertices(:,1);
handles.draw1.y = vertices(:,2);

% Add to Cluster 1
% notC1 = handles.AllIndicies(:,3) ~= 1;
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw1.x,handles.draw1.y);

handles = modifyClust(handles, 1 , inVals , 'trim');

plotRastWaves(handles, 'update-c1')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);





% --- Executes on button press in drawNew2.
function drawNew2_Callback(hObject, eventdata, handles)
% hObject    handle to drawNew2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw2.x = vertices(:,1);
handles.draw2.y = vertices(:,2);

% Create Cluster 1
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw2.x,handles.draw2.y);

% handles = makeClust(handles, 1 , inVals);

handles = modifyClust(handles, 2 , inVals , 'make');

plotRastWaves(handles, 'update-c2')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);


% --- Executes on button press in resetC2.
function resetC2_Callback(hObject, eventdata, handles)
% hObject    handle to resetC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


changeIND = handles.AllIndicies(:,3) == 2;

% handles = resetClust(handles, 1, changeIND);

handles = modifyClust(handles, 2 , changeIND , 'reset');

plotRastWaves(handles, 'update-c2')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);


% --- Executes on button press in addP2.
function addP2_Callback(hObject, eventdata, handles)
% hObject    handle to addP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw2.x = vertices(:,1);
handles.draw2.y = vertices(:,2);

% Add to Cluster 1
% notC1 = handles.AllIndicies(:,3) ~= 1;
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw2.x,handles.draw2.y);

handles = modifyClust(handles, 2 , inVals , 'add');

plotRastWaves(handles, 'update-c2')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);







% --- Executes on button press in trim2.
function trim2_Callback(hObject, eventdata, handles)
% hObject    handle to trim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.mScat)
h = impoly(handles.mScat);
vertices = getPosition(h);
vertices(end+1,:) = vertices(1,:);
delete(h);

handles.draw2.x = vertices(:,1);
handles.draw2.y = vertices(:,2);

% Add to Cluster 1
% notC1 = handles.AllIndicies(:,3) ~= 1;
[inVals , ~] = inpolygon(handles.AllIndicies(:,1),handles.AllIndicies(:,2),handles.draw2.x,handles.draw2.y);

handles = modifyClust(handles, 2 , inVals , 'trim');

plotRastWaves(handles, 'update-c2')

plotRastWaves(handles, 'update-noise')

guidata(hObject, handles);








function handles = plotRastWaves(handles, stage)


switch stage
    
    case 'main-new'
        
        cla(handles.clust1)
        axes(handles.clust1)
        title('')
        
        cla(handles.clust2)
        axes(handles.clust2)
        title('')
        
        cla(handles.mScat);
        axes(handles.mScat)
        
        plot(handles.xScat.Value, handles.yScat.Value,'k.')
        xlabel(handles.xScat.Label)
        ylabel(handles.yScat.Label)
        
        handles.mScat.XTick = [];
        handles.mScat.YTick = [];
        
        cla(handles.timePlot)
        axes(handles.timePlot)
        
        plot(handles.spTime,handles.allPeaks, 'k.')
        xlim([min(handles.spTime)  max(handles.spTime)])
        
        handles.timePlot.XTick = [];
        handles.timePlot.YTick = [];
        handles.timePlot.XTick = [min(handles.spTime)  max(handles.spTime)];
        handles.timePlot.XTickLabel = {'Start' , 'Stop'};
        
    case 'noise-new'
        
        cla(handles.noise);
        axes(handles.noise)
        mWf = mean(handles.NOwaves,2);
        sWf = std(handles.NOwaves, [], 2);
        pmWf = mWf + sWf;
        mmWf = mWf - sWf;
        plot(mWf,'k-');
        hold on
        plot(pmWf,'k--');
        plot(mmWf,'k--');
        xlim([1 size(handles.AllWaves,1)])
        ylim([min(min(handles.AllWaves)) max(max(handles.AllWaves))])
        title(['# Noise waves = ' , num2str(size(handles.AllWaves,2))])
        
        handles.noise.XTick = [];
        handles.noise.YTick = [];
        
    case 'update-c1'
        
        cla(handles.clust1)
        axes(handles.clust1)
        title('')
        
        if ~isempty(handles.c1waves)
            plot(handles.c1waves,'r')
            xlim([1 size(handles.NOwaves,1)])
            ylim([min(min(handles.c1waves)) max(max(handles.c1waves))])
            title(['# Clust 1 waves = ' , num2str(size(handles.c1waves,2))],'Color','r')
            
            handles.clust1.XTick = [];
            handles.clust1.YTick = [];
            
            
            if any(handles.AllIndicies(:,3) == 1)
                
                [metrics1] = clusterQual_at(handles.spikeDATA.features, handles.AllIndicies(:,3) , 1);
                
                handles.lratio1.String = num2str(round(metrics1.LRat,2));
                handles.idist1.String = num2str(round(metrics1.IsDs,2));
            end
            
            if any(handles.AllIndicies(:,3) == 2)
                
                [metrics2] = clusterQual_at(handles.spikeDATA.features, handles.AllIndicies(:,3) , 2);
                
                handles.lratio2.String = num2str(round(metrics2.LRat,2));
                handles.idist2.String = num2str(round(metrics2.IsDs,2));
            end
            
            
        end
        
        cla(handles.mScat)
        axes(handles.mScat)
        plot(handles.xScat.Value, handles.yScat.Value,'k.')
        hold on
        c1I = handles.AllIndicies(:,3) == 1;
        plot(handles.AllIndicies(c1I,1), handles.AllIndicies(c1I,2),'r.');
        c2I = handles.AllIndicies(:,3) == 2;
        plot(handles.AllIndicies(c2I,1), handles.AllIndicies(c2I,2),'b.');
        
        %%% Update Time Plot
        cla(handles.timePlot)
        axes(handles.timePlot)
        
        plot(handles.spTime,handles.allPeaks, 'k.')
        xlim([min(handles.spTime)  max(handles.spTime)])
        
        hold on
        plot(handles.spTime(c1I),handles.allPeaks(c1I), 'r.')
        plot(handles.spTime(c2I),handles.allPeaks(c2I), 'b.')
        
        handles.timePlot.XTick = [];
        handles.timePlot.YTick = [];
        handles.timePlot.XTick = [min(handles.spTime)  max(handles.spTime)];
        handles.timePlot.XTickLabel = {'Start' , 'Stop'};
        
        
    case 'update-c2'
        
        cla(handles.clust2)
        axes(handles.clust2)
        title('')
        
        if ~isempty(handles.c2waves)
            plot(handles.c2waves,'b')
            xlim([1 size(handles.NOwaves,1)])
            ylim([min(min(handles.c2waves)) max(max(handles.c2waves))])
            title(['# Clust 2 waves = ' , num2str(size(handles.c2waves,2))],'Color','b')
            
            handles.clust2.XTick = [];
            handles.clust2.YTick = [];
            
            if any(handles.AllIndicies(:,3) == 1)
                
                [metrics1] = clusterQual_at(handles.spikeDATA.features, handles.AllIndicies(:,3) , 1);
                
                handles.lratio1.String = num2str(round(metrics1.LRat,2));
                handles.idist1.String = num2str(round(metrics1.IsDs,2));
            end
            
            if any(handles.AllIndicies(:,3) == 2)
                
                [metrics2] = clusterQual_at(handles.spikeDATA.features, handles.AllIndicies(:,3) , 2);
                
                handles.lratio2.String = num2str(round(metrics2.LRat,2));
                handles.idist2.String = num2str(round(metrics2.IsDs,2));
            end
        end
        
        cla(handles.mScat)
        axes(handles.mScat)
        plot(handles.xScat.Value, handles.yScat.Value,'k.')
        hold on
        c1I = handles.AllIndicies(:,3) == 1;
        plot(handles.AllIndicies(c1I,1), handles.AllIndicies(c1I,2),'r.');
        c2I = handles.AllIndicies(:,3) == 2;
        plot(handles.AllIndicies(c2I,1), handles.AllIndicies(c2I,2),'b.');
        
        cla(handles.timePlot)
        axes(handles.timePlot)
        
        plot(handles.spTime,handles.allPeaks, 'k.')
        xlim([min(handles.spTime)  max(handles.spTime)])
        
        hold on
        plot(handles.spTime(c1I),handles.allPeaks(c1I), 'r.')
        plot(handles.spTime(c2I),handles.allPeaks(c2I), 'b.')
        
        handles.timePlot.XTick = [];
        handles.timePlot.YTick = [];
        handles.timePlot.XTick = [min(handles.spTime)  max(handles.spTime)];
        handles.timePlot.XTickLabel = {'Start' , 'Stop'};
        
    case 'update-noise'
        
        axes(handles.noise)
%         plot(handles.NOwaves,'k')
        
        mWf = mean(handles.NOwaves,2);
        sWf = std(handles.NOwaves, [], 2);
        pmWf = mWf + sWf;
        mmWf = mWf - sWf;
        plot(mWf,'k-');
        hold on
        plot(pmWf,'k--');
        plot(mmWf,'k--');
        xlim([1 size(handles.NOwaves,1)])
        ylim([min(min(handles.NOwaves)) max(max(handles.NOwaves))])
        title(['# Noise waves = ' , num2str(size(handles.NOwaves,2))])
        
        handles.noise.XTick = [];
        handles.noise.YTick = [];
        
        
end




function handles = modifyClust(handles, cluster, index , stage)


switch stage
    
    case 'make'
        
        handles.AllIndicies(index,3) = cluster;
        
    case 'reset'
        
        handles.AllIndicies(index,3) = 0;
        
    case 'add'
        
        handles.AllIndicies(index,3) = cluster;
        
    case 'trim'
        
        handles.AllIndicies(index,3) = 0;
        
end

if cluster == 1
    handles.c1waves = handles.AllWaves(:,handles.AllIndicies(:,3) == cluster);
else
    handles.c2waves = handles.AllWaves(:,handles.AllIndicies(:,3) == cluster);
end
handles.NOwaves = handles.AllWaves(:,handles.AllIndicies(:,3) == 0);


% --------------------------------------------------------------------
function exportData_Callback(hObject, eventdata, handles)
% hObject    handle to exportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in restartButton.
function restartButton_Callback(hObject, eventdata, handles)
% hObject    handle to restartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH);
AT_MClust_v1;
