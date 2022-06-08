function varargout = ExampleGUI(varargin)
% EXAMPLEGUI MATLAB code for ExampleGUI.fig
%      EXAMPLEGUI, by itself, creates a new EXAMPLEGUI or raises the existing
%      singleton*.
%
%      H = EXAMPLEGUI returns the handle to a new EXAMPLEGUI or the handle to
%      the existing singleton*.
%
%      EXAMPLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXAMPLEGUI.M with the given input arguments.
%
%      EXAMPLEGUI('Property','Value',...) creates a new EXAMPLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExampleGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExampleGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExampleGUI

% Last Modified by GUIDE v2.5 08-Aug-2021 02:26:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExampleGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ExampleGUI_OutputFcn, ...
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


% --- Executes just before ExampleGUI is made visible.
function ExampleGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExampleGUI (see VARARGIN)

% Choose default command line output for ExampleGUI
handles.output = hObject;

handles.starttime = clock;
set(handles.text2, 'String', '00:00:00.00');
delete(timerfind);
handles.tmr = timer('ExecutionMode','FixedRate','TimerFcn',{@tmrFcn,hObject},'Period',0.05,'BusyMode','queue');

instrreset;
handles.s = serial('COM4');
set(handles.s,'BaudRate',38400);
set(handles.s,'DataBits',8,'Parity', 'none', 'StopBits', 1, 'Terminator', 'CR/LF');

handles.N9913A_2 = tcpip('192.168.15.3', 5025);     %-->> FieldFox Configuration
handles.N9913A_2.InputBufferSize = 8388608;
handles.N9913A_2.ByteOrder = 'littleEndian';

set(handles.pushbutton1, 'Enable','off');
set(handles.pushbutton2, 'Enable','off');
set(handles.pushbutton4, 'Enable','off');

set(handles.pushbutton2, 'UserData', []);       %-->>Data Matrix
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExampleGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ExampleGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)       %-->> Button to start the process
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Enable','off');
handles.starttime = clock;
guidata(hObject, handles);

% Command to start recording the data in the FieldFox
fprintf(handles.N9913A_2, 'RECP:ACT:REC');

start(handles.tmr);
%guidata(hObject, handles);

function tmrFcn(hObject, eventdata, handles)        %-->> Timer Function
handles = guidata(handles);
time_elapsed = etime(clock,handles.starttime);
str = formatTime(time_elapsed);
set(handles.text2, 'String', str);
settings = fgetl(handles.s);
settings = [settings,',',str];
GPSdata = get(handles.pushbutton2,'UserData');
GPSdata = char(GPSdata,settings);
set(handles.pushbutton2, 'UserData', GPSdata);


function str = formatTime(float_time)   %--->> Time Format Function
hrs = floor(float_time/3600);
min = floor(float_time/60 - 60*hrs);
sec = float_time - 60*(min + 60*hrs);
h = sprintf('%1.0f:',hrs);
m = sprintf('%1.0f:',min);
s = sprintf('%1.3f',sec);
if hrs < 10
    h = sprintf('0%1.0f:',hrs);
end
if min < 10
    m = sprintf('0%1.0f:',min);
end
if sec < 10
    s = sprintf('0%1.3f',sec); 
end
str = [h m s];

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)       %-->> Button to save the process
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton2, 'Enable','off'); 
delete(handles.tmr);
fclose(handles.s);
delete(handles.s);
fclose(handles.N9913A_2);
delete(handles.N9913A_2);
GPSdata = get(handles.pushbutton2,'UserData');
save(['D:\jorge\Tesis1\Measurements',datestr(now, ' ddmmmyy_HH-MM-SS')],'GPSdata');


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)      %-->> Button to open ports
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fopen(handles.s);
fopen(handles.N9913A_2);
set(handles.pushbutton1, 'Enable','on');
set(handles.pushbutton2, 'Enable','on');
set(handles.pushbutton3, 'Enable','off'); 
set(handles.pushbutton4, 'Enable','on'); 

% Command for Center Frequency
fprintf(handles.N9913A_2, 'FREQ:CENT 2.4E9'); % 760 MHz
% Command for Frequency Span
fprintf(handles.N9913A_2, 'FREQ:SPAN 3E6'); % 1? kHz
% Command for configurate points
fprintf(handles.N9913A_2, 'SWE:POIN 1001'); % 1001 points
% Command for disable RF Attenuation
% '0' to set the attenuation manually
% '1' to enable the attenuation manually
fprintf(handles.N9913A_2, 'POW:ATT:AUTO 0');
% Command for change the attenuation
fprintf(handles.N9913A_2, 'POW:ATT 0'); % 0 dB
% Command for change the level
fprintf(handles.N9913A_2, 'DISP:WIND:TRAC1:Y:RLEV -11'); % -11 dBm
%Video Bandwidth
%fprintf(handles.N9913A_2, 'BAND:VID 5e6');
%Resolution Bandwidth in Hz
%fprintf(handles.N9913A_2, 'BAND 5e6');

% Is there an open recording session?
OpenOrClose = query(handles.N9913A_2, 'STAT:OPER:SAM:COND?');
OpenOrClose = str2double(OpenOrClose);
if OpenOrClose==64
     %f=warndlg('There is an open session in the FIELDFOX, the session will be closed to continue');
     fprintf(handles.N9913A_2, 'RECP:SESS:CLOS');
end
% A new recording session is created
fprintf(handles.N9913A_2, 'RECP:SESS:NEW');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)      %-->> Button to stop the process
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stop the FieldFox
fprintf(handles.N9913A_2, 'RECP:ACT:STOP');
stop(handles.tmr);
% Stop the FieldFox
fprintf(handles.N9913A_2, 'RECP:SESS:CLOS');
set(handles.pushbutton4, 'Enable','off'); 
