

% *******************  Conceptualization  ****************************%
% *******************          of         ****************************%
% ******************   Internet of Things ****************************%




% The Following Code has been scripted in defence for the Data Analysis
% and Computational Methods with MATLAB course at the University of Tartu,
% Estonia for the Autumn Semester 2018.

%---------------------------About----------------------------------------%
% The following code conceptualizes Internet of Things as an approach towards
% space missions with the aspiration to achieve high latency communication
% between satellites, probes, vehicles and ground stations.
% 
% The code initiates a User Friendly Graphical User Interface created with
% the GUIDE (GUI Development Environment) stock based on MATLAB.
% 
% It receives data from a free public server created on Thingspeak with 
% multiple defined channels.
% Currently the Thingspeak server receives data through an android
% application developed on MIT AppInventor-2 (courtesy of MIT, USA).
% The application send data via a Http request sent to the Write API index
% on the server and logs data chronologically.
 
% ***********-------------Data Acquisition-----------********************** 
% The MATLAB GUI acquires this data via the online HTTP request server and 
% displays the data.


% ***********---------------Data Analysis------------**********************
% The acquired data is analyzed on the MATLAB code structure for 
% In-Orbit Status and Sensor Status, which is indicated by color codes
% (Green = Active | Red = InActive), and textual representation.
 

%Server Info
% Channel Rights      : Public
% Channel ID          : 617626
% Read  API           : BXOLPU25WPWMVQMO
% Write API           : DD9IEKDRPUFUDZXQ
% Channel 01          : Sensor Data
% Channel 02          : In Orbit Status
% Channel 03          : Sensor Status
% Update Channel Feed : https://api.thingspeak.com/update?api_key=DD9IEKDRPUFUDZXQ&field1=0
% Get Channel Feed    : https://api.thingspeak.com/channels/617626/feeds.json?results=1
% Get Channel Status  : https://api.thingspeak.com/channels/617626/status.json




%Author Details -
%   Name        : AdityaSavioPaul
%   Course      : MS - Robotics and Space Technology
%   University  : Univerity of Tartu, Estonia
%   Faculty     : Institute of Technology
%   Email       : aditya.savio.paul@estcube.eu



function varargout = MissionControlGUI(varargin)
% MISSIONCONTROLGUI MATLAB code for MissionControlGUI.fig
%      MISSIONCONTROLGUI, by itself, creates a new MISSIONCONTROLGUI or raises the existing
%      singleton*.
%
%      H = MISSIONCONTROLGUI returns the handle to a new MISSIONCONTROLGUI or the handle to
%      the existing singleton*.
%
%      MISSIONCONTROLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MISSIONCONTROLGUI.M with the given input arguments.
%
%      MISSIONCONTROLGUI('Property','Value',...) creates a new MISSIONCONTROLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MissionControlGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MissionControlGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MissionControlGUI

% Last Modified by GUIDE v2.5 28-Nov-2018 06:33:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MissionControlGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MissionControlGUI_OutputFcn, ...
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


% --- Executes just before MissionControlGUI is made visible.
function MissionControlGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user sensordata (see GUIDATA)
% varargin   command line arguments to MissionControlGUI (see VARARGIN)

% Choose default command line output for MissionControlGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MissionControlGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MissionControlGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user sensordata (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user sensordata (see GUIDATA)


%Changing Button Text from Start to Refresh upon click
set(handles.refresh,'String','Refresh');


%-------------Data Acquisition from Server(Thingspeak)Channels----------------------------%

readChannelID = 617626; %Cloud Server Public Access Key

fieldID1 =1; % Thingspeak : Sensor Data    [Range of Integers]
fieldID2 =2; % Thingspeak : InOrbit Status [0,1]
fieldID3 =3; % Thingspeak : Sensor  Status [0,1]

%Application Index Key for Cloud Public Server on Thingspeak
readAPIKey = 'BXOLPU25WPWMVQMO'; 

%Sensor Data and corresponding time
[data1, time] = thingSpeakRead(readChannelID, 'Field', fieldID1, 'NumPoints', 30, 'ReadKey', readAPIKey);

%In Orbit Status and corresponding time
[data2, time] = thingSpeakRead(readChannelID, 'Field', fieldID2, 'NumPoints', 10, 'ReadKey', readAPIKey);

%Sensor Deployment and corresponding
[data3, time] = thingSpeakRead(readChannelID, 'Field', fieldID3, 'NumPoints', 10, 'ReadKey', readAPIKey);

%-----------------------Threshold-Sensor-------------------------------------%


%Reading FIELD 1 Value last value of Sensor
% Value > threshold : Object Detected
% Value < threshold : No Object Detected

%HTTP request to acces Public Data on Server
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(readChannelID),'/fields/1/last.txt');

%Retrieving data into variables data2 and time
[data1, time] = thingSpeakRead(readChannelID, 'Field', fieldID1, 'NumPoints', 30, 'ReadKey', readAPIKey);

%Storing Last Value for Threshold Check
lastValue01 = str2double(webread(thingSpeakURL, 'api_key', readAPIKey))

%Conditional block for threshold check
thresh=0;
thresh = str2double(get(handles.threshold,'String'))
if (thresh~=0)
if (lastValue01 > thresh)
%     plantMessage = ' No Water Needed. ';
%     webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
      disp("Object Detected")
%     set(handles.approaching,'backgroundColor','green');
      set(handles.threshstatus,'String','Object Detected');
end

if (lastValue01 < thresh)
%     plantMessage = ' No Water Needed. ';
%     webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
    disp("No Object Detected")
    %set(handles.approaching,'backgroundColor','red');     % We can also set the color as [r g b]
    set(handles.threshstatus,'String','No Object Detected'); % Set new message
end
end

%-----------------------ORBIT-STATUS-------------------------------------%


%Reading FIELD 2 Value for 0 and 1
% Flag Status Check for Condition
% 0 : Orbit Not Approached / Orbit Approaching
% 1 : Orbit Approached

%HTTP request to acces Public Data on Server
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(readChannelID),'/fields/2/last.txt');
%Retrieving data into variables data2 and time
[data2, time] = thingSpeakRead(readChannelID, 'Field', fieldID2, 'NumPoints', 30, 'ReadKey', readAPIKey);

%Storing Last Value for Condition Check
lastValue02 = str2double(webread(thingSpeakURL, 'api_key', readAPIKey))

%Conditional block for status check
if (lastValue02>0)
%     plantMessage = ' No Water Needed. ';
%     webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
    disp("Orbit Approached")
    set(handles.approaching,'backgroundColor','green');
    %set(handles.approaching,'String','ORBIT APPROACHED');
end

if (lastValue02<1)
%     plantMessage = ' No Water Needed. ';
%     webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
    disp("Approaching Orbit")
    set(handles.approaching,'backgroundColor','red');     % We can also set the color as [r g b]
    %set(handles.approaching,'String','Approaching Orbit'); % Set new message
end

%-----------------------SENSOR-STATUS-------------------------------------%

%Reading FIELD 3 Value for 0 and 1
% Flag Status Check for Condition
% 0 : Sensor Not Active
% 1 : Sensor Active

%HTTP request to acces Public Data on Server
thingSpeakURL = strcat('https://api.thingspeak.com/channels/',string(readChannelID),'/fields/3/last.txt');

%Retrieving data into variables data3 and time
[data3, time] = thingSpeakRead(readChannelID, 'Field', fieldID3, 'NumPoints', 30, 'ReadKey', readAPIKey);

%Storing last value for condition check
lastValue03 = str2double(webread(thingSpeakURL, 'api_key', readAPIKey))

%Conditional block for status check
if (lastValue03>0)
%     plantMessage = ' No Water Needed. ';
%     webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
    disp("Orbit Approached")
    set(handles.sensor,'backgroundColor','green');
    %set(handles.sensor,'String','Sensor Active');
end

if (lastValue03<1)
%     plantMessage = ' No Water Needed. ';
%   webwrite(iftttURL,'value1',lastValue,'value2',plantMessage);
    disp("Approaching Orbit")
    set(handles.sensor,'backgroundColor','red');     % We can also set the color as [r g b]
    %set(handles.sensor,'String','Sensor InActive');  % Set new message
end


%Pause for 5 milliseconds for Data Buffering
%pause(5);


%Plotting Data to Graphs for Graphical LookThrough

axes(handles.axes1) % Object calling handles assigned to Graph name Axes1
stem(time, data1)   % Plotting Stem Graph of Data against Time
xlabel('TIME');     % Setting X Axis Title
ylabel('DATA');     % Setting Y Axis Title
title('Sensory Data')

axes(handles.axes2) % Object calling handles assigned to Graph name Axes2
scatter(time, data1)% Plotting Scatter Graph of Data against Time
xlabel('TIME');     % Setting X Axis Title
ylabel('DATA');     % Setting Y Axis Title
title('Sensory Data')

axes(handles.axes3) % Object calling handles assigned to Graph name Axes3
stairs(time, data1)   % Plotting Data against Time
xlabel('TIME');     % Setting X Axis Title
ylabel('DATA');     % Setting Y Axis Title
title('Sensory Data')

%Setting Log values to GUI

%Sensor Data 
set(handles.sensordata,'String',data1,'Fontsize',15);
%In Orbit Last Data
set(handles.orbitstatus,'String',lastValue02);
%Sensor Status Last Data
set(handles.sensorstatus,'String',lastValue03);




function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold as text
%        str2double(get(hObject,'String')) returns contents of threshold as a double


% --- Executes during object creation, after setting all properties.
function threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user sensordata (see GUIDATA)

%END GUI
close;



%-----------------------------------------------------------------------------------%
%-----------------------------------------------------------------------------------%
%-------------------------------*END-OF-CODE*---------------------------------------%
%-----------------------------------------------------------------------------------%
%-----------------------------------------------------------------------------------%

