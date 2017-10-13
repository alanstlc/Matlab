function varargout = projekt(varargin)

%Semestr�ln� projekt A2M32MKS
%Alan �tolc, Alexandr Po�ta
%�VUT FEl 2013
%
%2) Model pohybu u�ivatele - Manhattan Mobility Model
%Vytvo�te simula�n� program pohybu u�ivatel� podle modelu MMM (Manhattan Mobility Model).
%Prove�te rozbor z�skan�ch v�sledk� pro r�zn� nastaven� hodnoty modelu (nap�. rychlost,
%pravd�podobnost odbo�en�, atd.).


%po��te�n� v�ci, na kter� by se sp�e nem�lo �ahat
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projekt_OpeningFcn, ...
                   'gui_OutputFcn',  @projekt_OutputFcn, ...
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

%funkce, ve kter� jsou v�ci, kter� se maj� st�t hned po startu
function projekt_OpeningFcn(hObject, eventdata, handles, varargin)
clc;    %vymaz�n� okna p��kazov� ��dky
global xmax;    %vytvo�en� glob�ln� prom�nn� s ���kou mapy
global ymax;    %vytvo�en� glob�ln� prom�nn� s v��kou mapy
global mapa;    %vytvo�en� glob�ln� prom�nn� s mapou
global okraj;   %vytvo�en� glob�ln� prom�nn� okraje mapy
global odboceni; %glob�ln� prom�nn� pro ov��en� funk�nosti programu
odboceni = ([0 0]);
set(handles.text3,'String','-');
%nastaven� indik�toru rychlosti a pravd�podobnosti odbo�en�
set(handles.text4,'String',['Rychlost - ' num2str(get(handles.slider2,'Value')*9+1)]);
set(handles.text2,'String',['Pst odbo�en� - ' num2str(get(handles.slider1,'Value')*100) '%']);
okraj=50;
xmax=300;
ymax=300;
mapa=zeros(xmax,ymax);  %nuly v map�=nic, jedni�ky=cesta

for i=1:1:xmax/okraj-1 %vytvo�en� horizont�ln�ch cest
mapa(okraj*i,okraj:ymax-okraj)=1;
end;
for i=1:1:ymax/okraj-1  %vytvo�en� vertik�ln�ch cest
mapa(okraj:xmax-okraj,i*okraj)=1;
end;

%vytvo�en� grafu, cesty (jedni�ky) nejsou vid�t, ale zv�raz�uj� je vedlej��
%osy
axes(handles.axes1); xlim([0 xmax]); ylim([0 ymax]); grid on;
colormap('gray');
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});
handles.output = hObject;
guidata(hObject, handles);


%nepou�it� funkce s textov�m v�stupem
function varargout = projekt_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;





%funkce pro stisknut� my�i v oblasti grafu
function axes1_ButtonDownFcn(hObject, eventdata, handles)
global xmax;    %nahr�n� glob�ln�ch prom�nn�ch do funkce
global ymax;
global mapa;
global okraj;
pos=get(handles.axes1,'CurrentPoint');   %z�sk�n� aktu�ln� pozice my�i
x_pos=round(pos(1,1));  %zaokrouhlen� pozice
y_pos=round(pos(1,2));
%u�ivatel klik� do mapy a vol� tak, kde chce chod�c�ho pan��ka m�ti
if x_pos<okraj x_pos=okraj; end;    %o�et�en� okraj� p�i kliknut� mino mapu
if x_pos>(xmax-okraj) x_pos=xmax-okraj; end;   
if y_pos<okraj y_pos=okraj; end;
if y_pos>(ymax-okraj) y_pos=ymax-okraj; end;
%o�et�en� p�i kliknut� mimo cestu
if abs(x_pos-round(x_pos/10)*10)>abs(y_pos-round(y_pos/10)*10)
y_pos=round(y_pos/okraj)*okraj;
else
x_pos=round(x_pos/okraj)*okraj;
end;

%vytvo�en� chod�c�ho pan��ka
global u1;
%p�i�azen� aktu�ln� a b�val� pozice (ta je volena pro jednoduchost jako y-1)
u1=[x_pos y_pos x_pos y_pos-1];
axes(handles.axes1);
plot(u1(1),u1(2),'o'); %vykreslen� chod�c�ho pan��ka
xlim([0 xmax]); ylim([0 ymax]); grid on;    %ozna�en� maxim a minim grafu
%nastaven� grafu jako znovu aktivn� pro kliknut�
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});




%tla��tko, co spou�t� a zastavuje pohyb
function pushbutton4_Callback(hObject, eventdata, handles)
global mapa;    %nahr�n� glob�ln�ch prom�nn�ch do funkce
global xmax;
global ymax;
global u1;
%nastaven� grafu jako znovu aktivn� pro kliknut�
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});
%nastaven� stringu tla��tka
if get(handles.pushbutton4,'Value')
   set(handles.pushbutton4,'String','Stop')
else set(handles.pushbutton4,'String','Spustit');
end;
%smy�ka, kter� se opakuje, dokud je zm��knuto tla��tko 'Spustit'
while get(handles.pushbutton4,'Value')
%nahr�n� moment�ln� polohy a minil� polohy pro z�sk�n� budouc� polohy
[u1(1),u1(2),u1(3),u1(4)]=move(u1(1),u1(2),u1(3),u1(4),handles);
%vykreslen� chod�c�ho pan��ka
axes(handles.axes1);
plot(u1(1),u1(2),'o');
xlim([0 xmax]); ylim([0 ymax]); grid on;
%ukazatel procentu�ln� �sp�nosti odbo�en�
global odboceni;
if odboceni(1)+odboceni(2)>0
set(handles.text3,'String',['% odbo�en� - ' num2str(round(odboceni(2)/(odboceni(1)+odboceni(2))*1000)/10) '%']);
else
set(handles.text3,'String','-');
end
%nastaven� zpomalen� pomoc� doln�ho slideru
pause(0.01/(get(handles.slider2,'Value')+0.1));
end;

%nastaven� text� p�i pr�ci se slidery
function slider1_Callback(hObject, eventdata, handles)
set(handles.text2,'String',['Pst odbo�en� - ' num2str(round(get(handles.slider1,'Value')*1000)/10) '%']);
%vynulov�n� kontorly funk�nosti pravd�podobnosti
global odboceni;
odboceni=([0 0]);
set(handles.text3,'String','-');
function slider2_Callback(hObject, eventdata, handles)
set(handles.text4,'String',['Rychlost - ' num2str(round((get(handles.slider2,'Value')*9+1)*10)/10)]);


%�pln� zbyte�n� funkce, kter� kdyby nebyly zadeklarov�ny, Matlab by nad�val
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
