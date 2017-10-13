function varargout = main(varargin)

%-------------------------------------------------------------------------
%Diplomov� pr�ce
%Program pro testov�n� frekven�n�ho eleva�n�ho mapov�n�
%Alan �tolc, �VUT FEl, 2013
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

%funkce, kter� prob�hnou bezprost�edn� po spu�t�n� programu
function main_OpeningFcn(hObject, eventdata, handles, varargin) %p��kazy po spou�t�n� programu
handles.output = hObject;
%nahr�n� v�choz�ho stimulu
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); 
set(handles.text8,'String',['fb=' num2str(base_f(x,fs)) 'Hz']);
set(handles.text10,'String',['fs=' num2str(fs) 'Hz']);
guidata(hObject, handles);
%aktivace grafu pro citlivost na kliknut� my�i
set(handles.axes2, 'ButtonDownFcn', {@axes2_ButtonDownFcn, handles});
%vykreslen� b�l�ho k��e do pozice 0,0  do grafu pro snadn�j�� orientaci a nastaven� rozm�r� os
axes(handles.axes2); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
%vykreslen� v�choz�ho bodu v bod� 0,0
hold on; plot(0,0,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
%aktivace grafu pro citlivost na kliknut� my�i
set(handles.axes3, 'ButtonDownFcn', {@axes3_ButtonDownFcn, handles});
%nastaven� parametr� grafu
axes(handles.axes3); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on;
%nastaven� textov�ch pol� s informacemi o stimulu
set(handles.edit1,'String',num2str(fs/4));
set(handles.edit2,'String',num2str(fs/2));
set(handles.edit3,'String',25);
%nahr�n� stimulu
[x,fs]=get_sample(x,fs,handles);
%vykreslen� stimulu
plot_fft(x,fs,handles);
%glob�ln� hodnota spusteni pro aktivaci testovac�ho m�du
global spusteno;
spusteno=0;

%funkce, bez kter� by Matlab hl�sil chybu
function varargout = main_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%funkce posouvaj�c� a zaokrouhluj�c� vykreslenou polohu stimulu ve
%vertik�ln� rovin�
function slider1_Callback(hObject, eventdata, handles)
SliderValue=get(handles.slider1,'Value');   %z�sk�n� hodnot slideru
SliderValue=(round(SliderValue/45*7))*45/7; %zaokrouhlen� z�skan� hodnoty
set(handles.slider1, 'Value', SliderValue); %nastaven� slideru na zaokrouhlenou hodnotu
set(handles.text_elevation,'String',[num2str(round(SliderValue*10)/10) '�']); %nastaven� zaokrouhlen� hodnoty
%funkce nahr�vaj�c�, upravuj�c� a vykresluj�c� stimul, p�ehr�n� �i nikoliv
%zna�� posledn� 0
load_create_plot( handles,0);
%vykreslen� posunut�ho bodu
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(get(handles.slider2,'Value'),SliderValue,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);

%identick� funkce jako funkce v��e, ale v horizont�ln� rovin�
function slider2_Callback(hObject, eventdata, handles)
SliderValue=get(handles.slider2,'Value');   %analogicky s v��
SliderValue=(round(SliderValue/5)*5);
set(handles.slider2, 'Value', SliderValue);
set(handles.text_azimuth,'String',[num2str(SliderValue) '�']);
load_create_plot( handles,0);
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(SliderValue,get(handles.slider1,'Value'),'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);

%p�ehr�n� stimulu v nastaven� poloze
function pushbutton1_Callback(hObject, eventdata, handles)
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
[x, fs]=get_sample(x,fs,handles);
sound(x,fs);

%p�ehr�n� stimulu z polohy 0,0
function pushbutton2_Callback(hObject, eventdata, handles)
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
sound(x,fs);

%funkce ovl�daj�c� filtraci stimulu
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

%funkce m�n�c� stimul za jin�
function pushbutton3_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.wav';'*.WAV';'*.Wav'},'Vyberte po�adovan� stimul');
set(handles.text7,'String',FileName);
[x,fs]=wavread([PathName FileName]);
set(handles.text8,'String',['fb=' num2str(base_f(x,fs)) 'Hz']);
set(handles.text10,'String',['fs=' num2str(fs) 'Hz']);
set(handles.text9,'String',PathName);
[x,fs]=get_sample(x,fs,handles);
plot_fft(x,fs,handles);

%funkce vykresluj�c� graf p�i zm�n�
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
load_create_plot( handles,0);

%funkce popisuj�c� pr�b�h p�i kliknut� do okna grafu
function axes2_ButtonDownFcn(hObject, eventdata, handles)
if strcmpi(get(handles.axes2,'Visible'),'on');
%zji�t�n� pozice my�i v grafu
pos=get(handles.axes2,'CurrentPoint');
%zji�t�n� pozice z vektoru pos
x_pos=pos(1,1);
y_pos=pos(1,2);
x_pos=round(x_pos/5)*5;
y_pos=round(y_pos/45*7)*45/7;
%vykreslen� zvolen� polohy v grafu
axes(handles.axes2); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
set(handles.slider1, 'Value', y_pos); %nastavené slideru na zaokrouhlenou hodnotu
set(handles.text_elevation,'String',[num2str(round(y_pos*10)/10) '�']); %nastavení zaokrouhlené hodnoty
set(handles.slider1, 'Visible', 'on');
set(handles.slider2, 'Value', x_pos);
set(handles.text_azimuth,'String',[num2str(x_pos) '�']);
%vykreslen� vzorku do prav�ho grafu a jeho p�ehr�n�
load_create_plot( handles, 1);
end;

%p�ep�n�n� a vykreslen�
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
if get(handles.radiobutton2,'Value')
    set(handles.togglebutton3,'Enable','off');
    set(handles.togglebutton4,'Enable','off');
else set(handles.togglebutton3,'Enable','on'); 
    set(handles.togglebutton4,'Enable','on');end;
load_create_plot( handles,0 );

%vz�jemn� p�ep�n�n� button� viz dal�� funkce
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

%vykreslen� grafu
function slider6_Callback(hObject, eventdata, handles)
load_create_plot( handles,0 );

%p�ep�n�n� dvou tla��tek
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


%tla��tko spou�t�j�c� testov�n�
function pushbutton6_Callback(hObject, eventdata, handles)
global vysledky;
%zji�t�n�, zdali je testovac� m�d �i nikoliv
if strcmpi(get(handles.axes3,'Visible'),'off');
%spu�t�n� testov�n�
visibility(handles,1);
cla(handles.axes1);cla(handles.axes2);
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
set(handles.pushbutton6,'String','Ukon�it testov�n�');

if get(handles.checkbox3,'Value')
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton6,'Enable','off');
testing_joy(handles);   
end;

else
%ukon�en� testovac� m�du
%zji�t�n� �asu
c=clock;
%vytvo�en� adres���
mkdir('vysledky');
mkdir('vysledky\pitch');
mkdir('vysledky\boltec');
if get(handles.togglebutton5,'Value')
dlmwrite(['vysledky\pitch\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
else
dlmwrite(['vysledky\boltec\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
end;
%obnoven� nastavovac�ho rozhran�
visibility(handles,0);
load_create_plot( handles,0);
axes(handles.axes2); grid on; set(handles.axes2, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
hold on; plot(0,0,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
set(handles.slider1,'Value',0);
set(handles.slider2,'Value',0);
set(handles.pushbutton6,'String','Spustit testov�n�');
set(handles.axes3,'Visible','off');
axes(handles.axes3);cla;
set(handles.edit4,'String',num2str(0));
%uk�z�n� �sp�nosti
percent=uspesnost(vysledky);
h = msgbox(['Va�e �sp�nost je ' num2str(percent) '%!'],'V�sledek m��en�');
end;


%funkce staraj�c� se o testov�n� pomoc� my�i (kliknut� na grafick� vstup)
function axes3_ButtonDownFcn(hObject, eventdata, handles)
global spusteno;    %prom�nn� ��kaj�c�, zdali se odhaduje �i �ek� na dal�� pokus
if strcmpi(get(handles.axes3,'Visible'),'on');
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);

if spusteno==0
spusteno=testing(handles,0);
else
spusteno=testing(handles,1);
end;

end;



%funkce, bez kter�ch by Matlab hl�sil chyby
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
