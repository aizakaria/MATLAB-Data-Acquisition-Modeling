function varargout = IHM(varargin)

% IHM MATLAB code for IHM.fig
%      IHM, by itself, creates a new IHM or raises the existing
%      singleton*.
%
%      H = IHM returns the handle to a new IHM or the handle to
%      the existing singleton*.
%
%      IHM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IHM.M with the given input arguments.
%
%      IHM('Property','Value',...) creates a new IHM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IHM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IHM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IHM

% Last Modified by GUIDE v2.5 04-Apr-2023 03:25:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IHM_OpeningFcn, ...
                   'gui_OutputFcn',  @IHM_OutputFcn, ...
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


% --- Executes just before IHM is made visible.
function IHM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IHM (see VARARGIN)

    %On ajoute l'image du de l'episen 
    img = imread('logo_episen.jpg'); 
    % Affichage de l'image dans les axes
    imshow(img, 'Parent', handles.axes7); 

    handles.output = hObject;

    %On innitialise les valeurs
    handles.a = 1;
    handles.b = 1;
    handles.n = 1000;
    handles.x1 = 0;
    handles.x2 = 5;

    %On défini la valeur de la chaîne de la zone de texte pour correspondre à la valeur initiale du curseur
    set(handles.text3, 'String', ['a = ' num2str(handles.a)]);
    set(handles.text4, 'String', ['b = ' num2str(handles.b)]);
    set(handles.text5, 'String', ['N = ' num2str(handles.n)]);
    set(handles.text6, 'String', ['x1 = ' num2str(handles.x1)]);
    set(handles.text7, 'String', ['x2 = ' num2str(handles.x2)]);

    %configuration affiche bouton radio
    set(handles.text_covariance_value, 'Visible', 'off');
    set(handles.text_vrr_value, 'Visible', 'off');
    set(handles.text_delta_a_value, 'Visible', 'off');
    set(handles.text_delta_b_value, 'Visible', 'off');
    set(handles.text_R2, 'Visible', 'off');

    % Update handles structure
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = IHM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array

    val = get(hObject, 'Value'); % on prends la valeur séléctionnée
    Moy = get(handles.slider10, 'Value');
    sigma = get(handles.slider9, 'Value');
    x1 = handles.x1;
    x2 = handles.x2;
    n = handles.n;
    x = linspace(x1, x2, n);
    y = zeros(1, n);

    switch val
        case 2 % Bruit gaussien
            y = Moy + sigma * randn(1, n);
        case 3 % Bruit uniforme
            y = Moy + sigma * rand(1, n) - sigma/2;
    end

    % Plot tyoe bruit
    axes_handle = handles.axes2;
    plot(axes_handle, x, y);
    xlabel(axes_handle, 'x');
    ylabel(axes_handle, 'y');

    % Plot l'histrogramme du bruit choisi
    axes_histogram = handles.axes3;
    class = round(get(handles.slider11, 'Value'));

    if val == 2 % Bruit gaussien
        histfit(axes_histogram, y, class);
        title(axes_histogram, 'Histogramme du bruit gaussien');
    else % Bruit uniforme
        hist(axes_histogram, y, class);
        title(axes_histogram, 'Histogramme du bruit uniforme');
    end
    xlabel(axes_histogram, ['Nombre de réalisations : ' num2str(n)]);
    ylabel(axes_histogram, 'Frequence');

function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider

    sigma = get(hObject, 'Value');
    set(handles.text10, 'String', ['Σ = ' num2str(sigma, '%.2f')]);

    % on appelle le popupmenu pour mettre à jourl'histogramme
    popupmenu2_Callback(handles.popupmenu2, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    set(hObject, 'Min', 0);
    set(hObject, 'Max', 10);
    set(hObject, 'SliderStep', [1/100, 10/100]);
    set(hObject, 'Value', 1);

    handles.text10 = findobj('Tag', 'text10');
    set(handles.text10, 'String', 'Σ = 1');

    % Update handles structure
    guidata(hObject, handles);

function slider10_Callback(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
% get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    Moy = get(hObject, 'Value');
    set(handles.text11, 'String', ['Moy = ' num2str(Moy, '%.2f')]);

    % on appelle le popupmenu pour mettre à jourl'histogramme
    popupmenu2_Callback(handles.popupmenu2, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    set(hObject, 'Min', 0);
    set(hObject, 'Max', 10);
    set(hObject, 'SliderStep', [1/100, 10/100]);
    set(hObject, 'Value', 1);

    % Valeur initial dans le text_box
    handles.text11 = findobj('Tag', 'text11');
    set(handles.text11, 'String', 'Moy = 1');

    % Update handles structure
    guidata(hObject, handles);


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    class = round(get(hObject, 'Value'));
    set(handles.text12, 'String', ['class = ' num2str(class)]);

    % on appelle le popupmenu pour mettre à jourl'histogramme
    popupmenu2_Callback(handles.popupmenu2, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    % On configure le slider
    set(hObject, 'Min', 1);
    set(hObject, 'Max', 101);
    set(hObject, 'SliderStep', [1/100, 10/100]);
    set(hObject, 'Value', 50);

    % Valeur initial dans le text_box
    handles.text12 = findobj('Tag', 'text12');
    set(handles.text12, 'String', 'class = 50');
    % Update handles structure
    guidata(hObject, handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

    val = get(handles.popupmenu1,'value');
    a = handles.a;
    b = handles.b;
    n = handles.n;
    x1 = handles.x1;
    x2= handles.x2;

    % on recupère l'objet dans l'axe 1
    axes_handle = handles.axes1;

   switch(val)
    case 2
        x = linspace(x1, x2, n);
        y = fonction_exp(a, b, x);
        plot_title = ['Fonction Exponentielle: y = ' num2str(a) ' * exp(' num2str(b) ' * x)'];

    case 3
        x = linspace(x1, x2, n);
        y = fonction_log(a, b, x);
        plot_title = ['Fonction Logarithme: y = ' num2str(a) ' + ' num2str(b) ' * log(x)'];

    case 4
        x = linspace(x1, x2, n);
        y = fonction_lineaire(a, b, x);
        plot_title = ['Fonction linéaire: y = ' num2str(a) ' + ' num2str(b) ' * x'];

    case 5
        x = linspace(x1, x2, n);
        y = fonction_puissance(a, b, x);
        plot_title = ['Fonction puissance: y = ' num2str(a) ' * x ^ ' num2str(b)];
   end

    % On plot les fonctions dans l'axe 1
    axes(axes_handle);
    plot(x, y);
    xlabel('x');
    ylabel('y');
    title(plot_title);
   
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
 
    % on récupère la nouvelle valeur de a 
    a = round(get(hObject, 'Value'));
    
    % on mets la valeur de a dans le handles
    handles.a = a;
    
    % Update the handles structure
    guidata(hObject, handles);

    set(handles.text3, 'String', ['a = ' num2str(a)]);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

 % On configure le slider
    set(hObject, 'Min', 1);
    set(hObject, 'Max', 500);
    set(hObject, 'Value', 1);
    set(hObject, 'SliderStep', [1/10000, 1/10000]); % This sets the step size for the slider

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % On récupère la valeur de a su slider
    b= round(get(hObject, 'Value'));
    
    % on mets la valeur de a dans le handles
    handles.b = b;
    
    % Update the handles structure
    guidata(hObject, handles);

    set(handles.text4, 'String', ['b = ' num2str(b)]);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

 % On configure le slider
    set(hObject, 'Min', 1);
    set(hObject, 'Max', 500);
    set(hObject, 'Value', 1);
    set(hObject, 'SliderStep', [1/100, 1/100]); 
    handles.b = 1;
    guidata(hObject, handles);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    n = round(get(hObject, 'Value')); % On prends la valeur du slyder et on l'arrondie
    handles.n = n; % on prends la valeur de n et la mettre dans le handle
    guidata(hObject, handles); % on udate le handles
    set(handles.text5, 'String', ['N = ' num2str(n)]);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


    set(hObject, 'Min', 50);
    set(hObject, 'Max', 10000);
    set(hObject, 'Value', 1000);
    set(hObject, 'SliderStep', [1/10000, 10/10000]); 
    handles.n = 1000;
    guidata(hObject, handles);
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end



% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    x1 = get(hObject, 'Value');
    handles.x1 = x1; 
    guidata(hObject, handles); 
    set(handles.text6, 'String', ['x1 = ' num2str(x1, '%.2f')]);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    set(hObject, 'Min', 0);
    set(hObject, 'Max', 5);
    set(hObject, 'Value', 0);
    set(hObject, 'SliderStep', [0.01, 0.1]);
    guidata(hObject, handles);

function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    x2 = get(hObject, 'Value');
    handles.x2 = x2;
    guidata(hObject, handles);
    set(handles.text7, 'String', ['x2 = ' num2str(x2, '%.2f')]);

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

    set(hObject, 'Min', 0);
    set(hObject, 'Max', 5);
    set(hObject, 'Value', 5);
    set(hObject, 'SliderStep', [0.01, 0.1]);


% --- Executes on button press in pushbutton1.OpeningFcn
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Récupérez les coefficients d'extraction
% Récupérez les données x et y_noisy


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% On donne la valeur par défaut des sliders
    set(handles.slider1, 'Value', 3);
    set(handles.slider3, 'Value', 6);
    set(handles.slider4, 'Value', 100);
    set(handles.slider5, 'Value', 0);
    set(handles.slider6, 'Value', 5);
    set(handles.slider9, 'Value', 2);
    set(handles.slider10, 'Value', 1);
    set(handles.slider11, 'Value', 100);

    %On modifier aussi la zone de texte
    set(handles.text3, 'String',['a = ' num2str(3)]);
    set(handles.text4, 'String',['b = ' num2str(6)]);
    set(handles.text5, 'String',['N = ' num2str(100)]);
    set(handles.text6, 'String',['xmin = ' num2str(0)]);
    set(handles.text7, 'String',['xmax = ' num2str(5)]);
    set(handles.text10, 'String',['Σ = ' num2str(2)]);
    set(handles.text11, 'String',['Moy = ' num2str(1)]);
    set(handles.text12, 'String',['class = ' num2str(100)]);

    %On donne la valeurs par défaut des popupmenu
    set(handles.popupmenu1, 'Value', 2);
    set(handles.popupmenu2, 'Value', 2);

    % Update handles structure
    guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton1

    debug_mode = get(hObject, 'Value'); % Récupère l'état du bouton radio
    
    if debug_mode
        % On active le mode de débogage et affichez les éléments 
        set(handles.text_covariance_value, 'Visible', 'on');
        set(handles.text_vrr_value, 'Visible', 'on');
        set(handles.text_delta_a_value, 'Visible', 'on');
        set(handles.text_delta_b_value, 'Visible', 'on');
        set(handles.text_R2, 'Visible', 'on');
    else
        % On désactive le mode de débogage et masquez les éléments
        set(handles.text_covariance_value, 'Visible', 'off');
        set(handles.text_vrr_value, 'Visible', 'off');
        set(handles.text_delta_a_value, 'Visible', 'off');
        set(handles.text_delta_b_value, 'Visible', 'off');
        set(handles.text_R2, 'Visible', 'off');
    end

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
    
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 % Set the initial value of 'a'
% --- Executes on key press with focus on slider1 and none of its controls.


function slider1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function slider1_ValueChanging(hObject, eventdata, handles)
    % hObject    handle to slider1 (see GCBO)
    % eventdata  event data structure (see GUIDATA)
    % handles    structure with handles and user data (see GUIDATA)

    % On récupère la valeur de a
    a = eventdata.Value;
    % on update la valeur de a 
    set(handles.text3, 'String', ['a = ' num2str(a)]);

    %%%%%%%%%%%% Les systemes %%%%%%%%%%%%%%%%%%%%%%%
    function y = fonction_exp(a, b, x)
        y = a * exp(b * x);

    function y = fonction_log(a, b, x)
        y = a + b * log(x);

    function y = fonction_lineaire(a, b, x)
        y = a + b * x;

    function y = fonction_puissance(a, b, x)
        y = a * x .^ b;


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes4

function [coeffs_linlin, coeffs_loglog, coeffs_loglin, coeffs_linlog] = extraction_base(x, y) %Fonction d'extraction
    x_centered = x - mean(x);
    y_centered = y - mean(y);
    log_x_centered = log(x_centered - min(x_centered) + 1);
    log_y_centered = log(y_centered - min(y_centered) + 1);

    %On calcule les coefficients pour la représentation lin lin
    coeffs_linlin = polyfit(x_centered, y_centered, 1);

    %On calcule les coefficients pour la représentation log log
    coeffs_loglog = polyfit(log_x_centered, log_y_centered, 1);

    %On calcule les coefficients pour la représentation log linéaire
    coeffs_loglin = polyfit(x_centered, log_y_centered, 1);

    %On calcule les coefficients pour la représentation linéaire log
    coeffs_linlog = polyfit(log_x_centered, y_centered, 1);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get the values from sliders and popup menus

    val_noise = get(handles.popupmenu2, 'Value');
    val_function = get(handles.popupmenu1, 'Value');
    moy = get(handles.slider10, 'Value');
    sigma = get(handles.slider9, 'Value');

    n = handles.n;
    x1 = handles.x1;
    x2 = handles.x2;
    x = linspace(x1, x2, n);

    a = handles.a;
    b = handles.b;

    switch val_function
        case 2 % Exponentielle
            y_original = fonction_exp(a, b, x);
        case 3 % Logarithmique
            y_original = fonction_log(a, b, x);
        case 4 % Puissance
            y_original = fonction_puissance(a, b, x);
        case 5 % Lineaire
            y_original = fonction_lineaire(a, b, x);
    end

    % Ajout du bruit au systeme
    switch val_noise
        case 2 % Gaussien
            noise = moy + sigma * randn(1, n);
        case 3 % Uniforme
            noise = moy + sigma * rand(1, n) - sigma/2;
    end

    y_noisy = y_original + noise;

    % Plot le bruit
    axes_noisy = handles.axes4;
    plot(axes_noisy, x, y_noisy,'r');
    xlabel(axes_noisy, 'x');
    ylabel(axes_noisy, 'y');
    title(axes_noisy, 'Fonction bruitée');

    % On utilise la fonction d'extraction de base
    [coeffs_linlin, coeffs_loglog, coeffs_loglin, coeffs_linlog] = extraction_base(x, y_noisy);

    % On plot l'extraction avec le système bruité
    switch val_function
        case 2 % Exponentielle
            y_extr = coeffs_linlin(1) * exp(coeffs_linlin(2) * x);
        case 3 % Logarithmique
            y_extr = coeffs_loglog(1) * log(x) + coeffs_loglog(2);
        case 4 % Puissance
            y_extr = coeffs_loglin(1) * x.^coeffs_loglin(2);
        case 5 % Lineaire
            y_extr = coeffs_linlog(1) * x + coeffs_linlog(2);
    end
    
    hold(axes_noisy, 'on'); % Hold on du plot de la fonction bruité
    plot(axes_noisy, x, y_extr, 'K'); % On plot l'extraction
    hold(axes_noisy, 'off'); % 
    legend(axes_noisy, 'Signal bruité', 'Extraction');
    
        % On récupère les coefficients d'extraction
    [coeffs_linlin, coeffs_loglog, coeffs_loglin, coeffs_linlog] = extraction_base(x, y_noisy);

    % Affichage des résultats
    set(handles.text_a_theorique, 'String',['a = ' num2str(handles.a)]);
    set(handles.text_b_theorique, 'String',['b = ' num2str(handles.b)]);
    set(handles.text_sigma_theorique, 'String',['sigma théorique = ' num2str(sigma)]);

    switch val_function
        case 2 % Exponentielle
            y_extr = coeffs_linlin(1) * exp(coeffs_linlin(2) * x);
            set(handles.text_a_estime, 'String',['B0 = ' num2str(coeffs_linlin(1))]);
            set(handles.text_b_estime, 'String',['B1 = ' num2str(coeffs_linlin(2))]);
        case 3 % Logarithmique
            y_extr = coeffs_loglog(1) * log(x) + coeffs_loglog(2);
            set(handles.text_a_estime, 'String',['B0 = ' num2str(coeffs_linlin(1))]);
            set(handles.text_b_estime, 'String',['B1 = ' num2str(coeffs_linlin(2))]);
        case 4 % Puissance
            y_extr = coeffs_loglin(1) * x.^coeffs_loglin(2);
            set(handles.text_a_estime, 'String',['B0 = ' num2str(coeffs_linlin(1))]);
            set(handles.text_b_estime, 'String',['B1 = ' num2str(coeffs_linlin(2))]);
        case 5 % Lineaire
            y_extr = coeffs_linlog(1) * x + coeffs_linlog(2);
            set(handles.text_a_estime, 'String',['B0 = ' num2str(coeffs_linlin(1))]);
            set(handles.text_b_estime, 'String',['B1 = ' num2str(coeffs_linlin(2))]);
    end

    % Clacule de l'erreur sigma estimée
    error = y_noisy - y_extr;
    sigma_estime = std(error);

    % On défini la valeur pour text_sigma_estime
    set(handles.text_sigma_estime, 'String',['sigma estimé = ' num2str(sigma_estime)]);
    % On calcul les valeurs estimées de y
    switch val_function
        case 2 % Exponentielle
            y_estime = coeffs_linlin(1) * exp(coeffs_linlin(2) * x);
        case 3 % Logarithmique
            y_estime = coeffs_loglog(1) * log(x) + coeffs_loglog(2);
        case 4 % Puissance
            y_estime = coeffs_loglin(1) * x.^coeffs_loglin(2);
        case 5 % Lineaire
            y_estime = coeffs_linlog(1) * x + coeffs_linlog(2);
    end

    % On clacule les erreurs quadratiques 
    erreur_quadratique = (y_noisy - y_estime).^2;

    % On calcule l'erreur quadratique moyenne (RMSE)
    rmse = sqrt(mean(erreur_quadratique));

    % On affiche les erreurs de a, b et sigma
    set(handles.text_erreur_a, 'String',['Erreur a = ' num2str(abs(handles.a - coeffs_linlin(1)))]);
    set(handles.text_erreur_b, 'String',['Erreur b = ' num2str(abs(handles.b - coeffs_linlin(2)))]);
    set(handles.text_erreur_sigma, 'String',['Erreur sigma = ' num2str(abs(sigma - rmse))]);

    %carrés residuels
    SST = sum((y_noisy - mean(y_noisy)).^2);
    SSR = sum((y_noisy - y_estime).^2);
    R2 = 1 - (SSR / SST);
    set(handles.text_R2, 'String',['R2 = ' num2str(R2)]);

    % On calcule les résidus, la covariance et le VRR
    residuals = y_noisy - y_estime;
    covariance = cov(x, y_noisy);
    RSS = sum(residuals .^ 2);
    TSS = sum((y_noisy - mean(y_noisy)) .^ 2);
    VRR = 1 - (RSS / TSS);

    % On calcule Delta a et Delta b
    n = length(x);
    x_mean = mean(x);
    s = sqrt(sum(residuals .^ 2) / (n - 2));
    delta_a = s * sqrt((1/n) + (x_mean .^ 2) / sum((x - x_mean) .^ 2));
    delta_b = s / sqrt(sum((x - x_mean) .^ 2));

    % On ajoute les valeurs calculées
    set(handles.text_covariance_value, 'String',['Covariance = ' num2str(covariance(1, 2))]);
    set(handles.text_vrr_value, 'String',['VRR = ' num2str(VRR)]);
    set(handles.text_delta_a_value, 'String',['Delta a = ' num2str(delta_a)]);
    set(handles.text_delta_b_value, 'String',['Delta b = ' num2str(delta_b)]);

% --- Executes on button press in result_axes.
function result_axes_Callback(hObject, eventdata, handles)
% hObject    handle to result_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [filename, pathname] = uiputfile('*.pdf', 'Enregistrer les résultats sous');
    if isequal(filename, 0) || isequal(pathname, 0)
        disp('Annuler')
    else
        temp_fig = figure('Visible', 'off');


        new_axes = copyobj(handles.result_axes, temp_fig);
        set(new_axes, 'Units', 'normalized', 'Position', [0.13, 0.11, 0.775, 0.815]);

        % On récupère les valeurs des résultats
        a_theorique = get(handles.text_a_theorique, 'String');
        b_theorique = get(handles.text_b_theorique, 'String');
        sigma_theorique = get(handles.text_sigma_theorique, 'String');
        a_estime = get(handles.text_a_estime, 'String');
        b_estime = get(handles.text_b_estime, 'String');
        sigma_estime = get(handles.text_sigma_estime, 'String');
        erreur_a = get(handles.text_erreur_a, 'String');
        erreur_b = get(handles.text_erreur_b, 'String');
        erreur_sigma = get(handles.text_erreur_sigma, 'String');
    
        % On crée un tableau de texte pour afficher les résultats
        results_table = {
            'Théorique', 'Estimé', 'Erreur';
            ['a: ', a_theorique], ['B0: ', a_estime], ['Erreur a: ', erreur_a];
            ['b: ', b_theorique], ['B1: ', b_estime], ['Erreur b: ', erreur_b];
            ['Sigma: ', sigma_theorique], ['Sigma estimé: ', sigma_estime], ['Erreur sigma: ', erreur_sigma]
        };
    
        uitable(temp_fig, 'Data', results_table, 'Units', 'normalized', 'Position', [0.1, 0.01, 0.8, 0.15]);

        % On exporte la figure temporaire au format PDF
        print(temp_fig, '-dpdf', fullfile(pathname, filename));
        close(temp_fig);

        % On affiche un message indiquant que le fichier a été enregistré
        msgbox(['Résultats enregistrés sous : ', fullfile(pathname, filename)], 'Fichier enregistré');
    end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
