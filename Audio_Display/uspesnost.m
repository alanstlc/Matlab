function [percent] = uspesnost( vysledky )

%-------------------------------------------------------------------------
%vystup=uspesnost(vysledky)
%Funkce vrac� procentu�ln� �sp�nost lokalizace
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

%zji�t�n� po�tu ��dk� a sloupc�
[radky,sloupce]=size(vysledky);
for i=1:1:radky
%vypo�ten� �sp�nosti, rozd�len� elevace a azimutu 50 na 50
uspesnost(i)=(1-abs(vysledky(i,2)-vysledky(i,3))/90)+(1-abs(vysledky(i,4)-vysledky(i,5))/90);
end;
%p�eveden� na procenta a zaokrouhlen�
percent=round(10*sum(uspesnost)/radky/2*100)/10;
end