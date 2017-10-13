function [f] = base_f(in,fs)

%-------------------------------------------------------------------------
%z�kladn� frekvence=base_f(vstupn� signal, vzorkovac� frekvence)
%Funkce vrac� z�kladn� frekvenci vlo�en�ho zvukov�ho sign�lu
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

[l,channel]=size(in);	%zji�t�n� po�tu kan�l�
if channel==2 x=(in(:,1)/2+in(:,2)/2);	%p�eveden� stereo sign�lu na mono
else x=in;
end;

dt = 1/fs;	%zji�t�n� periody
I0 = round(0.1/dt);	%ozna�en� �seku od 0.1s
Iend = round(0.25/dt);	%ozna�en� �seku do 0.25s
in = x(I0:Iend);
[b0,a0]=butter(2,325/(fs/2));	%vytvo�en� Butterworhova filtru
xin = abs(in);	%p�eklopen� sign�lu do kladn�ch hodnot
xin=filter(b0,a0,xin);	%filtrace sign�lu
xin = xin-mean(xin);	%ode�ten� st�edn� hodnoty
x2=zeros(length(xin),1); %vytvo�en� nulov�ho vektoru
x2(1:length(in)-1)=xin(2:length(in));	%dosazen� posunut�ho sign�lu do nulov�ho vektoru
zc=length(find((xin>0 & x2<0) | (xin<0 & x2>0)));	%hled�n� nul
f=0.5*fs*zc/length(in);	%vypo�t�n� z�kladn� frekvence
end
