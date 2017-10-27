function varargout = TRON_main_gui(varargin)
% TRON_MAIN_GUI MATLAB code for TRON_main_gui.fig
%      TRON_MAIN_GUI, by itself, creates a new TRON_MAIN_GUI or raises the existing
%      singleton*.
%
%      H = TRON_MAIN_GUI returns the handle to a new TRON_MAIN_GUI or the handle to
%      the existing singleton*.
%
%      TRON_MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRON_MAIN_GUI.M with the given input arguments.
%
%      TRON_MAIN_GUI('Property','Value',...) creates a new TRON_MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TRON_main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TRON_main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TRON_main_gui

% Last Modified by GUIDE v2.5 01-Nov-2016 19:51:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TRON_main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @TRON_main_gui_OutputFcn, ...
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


% --- Executes just before TRON_main_gui is made visible.
function TRON_main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TRON_main_gui (see VARARGIN)

% Choose default command line output for TRON_main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.speed_txt,'String',num2str(round(get(handles.speed_slider,'Value'))))
% UIWAIT makes TRON_main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TRON_main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in p2_human_sel.
function p2_human_sel_Callback(hObject, eventdata, handles)
% hObject    handle to p2_human_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p2_human_sel
if get(hObject,'Value') == 1 % if selected
    set(handles.p2_ai_sel,'Value',0); % deselect the other
    set(handles.p2_ai_alg_txt,'Visible','off'); % hiding the AI algorithm setup
    set(handles.p2_ai_alg,'Visible','off');
else
    set(hObject,'Value',1); % prevent deleselecting
end

% --- Executes on button press in p2_ai_sel.
function p2_ai_sel_Callback(hObject, eventdata, handles)
% hObject    handle to p2_ai_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p2_ai_sel
if get(hObject,'Value') == 1 % if selected
    set(handles.p2_human_sel,'Value',0); % deselect the other
    set(handles.p2_ai_alg_txt,'Visible','on'); % making the AI algorithm setup visible
    set(handles.p2_ai_alg,'Visible','on');
else
    set(hObject,'Value',1); % prevent deleselecting
end

% --- Executes on selection change in p2_ai_alg.
function p2_ai_alg_Callback(hObject, eventdata, handles)
% hObject    handle to p2_ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p2_ai_alg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p2_ai_alg


% --- Executes during object creation, after setting all properties.
function p2_ai_alg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2_ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in p1_human_sel.
function p1_human_sel_Callback(hObject, eventdata, handles)
% hObject    handle to p1_human_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p1_human_sel
if get(hObject,'Value') == 1 % if selected
    set(handles.p1_ai_sel,'Value',0); % deselect the other
    set(handles.p1_ai_alg_txt,'Visible','off'); % hiding the AI algorithm setup
    set(handles.p1_ai_alg,'Visible','off');
    set(handles.acq_sel,'Enable','off'); % Make data acq invalid
    set(handles.p2_human_sel,'Enable','on');
    set(handles.normal_sel,'Value',1);
    set(handles.acq_sel,'Value',0)
    set(handles.speed_panel,'Visible','on');
    set(handles.acq_panel,'Visible','off'); 
else
    set(hObject,'Value',1); % prevent deleselecting
end

% --- Executes on button press in p1_ai_sel.
function p1_ai_sel_Callback(hObject, eventdata, handles)
% hObject    handle to p1_ai_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p1_ai_sel
if get(hObject,'Value') == 1 % if selected
    set(handles.p1_human_sel,'Value',0); % deselect the other
    set(handles.p1_ai_alg_txt,'Visible','on'); % making the AI algorithm setup visible
    set(handles.p1_ai_alg,'Visible','on');
    set(handles.acq_sel,'Enable','on'); % Make data acq invalid
    set(handles.p2_human_sel,'Value',0);
    set(handles.p2_human_sel,'Enable','off'); 
    set(handles.p2_ai_sel,'Value',1);
    set(handles.p2_ai_alg_txt,'Visible','on'); % making the AI algorithm setup visible
    set(handles.p2_ai_alg,'Visible','on');
else
    set(hObject,'Value',1); % prevent deleselecting
end

% --- Executes on selection change in p1_ai_alg.
function p1_ai_alg_Callback(hObject, eventdata, handles)
% hObject    handle to p1_ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns p1_ai_alg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from p1_ai_alg


% --- Executes during object creation, after setting all properties.
function p1_ai_alg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1_ai_alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Reading user inputs

p1_mode = get(handles.p1_human_sel,'Value');
p2_mode = get(handles.p2_human_sel,'Value');
% 1 -> human
% 0 -> AI
    
game_mode = get(handles.normal_sel,'Value');
game_mode = game_mode{2}; % there is an issue, the get method give back a cell
% 1 -> normal with display
% 0 -> data acqusition without display and more loops

if p1_mode == 0
    % AI, getting the algoritm
    p1_AI_alg = get(handles.p1_ai_alg,'Value');
    
   % 1 ->  random
   % 2 -> Simple selection
   % 3 -> NN gen 2.5
   % 4 -> NN gen 3
end

if p2_mode == 0
    % AI, getting the algoritm
    p2_AI_alg = get(handles.p2_ai_alg,'Value');
    
   % 1 ->  random
   % 2 -> Simple selection
   % 3 -> NN gen 2.5
   % 4 -> NN gen 3
end
if p1_mode == 1
    % HUMAN VS AI
    speed = get(handles.speed_slider,'Value');
    if p2_mode == 1
        % HUMAN VS HUMAN
        HumanvsHuman(speed);
    else
        HumanvsAI(p2_AI_alg,speed);
    end
    return;
end
if game_mode == 1 
    % if normal game
    speed = get(handles.speed_slider,'Value');
    if p1_mode + p2_mode == 0
       % AI vs AI matchup 
        % Starting the game
        AIvsAI(p1_AI_alg,p2_AI_alg,speed,1);
    end
else
    loops_str = get(handles.nr_games,'String');
    if ischar(loops_str)
        loops = str2double(loops_str);
    else
        loops = loops_str;
    end
    if isnan(loops)
        errordlg('Please provide the number of simulation!');
        return;
    end
    PathName = getappdata(handles.browse,'PathName');
    FileName = getappdata(handles.browse,'FileName');
    % default name
    if isempty(PathName) || isempty(FileName)
        PathName = 'C:\Cubby\Egyetemi cuccok\Szakdolgozat\TRON_game_final\train_data';
        t = clock;
        t = num2str(round(t));
        FileName = strcat('results_',t(find(~isspace(t))),'.mat');
    end
    collect_data(loops,PathName,FileName,p1_AI_alg,p2_AI_alg);
end



function nr_games_Callback(hObject, eventdata, handles)
% hObject    handle to nr_games (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nr_games as text
%        str2double(get(hObject,'String')) returns contents of nr_games as a double


% --- Executes during object creation, after setting all properties.
function nr_games_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nr_games (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.mat','Save Results');
setappdata(handles.browse,'PathName',PathName);
setappdata(handles.browse,'FileName',FileName);

% --- Executes on button press in normal_sel.
function normal_sel_Callback(hObject, eventdata, handles)
% hObject    handle to normal_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normal_sel
if get(hObject,'Value') == 1
    set(handles.acq_sel,'Value',0);
    set(handles.acq_panel,'Visible','off');
    set(handles.speed_panel,'Visible','on');
else
    set(hObject,'Value',1);
end

% --- Executes on button press in acq_sel.
function acq_sel_Callback(hObject, eventdata, handles)
% hObject    handle to acq_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acq_sel
if get(hObject,'Value') == 1
    set(handles.normal_sel,'Value',0);
    set(handles.acq_panel,'Visible','on');
    set(handles.speed_panel,'Visible','off');
else
    set(hObject,'Value',1);
end

% --- Executes on button press in normal_sel.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to normal_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normal_sel


% --- Executes on button press in acq_sel.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to acq_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acq_sel


% --- Executes on slider movement.
function speed_slider_Callback(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.speed_txt,'String',num2str(round(get(handles.speed_slider,'Value'))))
% --- Executes during object creation, after setting all properties.
function speed_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
