function [ y,f_sample ] = get_sample( x,fs, handles)

%-------------------------------------------------------------------------
%[vystupni signal, nová vzorkovací frekvence]=get_sample(vstupni signal, vzorkovací frekvence,handles)
%Funkce vrací virtuálnì polohovaný stereo signál pomocí principu ILD
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

odraz=get(handles.slider6,'Value');
set(handles.text11,'String',['Odraz ' num2str(odraz) 'ms']);
x_f=filter_comb( x,fs,odraz);

f_sample=fs;

if get(handles.togglebutton5,'Value')

fs(1)=f_sample;
if get(handles.radiobutton5,'Value')
fs(2)=round(f_sample*1.125/5)*5;
fs(3)=round(f_sample*1.25);
fs(4)=round(f_sample*1.333/5)*5;
fs(5)=round(f_sample*1.5);
fs(6)=round(f_sample*1.666/5)*5;
fs(7)=round(f_sample*1.875);
else
fs(2)=round(f_sample*1.122/5)*5;
fs(3)=round(f_sample*1.26);
fs(4)=round(f_sample*1.335/5)*5;
fs(5)=round(f_sample*1.5);
fs(6)=round(f_sample*1.682/5)*5;
fs(7)=round(f_sample*1.888/5)*5;   
end;
fs(8)=f_sample+f_sample;

SliderValue=get(handles.slider1,'Value');
i=abs(SliderValue/45*7)+1; 
if SliderValue>0
e = pvoc(x_f, f_sample/fs(i)); 
y = resample(e,f_sample,fs(i)); % NB: 0.8 = 4/5 
else
if get(handles.radiobutton5,'Value')
fs(2)=round(f_sample/2*1.875);   
fs(3)=round(f_sample/2*(1.666/5))*5;  
fs(4)=round(f_sample/2*1.5);        
fs(5)=round(f_sample/2*(1.333/5))*5;   
fs(6)=round(f_sample/2*1.25);           
fs(7)=round(f_sample/2*(1.125/5))*5;    
else
fs(2)=round(f_sample/2*1.888/5)*5;      
fs(3)=round(f_sample/2*1.682/5)*5;      
fs(4)=round(f_sample/2*1.5);   
fs(5)=round(f_sample/2*1.335/5)*5;
fs(6)=round(f_sample/2*1.26);
fs(7)=round(f_sample/2*1.122/5)*5; 
end;
fs(8)=f_sample/2;

e = pvoc(x_f, f_sample/fs(i)); 
y = resample(e,f_sample,fs(i)); % NB: 0.8 = 4/5

end;

else
elev=get(handles.slider1,'Value');
angle=get(handles.slider2,'Value');

[length,channel]=size(x);
y(:,1)=boltec(angle,elev,x_f(:,1),fs);
if channel==2
y(:,2)=boltec(angle,elev,x_f(:,2),fs);
end;
i=1;
end;

angle=get(handles.slider2,'Value');

[delka,channel]=size(y);
if channel==1 y(:,2)=y(:,1); end;

if get(handles.radiobutton1,'Value')
if get(handles.togglebutton3,'Value')
    if angle>0
    y(:,1)=shadow(angle,fs(i),y(:,1));
    elseif angle<0
    y(:,2)=shadow(abs(angle),fs(i),y(:,2));
    end;
else
y=ild(angle,y);
end;
end;

if get(handles.radiobutton2,'Value')
y=itd(angle,fs(i),y);
end;

if get(handles.radiobutton3,'Value')
if get(handles.togglebutton3,'Value')
 if angle>0
    y(:,1)=shadow(angle,fs(i),y(:,1));
    elseif angle<0
    y(:,2)=shadow(abs(angle),fs(i),y(:,2));
    end;
else
y=ild(angle,y);
end;
y=itd(angle,fs(i),y);
end;
if get(handles.checkbox2,'Value')
y=low_pass(y,fs(i),handles);
end;

end

