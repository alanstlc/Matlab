function varargout = projekt(varargin)

%Semestrální projekt A2M32MKS
%Alan Štolc, Alexandr Pošta
%ÈVUT FEl 2013
%
%2) Model pohybu uživatele - Manhattan Mobility Model
%Vytvoøte simulaèní program pohybu uživatelù podle modelu MMM (Manhattan Mobility Model).
%Proveïte rozbor získaných výsledkù pro rùznì nastavené hodnoty modelu (napø. rychlost,
%pravdìpodobnost odboèení, atd.).


%poèáteèní vìci, na které by se spíše nemìlo šahat
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

%funkce, ve které jsou vìci, které se mají stát hned po startu
function projekt_OpeningFcn(hObject, eventdata, handles, varargin)
clc;    %vymazání okna pøíkazové øádky
global xmax;    %vytvoøení globální promìnné s šíøkou mapy
global ymax;    %vytvoøení globální promìnné s výškou mapy
global mapa;    %vytvoøení globální promìnné s mapou
global okraj;   %vytvoøení globální promìnné okraje mapy
global odboceni; %globální promìnná pro ovìøení funkènosti programu
odboceni = ([0 0]);
set(handles.text3,'String','-');
%nastavení indikátoru rychlosti a pravdìpodobnosti odboèení
set(handles.text4,'String',['Rychlost - ' num2str(get(handles.slider2,'Value')*9+1)]);
set(handles.text2,'String',['Pst odboèení - ' num2str(get(handles.slider1,'Value')*100) '%']);
okraj=50;
xmax=300;
ymax=300;
mapa=zeros(xmax,ymax);  %nuly v mapì=nic, jednièky=cesta

for i=1:1:xmax/okraj-1 %vytvoøení horizontálních cest
mapa(okraj*i,okraj:ymax-okraj)=1;
end;
for i=1:1:ymax/okraj-1  %vytvoøení vertikálních cest
mapa(okraj:xmax-okraj,i*okraj)=1;
end;

%vytvoøení grafu, cesty (jednièky) nejsou vidìt, ale zvýrazòují je vedlejší
%osy
axes(handles.axes1); xlim([0 xmax]); ylim([0 ymax]); grid on;
colormap('gray');
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});
handles.output = hObject;
guidata(hObject, handles);


%nepoužitá funkce s textovým výstupem
function varargout = projekt_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;





%funkce pro stisknutí myši v oblasti grafu
function axes1_ButtonDownFcn(hObject, eventdata, handles)
global xmax;    %nahrání globálních promìnných do funkce
global ymax;
global mapa;
global okraj;
pos=get(handles.axes1,'CurrentPoint');   %získání aktuální pozice myši
x_pos=round(pos(1,1));  %zaokrouhlení pozice
y_pos=round(pos(1,2));
%uživatel kliká do mapy a volí tak, kde chce chodícího panáèka míti
if x_pos<okraj x_pos=okraj; end;    %ošetøení okrajù pøi kliknutí mino mapu
if x_pos>(xmax-okraj) x_pos=xmax-okraj; end;   
if y_pos<okraj y_pos=okraj; end;
if y_pos>(ymax-okraj) y_pos=ymax-okraj; end;
%ošetøení pøi kliknutí mimo cestu
if abs(x_pos-round(x_pos/10)*10)>abs(y_pos-round(y_pos/10)*10)
y_pos=round(y_pos/okraj)*okraj;
else
x_pos=round(x_pos/okraj)*okraj;
end;

%vytvoøení chodícího panáèka
global u1;
%pøiøazení aktuální a bývalé pozice (ta je volena pro jednoduchost jako y-1)
u1=[x_pos y_pos x_pos y_pos-1];
axes(handles.axes1);
plot(u1(1),u1(2),'o'); %vykreslení chodícího panáèka
xlim([0 xmax]); ylim([0 ymax]); grid on;    %oznaèení maxim a minim grafu
%nastavení grafu jako znovu aktivní pro kliknutí
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});




%tlaèítko, co spouští a zastavuje pohyb
function pushbutton4_Callback(hObject, eventdata, handles)
global mapa;    %nahrání globálních promìnných do funkce
global xmax;
global ymax;
global u1;
%nastavení grafu jako znovu aktivní pro kliknutí
set(handles.axes1, 'ButtonDownFcn', {@axes1_ButtonDownFcn, handles});
%nastavení stringu tlaèítka
if get(handles.pushbutton4,'Value')
   set(handles.pushbutton4,'String','Stop')
else set(handles.pushbutton4,'String','Spustit');
end;
%smyèka, která se opakuje, dokud je zmáèknuto tlaèítko 'Spustit'
while get(handles.pushbutton4,'Value')
%nahrání momentální polohy a minilé polohy pro získání budoucí polohy
[u1(1),u1(2),u1(3),u1(4)]=move(u1(1),u1(2),u1(3),u1(4),handles);
%vykreslení chodícího panáèka
axes(handles.axes1);
plot(u1(1),u1(2),'o');
xlim([0 xmax]); ylim([0 ymax]); grid on;
%ukazatel procentuální úspìšnosti odboèení
global odboceni;
if odboceni(1)+odboceni(2)>0
set(handles.text3,'String',['% odboèení - ' num2str(round(odboceni(2)/(odboceni(1)+odboceni(2))*1000)/10) '%']);
else
set(handles.text3,'String','-');
end
%nastavení zpomalení pomocí dolního slideru
pause(0.01/(get(handles.slider2,'Value')+0.1));
end;

%nastavení textù pøi práci se slidery
function slider1_Callback(hObject, eventdata, handles)
set(handles.text2,'String',['Pst odboèení - ' num2str(round(get(handles.slider1,'Value')*1000)/10) '%']);
%vynulování kontorly funkènosti pravdìpodobnosti
global odboceni;
odboceni=([0 0]);
set(handles.text3,'String','-');
function slider2_Callback(hObject, eventdata, handles)
set(handles.text4,'String',['Rychlost - ' num2str(round((get(handles.slider2,'Value')*9+1)*10)/10)]);


%úplnì zbyteèné funkce, které kdyby nebyly zadeklarovány, Matlab by nadával
function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
