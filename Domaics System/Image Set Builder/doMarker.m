function varargout = doMarker(varargin)
% DOMARKER MATLAB code for doMarker.fig
%      DOMARKER, by itself, creates a new DOMARKER or raises the existing
%      singleton*.
%
%      H = DOMARKER returns the handle to a new DOMARKER or the handle to
%      the existing singleton*.
%
%      DOMARKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOMARKER.M with the given input arguments.
%
%      DOMARKER('Property','Value',...) creates a new DOMARKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before doMarker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to doMarker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help doMarker

% Last Modified by GUIDE v2.5 01-Feb-2012 21:00:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @doMarker_OpeningFcn, ...
                   'gui_OutputFcn',  @doMarker_OutputFcn, ...
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


% --- Executes just before doMarker is made visible.
function doMarker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to doMarker (see VARARGIN)

% Choose default command line output for doMarker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set axes handle
axes(handles.axes1);

% Set the count field to the number of stored images
[ m n ] = size(ls(get(handles.path,'String')));
set(handles.count,'String',int2str(m-2));

% Sort out xml writing paths
path = get(handles.path,'String');
[ r c ] = size(path);
setName = path(17:c);
[ r2 c2 ] = size(setName);

% Set global variable entries
global entries;
entryPath = [ 'image/processed/xml/' setName(1:(c2-1)) '_xml.xml' ];

found = ls(entryPath);
if ~strcmp(found,'')
    set(handles.xml,'String',entryPath);
    entries = xmlLoad(entryPath);
else
    set(handles.xml,'String',xmlBuildMarkup(setName(1:(c2-1))));
    entries;
end
[ m n ] = size(entries);
init = m - 1;
set(handles.pointer,'String',int2str(init))
updateImageDisplayed(handles);



% UIWAIT makes doMarker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = doMarker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global entries;
entries = incImagePointer(handles,1, entries);
updateImageDisplayed(handles);

% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global entries;
entries = incImagePointer(handles,-1, entries);
updateImageDisplayed(handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global entries;
xmlSave(entries,get(handles.xml,'String'));



function pointer_Callback(hObject, eventdata, handles)
% hObject    handle to pointer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pointer as text
%        str2double(get(hObject,'String')) returns contents of pointer as a double
updateImageDisplayed(handles);



% --- Executes during object creation, after setting all properties.
function pointer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
