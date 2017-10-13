function [spusteno] = testing( handles,guessing )

%-------------------------------------------------------------------------
%spusteno=testing(handles, h�d�n� �i rnd polohov�n�)
%Funkce p�ehr�v� n�hodn� vzorky a zaznamen�v� reakce u�ivatele p�i
%testov�n� pomoc� my�i
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

global vysledky;
%spu�t�n� testovac�ho m�du
if strcmpi(get(handles.axes3,'Visible'),'on');
pocet=str2num(get(handles.edit4,'String'));

%pokud se neh�d�, n�hodn� se polohuje zvuk
if guessing==0;
pause(0.1);

%n�hodn� ur�en� polohy stimulu
x_rand=45;
y_rand=45;
while (x_rand^2)>(45^2-y_rand^2)
x_rand=round((rand(1)*90-45)/5)*5;
y_rand=round((rand(1)*90-45)/45*7)*45/7;
end;
%nastaven� n�hodn� polohy stimulu
set(handles.slider1,'Value',y_rand);
set(handles.slider2,'Value',x_rand);

%nahr�n� stimulu a jeho upraven� do n�hodn� vybran� polohy
[sample, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
[sample,f_sample]=get_sample(sample,fs,handles);
sound(sample,f_sample);
spusteno=1;

%se ji� n�hodn� napolohoval zvuk, program vy�k�v� na odhad u�ivatele
else
set(handles.edit4,'String',num2str(pocet+1));

%zji�t�n� polohy kurzoru my�i v grafu
pos=get(handles.axes3,'CurrentPoint');
x_pos=pos(1,1);
y_pos=pos(1,2);
%zaokrouhlen� polohy
x_pos=round(x_pos/5)*5;
y_pos=round(y_pos/45*7)*45/7;
%ulo�en� odhadu do matice v�sledky
vysledky(str2num(get(handles.edit4,'String')),:)=[str2num(get(handles.edit4,'String')),(get(handles.slider2,'Value')),(get(handles.slider1,'Value')),x_pos,y_pos];
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
%zobrazen� skute�n� hodnoty v u�ebn�m m�du
pause(0.5);
if get(handles.checkbox4,'Value')
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; plot(get(handles.slider2,'Value'),get(handles.slider1,'Value'),'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12);
end;

%ozn�men� konce �ek�n� u�ivatele na odezvu
spusteno=0;
end;
end;
end

