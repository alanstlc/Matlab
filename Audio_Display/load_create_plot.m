function [ ] = load_create_plot( handles ,play)

%-------------------------------------------------------------------------
%load_create_plot(handles, pøehrát vzorek)
%Funkce, ve které jsou obsaženy èasto používané funkce
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

%nahrání vzorku
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); %nahrÃ¡nÃ­ vzorku
%upravení vzorku
[y,f_sample]=get_sample(x,fs,handles);
%vykreslení vzorku
plot_fft(y,f_sample,handles);

%pøehrání vzorku
if play sound(y,f_sample); end;
end

