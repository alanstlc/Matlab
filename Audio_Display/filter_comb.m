function [y] = filter_comb( x,fs,odraz)

%-------------------------------------------------------------------------
%vystupni signal=filter_comb(vstupni signal,vzorkovac� frekvence, po�et ms zpo�d�n�)
%Funkce p�i��t� ztlumen� a zpo�d�n� sign�l
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

[length,channel]=size(x);
if channel==1 x(:,2)=x(:,1); end;
%vytvo�en� vektoru pro zpo�d�n� sign�l
y=zeros(length+odraz*round(fs/1000),2);
%nahr�n� p�vodn�ho sign�lu do nov�ho vektoru
y(1:length,1)=x(:,1);
y(1:length,2)=x(:,2);
%p�i�ten� zpo�d�n�ho a ztlumen�ho sign�lu k sin�lu p�vodn�mu
if odraz>0
y(odraz*round(fs/1000)+1:end,1)=0.6*(y(odraz*round(fs/1000)+1:end,1)+x(:,1));
y(odraz*round(fs/1000)+1:end,2)=0.6*(y(odraz*round(fs/1000)+1:end,2)+x(:,2));
end;
end

