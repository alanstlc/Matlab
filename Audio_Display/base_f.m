function [f] = base_f(in,fs)

%-------------------------------------------------------------------------
%základní frekvence=base_f(vstupní signal, vzorkovací frekvence)
%Funkce vrací základní frekvenci vloženého zvukového signálu
%Alan Štolc, ČVUT FEl, 2013
%-------------------------------------------------------------------------

[l,channel]=size(in);	%zjištění počtu kanálů
if channel==2 x=(in(:,1)/2+in(:,2)/2);	%převedení stereo signálu na mono
else x=in;
end;

dt = 1/fs;	%zjištění periody
I0 = round(0.1/dt);	%označení úseku od 0.1s
Iend = round(0.25/dt);	%označení úseku do 0.25s
in = x(I0:Iend);
[b0,a0]=butter(2,325/(fs/2));	%vytvoření Butterworhova filtru
xin = abs(in);	%překlopení signálu do kladných hodnot
xin=filter(b0,a0,xin);	%filtrace signálu
xin = xin-mean(xin);	%odečtení střední hodnoty
x2=zeros(length(xin),1); %vytvoření nulového vektoru
x2(1:length(in)-1)=xin(2:length(in));	%dosazení posunutého signálu do nulového vektoru
zc=length(find((xin>0 & x2<0) | (xin<0 & x2>0)));	%hledání nul
f=0.5*fs*zc/length(in);	%vypočtění základní frekvence
end
