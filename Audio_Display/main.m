function varargout = main(varargin)

%-------------------------------------------------------------------------
%Diplomová práce
%Program pro testování frekvenèního elevaèního mapování
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

%funkce, které probìhnou bezprostøednì po spuštìní programu
function main_OpeningFcn(hObject, eventdata, handles, varargin) %pøíkazy po spouštìní programu
handles.output = hObject;
%nahrání výchozího stimulu
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); 
set(handles.text8,'String',['fb=' num2str(base_f(x,fs)) 'Hz']);
set(handles.text10,'String',['fs=' num2str(fs) 'Hz']);
guidata(hObject, handles);
%aktivace grafu pro citlivost na kliknutí myši
set(handles.axes2, 'ButtonDownFcn', {@axes2_ButtonDownFcn, handles});
%vykreslení bílého køíže do pozice 0,0  do grafu pro snadnìjší orientaci a nastavení rozmìrù os
axes(handles.axes2); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
%vykreslení výchozího bodu v bodì 0,0
hold on; plot(0,0,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
%aktivace grafu pro citlivost na kliknutí myši
set(handles.axes3, 'ButtonDownFcn', {@axes3_ButtonDownFcn, handles});
%nastavení parametrù grafu
axes(handles.axes3); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on;
%nastavení textových polí s informacemi o stimulu
set(handles.edit1,'String',num2str(fs/4));
set(handles.edit2,'String',num2str(fs/2));
set(handles.edit3,'String',25);
%nahrání stimulu
[x,fs]=get_sample(x,fs,handles);
%vykreslení stimulu
plot_fft(x,fs,handles);
%globální hodnota spusteni pro aktivaci testovacího módu
global spusteno;
spusteno=0;

%funkce, bez které by Matlab hlásil chybu
function varargout = main_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%funkce posouvající a zaokrouhlující vykreslenou polohu stimulu ve
%vertikální rovinì
function slider1_Callback(hObject, eventdata, handles)
SliderValue=get(handles.slider1,'Value');   %získání hodnot slideru
SliderValue=(round(SliderValue/45*7))*45/7; %zaokrouhlení získané hodnoty
set(handles.slider1, 'Value', SliderValue); %nastavení slideru na zaokrouhlenou hodnotu
set(handles.text_elevation,'String',[num2str(round(SliderValue*10)/10) '°']); %nastavení zaokrouhlení hodnoty
%funkce nahrávající, upravující a vykreslující stimul, pøehrání èi nikoliv
%znaèí poslední 0
load_create_plot( handles,0);
%vykreslení posunutého bodu
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(get(handles.slider2,'Value'),SliderValue,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);

%identická funkce jako funkce výše, ale v horizontální rovinì
function slider2_Callback(hObject, eventdata, handles)
SliderValue=get(handles.slider2,'Value');   %analogicky s výš
SliderValue=(round(SliderValue/5)*5);
set(handles.slider2, 'Value', SliderValue);
set(handles.text_azimuth,'String',[num2str(SliderValue) '°']);
load_create_plot( handles,0);
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(SliderValue,get(handles.slider1,'Value'),'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);

%pøehrání stimulu v nastavené poloze
function pushbutton1_Callback(hObject, eventdata, handles)
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
[x, fs]=get_sample(x,fs,handles);
sound(x,fs);

%pøehrání stimulu z polohy 0,0
function pushbutton2_Callback(hObject, eventdata, handles)
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
sound(x,fs);

%funkce ovládající filtraci stimulu
function checkbox2_Callback(hObject, eventdata, handles)
if get(handles.checkbox2, 'Value');
set(handles.edit1, 'Enable', 'On');
set(handles.edit2, 'Enable', 'On');
set(handles.edit3, 'Enable', 'On');
else
set(handles.edit1, 'Enable', 'Off');
set(handles.edit2, 'Enable', 'Off');
set(handles.edit3, 'Enable', 'Off');
end;
load_create_plot( handles,0);

%funkce mìnící stimul za jiný
function pushbutton3_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.wav';'*.WAV';'*.Wav'},'Vyberte požadovaný stimul');
set(handles.text7,'String',FileName);
[x,fs]=wavread([PathName FileName]);
set(handles.text8,'String',['fb=' num2str(base_f(x,fs)) 'Hz']);
set(handles.text10,'String',['fs=' num2str(fs) 'Hz']);
set(handles.text9,'String',PathName);
[x,fs]=get_sample(x,fs,handles);
plot_fft(x,fs,handles);

%funkce vykreslující graf pøi zmìnì
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
load_create_plot( handles,0);

%funkce popisující prùbìh pøi kliknutí do okna grafu
function axes2_ButtonDownFcn(hObject, eventdata, handles)
if strcmpi(get(handles.axes2,'Visible'),'on');
%zjištìní pozice myši v grafu
pos=get(handles.axes2,'CurrentPoint');
%zjištìní pozice z vektoru pos
x_pos=pos(1,1);
y_pos=pos(1,2);
x_pos=round(x_pos/5)*5;
y_pos=round(y_pos/45*7)*45/7;
%vykreslení zvolené polohy v grafu
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
set(handles.slider1, 'Value', y_pos); %nastavenÃ© slideru na zaokrouhlenou hodnotu
set(handles.text_elevation,'String',[num2str(round(y_pos*10)/10) '°']); %nastavenÃ­ zaokrouhlenÃ© hodnoty
set(handles.slider1, 'Visible', 'on');
set(handles.slider2, 'Value', x_pos);
set(handles.text_azimuth,'String',[num2str(x_pos) '°']);
%vykreslení vzorku do pravého grafu a jeho pøehrání
load_create_plot( handles, 1);
end;

%pøepínání a vykreslení
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
if get(handles.radiobutton2,'Value')
    set(handles.togglebutton3,'Enable','off');
    set(handles.togglebutton4,'Enable','off');
else set(handles.togglebutton3,'Enable','on'); 
    set(handles.togglebutton4,'Enable','on');end;
load_create_plot( handles,0 );

%vzájemné pøepínání buttonù viz další funkce
function togglebutton3_Callback(hObject, eventdata, handles)
if get(handles.togglebutton3,'Value')
    set(handles.togglebutton4,'Value',0);
else
       set(handles.togglebutton4,'Value',1);
end;
load_create_plot( handles,0 );

function togglebutton1_Callback(hObject, eventdata, handles)
if get(handles.togglebutton1,'Value')
    set(handles.togglebutton2,'Value',0);
else
       set(handles.togglebutton2,'Value',1);
end;
load_create_plot( handles,0 );

function togglebutton2_Callback(hObject, eventdata, handles)
if get(handles.togglebutton2,'Value')
    set(handles.togglebutton1,'Value',0);
else
       set(handles.togglebutton1,'Value',1);
end;
load_create_plot( handles,0 );


function togglebutton4_Callback(hObject, eventdata, handles)
if get(handles.togglebutton4,'Value')
    set(handles.togglebutton3,'Value',0);
else
       set(handles.togglebutton3,'Value',1);
end;
load_create_plot( handles,0 );

%vykreslení grafu
function slider6_Callback(hObject, eventdata, handles)
load_create_plot( handles,0 );

%pøepínání dvou tlaèítek
function togglebutton6_Callback(hObject, eventdata, handles)
if get(handles.togglebutton6,'Value')
    set(handles.togglebutton5,'Value',0);
else
       set(handles.togglebutton5,'Value',1);
end;
load_create_plot( handles,0);


function togglebutton5_Callback(hObject, eventdata, handles)
if get(handles.togglebutton5,'Value')
    set(handles.togglebutton6,'Value',0);
else
       set(handles.togglebutton6,'Value',1);
end;
load_create_plot( handles,0);


%tlaèítko spouštìjící testování
function pushbutton6_Callback(hObject, eventdata, handles)
global vysledky;
%zjištìní, zdali je testovací mód èi nikoliv
if strcmpi(get(handles.axes3,'Visible'),'off');
%spuštìní testování
visibility(handles,1);
cla(handles.axes1);cla(handles.axes2);
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
set(handles.pushbutton6,'String','Ukonèit testování');

if get(handles.checkbox3,'Value')
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton6,'Enable','off');
testing_joy(handles);   
end;

else
%ukonèení testovací módu
%zjištìní èasu
c=clock;
%vytvoøení adresáøù
mkdir('vysledky');
mkdir('vysledky\pitch');
mkdir('vysledky\boltec');
if get(handles.togglebutton5,'Value')
dlmwrite(['vysledky\pitch\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
else
dlmwrite(['vysledky\boltec\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
end;
%obnovení nastavovacího rozhraní
visibility(handles,0);
load_create_plot( handles,0);
axes(handles.axes2); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
hold on; plot(0,0,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
set(handles.slider1,'Value',0);
set(handles.slider2,'Value',0);
set(handles.pushbutton6,'String','Spustit testování');
set(handles.axes3,'Visible','off');
axes(handles.axes3);cla;
set(handles.edit4,'String',num2str(0));
%ukázání úspìšnosti
percent=uspesnost(vysledky);
h = msgbox(['Vaše úspìšnost je ' num2str(percent) '%!'],'Výsledek mìøení');
end;


%funkce starající se o testování pomocí myši (kliknutí na grafický vstup)
function axes3_ButtonDownFcn(hObject, eventdata, handles)
global spusteno;    %promìnná øíkající, zdali se odhaduje èi èeká na další pokus
if strcmpi(get(handles.axes3,'Visible'),'on');
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);

if spusteno==0
spusteno=testing(handles,0);
else
spusteno=testing(handles,1);
end;

end;



%funkce, bez kterých by Matlab hlásil chyby
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider6_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function radiobutton7_CreateFcn(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function figure1_CreateFcn(hObject, eventdata, handles)
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
function edit1_Callback(hObject, eventdata, handles)
function edit2_Callback(hObject, eventdata, handles)
function edit3_Callback(hObject, eventdata, handles)
function togglebutton2_ButtonDownFcn(hObject, eventdata, handles)
function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox3_Callback(hObject, eventdata, handles)
function checkbox4_Callback(hObject, eventdata, handles)
function axes1_CreateFcn(hObject, eventdata, handles)
function axes2_CreateFcn(hObject, eventdata, handles)
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
