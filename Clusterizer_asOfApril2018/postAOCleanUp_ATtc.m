function [] = postAOCleanUp_ATtc(dirLOC)
%postAOCleanUp_ATtc Summary of this function goes here
%   DIRLOC = directory location of files to be cleaned
%
% Example: postAOCleanUp_ATtc('D:\Dropbox\AT_Test_Folder\tmpTransfer\case12')
%
% Keep only 2 EMG and 1 Accelerometer
% Keep MER mLFP and LFP
% Keep TTL
%
% # 2 DELETE FILES from S3
%         cd(cur_Dir)
%         ckSet = checkSets(cur_Dir);
%
% Loop through cases
% Use Matfile to find relevant files
% Load file
% Find present files
% Overwrite and Save
% Use Matfile to clear file variables
%
% Look for .FS.SS. in file name


studyList = {'AT-IO-F','AT-IO-S'};

for si = 1:length(studyList)
    cd(dirLOC)
    toTList = getMatNames(dirLOC , 1);
    % Check stages complete
    [fsList , ssList] = getStudyLists(toTList);
    study = studyList{si};
    
    % Separate by FS and SS
    if si == 1
        runFrefine(fsList , dirLOC , study);
    else
        runFrefine(ssList , dirLOC , study);
    end
end

end


%%%% GETMATNAMES FUNCTION
function [outMatNames] = getMatNames(mainDir,matflag)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cd(mainDir)

if matflag
    getCons = dir('*.mat');
else
    getCons = [dir('*.mat'); dir('*.txt')];
end

outMatNames = {getCons.name};

end




%%%% MATFileNAMES FUNCTION
function mFileI = getMatfile(matName)

tmpInfo = matfile(matName);
wInfo = whos(tmpInfo);
mFileI = {wInfo.name};

end



%%%% REMOVE list
function [remFinal , outS , keepFinal] = remvIndex(fldList , study , fName)

switch study
    case 'AT-IO-F'
        
        outS = nan;
        keepList = {'CACC','CEMG','CSPK','CLFP','CMacro','ProcDone','accel','emg','lfp','mLFP','mer','CDIG','ttlInfo'};
        keepIndex = contains(fldList,keepList);
        listK1 = fldList(keepIndex);
        listR1 = fldList(~keepIndex);
        
        
        ckList = listK1(contains(listK1,{'CEMG','CACC'}));
        nonCklist = listK1(~contains(listK1,{'CEMG','CACC'}));
        
        finKeep = [];
        finRem = [];
        for ci = 1:2
            
            switch ci
                case 1
                    %                     kepN = 2;
                    emgL = ckList(cellfun(@(x) (contains(x,'EMG')), ckList));
                    keepIi = cellfun(@(x) (contains(x(10:11),{'01','02'})) & (contains(x,'EMG')), emgL);
                    keepT = emgL(keepIi);
                    remT = emgL(~keepIi);
                    
                case 2
                    %                     kepN = 2;
                    accL = ckList(cellfun(@(x) (contains(x,'CACC')), ckList));
                    %             keepIi = cellfun(@(x) (contains(x(length(x)),{'X','Y','Z'})) & (contains(x,'CACC')) &...
                    %                 (contains(x(10:11),{'01','02'})), accL);
                    keepIi = cellfun(@(x)  (contains(x,'CACC')) &...
                        (contains(x(22),{'1','2'})), accL);
                    %              keepIi = cellfun(@(x) (str2double(x(22)) <= kepN), ckList);
                    keepT = accL(keepIi);
                    remT = accL(~keepIi);
                    
            end
            finKeep = [finKeep , keepT]; %#ok<AGROW>
            finRem = [finRem , remT]; %#ok<AGROW>
            
        end
        keepFinal = [finKeep , nonCklist];
        remFinal = [finRem , listR1];
        
    case 'AT-IO-S'
        keepFinal = [];
        unproc = {'CACC','CEMG','CSPK','CLFP','CMacro_LFP','CDIG'};
        outS = struct;
        for ui = 1:length(unproc)
            
            outS.(unproc{ui}) = procDat(unproc{ui} , fldList , fName);
            
            switch unproc{ui} % Isolate raw
                case 'CACC'
                    cleanList = fldList(contains(fldList,unproc{ui}));
                    keepIi = cleanList(cellfun(@(x) (contains(x(end-1:end),{'X','Y','Z'})), cleanList));
                case {'CEMG','CSPK','CLFP','CMacro_LFP'}
                    cleanList = fldList(contains(fldList,unproc{ui}));
                    keepIi = cleanList(cellfun(@(x) (contains(x(end-1:end),{'01','02'})), cleanList));
                case 'CDIG'
                    cleanList = fldList(contains(fldList,unproc{ui}));
                    keepIi = cleanList(cellfun(@(x) (contains(x(end-1:end),{'Up','wn'})), cleanList));
            end
            keepFinal = [keepFinal , keepIi]; %#ok<AGROW>
        end
        remFinal = nan;
end


end


%%%% LOOP through and CLEAN files
function [] = runFrefine(toTList , cDir , study)

numFiles = length(toTList);
for ti = 1:length(toTList)
    tmpMat = toTList{ti};
    tmpMfN = getMatfile(tmpMat);
    [remFinal , outStruct , keepFinal] = remvIndex(tmpMfN , study , tmpMat);
    % Load
    allDat = load(tmpMat);
    % Resave with new list
    
    switch study
        case 'AT-IO-F'
            newDat = rmfield(allDat,remFinal);
            cd(cDir)
            
            % New FS name
            tmpStr = strsplit(tmpMat,'.');

            tmpStr2 = strjoin(tmpStr(1:end-1),'.');
            
            newMat = [tmpStr2, '.FS.mat'];
            
            save(newMat,'-struct','newDat')
            % Clear all
            clearvars allDat
            disp([num2str(ti) , ' out of ' , num2str(numFiles), ' done!'])
        case 'AT-IO-S'
            remTemp = tmpMfN(~ismember(tmpMfN,keepFinal));
            newDat = rmfield(allDat,remTemp);
            
            fNs = fieldnames(outStruct);
            for si = 1:length(fNs)
                switch fNs{si}
                    case 'CACC'
                        stN = 'accel';
                    case 'CEMG'
                        stN = 'emg';
                    case 'CSPK'
                        stN = 'mer';
                    case 'CLFP'
                        stN = 'mLFP';
                    case 'CMacro_LFP'
                        stN = 'lfp';
                    case 'CDIG'
                        stN = 'ttl';
                end % switch case
                newDat.(stN) = outStruct.(fNs{si});
            end % For loop
            cd(cDir)

            % New SS name
            tmpStr = strsplit(tmpMat,'.');
            tmpStr2 = strjoin(tmpStr(1:end-1),'.');
            newMat = [tmpStr2, '.SS.mat'];
            save(newMat,'-struct','newDat')

            % Clear all
            clearvars allDat
            disp([num2str(ti) , ' out of ' , num2str(numFiles), ' done!'])
            
    end % Switch case
end % For loop
end % Function



function [outStruct] = procDat(tmpDat , fldList , fname)

% compile get rid list
% compile keep list
% create data struct = khz, starttime, endtime
cleanList = fldList(contains(fldList,tmpDat));
switch tmpDat
    case {'CACC','CEMG','CSPK','CLFP','CMacro_LFP'}
        
        % Find KHz , TimeBegin , TimeEnd , Gain , BitResolution
        featS = {'TimeBegin','TimeEnd','KHz','BitResolution','Gain'};
        
        for fi = 1:length(featS)
            % Extract the first value with the identifited feature [there
            % will be several]
            tmpFeat = cleanList{find(contains(cleanList,featS{fi}),1,'first')};
            
            % Blind extract value from field and remap to outstruct
            featValst = load(fname,tmpFeat);
            fieldNM = fieldnames(featValst);
            featVal = featValst.(fieldNM{1});
            
            % May need to change inner field name to match other files
            outStruct.(featS{fi}) = featVal;
        end
        
    case 'CDIG'
        featS = {'TimeBegin','TimeEnd','KHz'};
        for fi = 1:length(featS)
            % Extract the first value with the identifited feature [there
            % will be several]
            tmpFeat = cleanList{find(contains(cleanList,featS{fi}),1,'first')};
            
            % Blind extract value from field and remap to outstruct
            featValst = load(fname,tmpFeat);
            fieldNM = fieldnames(featValst);
            featVal = featValst.(fieldNM{1});
            
            % May need to change inner field name to match other files
            outStruct.(featS{fi}) = featVal;
        end
end





end



%%%%%%%%%%% GET LISTS %%%%%%%%%%%%%%%%%%%%%
function [fsList , ssList] = getStudyLists(inLIST)

fsList = {};
fcount = 1;
ssList = {};
scount = 1;
for i = 1:length(inLIST)
    
    tFna = inLIST{i};
    nEles = strsplit(tFna,'.');
    
    fsCheck = sum(contains(nEles,'FS'));
    ssCheck = sum(contains(nEles,'SS'));
    
    if fsCheck && ssCheck
        continue
    elseif ~fsCheck && ~ssCheck
        fsList{fcount} = inLIST{i};  %#ok<AGROW>
        fcount = fcount + 1;
    elseif fsCheck && ~ssCheck
        ssList{scount} = inLIST{i};  %#ok<AGROW>
        scount = scount + 1;
    end
    
end

end

