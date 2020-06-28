function varargout = swat(varargin)
%Developer: Khaled Talaat
%Contributors: Cameron Trapp (Original concept + preliminary simulation framework)
%Debugging, testing, and validation: Kishore Vakamudi
%Principal Investigator: Stefan Posse
%Acknowledgements: Arvind Caprihan

%GUI style was designed in MATLAB GUIDE v2.5. To modify the GUI style, you need
%to use GUIDE and modify swat.fig which is part of this program.

% SWAT MATLAB code for swat.fig
%      SWAT, by itself, creates a new SWAT or raises the existing
%      singleton*.
%
%      H = SWAT returns the handle to a new SWAT or the handle to
%      the existing singleton*.
%
%      SWAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SWAT.M with the given input arguments.
%
%      SWAT('Property','Value',...) creates a new SWAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before swat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to swat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @swat_OpeningFcn, ...
                   'gui_OutputFcn',  @swat_OutputFcn, ...
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

function switchPanel(hObject,eventdata,handles,currentPanel,currentPanel2)
set(handles.signalspanel, 'visible', 'off')
set(handles.confoundspanel, 'visible', 'off')
set(handles.detrendingvectorspanel, 'visible', 'off')
set(handles.correlationspanel, 'visible', 'off')
set(handles.slidingwindowspanel, 'visible', 'off')
set(handles.helppanel, 'visible', 'off')
set(handles.detrendingvectorsdefinitionpanel, 'visible', 'off')
set(handles.detrendedsignalspanel, 'visible', 'off')
set(handles.resultsslidingwindowspanel, 'visible', 'off')
set(handles.fftpanel, 'visible', 'off')
set(handles.gammaspanel, 'visible', 'off')
set(handles.frequencyConfoundsPanel, 'visible', 'off')
set(handles.(char(currentPanel)),'visible','on')
if exist('currentPanel2','var')
    set(handles.(char(currentPanel2)),'visible','on')
end
global globalHandles
globalHandles = handles;

function updatePlots(hObject,eventdata,handles)
warning off;
if handles.showonlysignalscheckbox.Value == 1
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes4,'reset');
for i=1:1:length(handles.signals.displayonly)
    if handles.signals.displayset(i) == 1
        dataset = 'values';
    elseif handles.signals.displayset(i) == 2
        dataset = 'detrended';
    elseif handles.signals.displayset(i) == 3
        dataset = 'original';
    end
    dataToPlot = handles.signals.(char(dataset))(handles.signals.displayonly(i),:);
    hold(handles.axes1,'on')
    hold(handles.axes2,'on')
    hold(handles.axes4,'on')
    plot(dataToPlot.','Parent', handles.axes1,'LineWidth',2);
    legend(handles.axes1,handles.signals.displayonlynames);
    plot(dataToPlot.','Parent', handles.axes2,'LineWidth',2);
    legend(handles.axes2,handles.signals.displayonlynames);
    plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);
    legend(handles.axes4,handles.signals.displayonlynames);
    x_axis = get(handles.axes1,'xtick');
    set(handles.axes1,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
    set(handles.axes2,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
    set(handles.axes4,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
end
    hold(handles.axes1,'off')
    hold(handles.axes2,'off')
    hold(handles.axes4,'off')

elseif handles.showonlysignalscheckbox.Value == 0
    cla(handles.axes1,'reset');
    cla(handles.axes2,'reset');
    cla(handles.axes4,'reset');
    plot(handles.signals.values.','Parent', handles.axes1,'LineWidth',2);
    legend(handles.axes1,handles.signals.names);
    plot(handles.signals.values.','Parent', handles.axes2,'LineWidth',2);
    legend(handles.axes2,handles.signals.names);
    plot(handles.signals.values.','Parent', handles.axes4,'LineWidth',2);
    legend(handles.axes4,handles.signals.names);
    x_axis = get(handles.axes1,'xtick');
    set(handles.axes1,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
    set(handles.axes2,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
    set(handles.axes4,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
end

% FFT Confounds
try 
    if handles.modulated.updatePlots == 1
        if handles.showonlysignalscheckbox.Value == 0
        cla(handles.axes8,'reset');
        legendstr = handles.modulated.names;
        for i=1:1:size(handles.modulated.values,1)
            f=linspace(0,.5/handles.signals.tr,size(handles.modulated.values,2)/2);
            Y= fft(handles.modulated.values(i,:).',size(handles.modulated.values,2));
            Pyy=Y.*conj(Y)/size(handles.modulated.values,2);
            hold(handles.axes8,'on')
            plot(f,Pyy(1:size(handles.modulated.values,2)/2),'Parent', handles.axes8,'LineWidth',2);
            legend(handles.axes8,handles.modulated.names);
            ylabel(handles.axes8,'Amplitude', 'fontsize', 10)
            xlabel(handles.axes8,'Frequency (Hz)','fontsize', 10)
        end
        hold(handles.axes8,'off')
        end

        if handles.showonlysignalscheckbox.Value == 1
        cla(handles.axes8,'reset');
        legendstr = {};
        for i=1:1:length(handles.signals.displayonly)
        if handles.signals.displayset(i) == 1
            dataset = 'values';
        elseif handles.signals.displayset(i) == 2
            dataset = 'detrended';
            continue; 
        elseif handles.signals.displayset(i) == 3
            dataset = 'original';
            continue; 
        end
            legendstr{end+1} = char(handles.signals.displayonlynames(i));
            f=linspace(0,.5/handles.signals.tr,size(handles.modulated.values,2)/2);
            Y= fft(handles.modulated.(char(dataset))(handles.signals.displayonly(i),:).',size(handles.modulated.values,2));
            Pyy=Y.*conj(Y)/size(handles.modulated.values,2);
            hold(handles.axes8,'on')
            plot(f,Pyy(1:size(handles.modulated.values,2)/2),'Parent', handles.axes8,'LineWidth',2);
            legend(handles.axes8,legendstr);
            ylabel(handles.axes8,'Amplitude', 'fontsize', 10)
            xlabel(handles.axes8,'Frequency (Hz)','fontsize', 10)    
        end
        hold(handles.axes8,'off')
        end
        try
        ylim(handles.axes8,[handles.signals.ylimfft]);
        catch
        end
        try
        xlim(handles.axes8,[handles.signals.xlimfft]);
        catch
        end
        set(handles.selectSignalFC,'String',legendstr);
    end
catch
end


function correlation = correlatesignals(signal1,signal2,handles)
correlation = [];
if handles.signals.correlationrelation == 1
    %i.e Pearson correlation
   correlation = corrcoef(signal1,signal2); 
end
if handles.signals.correlationrelation == 2
   %Like Pearson but with no subtraction of mean
   numerator = dot(signal1,signal2);
   denominator = norm(signal1)*norm(signal2);
   correlation(1,1) = 1; %correlation of signal with itself
   correlation(2,1) = numerator/denominator;
end

% --- Executes just before swat is made visible.
function swat_OpeningFcn(hObject, eventdata, handles, varargin)
% hObject    handle to boxcarconfounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Choose default command line output for swat
handles.output = hObject;
handles.savedir = [];
handles.signals = struct;
handles.signals.signalsize = [];
handles.signals.original = [];
handles.signals.values = [];
handles.signals.detrended = [];
handles.signals.detrendedoriginal = [];
handles.signals.detrendedname = {};
handles.signals.history = {};
handles.signals.confoundtypes = {};
handles.signals.names = {};
handles.signals.detrendingvectors = [];
handles.signals.detrendingfitorder = [];
handles.signals.detrendingvectornames = {};
handles.signals.meanwindowcorrelations = [];
handles.signals.meanwindowzscores = [];
handles.signals.windowsizes = [];
handles.signals.displayonly = [];
handles.signals.displayset = [];
handles.signals.displayonlynames = {};
handles.modulated = struct;
handles.modulated.values = [];
handles.modulated.names = {};
handles.sw.slidingwindowresults = {};
handles.sw.slidingwindowzscoreresults = {};
handles.sw.slidingwindownames = {};
handles.signals.detrendingvectorsmatrix = [];
handles.signals.correlationrelation = 1;
handles.macros = struct;
handles.macros.macrofile = [];
handles.macros.macroname = [];
handles.macros.macropath = [];
handles.macros.recording = 0;
handles.macros.nowplaying = 0;
handles.macros.macroiteration = 1;
handles.macros.nruns = [];
handles.batchmode = struct;
handles.batchmode.windowcorrelations = struct;
handles.batchmode.windowzscores = struct;
handles.batchmode.windowsizes = struct;
global gammadata;
gammadata = struct;
clear gammadata;
global gammaslegendlist;
gammaslegendlist = {};
handles.signals.tr = 1; %Default repetition time

saveDir = uigetdir([],'Select Saving Directory');
if isempty(saveDir)
   return; 
end
handles.savedir = saveDir;

% Update handles structure
guidata(hObject, handles);
switchPanel(hObject,eventdata,handles,'signalspanel')


% UIWAIT makes swat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = swat_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in signals.
function signals_Callback(hObject, eventdata, handles)
switchPanel(hObject,eventdata,handles,'signalspanel')
updatePlots(hObject, eventdata, handles);
eventrecorder(hObject, eventdata, handles, '> Signals');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in confounds.
function confounds_Callback(hObject, eventdata, handles)
switchPanel(hObject,eventdata,handles,'confoundspanel')
set(handles.selectsignalconfounds, 'string', handles.signals.names);
guidata(hObject, handles);
updatePlots(hObject, eventdata, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds');
playMacro(hObject, eventdata, handles)



% --- Executes on button press in detrendingvectors.
function detrendingvectors_Callback(hObject, eventdata, handles)
set(handles.allvectorslist, 'string', handles.signals.names);
guidata(hObject, handles)
switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendingvectorsdefinitionpanel')
eventrecorder(hObject, eventdata, handles, '> Detrend');
playMacro(hObject, eventdata, handles)

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
resetConfirm = questdlg('Are you sure you want to reset?','Yes','No');
elseif handles.macros.nowplaying
   resetConfirm = 'Yes'; 
end
eventrecorder(hObject, eventdata, handles, '> Reset');
switch resetConfirm
    case 'Yes'
    handles.signals = struct;
    handles.signals.signalsize = [];
    handles.signals.original = [];
    handles.signals.values = [];
    handles.signals.detrended = [];
    handles.signals.detrendedoriginal = []; 
    handles.signals.detrendedname = {};
    handles.signals.history = {};
    handles.signals.confoundtypes = {};
    handles.signals.names = {};
    handles.signals.detrendingvectors = [];
    handles.signals.detrendingfitorder = [];
    handles.signals.detrendingvectornames = {};
    handles.signals.meanwindowcorrelations = [];
    handles.signals.meanwindowzscores = [];
    handles.signals.windowsizes = [];
    handles.signals.displayonly = [];
    handles.signals.displayset = [];
    handles.signals.displayonlynames = {};
    handles.signals.detrendingvectorsmatrix = [];
    handles.signals.correlationrelation = 1;
    handles.modulated = struct;
    handles.modulated.values = [];
    handles.modulated.names = {};
    global gammadata;
    gammadata = struct;
    clear gammadata;
    global gammaslegendlist;
    gammaslegendlist = {};
    handles.signals.tr = 1;
    cla(handles.axes1,'reset');
    cla(handles.axes2,'reset');
    cla(handles.axes3,'reset');
    cla(handles.axes4,'reset');
    cla(handles.axes5,'reset');
    guidata(hObject, handles);
    case 'No' 
    return;
    otherwise
        return;
end
guidata(hObject, handles);
playMacro(hObject, eventdata, handles)


% --- Executes on button press in correlations.
function correlations_Callback(hObject, eventdata, handles)
if ~isempty(handles.signals.names)
set(handles.selectcorrelations1, 'string', handles.signals.names);
set(handles.selectcorrelations2, 'string', handles.signals.names);
set(handles.selectoriginalcorrelations1, 'string', handles.signals.names);
set(handles.selectoriginalcorrelations2, 'string', handles.signals.names);
end
if ~isempty(handles.signals.detrendedname)
set(handles.selectdetrendedcorrelations1, 'string', handles.signals.detrendedname);
set(handles.selectdetrendedcorrelations2, 'string', handles.signals.detrendedname);
end
guidata(hObject,handles)
switchPanel(hObject,eventdata,handles,'correlationspanel')
eventrecorder(hObject, eventdata, handles, '> Correlations');
playMacro(hObject, eventdata, handles)



% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
switchPanel(hObject,eventdata,handles,'helppanel')
eventrecorder(hObject, eventdata, handles, '> About');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in slidingwindows.
function slidingwindows_Callback(hObject, eventdata, handles)
updatePlots(hObject, eventdata, handles);
switchPanel(hObject,eventdata,handles,'slidingwindowspanel')
eventrecorder(hObject, eventdata, handles, '> SlidingWindows');
playMacro(hObject, eventdata, handles)



% --- Executes on button press in importsignal.
function importsignal_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
[file, filePath] = uigetfile({'*.csv';'*.dat';'*.txt'},'MultiSelect','on');
end
try
if ~handles.macros.nowplaying
    if ~iscell(file)
    newSignals = dlmread(fullfile(filePath,file));
      if size(newSignals,1) > size(newSignals,2)
           newSignals = newSignals.';
      end
    eventrecorder(hObject, eventdata, handles, '> Signals_ImportSignals');
    eventrecorder(hObject, eventdata, handles, sprintf('>> %s',fullfile(filePath,file)));
    elseif iscell(file)
        newSignals = [];
       for k=1:1:length(file)
          impsignals = dlmread(fullfile(filePath,file{k}));
          eventrecorder(hObject, eventdata, handles, '> Signals_ImportSignals');
          eventrecorder(hObject, eventdata, handles, sprintf('>> %s',fullfile(filePath,file{k})));
          if size(impsignals,1) > size(impsignals,2)
                impsignals = impsignals.';
          end
          newSignals = [newSignals; impsignals];
       end
    end
elseif handles.macros.nowplaying
    newSignals = csvread(char(handles.macros.payload{1,1}));
end
catch
   return;
end

try
for i=1:1:size(newSignals,1)
signalName = {};
prompt = {'Name of signal?'};
prompttitle = 'Name';
if ~handles.macros.nowplaying
    if ~iscell(file)
    signalName = inputdlg(prompt,prompttitle);
    elseif iscell(file)
    signalName = file{i}; 
    end
elseif handles.macros.nowplaying
    signalName = char(handles.macros.payload{i+1,1});
end
if isempty(signalName)
   signalName = 'UntitledSignal'; 
end
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',char(signalName)));
handles.signals.original = [handles.signals.original; newSignals(i,:)];
handles.signals.values = [handles.signals.values; newSignals(i,:)];
handles.signals.names{end+1} = char(signalName);
handles.signals.history{end+1} = handles.signals.values;
guidata(hObject, handles);
updatePlots(hObject,eventdata,handles);
end
catch
    disp('Error: The added signal is not the same size as the original signals')
    return;
end

playMacro(hObject, eventdata, handles)


% --- Executes on button press in generaterandomsignal.
function generaterandomsignal_Callback(hObject, eventdata, handles)
eventrecorder(hObject, eventdata, handles, '> Signals_GenerateRandomSignal');
if isempty(handles.signals.signalsize)
prompt = {'Number of points?'};
prompttitle = 'Size';
if ~handles.macros.nowplaying
signalSize = inputdlg(prompt,prompttitle);
elseif handles.macros.nowplaying
    signalSize = handles.macros.payload{1,1};
end
if isempty(signalSize)
   return; 
end
if ~handles.macros.nowplaying
handles.signals.signalsize = str2num(signalSize{:});
elseif handles.macros.nowplaying
    handles.signals.signalsize = signalSize;
end
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',char(signalSize)));
end

if ~handles.macros.nowplaying
prompt = {'Name of the Signal'};
prompttitle = 'Name';
signalName = inputdlg(prompt,prompttitle);
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',char(signalName)));

distribution = listdlg('PromptString','Distribution:','SelectionMode','single','ListString',{'Normal','Ricean','Rayleigh','Non-central Chi-square','Colored Noise'},'ListSize',[300,200]);
if isempty(distribution)
   return; 
end
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',distribution));

if distribution == 1
prompt = {'Standard deviation'};
prompttitle = 'STD';
signalSTD = inputdlg(prompt,prompttitle);
signalSTD = str2num(signalSTD{:});
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',signalSTD));
elseif distribution == 2
    prompt = {'Non-centrality Parameter (S)','Scale Parameter (Sigma)'};
    prompttitle = 'Parameters';
    riceparams = inputdlg(prompt,prompttitle,[1,35]);
    riceparams = cellfun(@str2num,riceparams,'un',0);  
    riceparams = cell2mat(riceparams);
    eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%f,',riceparams)));
elseif distribution == 3
    prompt = {'Scale Parameter (b)'};
    prompttitle = 'Parameters';
    scaleparam = inputdlg(prompt,prompttitle,[1,35]);
    scaleparam = str2num(scaleparam{:});
    eventrecorder(hObject, eventdata, handles, sprintf('>> %f',scaleparam));
elseif distribution == 4
    prompt = {'Degrees of Freedom','Non-centrality Parameter'};
    prompttitle = 'Parameters';
    chiparams = inputdlg(prompt,prompttitle,[1,35]);
    chiparams = cellfun(@str2num,chiparams,'un',0);  
    chiparams = cell2mat(chiparams);
    eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%f,',chiparams))); 
elseif distribution == 5
    colorselected = listdlg('PromptString','Distribution:','SelectionMode','single','ListString',{'Pink','White','Brown','Blue','Purple','Custom'},'ListSize',[300,200]);
    if isempty(colorselected)
        return;
    end
    
    switch colorselected
        case 1
            alpha = 1;
        case 2 
            alpha = 0;
        case 3
            alpha = 2;
        case 4
            alpha = -1;
        case 5
            alpha = -2;
        case 6
             prompt = {'Alpha'};
             prompttitle = 'Inverse Frequency Power';
             alpha = inputdlg(prompt,prompttitle,[1,35]);
             if isempty(alpha)
                 return;
             end
             alpha = str2num(alpha{:});
        otherwise
            return;
    end
    eventrecorder(hObject, eventdata, handles, sprintf('>> %f',alpha));
end

elseif handles.macros.nowplaying
    signalName = handles.macros.payload{end-2,1};
    distribution = handles.macros.payload{end-1,1};
    if distribution == 1
    signalSTD = handles.macros.payload{end,1};
    elseif distribution == 2
    riceparams = handles.macros.payload{end,1};
    elseif distribution == 3
    scaleparam = handles.macros.payload{end,1};
    elseif distribution == 4
    chiparams = handles.macros.payload{end,1};
    elseif distribution == 5
    alpha = handles.macros.payload{end,1};
    end
end

if isempty(signalName)
   return; 
end
if ~handles.macros.nowplaying
if distribution == 1
if isempty(signalSTD)
    signalSTD = 1;
end
elseif distribution == 2
    if isempty(riceparams)
       return; 
    end
elseif distribution == 3
    if isempty(scaleparam)
       return; 
    end
elseif distribution == 4
    if isempty(chiparams)
       return; 
    end
elseif distribution == 5
    if isempty(alpha)
        return;
    end
end
end

if distribution == 1
  newSignal =  signalSTD*randn(1,handles.signals.signalsize);
elseif distribution == 2
  for i=1:1:handles.signals.signalsize
   newSignal(i) = random('Rician',riceparams(1),riceparams(2)); 
  end
elseif distribution == 3
  for i=1:1:handles.signals.signalsize
   newSignal(i) = random('Rayleigh',scaleparam); 
  end  
elseif distribution == 4
  for i=1:1:handles.signals.signalsize
   newSignal(i) = random('Noncentral Chi-square',chiparams(1),chiparams(2)); 
  end
elseif distribution == 5
    newSignalObject = dsp.ColoredNoise(alpha,handles.signals.signalsize,1);
    newSignal = step(newSignalObject).';   
end

handles.signals.original = [handles.signals.original; newSignal];
handles.signals.values =  [handles.signals.values; newSignal];
handles.signals.names{end+1} = char(signalName);
handles.signals.history{end+1} = handles.signals.values;
guidata(hObject, handles);
updatePlots(hObject,eventdata,handles);
playMacro(hObject, eventdata, handles)


% --- Executes on button press in exportsignal.
function exportsignal_Callback(hObject, eventdata, handles)
[file, filePath] = uiputfile({'*.csv'});
try
if ~handles.macros.nowplaying
csvwrite(fullfile(filePath,file),[handles.signals.values.',handles.signals.detrended.']);
elseif handles.macros.nowplaying
csvwrite(char(handles.macros.payload{1,1}),[handles.signals.values.',handles.signals.detrended.']);
end
catch
    disp('Export failed')
    return;
end
currentTime = datestr(now,'mm-dd-yyyy HH-MM');
eventrecorder(hObject, eventdata, handles, '> Signals_ExportSignals');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s%s',fullfile(filePath,file),currentTime));
playMacro(hObject, eventdata, handles)

% --- Executes on button press in undosignals.
function undosignals_Callback(hObject, eventdata, handles)
try
handles.signals.history(end) = [];
handles.signals.values = handles.signals.history{end};
if length(handles.signals.names) > size(handles.signals.values,1)
   handles.signals.names(end) = []; 
end
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
catch
end
eventrecorder(hObject, eventdata, handles, '> Signals_Undo');
playMacro(hObject, eventdata, handles)

% --- Executes on button press in boxcarconfounds.
function boxcarconfounds_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
confoundLimits = round(ginput(2))
prompt = {'Boxcar amplitude:'};
prompttitle = 'Amplitude';
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
amplitude = str2num(amplitude{:});
elseif handles.macros.nowplaying
confoundLimits = handles.macros.payload{1,1};
amplitude = handles.macros.payload{2,1};
end
if confoundLimits(2,1) > size(handles.signals.values,2)
    confoundLimits(2,1) = size(handles.signals.values,2);
end
signalToModify = handles.selectsignalconfounds.Value;
for i=confoundLimits(1,1):1:confoundLimits(2,1)
 handles.signals.values(signalToModify,i) =  handles.signals.values(signalToModify,i) + amplitude;
end
handles.signals.confoundtypes{end+1} = 'boxcar';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Boxcar');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d;%d',confoundLimits(1,1),confoundLimits(2,1)));        
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',amplitude));  
playMacro(hObject, eventdata, handles)

% --- Executes on button press in spikeconfounds.
function spikeconfounds_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
confoundLimits = round(ginput(1))
prompt = {'Spike amplitude:'};
prompttitle = 'Amplitude';
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
amplitude = str2num(amplitude{:});
elseif handles.macros.nowplaying
confoundLimits = handles.macros.payload{1,1};
amplitude = handles.macros.payload{2,1};
end
confoundLimits = confoundLimits(1,1);
if confoundLimits > size(handles.signals.values,2)
    confoundLimits = size(handles.signals.values,2);
end

signalToModify = handles.selectsignalconfounds.Value;
for i=(confoundLimits-4):1:(confoundLimits+4)
 handles.signals.values(signalToModify,i) =  handles.signals.values(signalToModify,i) + amplitude;
end
handles.signals.confoundtypes{end+1} = 'spike';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Spike');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',confoundLimits(1,1)));        
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',amplitude)); 
playMacro(hObject, eventdata, handles)

% --- Executes on button press in driftconfounds.
function driftconfounds_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
confoundLimits = round(ginput(2));
prompt = {'Maximum amplitude:'};
prompttitle = 'Amplitude';
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
amplitude = str2num(amplitude{:});
elseif handles.macros.nowplaying
confoundLimits = handles.macros.payload{1,1};
amplitude = handles.macros.payload{2,1};  
end

if confoundLimits(2,1) > size(handles.signals.values,2)
    confoundLimits(2,1) = size(handles.signals.values,2);
end
signalToModify = handles.selectsignalconfounds.Value;
signal = handles.signals.values(signalToModify,:);
slope = (amplitude-signal(confoundLimits(1,1)))/(confoundLimits(2,1)-confoundLimits(1,1));
for i=confoundLimits(1,1):1:confoundLimits(2,1)
 handles.signals.values(signalToModify,i) =  signal(i) + slope*(i-confoundLimits(1,1));
end
handles.signals.confoundtypes{end+1} = 'drift';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Drift');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d;%d',confoundLimits(1,1),confoundLimits(2,1)));        
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',amplitude)); 
playMacro(hObject, eventdata, handles)

% --- Executes on button press in sinusoidconfounds.
function sinusoidconfounds_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
confoundLimits = round(ginput(2));
prompt = {'Maximum amplitude:'};
prompttitle = 'Amplitude';
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
amplitude = str2num(amplitude{:});
elseif handles.macros.nowplaying
confoundLimits = handles.macros.payload{1,1};
amplitude = handles.macros.payload{2,1};
end

if confoundLimits(2,1) > size(handles.signals.values,2)
    confoundLimits(2,1) = size(handles.signals.values,2);
end
signalToModify = handles.selectsignalconfounds.Value;
signal = handles.signals.values(signalToModify,:);
for i=confoundLimits(1,1):1:confoundLimits(2,1)
 handles.signals.values(signalToModify,i) =  signal(i) + amplitude*sin(2*pi*(i-confoundLimits(1,1))/(2*(confoundLimits(2,1)-confoundLimits(1,1))));
end
handles.signals.confoundtypes{end+1} = 'sinusoid';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Sinusoid');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d;%d',confoundLimits(1,1),confoundLimits(2,1)));        
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',amplitude)); 
playMacro(hObject, eventdata, handles)

% --- Executes on button press in undoconfounds.
function undoconfounds_Callback(hObject, eventdata, handles)
try
handles.signals.history(end) = [];
handles.signals.confoundtypes(end) = [];
handles.signals.values = handles.signals.history{end};
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
catch
end
eventrecorder(hObject, eventdata, handles, '> Confounds_Undo');
playMacro(hObject, eventdata, handles)

% --- Executes on selection change in selectsignalconfounds.
function selectsignalconfounds_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
    handles.selectsignalconfounds.Value = handles.macros.payload{1,1};
end
eventrecorder(hObject, eventdata, handles, '> Confounds_SelectSignal');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',handles.selectsignalconfounds.Value));
playMacro(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function selectsignalconfounds_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addnoisesignals.
function addnoisesignals_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
signalsToModify = listdlg('PromptString','Modify:','ListString',handles.signals.names);
if isempty(signalsToModify)
   return; 
end
prompt = {'Signal to noise ratio:'};
prompttitle = 'SNR';
snr = inputdlg(prompt,prompttitle);
if isempty(snr)
   return; 
end
snr = str2num(snr{:});

noiseDistribution = listdlg('PromptString','Modify:','ListString',{'Normal','Rician'});
if isempty(noiseDistribution)
   return; 
end

prompt = {'Non-centrality Parameter (S)','Scale Parameter (Sigma)'};
prompttitle = 'Parameters';
riceparams = inputdlg(prompt,prompttitle,[1,35]);
riceparams = cellfun(@str2num,riceparams,'un',0);  
riceparams = cell2mat(riceparams);

if isempty(riceparams)
   return;
end
    
elseif handles.macros.nowplaying
signalsToModify = handles.macros.payload{1,1};
snr = handles.macros.payload{2,1};
noiseDistribution = handles.macros.payload{3,1};
riceparams = handles.macros.payload{end,1};
end


for j=1:1:length(signalsToModify)
signalToModify = signalsToModify(j);
if noiseDistribution ==1
handles.signals.values(signalToModify,:) =  handles.signals.values(signalToModify,:) + (1/snr)*randn(1,size(handles.signals.values,2));
elseif noiseDistribution == 2
    for k=1:size(handles.signals.values,2)
        noiseSignal(1,k) = random('Rician',riceparams(1),riceparams(2));
    end
handles.signals.values(signalToModify,:) =  handles.signals.values(signalToModify,:) + (1/snr)*noiseSignal;   
end
end
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Signals_AddNoise');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',signalsToModify)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',snr));    
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',noiseDistribution)));
if noiseDistribution == 2
    eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%f,',riceparams))); 
end
playMacro(hObject, eventdata, handles)


% --- Executes on button press in filterssignals.
function filterssignals_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
signalToFilter = listdlg('PromptString','Signal to Filter:','SelectionMode','single','ListString',handles.signals.names);
if isempty(signalToFilter)
   return; 
end
list = {'Conventional Filtering','Zero-phase Filtering','Moving Average Filter','Bruno Low Pass','Bruno Band Pass','Bruno Band Stop','Bruno High Pass'};
filterType = listdlg('PromptString','Signal to Filter:','SelectionMode','single','ListString',list);
if isempty(filterType)
   return; 
end

elseif handles.macros.nowplaying
    signalToFilter = handles.macros.payload{1,1};
    filterType = handles.macros.payload{2,1};
    if filterType == 1 || filterType == 2
    load(char(handles.macros.payload{3,1}),'-mat');
    elseif filterType == 3
    hampoints = handles.macros.payload{3,1};
    elseif filterType == 4
    maxfrequency = handles.macros.payload{3,1};
    elseif filterType == 5
    freqrange = handles.macros.payload{3,1};
    elseif filterType ==6
    freqrange = handles.macros.payload{3,1};    
    elseif filterType ==7
    minfrequency = handles.macros.payload{3,1};
    end
end

if filterType == 1
if ~handles.macros.nowplaying
d = designfilt;
end
filteredSignal = filter(d,handles.signals.values(signalToFilter,:));
%In case the user is recording a macro, we need to save the filter object
    if handles.macros.recording == 1
    save(fullfile(handles.macros.macropath,strcat(handles.macros.macroname,'.d')),'d','-mat');
    end
elseif filterType == 2
if ~handles.macros.nowplaying
d = designfilt;
end
filteredSignal = filtfilt(d,handles.signals.values(signalToFilter,:));
    if handles.macros.recording == 1
    save(fullfile(handles.macros.macropath,strcat(handles.macros.macroname,'.d')),'d','-mat');
    end
elseif filterType == 3 
prompt = {'Hamming points:'};
prompttitle = 'Hamming';
if ~handles.macros.nowplaying
hampoints = inputdlg(prompt,prompttitle);
if isempty(hampoints)
   return; 
end
hampoints = str2num(hampoints{:}); 
end
filteredSignal = movingaveragefilter(hObject,eventdata,handles,handles.signals.values(signalToFilter,:).',hampoints);
elseif filterType == 4
prompttitle = 'Maximum Frequency';
prompt = {'Maximum Frequency (Hz)'};
if ~handles.macros.nowplaying
maxfrequency = inputdlg(prompt,prompttitle,[1,35]);
if isempty(maxfrequency)
    return;
end
maxfrequency = cellfun(@str2num,maxfrequency,'un',0);  
maxfrequency = cell2mat(maxfrequency);
end

f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
Y= fft(handles.signals.values(signalToFilter,:).',size(handles.signals.values,2));
filteredSignal = zeros(1,size(handles.signals.values,2));
filteredSignal(1,1:find(f >= maxfrequency(1),1)) = Y(1:find(f >= maxfrequency(1),1));
filteredSignal = 2*real(ifft(filteredSignal)); 

elseif filterType == 5
prompttitle = 'Frequency Range';
prompt = {'Minimum Frequency (Hz)','Maximum Frequency (Hz)'};
if ~handles.macros.nowplaying
freqrange = inputdlg(prompt,prompttitle,[1,35]);
if isempty(freqrange)
    return;
end
freqrange = cellfun(@str2num,freqrange,'un',0);  
freqrange = cell2mat(freqrange);
end

f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
Y= fft(handles.signals.values(signalToFilter,:).',size(handles.signals.values,2));
filteredSignal = zeros(1,size(handles.signals.values,2));
filteredSignal(1,find(f >= freqrange(1),1):find(f >= freqrange(2),1)) = Y(find(f >= freqrange(1),1):find(f >= freqrange(2),1));
filteredSignal = 2*real(ifft(filteredSignal)); 

elseif filterType == 6
    prompttitle = 'Stop Band';
    prompt = {'Minimum Frequency (Hz)','Maximum Frequency (Hz)'};
    if ~handles.macros.nowplaying
    freqrange = inputdlg(prompt,prompttitle,[1,35]);
    if isempty(freqrange)
        return;
    end
    freqrange = cellfun(@str2num,freqrange,'un',0);  
    freqrange = cell2mat(freqrange);
    end
    
    f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
    Y= fft(handles.signals.values(signalToFilter,:).',size(handles.signals.values,2));
    filteredSignal = zeros(1,size(handles.signals.values,2));
    filteredSignal(1:length(f)) = Y(1:length(f)).';
    filteredSignal(1,find(f >= freqrange(1),1):find(f >= freqrange(2),1)) = zeros(1,length(find(f >= freqrange(1),1):find(f >= freqrange(2),1)));
    filteredSignal = 2*real(ifft(filteredSignal)); 

elseif filterType == 7
    prompttitle = 'Minimum Frequency';
    prompt = {'Minimum Frequency (Hz)'};
    if ~handles.macros.nowplaying
    minfrequency = inputdlg(prompt,prompttitle,[1,35]);
    if isempty(minfrequency)
        return;
    end
    minfrequency = cellfun(@str2num,minfrequency,'un',0);  
    minfrequency = cell2mat(minfrequency);
    end

    f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
    Y= fft(handles.signals.values(signalToFilter,:).',size(handles.signals.values,2));
    filteredSignal = zeros(1,size(handles.signals.values,2));
    filteredSignal(1,find(f >= minfrequency(1),1):length(f)) = Y(find(f >= minfrequency(1),1):length(f));
    filteredSignal = 2*real(ifft(filteredSignal));
end
handles.signals.values(signalToFilter,:) = filteredSignal;
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Signals_Filters');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d',signalToFilter)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d',filterType)));
if filterType == 1 || filterType == 2
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',fullfile(handles.macros.macropath,strcat(handles.macros.macroname,'.d'))));
elseif filterType == 3
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d',hampoints)));  
elseif filterType == 4
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',maxfrequency)); 
elseif filterType == 5
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%f,',freqrange)));
elseif filterType == 6
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%f,',freqrange)));
elseif filterType == 7
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',minfrequency));
end
playMacro(hObject, eventdata, handles)


% --- Executes on button press in mixsignalssignals.
function mixsignalssignals_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
mixInto = listdlg('PromptString','Mix into:','SelectionMode','single','ListString',handles.signals.names);
if isempty(mixInto)
   return; 
end
mixWith = listdlg('PromptString','Mix with:','SelectionMode','single','ListString',handles.signals.names);
if isempty(mixWith)
   return; 
end
prompt = {'Mixing parameter (0-1):'};
prompttitle = 'Mixing';
beta = inputdlg(prompt,prompttitle);
beta = str2num(beta{:});
if isempty(beta)
   return; 
end
list = {'Mix All','Stochastic Mixing (Partial)'};
mixingType = listdlg('PromptString','Mixing Type','SelectionMode','single','ListString',list);
if isempty(mixingType)
   return; 
end
elseif handles.macros.nowplaying
    mixInto = handles.macros.payload{1,1};
    mixWith = handles.macros.payload{2,1};
    beta = handles.macros.payload{3,1};
    mixingType = handles.macros.payload{4,1};
end
if mixingType == 1
handles.signals.values(mixInto,:) =  (1-beta).*handles.signals.values(mixInto,:) + beta.*handles.signals.values(mixWith,:);
elseif mixingType == 2
   for i=1:size(handles.signals.values,2)
       if rand >= beta
       handles.signals.values(mixInto,i) = (1-beta).*handles.signals.values(mixInto,i) + beta.*handles.signals.values(mixWith,i);
       end
   end
end
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Signals_MixSignals');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',num2str(mixInto)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',num2str(mixWith)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',num2str(beta)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',num2str(mixingType)));
playMacro(hObject, eventdata, handles)


% --- Executes on button press in definitiondetrendingvectors.
function definitiondetrendingvectors_Callback(hObject, eventdata, handles)
set(handles.allvectorslist, 'string', handles.signals.names);
guidata(hObject, handles)
switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendingvectorsdefinitionpanel')
eventrecorder(hObject, eventdata, handles, '> Detrend_Definition');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in detrenddetrendingvectors.
function detrenddetrendingvectors_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
signalsToDetrend = listdlg('PromptString','Signal(s) to detrend:','ListString',handles.signals.names);
if isempty(signalsToDetrend) || isempty(handles.signals.detrendingvectors)
   switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendedsignalspanel')
   return; 
end
elseif handles.macros.nowplaying
   if isempty(handles.macros.payload{1,1})
      switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendedsignalspanel')
      return; 
   end
   signalsToDetrend = handles.macros.payload{1,1};
end
handles.signals.detrendedoriginal = [handles.signals.detrendedoriginal;  signalsToDetrend.'];
for i=1:1:length(signalsToDetrend)
handles.signals.detrendedname{end+1} = handles.signals.names{signalsToDetrend(i)};
end
%Build detrending vectors matrix
detrendingVectors = [];
if handles.usefitsdetrendingvectors.Value == 0
    for i=1:1:length(handles.signals.detrendingvectors)
        detrendingVectors(end+1,:) = handles.signals.values(handles.signals.detrendingvectors(i),:);
    end
elseif handles.usefitsdetrendingvectors.Value == 1
    order = handles.signals.detrendingfitorder;
    for i=1:1:length(handles.signals.detrendingvectors)
    p = polyfit((1:size(handles.signals.values(handles.signals.detrendingvectors(i),:),2))', (handles.signals.values(handles.signals.detrendingvectors(i),:)).', order);    
    detrendingVectors(end+1,:) = (polyval(p, (1:size(handles.signals.values(handles.signals.detrendingvectors(i),:),2))')).';
    end
end

if handles.constantweightscheckbox.Value
for i=1:1:length(signalsToDetrend)
handles.signals.detrended(end+1,:) = handles.signals.values(signalsToDetrend(i),:) - (str2num(handles.weightsdetrendingvectors.String).')*detrendingVectors;
end
elseif ~handles.constantweightscheckbox.Value
    %In case the user didn't choose to explicitly provide weights, we
    %calculate the weights based on Gembris et al. (2000)
    global gammadata;
    for i=1:1:length(signalsToDetrend)
    SMatrix = detrendingVectors.'; %Each column should be a vector
    STranspose = SMatrix.';
    STS = STranspose*SMatrix;
    invSTS = inv(STS);
    gamma = invSTS * (STranspose*(handles.signals.values(signalsToDetrend(i),:)).');
    gammadata.predetrended.(char(handles.signals.names(signalsToDetrend(i)))) = [];
    gammadata.predetrended.(char(handles.signals.names(signalsToDetrend(i))))(1,:) = gamma.';
    disp('Gamma is: ')
    disp(gamma)
    handles.signals.detrended(end+1,:) = ((handles.signals.values(signalsToDetrend(i),:)).' - SMatrix*gamma).';
    end
end
cla(handles.axes3,'reset');
plot(handles.signals.detrended.','Parent', handles.axes3,'LineWidth',2);
legend(handles.axes3, strcat(handles.signals.detrendedname,'-detrended'));
x_axis = get(handles.axes3,'xtick');
set(handles.axes3,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
handles.signals.detrendingvectorsmatrix = detrendingVectors;
guidata(hObject, handles);
switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendedsignalspanel')
eventrecorder(hObject, eventdata, handles, '> Detrend_Detrend');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',signalsToDetrend)));
playMacro(hObject, eventdata, handles)


% --- Executes on selection change in allvectorslist.
function allvectorslist_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
    handles.allvectorslist.Value = handles.macros.payload{1,1};
end
eventrecorder(hObject, eventdata, handles, '> Detrend_AllVectorsList');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',handles.allvectorslist.Value));
playMacro(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function allvectorslist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in detrendingvectorslist.
function detrendingvectorslist_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
    handles.detrendingvectorslist.Value = handles.macros.payload{1,1};
end
eventrecorder(hObject, eventdata, handles, '> Detrend_DetrendingVectorsList');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',handles.detrendingvectorslist.Value));
playMacro(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function detrendingvectorslist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in adddetrendingvectors.
function adddetrendingvectors_Callback(hObject, eventdata, handles)
handles.signals.detrendingvectors = unique([handles.signals.detrendingvectors; handles.allvectorslist.Value],'stable');
handles.signals.detrendingvectornames{end+1} = handles.signals.names{handles.allvectorslist.Value};
handles.signals.detrendingvectornames = unique(handles.signals.detrendingvectornames,'stable');
set(handles.detrendingvectorslist,'string',handles.signals.detrendingvectornames);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Detrend_AddDetrendingVectors');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in usefitsdetrendingvectors.
function usefitsdetrendingvectors_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
   handles.usefitsdetrendingvectors.Value = 1 - 1.*(handles.usefitsdetrendingvectors.Value==1);
   try
   order = handles.macros.payload{1,1};
   catch
   end
   guidata(hObject, handles);
end

if handles.usefitsdetrendingvectors.Value == 1
if ~handles.macros.nowplaying
prompt = {'Order of fitting function:'};
prompttitle = 'PolyFit';
order = inputdlg(prompt,prompttitle);
order = str2num(order{:});
if isempty(order)
    order = 2;
   return; 
end
end
handles.signals.detrendingfitorder = order;
end
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Detrend_UseFits');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',num2str(order)));
playMacro(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of usefitsdetrendingvectors



function weightsdetrendingvectors_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
load(char(handles.macros.payload{1,1}),'-mat');
handles.weightsdetrendingvectors.String = weightsString;
guidata(hObject,handles)
end
eventrecorder(hObject, eventdata, handles, '> Detrend_ConstantWeights');
if handles.macros.recording == 1
weightsString = handles.weightsdetrendingvectors.String;
save(fullfile(handles.macros.macropath,'constantdetrendingweights.mat'),'weightsString','-mat');
end
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',fullfile(handles.macros.macropath,'constantdetrendingweights.mat')));
playMacro(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function weightsdetrendingvectors_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function stepsizeslidingwindows_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function stepsizeslidingwindows_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sizeincrementslidingwindows_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
   handles.sizeincrementslidingwindows.String = num2str(handles.macros.payload{1,1});
   guidata(hObject,handles);
end
initialSize = floor(str2num(handles.initialsizeslidingwindows.String)/handles.signals.tr);
sizeIncrement = floor(str2num(handles.sizeincrementslidingwindows.String)/handles.signals.tr);
N = size(handles.signals.values,2);
set(handles.windowcountslidingwindows, 'value',(floor((N-initialSize)/sizeIncrement) + 1));
set(handles.windowcountslidingwindows, 'string',num2str(floor((N-initialSize)/sizeIncrement) + 1));
guidata(hObject,handles)
eventrecorder(hObject, eventdata, handles, '> SlidingWindows_SizeIncrement');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',handles.sizeincrementslidingwindows.String));
playMacro(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function sizeincrementslidingwindows_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function initialsizeslidingwindows_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of initialsizeslidingwindows as text
%        str2double(get(hObject,'String')) returns contents of initialsizeslidingwindows as a double
if handles.macros.nowplaying
   handles.initialsizeslidingwindows.String = num2str(handles.macros.payload{1,1});
   guidata(hObject,handles);
end
initialSize = floor(str2num(handles.initialsizeslidingwindows.String)/handles.signals.tr);
sizeIncrement = floor(str2num(handles.sizeincrementslidingwindows.String)/handles.signals.tr);
N = size(handles.signals.values,2);
set(handles.windowcountslidingwindows, 'value',(floor((N-initialSize)/sizeIncrement) + 1));
set(handles.windowcountslidingwindows, 'string',num2str(floor((N-initialSize)/sizeIncrement) + 1));
guidata(hObject,handles)
eventrecorder(hObject, eventdata, handles, '> SlidingWindows_InitialSize');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',handles.initialsizeslidingwindows.String));
playMacro(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function initialsizeslidingwindows_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowcountslidingwindows_Callback(hObject, eventdata, handles)
set(handles.windowcountslidingwindows,'string',num2str(handles.windowcountslidingwindows.Value));
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function windowcountslidingwindows_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startanalysisslidingwindows.
function startanalysisslidingwindows_Callback(hObject, eventdata, handles)
switchPanel(hObject,eventdata,handles,'slidingwindowspanel')
initialSize = floor(str2num(handles.initialsizeslidingwindows.String)/handles.signals.tr);
sizeIncrement = floor(str2num(handles.sizeincrementslidingwindows.String)/handles.signals.tr);
N = size(handles.signals.values,2);
numberOfWindows = str2num(handles.windowcountslidingwindows.String);
displacement = str2num(handles.stepsizeslidingwindows.String);

if ~handles.macros.nowplaying
signalSet = listdlg('PromptString','Select signal set:','SelectionMode','single','ListString',{'Current','Detrended', 'Detrend Online', 'Original'});
if isempty(signalSet)
   return; 
end
elseif handles.macros.nowplaying
    signalSet = handles.macros.payload{1,1};
    signalsToCorrelate = handles.macros.payload{2,1};
    analysisName = cellstr(handles.macros.payload{3,1});
end

if signalSet == 1
    if ~handles.macros.nowplaying
    signalsToCorrelate = listdlg('PromptString','Select 2 signals:','ListString',handles.signals.names);
    end
    if isempty(signalsToCorrelate)
       return; 
    end
    signal1 = handles.signals.values(signalsToCorrelate(1),:);
    signal2 = handles.signals.values(signalsToCorrelate(2),:);
    dataToPlot = handles.signals.values(signalsToCorrelate,:);
    cla(handles.axes4,'reset');
    plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);
elseif signalSet == 2
    if ~handles.macros.nowplaying
    signalsToCorrelate = listdlg('PromptString','Select 2 detrended signals:','ListString',handles.signals.detrendedname);
    end
    if isempty(signalsToCorrelate)
       return; 
    end
    signal1 = handles.signals.detrended(signalsToCorrelate(1),:);
    signal2 = handles.signals.detrended(signalsToCorrelate(2),:);
    dataToPlot = handles.signals.detrended(signalsToCorrelate,:);
    cla(handles.axes4,'reset');
    plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);
elseif signalSet == 3 %i.e detrend in the current window
    if ~handles.macros.nowplaying
    signalsToCorrelate = listdlg('PromptString','Select 2 signals:','ListString',handles.signals.names);
    end
    if isempty(signalsToCorrelate)
       return; 
    end
    signal1 = handles.signals.values(signalsToCorrelate(1),:);
    signal2 = handles.signals.values(signalsToCorrelate(2),:);
    dataToPlot = handles.signals.values(signalsToCorrelate,:);
    cla(handles.axes4,'reset');
    plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);

    detrendingVectors = [];
    if handles.usefitsdetrendingvectors.Value == 0
        for i=1:1:length(handles.signals.detrendingvectors)
            detrendingVectors(end+1,:) = handles.signals.values(handles.signals.detrendingvectors(i),:);
        end
    elseif handles.usefitsdetrendingvectors.Value == 1
        order = handles.signals.detrendingfitorder;
        for i=1:1:length(handles.signals.detrendingvectors)
        p = polyfit((1:size(handles.signals.values(handles.signals.detrendingvectors(i),:),2))', (handles.signals.values(handles.signals.detrendingvectors(i),:)).', order);    
        detrendingVectors(end+1,:) = (polyval(p, (1:size(handles.signals.values(handles.signals.detrendingvectors(i),:),2))')).';
        end
    end
    
elseif signalSet == 4
    if ~handles.macros.nowplaying
    signalsToCorrelate = listdlg('PromptString','Select 2 original signals:','ListString',handles.signals.names);
    end
    if isempty(signalsToCorrelate)
       return; 
    end
    signal1 = handles.signals.original(signalsToCorrelate(1),:);
    signal2 = handles.signals.original(signalsToCorrelate(2),:);
    dataToPlot = handles.signals.original(signalsToCorrelate,:);
    cla(handles.axes4,'reset');
    plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);
end
x_axis = get(handles.axes4,'xtick');
set(handles.axes4,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
windowSizes = [];
meanWindowCorrelations = [];
meanWindowZScores = [];
for i=1:1:numberOfWindows
   windowSize = initialSize + (i-1)*sizeIncrement;
   windowSizes = [windowSizes; windowSize];
   keepMoving = 1;
   j = 1;
   correlation = [];
   zScore = [];
   signal1CumulativeSlice = [];
   signal2CumulativeSlice = [];
   global gammadata;
   gammadata.detrendonline.(char(strcat('w',num2str(windowSize)))).(char(handles.signals.names(signalsToCorrelate(1)))) = [];
   gammadata.detrendonline.(char(strcat('w',num2str(windowSize)))).(char(handles.signals.names(signalsToCorrelate(2)))) = [];
   while keepMoving == 1
       leftLeg = 1 + (j-1)*displacement;
       rightLeg = windowSize + (j-1)*displacement;
       nextRightLeg = windowSize + j*displacement; 
       signal1Slice = signal1(leftLeg:rightLeg);
       signal2Slice = signal2(leftLeg:rightLeg);
       if signalSet == 3 %i.e window detrend
         detrendMatrixSlice = detrendingVectors(:,leftLeg:rightLeg);
             if handles.constantweightscheckbox.Value
                    constantGamma = str2num(handles.weightsdetrendingvectors.String).';
                    constantGammaSlice = constantGamma(leftLeg:rightLeg);
                    signal1Slice = signal1Slice - (constantGammaSlice)*detrendMatrixSlice;
                    signal2Slice = signal2Slice - (constantGammaSlice)*detrendMatrixSlice;
                elseif ~handles.constantweightscheckbox.Value
                    %In case the user didn't choose to explicitly provide weights, we
                    %calculate the weights based on Gembris et al. (2000)
                    SMatrix = detrendMatrixSlice.';
                    STranspose = SMatrix.';
                    STS = STranspose*SMatrix;
                    invSTS = inv(STS);
                    gamma1 = invSTS * (STranspose*signal1Slice.');
                    gamma2 = invSTS * (STranspose*signal2Slice.');
                    gammadata.detrendonline.(char(strcat('w',num2str(windowSize)))).(char(handles.signals.names(signalsToCorrelate(1))))(end+1,:) = gamma1.';
                    gammadata.detrendonline.(char(strcat('w',num2str(windowSize)))).(char(handles.signals.names(signalsToCorrelate(2))))(end+1,:) = gamma2.';
                    disp('Gamma 1 is: ')
                    disp(gamma1)
                    disp('Gamma 2 is: ')
                    disp(gamma2)
                    signal1Slice = (signal1Slice.' - SMatrix*gamma1).';
                    signal2Slice = (signal2Slice.' - SMatrix*gamma2).';
             end

       end
       currentcorrelation = correlatesignals(signal1Slice.',signal2Slice.',handles);
       currentcorrelation = currentcorrelation(2,1);
       correlation = [correlation; currentcorrelation];
       zScore = [zScore; atanh(currentcorrelation)];
       if j==1
       signal1CumulativeSlice = signal1Slice;
       signal2CumulativeSlice = signal2Slice; 
       end
       if j>1
       signal1CumulativeSlice = [signal1CumulativeSlice(1:j-1),signal1Slice];
       signal2CumulativeSlice = [signal2CumulativeSlice(1:j-1),signal2Slice];
       if signalSet ~=2 %Because 2 is pre-detrended. i.e signal is fully known in advance
       dataToPlot = [signal1CumulativeSlice;signal2CumulativeSlice];
       cla(handles.axes4,'reset');
       hold(handles.axes4,'on')
       xlim(handles.axes4,[0 size(handles.signals.values,2)]);
       plot(dataToPlot.','Parent', handles.axes4,'LineWidth',2);
       hold(handles.axes4,'off')
       end
       YLimit = handles.axes4.YLim;
       rect = rectangle(handles.axes4,'Position',[leftLeg YLimit(1) windowSize (YLimit(2)-YLimit(1))]);
       textToDisplay = sprintf('Current Correlation: %s \nCurrent Z-Score: %s \nRunning average correlation: %s \nRunning Average Z-Score: %s',num2str(currentcorrelation),num2str(atanh(currentcorrelation)),num2str(mean(correlation)),num2str(mean(zScore)));
       txt = text((leftLeg), (YLimit(1)+ (YLimit(2)-YLimit(1))/2), textToDisplay, 'Parent', handles.axes4);
       set(handles.axes4,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
       pause(0.01);
       delete(rect);
       delete(txt);
       end
       if (nextRightLeg > N)
                if signalSet == 3
                h1 = figure;
                ax1 = axes;
                currax = handles.axes4;
                copyobj( findobj(currax, 'visible', 'on','type','line'), ax1 );
                legend(ax1,handles.signals.names([signalsToCorrelate(1),signalsToCorrelate(2)]));
                currentDir = pwd;
                cd(sprintf('%s',handles.savedir));
                mkdir 'detrendedonline'
                cd 'detrendedonline'
                savefig(h1,strcat(num2str(windowSize),'-',char(datestr(now,'mm-dd-yyyy HH-MM')),'.fig'));
                cd(sprintf('%s',currentDir));
                close(h1);
                end
           break;
       end
       j = j + 1;
   end
   meanCorrelation = mean(correlation);
   meanWindowCorrelations = [meanWindowCorrelations; meanCorrelation];
   meanZScore = mean(zScore);
   meanWindowZScores = [meanWindowZScores; meanZScore];
   currentDir = pwd;
   cd(sprintf('%s',handles.savedir));
   csvwrite(char(strcat('correlations_w',num2str(i),'_',char(datestr(now,'mm-dd-yyyy HH-MM')),'.csv')),correlation);
   csvwrite(char(strcat('zscores_w',num2str(i),'_',char(datestr(now,'mm-dd-yyyy HH-MM')),'.csv')),zScore);
   cd(sprintf('%s',currentDir));
end
handles.signals.meanwindowcorrelations = meanWindowCorrelations;
handles.signals.meanwindowzscores = meanWindowZScores;
handles.signals.windowsizes = windowSizes;
handles.sw.slidingwindowresults{end+1} = [handles.signals.windowsizes,handles.signals.meanwindowcorrelations];
handles.sw.slidingwindowzscoreresults{end+1} = [handles.signals.windowsizes,handles.signals.meanwindowzscores];
prompt = {'Name the analysis:'};
prompttitle = 'Name';
if ~handles.macros.nowplaying
analysisName = inputdlg(prompt,prompttitle);
end
if isempty(analysisName)
   analysisName = 'Untitled'; 
end
handles.sw.slidingwindownames(end+1) = analysisName;

%Store results for batch mode
try
handles.batchmode.windowcorrelations.(char(analysisName))(end+1,:) = handles.signals.meanwindowcorrelations.';
handles.batchmode.windowzscores.(char(analysisName))(end+1,:) = handles.signals.meanwindowzscores.';
handles.batchmode.windowsizes.(char(analysisName))(end+1,:) = handles.signals.windowsizes.';
catch
handles.batchmode.windowcorrelations.(char(analysisName)) = [];  
handles.batchmode.windowzscores.(char(analysisName)) = []; 
handles.batchmode.windowsizes.(char(analysisName)) = [];
handles.batchmode.windowcorrelations.(char(analysisName))(end+1,:) = handles.signals.meanwindowcorrelations.';
handles.batchmode.windowzscores.(char(analysisName))(end+1,:) = handles.signals.meanwindowzscores.';
handles.batchmode.windowsizes.(char(analysisName))(end+1,:) = handles.signals.windowsizes.';
end

guidata(hObject,handles)
cla(handles.axes5,'reset');
plot(handles.signals.windowsizes,handles.signals.meanwindowcorrelations,'Parent', handles.axes5,'LineWidth',2);
x_axis = get(handles.axes5,'xtick');
set(handles.axes5,'xticklabel',arrayfun(@num2str,x_axis*handles.signals.tr,'un',0));
currentDir = pwd;
cd(sprintf('%s',handles.savedir));
csvwrite(char(strcat(analysisName,char(datestr(now,'mm-dd-yyyy HH-MM')),'.csv')),[handles.signals.windowsizes,handles.signals.meanwindowcorrelations]);
cd(sprintf('%s',currentDir));
switchPanel(hObject,eventdata,handles,'slidingwindowspanel','resultsslidingwindowspanel')
eventrecorder(hObject, eventdata, handles, '> SlidingWindows_StartAnalysis');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',signalSet));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,%d',signalsToCorrelate(1),signalsToCorrelate(2))));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',analysisName{:}));
playMacro(hObject, eventdata, handles)

% --- Executes on selection change in selectcorrelations1.
function selectcorrelations1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function selectcorrelations1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectcorrelations2.
function selectcorrelations2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function selectcorrelations2_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculatecorrelation.
function calculatecorrelation_Callback(hObject, eventdata, handles)
signal1 = (handles.signals.values(handles.selectcorrelations1.Value,:)).';
signal2 = (handles.signals.values(handles.selectcorrelations2.Value,:)).';
correlation = correlatesignals(signal1,signal2,handles);
correlation = correlation(2,1);
zScore = atanh(correlation);
handles.outputcorrelations.String = sprintf('Correlation: %s,  Z-score: %s',num2str(correlation),num2str(zScore));
guidata(hObject,handles)

% --- Executes on selection change in selectdetrendedcorrelations1.
function selectdetrendedcorrelations1_Callback(hObject, eventdata, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns selectdetrendedcorrelations1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectdetrendedcorrelations1


% --- Executes during object creation, after setting all properties.
function selectdetrendedcorrelations1_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectdetrendedcorrelations2.
function selectdetrendedcorrelations2_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns selectdetrendedcorrelations2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectdetrendedcorrelations2


% --- Executes during object creation, after setting all properties.
function selectdetrendedcorrelations2_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculatedetendedcorrelations.
function calculatedetendedcorrelations_Callback(hObject, eventdata, handles)
signal1 = (handles.signals.detrended(handles.selectdetrendedcorrelations1.Value,:)).';
signal2 = (handles.signals.detrended(handles.selectdetrendedcorrelations2.Value,:)).';
correlation = correlatesignals(signal1,signal2,handles);
correlation = correlation(2,1);
zScore = atanh(correlation);
handles.outputcorrelations2.String = sprintf('Correlation: %s,  Z-score: %s',num2str(correlation),num2str(zScore));
guidata(hObject,handles)

% --- Executes on button press in showonlysignalscheckbox.
function showonlysignalscheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to showonlysignalscheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.macros.nowplaying
    handles.showonlysignalscheckbox.Value = 1 - 1.*(handles.showonlysignalscheckbox.Value == 1);
    guidata(hObject,handles);
end
updatePlots(hObject,eventdata,handles)
eventrecorder(hObject, eventdata, handles, '> ShowSelectedSignalsCheckbox');
playMacro(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of showonlysignalscheckbox


% --- Executes on button press in selectsignalssignalspush.
function selectsignalssignalspush_Callback(hObject, eventdata, handles)
% hObject    handle to selectsignalssignmatlab save .mat filealspush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.macros.nowplaying
signalSet = listdlg('PromptString','Select signal set:','SelectionMode','single','ListString',{'Current','Detrended','Original'});
elseif handles.macros.nowplaying
    signalSet = handles.macros.payload{1,1};
    signalsToDisplay = handles.macros.payload{2,1};
end
if isempty(signalSet)
   return; 
end
if signalSet ==1
if ~handles.macros.nowplaying
signalsToDisplay = listdlg('PromptString','Select signals:','ListString',handles.signals.names);
end
if isempty(signalsToDisplay)
   return; 
end
signalNames = handles.signals.names(signalsToDisplay);
end
if signalSet == 2
   if ~handles.macros.nowplaying
   signalsToDisplay = listdlg('PromptString','Select signals:','ListString',handles.signals.detrendedname);
   end
    if isempty(signalsToDisplay)
       return; 
    end 
signalNames = handles.signals.detrendedname(signalsToDisplay);
signalNames = strcat(signalNames,'-detrended');
end
if signalSet ==3
if ~handles.macros.nowplaying
signalsToDisplay = listdlg('PromptString','Select signals:','ListString',handles.signals.names);
end
if isempty(signalsToDisplay)
   return; 
end
signalNames = handles.signals.names(signalsToDisplay);
signalNames = strcat(signalNames,'-original');
end
if handles.clearpreviousselections.Value == 1
   handles.signals.displayonly = [];
   handles.signals.displayset = [];
   handles.signals.displayonlynames = {};
end
handles.signals.displayonly = [handles.signals.displayonly; signalsToDisplay.'];
for i=1:1:length(signalNames)
handles.signals.displayonlynames{end+1} = signalNames{i};
end
for i=1:1:length(signalsToDisplay)
handles.signals.displayset = [handles.signals.displayset; signalSet.'];
end
guidata(hObject, handles);
updatePlots(hObject,eventdata,handles)
eventrecorder(hObject, eventdata, handles, '> SelectSignalsButton');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',signalSet));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',signalsToDisplay)));
playMacro(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function selectsignalssignalspush_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectsignalssignalspush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in detrendingresults.
function detrendingresults_Callback(hObject, eventdata, handles)
% hObject    handle to detrendingresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switchPanel(hObject,eventdata,handles,'detrendingvectorspanel','detrendedsignalspanel')
eventrecorder(hObject, eventdata, handles, '> Detrend_DetrendedSignals');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in resultsslidingwindows.
function resultsslidingwindows_Callback(hObject, eventdata, handles)
% hObject    handle to resultsslidingwindows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.macros.nowplaying
corrOrzscore = listdlg('PromptString','Plot what?','SelectionMode','single','ListString',{'Correlations','Z-Scores'});
if isempty(corrOrzscore)
   return; 
end
plotsToDisplay = listdlg('PromptString','Select plots:','ListString',handles.sw.slidingwindownames);
elseif handles.macros.nowplaying
    corrOrzscore = handles.macros.payload{1,1};
    plotsToDisplay = handles.macros.payload{2,1};
end
if isempty(plotsToDisplay)
   return; 
end
cla(handles.axes5,'reset');

global analysesTitles;
analysesTitles = {};
for i=1:1:length(plotsToDisplay)
if corrOrzscore == 1
dataToPlot = handles.sw.slidingwindowresults{plotsToDisplay(i)};
elseif corrOrzscore == 2
dataToPlot = handles.sw.slidingwindowzscoreresults{plotsToDisplay(i)};    
end
analysesTitles{end+1} = handles.sw.slidingwindownames{plotsToDisplay(i)};
hold(handles.axes5,'on')
plot(dataToPlot(:,1),dataToPlot(:,2),'Parent', handles.axes5,'LineWidth',2);
end
legend(handles.axes5, analysesTitles);
hold(handles.axes5,'off')

switchPanel(hObject,eventdata,handles,'slidingwindowspanel','resultsslidingwindowspanel')
eventrecorder(hObject, eventdata, handles, '> SlidingWindows_Results');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d',corrOrzscore)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',plotsToDisplay)));
playMacro(hObject, eventdata, handles)


% --- Executes on button press in constantweightscheckbox.
function constantweightscheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to constantweightscheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.macros.nowplaying
   handles.constantweightscheckbox.Value = 1 - 1.*(handles.constantweightscheckbox.Value == 1);
   guidata(hObject,handles);
end
eventrecorder(hObject, eventdata, handles, '> Detrend_UseConstantWeightsCheckbox');
playMacro(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of constantweightscheckbox


% --- Executes on button press in clearpreviousselections.
function clearpreviousselections_Callback(hObject, eventdata, handles)
% hObject    handle to clearpreviousselections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.macros.nowplaying
   handles.clearpreviousselections.Value = 1 - 1.*(handles.clearpreviousselections.Value == 1);
   guidata(hObject,handles);
end
eventrecorder(hObject, eventdata, handles, '> ClearPreviousSelectionsCheckbox');
playMacro(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of clearpreviousselections


% --- Executes on button press in xshiftconfounds.
function xshiftconfounds_Callback(hObject, eventdata, handles)
% hObject    handle to xshiftconfounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Shift by (s):'};
prompttitle = 'Horizontal Shift';
if ~handles.macros.nowplaying
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
shiftamplitude = str2num(amplitude{:})/handles.signals.tr;
elseif handles.macros.nowplaying
  shiftamplitude = handles.macros.payload{1,1};
end
signalToModify = handles.selectsignalconfounds.Value;
shiftedsignal = circshift(handles.signals.values(signalToModify,:),shiftamplitude,2);
handles.signals.values(signalToModify,:) = shiftedsignal;
handles.signals.confoundtypes{end+1} = 'xshift';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Xshift');
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',shiftamplitude));  
playMacro(hObject, eventdata, handles)


% --- Executes on button press in loadcase.
function loadcase_Callback(hObject, eventdata, handles)
% hObject    handle to loadcase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, filePath] = uigetfile({'*.case'});
try
load(fullfile(filePath,file),'-mat');
catch
    return;
end
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes on button press in savecase.
function savecase_Callback(hObject, eventdata, handles)
% hObject    handle to savecase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gammadata
if ~handles.macros.nowplaying
[file, filePath] = uiputfile({'*.case'});
elseif handles.macros.nowplaying
    file = strcat('c',num2str(handles.macros.macroiteration),'.case');
    filePath = fullfile(handles.savedir,'macrosaves');
end
try
save(fullfile(filePath,file),'-mat');
catch
    disp('Save unsuccessful')
    return;
end

eventrecorder(hObject, eventdata, handles, '> SaveCase');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in deletedetrendingvector.
function deletedetrendingvector_Callback(hObject, eventdata, handles)
handles.signals.detrendingvectors(handles.detrendingvectorslist.Value) = [];
handles.signals.detrendingvectornames(handles.detrendingvectorslist.Value) = [];
handles.detrendingvectorslist.Value = 1;
set(handles.detrendingvectorslist,'string',handles.signals.detrendingvectornames);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Detrend_DeleteDetrendingVectors');
playMacro(hObject, eventdata, handles)


% --- Executes on button press in savefigure.
function savefigure_Callback(hObject, eventdata, handles)
warning('off')
if ~handles.macros.nowplaying
figureSet = listdlg('PromptString','Select Figure(s):','ListString',{'Signals (Main)','Pre-detrended (All)', 'Sliding Windows (Results)', 'FFT'});
elseif handles.macros.nowplaying
   figureSet = handles.macros.payload{1,1}; 
end

if isempty(figureSet)
   return; 
end

currentDir = pwd;
if isempty(handles.savedir)
   handles.savedir = pwd; 
end
cd(sprintf('%s',handles.savedir));

mkdir 'savedplots'
cd 'savedplots'

currentTime = datestr(now,'mm-dd-yyyy HH-MM');
mkdir(sprintf('%s',currentTime));
cd(sprintf('%s',currentTime));
for i=1:1:length(figureSet)
    if figureSet(i) == 1
    h1 = figure;
    ax1 = axes;
    currax = handles.axes1;
    copyobj( findobj(currax, 'visible', 'on','type','line'), ax1 );
    if handles.showonlysignalscheckbox.Value == 1
        legend(ax1,handles.signals.displayonlynames);
    elseif handles.showonlysignalscheckbox.Value == 0
        legend(ax1,handles.signals.names);
    end

    ylabel(ax1,'Amplitude', 'fontsize', 10)
    xlabel(ax1,'Data Point','fontsize', 10)
    savefig(h1,'Signals.fig');
    close(h1);
    elseif figureSet(i) == 2
    h1 = figure;
    ax1 = axes;
    currax = handles.axes3;
    copyobj( findobj(currax, 'visible', 'on','type','line'), ax1 );
    legend(ax1,handles.signals.detrendedname);

    ylabel(ax1,'Amplitude', 'fontsize', 10)
    xlabel(ax1,'Data Point','fontsize', 10)
    savefig(h1,'Predetrended.fig');
    close(h1);
    elseif figureSet(i) == 3
    h1 = figure;
    ax1 = axes;
    currax = handles.axes5;
    copyobj( findobj(currax, 'visible', 'on','type','line'), ax1 );
    global analysesTitles;
    legend(ax1,analysesTitles);
    savefig(h1,'SlidingWindows.fig');
    close(h1);
    elseif figureSet(i) == 4
    h1 = figure;
    ax1 = axes;
    currax = handles.axes6;
    copyobj( findobj(currax, 'visible', 'on','type','line'), ax1 );
    if handles.showonlysignalscheckbox.Value == 1
        legend(ax1,handles.signals.displayonlynames);
    elseif handles.showonlysignalscheckbox.Value == 0
        legend(ax1,handles.signals.names);
    end
    try 
    xlim(handles.signals.xlimfft);
    ylim(handles.signals.ylimfft);
     catch
         try
         ylim(handles.signals.ylimfft);
         catch
        end
    end
    savefig(h1,'FFT.fig');
    close(h1);
    end
end
cd(sprintf('%s',currentDir));
eventrecorder(hObject, eventdata, handles, '> SaveFigures');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',figureSet)));
playMacro(hObject, eventdata, handles)

% --- Executes on button press in recordmacro.
function recordmacro_Callback(hObject, eventdata, handles)
[file, filePath] = uiputfile({'*.ktmacro'});
try
fileID = fopen(fullfile(filePath,file),'w');
fclose(fileID);
catch
    disp('Record canceled')
    return;
end
set(handles.recordmacro, 'visible', 'off')
handles.macros.macrofile = fullfile(filePath,file);
handles.macros.macropath = filePath;
handles.macros.macroname = strtok(file,'.');
handles.macros.recording = 1;
set(handles.stoprecording, 'visible', 'on')

guidata(hObject,handles);


% --- Executes on button press in playmacro.
function playmacro_Callback(hObject, eventdata, handles)
[file, filePath] = uigetfile({'*.ktmacro'});
%Read the macro file
try
global filelines
filelines.notDelimited = regexp(fileread(fullfile(filePath,file)),'\n','split');
filelines.notDelimited = filelines.notDelimited.';
filelines.delimited = {};
filelines.linetype = {};
filelines.commandlines = {};
filelines.constantinputlines = {};
filelines.variableinputlines = {};
%Find out how many inputs each command has
%To do that we need to recognize the type of each line
for i=1:1:size(filelines.notDelimited,1)
    filelines.delimited{i,1} = strsplit(filelines.notDelimited{i},{' ','\t'});
    if strcmp(filelines.delimited{i,1}{1,1}, '>')
        filelines.linetype{i,1} = 'command';
        filelines.commandlines{end+1,1} = i; %This stores the reference to the command line
        filelines.commandlines{end,2} = 0; %This stores the number of inputs
    elseif strcmp(filelines.delimited{i,1}{1,1}, '>>')
        filelines.linetype{i,1} = 'constantinput';
        filelines.constantinputlines{end+1,1} = i;
        filelines.commandlines{end,2} = filelines.commandlines{end,2} + 1;
    elseif strcmp(filelines.delimited{i,1}{1,1}, '>>>')
        filelines.linetype{i,1} = 'variableinput';
        filelines.variableinputlines{end+1,1} = i;
        filelines.commandlines{end,2} = filelines.commandlines{end,2} + 1;
    else 
        filelines.linetype{i,1} = 'undefined';
    end
end
catch
    return;
end


%Build action matrix for macro iteration checks
for k=1:1:size(filelines.delimited,1)
    filelines.actionmatrix{k,1} = size(filelines.delimited{k,1},2) - 2;
end

handles.macros.nowplaying = 1;
guidata(hObject,handles);
%Now actually playing the macro
set(handles.playmacro,'String','Now Playing..');
global currentmacrocommand
currentmacrocommand = 1;
playMacro(hObject,eventdata, handles);


function playMacro(hObject, eventdata, handles)
if handles.macros.nowplaying
global filelines
global currentmacrocommand
i = currentmacrocommand;
if i<=size(filelines.commandlines,1)


%Now need to built the input payload
handles.macros.payload = {};
%global macropayloads;
payload = {};
if filelines.commandlines{i,2} >= 1 %That's the number of inputs
    for j=1:1:filelines.commandlines{i,2}
        if strcmp(filelines.linetype{filelines.commandlines{i,1}+j,1}, 'constantinput')
        payload{j,1} = filelines.delimited{filelines.commandlines{i,1}+j,1}{1,2};
        end
        if strcmp(filelines.linetype{filelines.commandlines{i,1}+j,1}, 'variableinput') && isempty(handles.macros.nruns)
          if size(filelines.delimited{filelines.commandlines{i,1}+j,1},2) >= (1+handles.macros.macroiteration)
             payload{j,1} = filelines.delimited{filelines.commandlines{i,1}+j,1}{1,1+handles.macros.macroiteration};
            filelines.delimited{filelines.commandlines{i,1}+j,1}(:,1+handles.macros.macroiteration) = [];
          end
        end
        if strcmp(filelines.linetype{filelines.commandlines{i,1}+j,1}, 'variableinput') && isempty(handles.macros.nruns)
            disp('You may not use multiple runs option with variable input on the same macro. Please refer to the user manual.');
            return;
        end
    end
end

filelines.previousactionmatrix = filelines.actionmatrix;

%Update action matrix for macro iteration checks
for k=1:1:size(filelines.delimited,1)
    filelines.actionmatrix{k,1} = size(filelines.delimited{k,1},2) - 2;
end


    for j=1:1:size(payload,1)
        if ~isempty(payload{j,1})
        if ~isempty(str2num(payload{j,1}))
        payload{j,1} = str2num(payload{j,1});
        end
        end
    end
%macropayloads{end+1} = payload;
handles.macros.payload = payload;
guidata(hObject,handles);
%Now execute the call function
command = filelines.delimited{filelines.commandlines{i,1},1}{1,2};
currentmacrocommand = currentmacrocommand + 1;
pause(1);
disp(sprintf('%s',command));
eval(char(translatemacro(hObject, eventdata, handles, command)));
elseif i>size(filelines.commandlines,1) && max([filelines.actionmatrix{:}]) >=1 
    currentmacrocommand = 1;
    playMacro(hObject, eventdata, handles);
elseif i>size(filelines.commandlines,1) && max([filelines.actionmatrix{:}]) <= 0
    if ~isempty(handles.macros.nruns)
    handles.macros.nruns = handles.macros.nruns - 1;
    currentmacrocommand = 1;
        if handles.macros.nruns == 0
           handles.macros.nruns = [];
           set(handles.playmacro,'String','Play Macro');
           handles.macros.nowplaying = 0;
        end
    guidata(hObject,handles);
    playMacro(hObject, eventdata, handles);
    end
    if isempty(handles.macros.nruns)
    handles.macros.nowplaying = 0;
    set(handles.playmacro,'String','Play Macro');
    guidata(hObject,handles);
    end
end
end



% --- Executes on button press in stoprecording.
function stoprecording_Callback(hObject, eventdata, handles)
set(handles.recordmacro,'Value', 0)
set(handles.stoprecording, 'visible', 'off')
set(handles.recordmacro, 'visible', 'on')
handles.macros.recording = 0;
guidata(hObject,handles);

function eventrecorder(hObject, eventdata, handles, txt)
if handles.macros.recording == 1
fileID = fopen(handles.macros.macrofile,'a');
fprintf(fileID, '%s\n',txt);
fclose(fileID);
end

function translation = translatemacro(hObject, eventdata, handles, command)
switch command
     case 'Signals'
        translation = 'signals_Callback(hObject, eventdata, handles)';
     case 'Confounds'
        translation = 'confounds_Callback(hObject, eventdata, handles)';
     case 'Detrend'
        translation = 'detrendingvectors_Callback(hObject, eventdata, handles)';
     case 'Reset'
        translation = 'reset_Callback(hObject, eventdata, handles)';
     case 'Correlations'
        translation = 'correlations_Callback(hObject, eventdata, handles)';
     case 'About'
        translation = 'help_Callback(hObject, eventdata, handles)';
     case 'SlidingWindows'
        translation = 'slidingwindows_Callback(hObject, eventdata, handles)';       
     case 'Signals_ImportSignals'
        translation = 'importsignal_Callback(hObject, eventdata, handles)';
     case 'Signals_GenerateRandomSignal'
        translation = 'generaterandomsignal_Callback(hObject, eventdata, handles)';
     case 'Signals_ExportSignals'
        translation = 'exportsignal_Callback(hObject, eventdata, handles)';
     case 'Signals_Undo'
        translation = 'undosignals_Callback(hObject, eventdata, handles)';  
     case 'Confounds_Boxcar'
        translation = 'boxcarconfounds_Callback(hObject, eventdata, handles)';      
     case 'Confounds_Spike'
        translation = 'spikeconfounds_Callback(hObject, eventdata, handles)';    
     case 'Confounds_Drift'
        translation = 'driftconfounds_Callback(hObject, eventdata, handles)';     
     case 'Confounds_Xshift'
        translation = 'xshiftconfounds_Callback(hObject, eventdata, handles)';
     case 'Confounds_Yshift'
        translation = 'yshift_Callback(hObject, eventdata, handles)'; 
     case 'Confounds_Sinusoid'
        translation = 'sinusoidconfounds_Callback(hObject, eventdata, handles)';     
     case 'Confounds_Undo'
        translation = 'undoconfounds_Callback(hObject, eventdata, handles)';        
     case 'Confounds_SelectSignal'
        translation = 'selectsignalconfounds_Callback(hObject, eventdata, handles)';       
     case 'Signals_AddNoise'
        translation = 'addnoisesignals_Callback(hObject, eventdata, handles)';      
     case 'Signals_Filters'
        translation = 'filterssignals_Callback(hObject, eventdata, handles)';    
     case 'Signals_MixSignals'
        translation = 'mixsignalssignals_Callback(hObject, eventdata, handles)';       
     case 'Detrend_Definition'
        translation = 'definitiondetrendingvectors_Callback(hObject, eventdata, handles)';     
     case 'Detrend_Detrend'  
        translation = 'detrenddetrendingvectors_Callback(hObject, eventdata, handles)';    
     case 'Detrend_AddDetrendingVectors'
        translation = 'adddetrendingvectors_Callback(hObject, eventdata, handles)';      
     case 'Detrend_UseFits'
        translation = 'usefitsdetrendingvectors_Callback(hObject, eventdata, handles)';    
     case 'SlidingWindows_SizeIncrement'
        translation = 'sizeincrementslidingwindows_Callback(hObject, eventdata, handles)';      
     case 'SlidingWindows_InitialSize'
        translation = 'initialsizeslidingwindows_Callback(hObject, eventdata, handles)';      
     case 'SlidingWindows_StartAnalysis'
        translation = 'startanalysisslidingwindows_Callback(hObject, eventdata, handles)';     
     case 'ShowSelectedSignalsCheckbox'
        translation = 'showonlysignalscheckbox_Callback(hObject, eventdata, handles)';     
     case 'SelectSignalsButton'
        translation = 'selectsignalssignalspush_Callback(hObject, eventdata, handles)';      
     case 'Detrend_DetrendedSignals'
        translation = 'detrendingresults_Callback(hObject, eventdata, handles)';       
     case 'SlidingWindows_Results'
        translation = 'resultsslidingwindows_Callback(hObject, eventdata, handles)';   
     case 'Detrend_UseConstantWeightsCheckbox'
        translation = 'constantweightscheckbox_Callback(hObject, eventdata, handles)';      
     case 'ClearPreviousSelectionsCheckbox'
        translation = 'clearpreviousselections_Callback(hObject, eventdata, handles)';     
     case 'SaveCase'         
        translation = 'savecase_Callback(hObject, eventdata, handles)';   
     case 'Detrend_DeleteDetrendingVectors'
        translation = 'deletedetrendingvector_Callback(hObject, eventdata, handles)';     
     case 'SaveFigures'
        translation = 'savefigure_Callback(hObject, eventdata, handles)';   
     case 'Detrend_AllVectorsList'
        translation = 'allvectorslist_Callback(hObject, eventdata, handles)';
     case 'Detrend_DetrendingVectorsList'
        translation = 'detrendingvectorslist_Callback(hObject, eventdata, handles)';
     case 'Detrend_ConstantWeights'
        translation = 'weightsdetrendingvectors_Callback(hObject, eventdata, handles)';
     case 'DefineTR'
        translation = 'definetr_Callback(hObject, eventdata, handles)';
     case 'FFT'
        translation = 'fftbutton_Callback(hObject, eventdata, handles)';
     case 'NRuns'
        translation = 'setNRuns(hObject,eventdata,handles)';
    case 'CorrelationFormula'
        translation = 'selectcorrelationformula_Callback(hObject, eventdata, handles)';
    case 'SlidingWindows_BatchMode'
        translation = 'batchmodesw_Callback(hObject, eventdata, handles)';
    case 'SavePlotsGammas'
        translation = 'savegammas_Callback(hObject, eventdata, handles)';
    case 'FrequencyConfounds'
        translation = 'frequencyConfoundsMenu_Callback(hObject, eventdata, handles)';
    case 'FrequencyConfounds_AddConfound'
        translation = 'addConfoundFC_Callback(hObject, eventdata, handles)';
    case 'FrequencyConfounds_GenerateSignal'
        translation = 'generateSignalFromFreq_Callback(hObject, eventdata, handles)';
    case '> FrequencyConfounds_SelectSignal'
        translation = 'selectSignalFC_Callback(hObject, eventdata, handles)';
    otherwise
        translation = 'unknown';
end

function setNRuns(hObject,eventdata,handles)
if handles.macros.nowplaying == 1
    if isempty(handles.macros.nruns)
    handles.macros.nruns = handles.macros.payload{1,1};
    guidata(hObject,handles);
    end
end
playMacro(hObject,eventdata, handles);

% --- Executes on button press in fftbutton.
function fftbutton_Callback(hObject, eventdata, handles)
%Amplitude part is based on new_filter_FFT8 by Cameron Trapp and Kishore
%Vakamudi
if handles.showonlysignalscheckbox.Value == 0
    cla(handles.axes6,'reset');
    for i=1:1:size(handles.signals.values,1)
        f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
        Y= fft(handles.signals.values(i,:).',size(handles.signals.values,2));
        Pyy=Y.*conj(Y)/size(handles.signals.values,2);
        hold(handles.axes6,'on')
        plot(f,Pyy(1:size(handles.signals.values,2)/2),'Parent', handles.axes6,'LineWidth',2);
        legend(handles.axes6,handles.signals.names);
        ylabel(handles.axes6,'Amplitude', 'fontsize', 10)
        xlabel(handles.axes6,'Frequency (Hz)','fontsize', 10)
    end
    hold(handles.axes6,'off')
end

if handles.showonlysignalscheckbox.Value == 1
    cla(handles.axes6,'reset');
    for i=1:1:length(handles.signals.displayonly)
    if handles.signals.displayset(i) == 1
        dataset = 'values';
    elseif handles.signals.displayset(i) == 2
        dataset = 'detrended';
    elseif handles.signals.displayset(i) == 3
        dataset = 'original';
    end
    
        f=linspace(0,.5/handles.signals.tr,size(handles.signals.values,2)/2);
        Y= fft(handles.signals.(char(dataset))(handles.signals.displayonly(i),:).',size(handles.signals.values,2));
        Pyy=Y.*conj(Y)/size(handles.signals.values,2);
        hold(handles.axes6,'on')
        plot(f,Pyy(1:size(handles.signals.values,2)/2),'Parent', handles.axes6,'LineWidth',2);
        legend(handles.axes6,handles.signals.displayonlynames);
        ylabel(handles.axes6,'Amplitude', 'fontsize', 10)
        xlabel(handles.axes6,'Frequency (Hz)','fontsize', 10)    
    end
    hold(handles.axes6,'off')
end

try
ylim(handles.axes6,[handles.signals.ylimfft]);
catch
end
try
xlim(handles.axes6,[handles.signals.xlimfft]);
catch
end

eventrecorder(hObject, eventdata, handles, '> FFT');
switchPanel(hObject,eventdata,handles,'fftpanel')
playMacro(hObject,eventdata, handles);


% --- Executes on button press in definetr.
function definetr_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
prompt = {'Repetition time in seconds?'};
prompttitle = 'TR';
repetitionTime = inputdlg(prompt,prompttitle);
if isempty(repetitionTime)
   return; 
end
handles.signals.tr = str2num(repetitionTime{:});
guidata(hObject, handles);
updatePlots(hObject, eventdata, handles);
eventrecorder(hObject, eventdata, handles, '> DefineTR');
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',handles.signals.tr));
elseif handles.macros.nowplaying
    handles.signals.tr = handles.macros.payload{end,1};
    guidata(hObject, handles);
    updatePlots(hObject, eventdata, handles);
end

playMacro(hObject, eventdata, handles)


% --- Executes on button press in xlimfft.
function xlimfft_Callback(hObject, eventdata, handles)
% hObject    handle to xlimfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter x-min:','Enter x-max'};
title = 'input';
dims = [1 35];
currentxlim = xlim(handles.axes6);
definput = {char(num2str(currentxlim(1))),char(num2str(currentxlim(2)))};
limits = inputdlg(prompt,title,dims,definput);
if isempty(limits)
    return;
end
xlim(handles.axes6,[str2num(limits{1}) str2num(limits{2})]);
handles.signals.xlimfft = [str2num(limits{1}) str2num(limits{2})];
guidata(hObject, handles);


% --- Executes on button press in ylimfft.
function ylimfft_Callback(hObject, eventdata, handles)
% hObject    handle to ylimfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter y-min:','Enter y-max'};
title = 'input';
dims = [1 35];
currentylim = ylim(handles.axes6);
definput = {char(num2str(currentylim(1))),char(num2str(currentylim(2)))};
limits = inputdlg(prompt,title,dims,definput);
if isempty(limits)
    return;
end
ylim(handles.axes6,[str2num(limits{1}) str2num(limits{2})]);
handles.signals.ylimfft = [str2num(limits{1}) str2num(limits{2})];
guidata(hObject, handles);

function filteredsignal = movingaveragefilter(hObject,eventdata,handles,signal,hampoints)
% Hamming window takes 100% weights by default 
[scannum,~] = size(signal);
hamwin = hamming(hampoints);
ceiling = ceil(hampoints/2);

Timecourses_MAF=signal;
for i = 1:1:scannum
    if i <= ceiling
        wintmp = hamwin(ceiling-i+1:hampoints);
        TC_tmp = signal(1:length(wintmp),:);
    elseif i>(scannum-ceiling)
        wintmp = hamwin(1:hampoints-ceiling-i+scannum);
        TC_tmp = signal((scannum-length(wintmp)+1):scannum,:);
    else
        wintmp = hamwin;
        TC_tmp = signal((i-ceiling+1):(i-ceiling+length(wintmp)),:);
    end

    tmp = TC_tmp(:,1);
    Timecourses_MAF(i,1) = tmp' * wintmp ./ hampoints;
end
filteredsignal = 2*Timecourses_MAF; % KT Nov 13


% --- Executes on button press in gammas.
function gammas_Callback(hObject, eventdata, handles)
switchPanel(hObject,eventdata,handles,'gammaspanel')


% --- Executes on button press in windowsizegammas.
function windowsizegammas_Callback(hObject, eventdata, handles)
global gammadata;
windows = fields(gammadata.detrendonline);
window = listdlg('PromptString','Window size:','SelectionMode','single','ListString',windows);
if isempty(window)
   return; 
end
global gammaswindow;
gammaswindow = window;

% --- Executes on button press in gammagamma.
function gammagamma_Callback(hObject, eventdata, handles)
global gammadata;
global gammaswindow;
global gammaslegendlist;
windows = fields(gammadata.detrendonline);
signals = fields(gammadata.detrendonline.(char(windows{gammaswindow})));
signal = listdlg('PromptString','Signal:','SelectionMode','single','ListString',signals);
if isempty(signal)
   return; 
end
plotGammas(hObject, eventdata, handles, signal, handles.axes7)

function plotGammas(hObject, eventdata, handles, signal, ax)
global gammadata;
global gammaswindow;
global gammaslegendlist;
windows = fields(gammadata.detrendonline);
signals = fields(gammadata.detrendonline.(char(windows{gammaswindow})));
dataToPlot = gammadata.detrendonline.(char(windows{gammaswindow})).(char(signals{signal}));
hold(ax,'on')
plot(dataToPlot,'Parent', ax,'LineWidth',2);
for i=1:1:size(dataToPlot,2)
gammaslegendlist{end+1} = sprintf('%s',strcat(char(signals{signal}),'-D',num2str(i)));
end
legend(ax, gammaslegendlist);
ylabel(ax,'Gamma', 'fontsize', 10)
xlabel(ax,'Data Points','fontsize', 10)

% --- Executes on button press in resetgamma.
function resetgamma_Callback(hObject, eventdata, handles)
resetGammas(hObject, eventdata, handles, handles.axes7)

function resetGammas(hObject, eventdata, handles, ax)
global gammaslegendlist;
gammaslegendlist = {};
cla(ax,'reset');


% --- Executes on button press in selectcorrelationformula.
function selectcorrelationformula_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
correlationselection = listdlg('PromptString','Window size:','SelectionMode','single','ListString',{'Pearson','Pearson no mean subtraction'},'InitialValue',handles.signals.correlationrelation,'OKString','Use This','ListSize',[300,200]);
if isempty(correlationselection)
   return; 
end
end
if handles.macros.nowplaying
   correlationselection = handles.macros.payload{1,1}; 
end
handles.signals.correlationrelation = correlationselection;
guidata(hObject,handles);
eventrecorder(hObject, eventdata, handles, '> CorrelationFormula');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',correlationselection));
playMacro(hObject, eventdata, handles)

% --- Executes on selection change in selectoriginalcorrelations1.
function selectoriginalcorrelations1_Callback(hObject, eventdata, handles)
% hObject    handle to selectoriginalcorrelations1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectoriginalcorrelations1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectoriginalcorrelations1


% --- Executes during object creation, after setting all properties.
function selectoriginalcorrelations1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectoriginalcorrelations1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selectoriginalcorrelations2.
function selectoriginalcorrelations2_Callback(hObject, eventdata, handles)
% hObject    handle to selectoriginalcorrelations2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns selectoriginalcorrelations2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectoriginalcorrelations2


% --- Executes during object creation, after setting all properties.
function selectoriginalcorrelations2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectoriginalcorrelations2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in calculateoriginalcorrelations.
function calculateoriginalcorrelations_Callback(hObject, eventdata, handles)
% hObject    handle to calculateoriginalcorrelations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
signal1 = (handles.signals.original(handles.selectoriginalcorrelations1.Value,:)).';
signal2 = (handles.signals.original(handles.selectoriginalcorrelations2.Value,:)).';
correlation = correlatesignals(signal1,signal2,handles);
correlation = correlation(2,1);
zScore = atanh(correlation);
handles.outputcorrelations3.String = sprintf('Correlation: %s,  Z-score: %s',num2str(correlation),num2str(zScore));
guidata(hObject,handles)


% --- Executes on button press in batchmodesw.
function batchmodesw_Callback(hObject, eventdata, handles)
% hObject    handle to batchmodesw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
analyses = fields(handles.batchmode.windowcorrelations);
if ~handles.macros.nowplaying
corrOrzscore = listdlg('PromptString','Plot what?','SelectionMode','single','ListString',{'Correlations','Z-Scores'});
if isempty(corrOrzscore)
   return; 
end
plotsToDisplay = listdlg('PromptString','Select plots:','ListString',analyses);
if isempty(plotsToDisplay)
   return; 
end

savecsv = listdlg('PromptString','Save a csv file?','SelectionMode','single','ListString',{'Yes','No'});
if isempty(savecsv)
   savecsv = 0;
end

if savecsv == 1
   filePath = handles.savedir;
   file = 'batchmode';
end

elseif handles.macros.nowplaying
   corrOrzscore = handles.macros.payload{1,1};
   plotsToDisplay = handles.macros.payload{2,1};
   savecsv = 1;
   filePath = handles.savedir;
   file = 'batchmode';
end
cla(handles.axes5,'reset');
analysesTitles = {};
for i=1:1:length(plotsToDisplay)
analysesTitles{end+1} = analyses{plotsToDisplay(i)};
hold(handles.axes5,'on')
%Note that we are using the population standard deviation in the error bar
if corrOrzscore == 1
errorbar(handles.axes5,mean(handles.batchmode.windowsizes.(char(analyses{plotsToDisplay(i)}))).',mean(handles.batchmode.windowcorrelations.(char(analyses{plotsToDisplay(i)}))).',std(handles.batchmode.windowcorrelations.(char(analyses{plotsToDisplay(i)}))).','LineWidth',2);
    if savecsv == 1
         csvwrite(fullfile(filePath,strcat(file,'_',num2str(i),'.csv')),[mean(handles.batchmode.windowsizes.(char(analyses{plotsToDisplay(i)}))).',mean(handles.batchmode.windowcorrelations.(char(analyses{plotsToDisplay(i)}))).',std(handles.batchmode.windowcorrelations.(char(analyses{plotsToDisplay(i)}))).']); 
    end
elseif corrOrzscore == 2
errorbar(handles.axes5,mean(handles.batchmode.windowsizes.(char(analyses{plotsToDisplay(i)}))).',mean(handles.batchmode.windowzscores.(char(analyses{plotsToDisplay(i)}))).',std(handles.batchmode.windowzscores.(char(analyses{plotsToDisplay(i)}))).','LineWidth',2);    
    if savecsv == 1
         csvwrite(fullfile(filePath,strcat(file,'_',num2str(i),'.csv')),[mean(handles.batchmode.windowsizes.(char(analyses{plotsToDisplay(i)}))).',mean(handles.batchmode.windowzscores.(char(analyses{plotsToDisplay(i)}))).',std(handles.batchmode.windowzscores.(char(analyses{plotsToDisplay(i)}))).']);
    end
end
end
legend(handles.axes5, analysesTitles);
hold(handles.axes5,'off')
switchPanel(hObject,eventdata,handles,'slidingwindowspanel','resultsslidingwindowspanel')
eventrecorder(hObject, eventdata, handles, '> SlidingWindows_BatchMode');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d',corrOrzscore)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',plotsToDisplay)));
playMacro(hObject, eventdata, handles)


% --- Executes on button press in savegammas.
function savegammas_Callback(hObject, eventdata, handles)
warning('off')
global gammadata;
global gammaswindow;
windowsList = fields(gammadata.detrendonline);

if ~handles.macros.nowplaying
windows = listdlg('PromptString','Window size(s):','ListString',windowsList);
elseif handles.macros.nowplaying
   windows = handles.macros.payload{1,1}; 
end
if isempty(windows)
   return; 
end

%We are assuming that we have the same signals under each window size. If
%that is not the case, this function should not be used.
signalsList = fields(gammadata.detrendonline.(char(windowsList{windows(1)})));
if ~handles.macros.nowplaying
signals = listdlg('PromptString','Signal:','ListString',signalsList);
elseif handles.macros.nowplaying
   signals = handles.signals.payload{2,1}; 
end
if isempty(signals)
   return; 
end

currentDir = pwd;
if isempty(handles.savedir)
   handles.savedir = pwd; 
end
cd(sprintf('%s',handles.savedir));

mkdir 'savedplots'
cd 'savedplots'
mkdir 'gammas'
cd 'gammas'

for i=1:1:length(windows)
    gammaswindow = windows(i);
    for j=1:1:length(signals)
       h1 = figure;
       ax1 = axes;
       plotGammas(hObject, eventdata, handles, signals(j), ax1);
       savefig(h1,strcat('G',char(windowsList{windows(i)}),'-',char(signalsList(signals(j))),'-Gammas.fig'));
       resetGammas(hObject, eventdata, handles, ax1);
       close(h1);
    end   
end

cd(sprintf('%s',currentDir));
eventrecorder(hObject, eventdata, handles, '> SavePlotsGammas');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',windows)));
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',signals)));
playMacro(hObject, eventdata, handles)


% --- Executes on button press in yshift.
function yshift_Callback(hObject, eventdata, handles)
% hObject    handle to yshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Shift by:'};
prompttitle = 'Vertical Shift';
if ~handles.macros.nowplaying
amplitude = inputdlg(prompt,prompttitle);
if isempty(amplitude)
   return; 
end
shiftamplitude = str2num(amplitude{:});
elseif handles.macros.nowplaying
  shiftamplitude = handles.macros.payload{1,1};
end
signalToModify = handles.selectsignalconfounds.Value;
shiftedsignal = handles.signals.values(signalToModify,:) + shiftamplitude;
handles.signals.values(signalToModify,:) = shiftedsignal;
handles.signals.confoundtypes{end+1} = 'yshift';
handles.signals.history{end+1} = handles.signals.values;
updatePlots(hObject, eventdata, handles);
guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> Confounds_Yshift');
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',shiftamplitude));  
playMacro(hObject, eventdata, handles)


% --- Executes on button press in frequencyConfoundsMenu.
function frequencyConfoundsMenu_Callback(hObject, eventdata, handles)
handles.modulated.values = handles.signals.values;
handles.modulated.names = handles.signals.names;
handles.modulated.updatePlots = 1;
guidata(hObject,handles);
updatePlots(hObject, eventdata, handles);
handles.modulated.updatePlots = 0;
guidata(hObject,handles);
eventrecorder(hObject, eventdata, handles, '> FrequencyConfounds');
switchPanel(hObject,eventdata,handles,'frequencyConfoundsPanel')
playMacro(hObject,eventdata, handles);



% --- Executes on button press in fcXLim.
function fcXLim_Callback(hObject, eventdata, handles)
prompt = {'Enter x-min:','Enter x-max'};
title = 'input';
dims = [1 35];
currentxlim = xlim(handles.axes8);
definput = {char(num2str(currentxlim(1))),char(num2str(currentxlim(2)))};
limits = inputdlg(prompt,title,dims,definput);
if isempty(limits)
    return;
end
xlim(handles.axes8,[str2num(limits{1}) str2num(limits{2})]);
handles.signals.xlimfft = [str2num(limits{1}) str2num(limits{2})];
guidata(hObject, handles);


% --- Executes on button press in fcYLim.
function fcYLim_Callback(hObject, eventdata, handles)
prompt = {'Enter y-min:','Enter y-max'};
title = 'input';
dims = [1 35];
currentylim = ylim(handles.axes8);
definput = {char(num2str(currentylim(1))),char(num2str(currentylim(2)))};
limits = inputdlg(prompt,title,dims,definput);
if isempty(limits)
    return;
end
ylim(handles.axes8,[str2num(limits{1}) str2num(limits{2})]);
handles.signals.ylimfft = [str2num(limits{1}) str2num(limits{2})];
guidata(hObject, handles);


% --- Executes on button press in addConfoundFC.
function addConfoundFC_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
confoundLimits = ginput(2);
prompt = {'Boost Parameter:'};
prompttitle = 'Boost';
boost = inputdlg(prompt,prompttitle);
if isempty(boost)
   return; 
end
boost = str2num(boost{:});
elseif handles.macros.nowplaying
confoundLimits = handles.macros.payload{1,1};
boost = handles.macros.payload{2,1};
end
if confoundLimits(2,1) > size(handles.signals.values,2)
    confoundLimits(2,1) = size(handles.signals.values,2);
end
signalToModify = handles.selectSignalFC.Value;

% Here we need to modulate the signal
modulatedsignal = zeros(1,size(handles.modulated.values,2));
for j=1:5
for i=1:size(handles.modulated.values,2)
   tempsignal(1,i) = rand*boost; 
end
minFreq = confoundLimits(1,1);
maxFreq = confoundLimits(2,1);
D = designfilt('bandpassfir', 'StopbandFrequency1', minFreq - 0.05, 'PassbandFrequency1', minFreq, 'PassbandFrequency2', maxFreq, 'StopbandFrequency2', maxFreq + 0.05, 'StopbandAttenuation1', 60, 'PassbandRipple', 1, 'StopbandAttenuation2', 60, 'SampleRate', 1/handles.signals.tr);
tempsignal = filtfilt(D,tempsignal);
modulatedsignal = modulatedsignal + tempsignal;
end
modulatedsignal = modulatedsignal/5;
handles.modulated.values(signalToModify,:) =  handles.modulated.values(signalToModify,:) + modulatedsignal;
guidata(hObject, handles);

handles.modulated.updatePlots = 1;
updatePlots(hObject, eventdata, handles);
handles.modulated.updatePlots = 0;

guidata(hObject, handles);
eventrecorder(hObject, eventdata, handles, '> FrequencyConfounds_AddConfound');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d;%d',confoundLimits(1,1),confoundLimits(2,1)));        
eventrecorder(hObject, eventdata, handles, sprintf('>> %f',boost));  
playMacro(hObject, eventdata, handles)

% --- Executes on selection change in selectSignalFC.
function selectSignalFC_Callback(hObject, eventdata, handles)
if handles.macros.nowplaying
    handles.selectSignalFC.Value = handles.macros.payload{1,1};
end
eventrecorder(hObject, eventdata, handles, '> FrequencyConfounds_SelectSignal');
eventrecorder(hObject, eventdata, handles, sprintf('>> %d',handles.selectSignalFC.Value));
playMacro(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function selectSignalFC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectSignalFC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generateSignalFromFreq.
function generateSignalFromFreq_Callback(hObject, eventdata, handles)
if ~handles.macros.nowplaying
list = handles.selectSignalFC.String;
signalstoexport = listdlg('PromptString','Signals to generate:','ListString',list,'ListSize',[300,200]);
elseif handles.macros.nowplaying
signalstoexport = handles.macros.payload{1,1};
end
if isempty(signalstoexport)
   return; 
end
for i=1:length(signalstoexport)
handles.signals.values = [handles.signals.values; handles.modulated.values(signalstoexport(i),:)];
handles.signals.names{end+1} = strcat('modulated_',char(handles.modulated.names{signalstoexport(i)}));
end
guidata(hObject,handles);
updatePlots(hObject, eventdata, handles);
eventrecorder(hObject, eventdata, handles, '> FrequencyConfounds_GenerateSignal');
eventrecorder(hObject, eventdata, handles, sprintf('>> %s',sprintf('%d,',signalstoexport)));
playMacro(hObject, eventdata, handles)
