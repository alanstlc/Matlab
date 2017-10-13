function [spusteno] = testing( handles,guessing )

%-------------------------------------------------------------------------
%spusteno=testing(handles, hádání èi rnd polohování)
%Funkce pøehrává náhodnì vzorky a zaznamenává reakce uživatele pøi
%testování pomocí myši
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

global vysledky;
%spuštìní testovacího módu
if strcmpi(get(handles.axes3,'Visible'),'on');
pocet=str2num(get(handles.edit4,'String'));

%pokud se nehádá, náhodnì se polohuje zvuk
if guessing==0;
pause(0.1);

%náhodné urèení polohy stimulu
x_rand=45;
y_rand=45;
while (x_rand^2)>(45^2-y_rand^2)
x_rand=round((rand(1)*90-45)/5)*5;
y_rand=round((rand(1)*90-45)/45*7)*45/7;
end;
%nastavení náhodné polohy stimulu
set(handles.slider1,'Value',y_rand);
set(handles.slider2,'Value',x_rand);

%nahrání stimulu a jeho upravení do náhodnì vybrané polohy
[sample, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
[sample,f_sample]=get_sample(sample,fs,handles);
sound(sample,f_sample);
spusteno=1;

%se již náhodnì napolohoval zvuk, program vyèkává na odhad uživatele
else
set(handles.edit4,'String',num2str(pocet+1));

%zjištìní polohy kurzoru myši v grafu
pos=get(handles.axes3,'CurrentPoint');
x_pos=pos(1,1);
y_pos=pos(1,2);
%zaokrouhlení polohy
x_pos=round(x_pos/5)*5;
y_pos=round(y_pos/45*7)*45/7;
%uložení odhadu do matice výsledky
vysledky(str2num(get(handles.edit4,'String')),:)=[str2num(get(handles.edit4,'String')),(get(handles.slider2,'Value')),(get(handles.slider1,'Value')),x_pos,y_pos];
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);
%zobrazení skuteèné hodnoty v uèebním módu
pause(0.5);
if get(handles.checkbox4,'Value')
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; plot(get(handles.slider2,'Value'),get(handles.slider1,'Value'),'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12);
end;

%oznámení konce èekání uživatele na odezvu
spusteno=0;
end;
end;
end

