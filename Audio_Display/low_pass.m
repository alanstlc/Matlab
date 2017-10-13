function[out]=low_pass(x,fs,handles)

%-------------------------------------------------------------------------
%výstupní signál=low_pass(vstupní signál, vzorkovací frekvence, handles)
%Funkce signál filtrovaný dolní, horní èi pásmovou propustí
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

freq=str2num(get(handles.edit1, 'String')); %zjištìní støední frekvence
freq_b=str2num(get(handles.edit2, 'String')); %zjištìní šíøky pásma
rad=str2num(get(handles.edit3, 'String')); %zjištìní øádu filtru
f_l=(freq-freq_b/2)/fs*2;	%vytvoøení normované dolní meze
f_h=(freq+freq_b/2)/fs*2;	%vytvoøení normované horní meze
if (freq-freq_b/2)<=0 f_l=1/fs*2;
end;
if (freq+freq_b/2)/fs*2>=1 f_h=1-1/fs*2;
end;
b=fir1(rad,[f_l f_h]);	%vytvoøení filtru
out=filter(b,1,x);	%filtrace signálu
end
