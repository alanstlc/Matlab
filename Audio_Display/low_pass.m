function[out]=low_pass(x,fs,handles)

%-------------------------------------------------------------------------
%v�stupn� sign�l=low_pass(vstupn� sign�l, vzorkovac� frekvence, handles)
%Funkce sign�l filtrovan� doln�, horn� �i p�smovou propust�
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

freq=str2num(get(handles.edit1, 'String')); %zji�t�n� st�edn� frekvence
freq_b=str2num(get(handles.edit2, 'String')); %zji�t�n� ���ky p�sma
rad=str2num(get(handles.edit3, 'String')); %zji�t�n� ��du filtru
f_l=(freq-freq_b/2)/fs*2;	%vytvo�en� normovan� doln� meze
f_h=(freq+freq_b/2)/fs*2;	%vytvo�en� normovan� horn� meze
if (freq-freq_b/2)<=0 f_l=1/fs*2;
end;
if (freq+freq_b/2)/fs*2>=1 f_h=1-1/fs*2;
end;
b=fir1(rad,[f_l f_h]);	%vytvo�en� filtru
out=filter(b,1,x);	%filtrace sign�lu
end
