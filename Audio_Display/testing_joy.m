function [] = testing_joy( handles )

%-------------------------------------------------------------------------
%testing_joy(handles)
%Funkce pøehrává náhodnì vzorky a zaznamenává reakce uživatele pøi
%testování pomocí joysticku
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

cla(handles.axes1);cla(handles.axes2);
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6);
visibility(handles,1);
global vysledky;

%spuštìní testovací smyèky
loop=1;
while loop==1
 %získání polohy a hodnot tlaèítek joysticku
  [pos, but] = mat_joy(0);
   if but(2)==1
   loop=0;
   end;
   
  %první stisknutí hlavního tlaèítka
    if but(1)==1&&but(2)==0

pocet=str2num(get(handles.edit4,'String'));
%vytvoøení a pøehrání náhodné polohy stimulu
x_rand=45;
y_rand=42;
while (x_rand^2)>(45^2-y_rand^2)
x_rand=round((rand(1)*90-45)/5)*5;
y_rand=round((rand(1)*90-45)/45*7)*45/7;
end;
set(handles.slider1,'Value',y_rand);
set(handles.slider2,'Value',x_rand);
pause(0.5);
[sample, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); %nahrÃ¡nÃ­ vzorku
[sample,f_sample]=get_sample(sample,fs,handles);
sound(sample,f_sample);

%odhad místa, ze kterého zvuk vzešel
but(1)=0;
while but(1)==0
   [pos, but] = mat_joy(0);
    x_pos=45*pos(1)
    y_pos=45*-pos(2);
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerSize',12);


    if but(2)==1 
   but(1)=1;
   loop=0;
   end;

   %opìtovné pøehrání pùvodního vzorku
      if but(4)==1 
[sample, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]);
wavplay(sample,fs);
   end;
   
    %opìtovné pøehrání polohovaného vzorku
   if but(3)==1 
[sample, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); 
[sample,f_sample]=get_sample(sample,fs,handles);
wavplay(sample,f_sample);
   end;
end;

if but(2)==0
set(handles.edit4,'String',num2str(pocet+1));
x_pos=round(x_pos/5)*5;
y_pos=round(y_pos/45*7)*45/7;
%uložení odhadnuté polohy do výsledkù
vysledky(str2num(get(handles.edit4,'String')),:)=[str2num(get(handles.edit4,'String')),(get(handles.slider2,'Value')),(get(handles.slider1,'Value')),x_pos,y_pos];
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; cla; plot(0,0,'+', 'MarkerEdgeColor','w', 'MarkerSize',6); hold on; plot(x_pos,y_pos,'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','b', 'MarkerSize',12);

%zpožïovací smyèka
i=1;
while i<10000
i=i+0.0001;
end;
%vykreslení skuteèné polohy
if get(handles.checkbox4,'Value')
axes(handles.axes3); grid on; set(handles.axes3, 'GridLineStyle','-', 'XMinorGrid','off'); hold on; plot(get(handles.slider2,'Value'),get(handles.slider1,'Value'),'o', 'MarkerEdgeColor','k', 'MarkerFaceColor','c', 'MarkerSize',12);
end;

but(1)=0;
while but(1)==0
   [pos, but] = mat_joy(0);
   if but(2)==1 
   but(1)=1;
   loop=0;
   end;
end;
but(1)=0;

end;
end;
end;

%zjištìní aktuálního data a èasu
c=clock;
%uložení výsledkù
mkdir('vysledky_jst');
if get(handles.togglebutton5,'Value')
mkdir('vysledky_jst\pitch');
dlmwrite(['vysledky_jst\pitch\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
else
mkdir('vysledky_jst\boltec');
dlmwrite(['vysledky_jst\boltec\' num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5)) '.txt'], vysledky);
end;
%ukonèení testovacího módu zpìt do zkušebního (zviditelnìní a zneviditelnìní)
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

set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton2,'Enable','on');
set(handles.pushbutton6,'Enable','on');

%zjevení zprávy s hodnocením mìøení
percent=uspesnost(vysledky);
h = msgbox(['Vaše úspìšnost je ' num2str(percent) '%!'],'Výsledek mìøení');
end
