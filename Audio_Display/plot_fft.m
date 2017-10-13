function [] = plot_fft( x,fs,handles )

%-------------------------------------------------------------------------
%plot_fft(vstupn� signal, vzorkovac� frekvence, handles)
%Funkce vykresluje pr�b�h sign�lu, jeho fft �i spektrogram
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

[length,channel]=size(x);

if get(handles.togglebutton1,'Value')
    y1=x(:,1); y2=x(:,2);
else y1=x(:,2); y2=x(:,1);
end;	%v�b�r lev�ho �i prav�ho kan�lu
[puv_vzorek, f_puv_vzorku]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); %nahr�n� vzorku
peak=max(max(abs(puv_vzorek)));	%zji�t�n� maxim�ln� hodnoty vzorku
peak_max_db=max(max(db(abs(fft(puv_vzorek,f_puv_vzorku))/f_puv_vzorku*2))); %max db sign�lu
peak_low_db=min(min(db(abs(fft(puv_vzorek,f_puv_vzorku))/f_puv_vzorku*2))); %min db sign�lu

%vykreslen� �asov�ho pr�b�hu sign�lu
if get(handles.radiobutton7,'Value')
t=0:1/fs:length/fs-1/fs;
axes(handles.axes1);
plot(handles.axes1,t,y2,'c');
hold on;
plot(handles.axes1,t,y1);
xlim([0 t(end)]);
ylim([-peak peak]);
title(handles.axes1,'Stimul'); 
ylabel(handles.axes1,'A'); 
xlabel(handles.axes1,'t (s)');
hold off;
end;


if get(handles.radiobutton8,'Value')
X1=db(abs(fft(y1,fs))/fs*2); %fft sign�lu
X2=db(abs(fft(y2,fs))/fs*2); %fft sign�lu
axes(handles.axes1);
plot(handles.axes1,X2(1:fs/2),'c');
hold on;
plot(handles.axes1,X1(1:fs/2));
xlim([0 fs/2]);
ylim([peak_low_db peak_max_db]);
title(handles.axes1,'FFT stimulu'); 
ylabel(handles.axes1,'A (dB)'); 
xlabel(handles.axes1,'f (Hz)');
hold off;
end;

%vykreslen� spektrogramu sign�lu
if get(handles.radiobutton9,'Value')
axes(handles.axes1);specgram(y1);
title(handles.axes1,'Spektrogram stimulu'); 
ylabel(handles.axes1,'f (10kHz)'); 
xlabel(handles.axes1,'t (vzorky)');
end;

end

