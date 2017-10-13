function [ ] = load_create_plot( handles ,play)

%-------------------------------------------------------------------------
%load_create_plot(handles, p�ehr�t vzorek)
%Funkce, ve kter� jsou obsa�eny �asto pou��van� funkce
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

%nahr�n� vzorku
[x, fs]=wavread([get(handles.text9,'String') get(handles.text7,'String')]); %nahrání vzorku
%upraven� vzorku
[y,f_sample]=get_sample(x,fs,handles);
%vykreslen� vzorku
plot_fft(y,f_sample,handles);

%p�ehr�n� vzorku
if play sound(y,f_sample); end;
end

