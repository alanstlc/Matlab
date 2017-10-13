function [percent] = uspesnost( vysledky )

%-------------------------------------------------------------------------
%vystup=uspesnost(vysledky)
%Funkce vrací procentuální úspìšnost lokalizace
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

%zjištìní poètu øádkù a sloupcù
[radky,sloupce]=size(vysledky);
for i=1:1:radky
%vypoètení úspìšnosti, rozdìlení elevace a azimutu 50 na 50
uspesnost(i)=(1-abs(vysledky(i,2)-vysledky(i,3))/90)+(1-abs(vysledky(i,4)-vysledky(i,5))/90);
end;
%pøevedení na procenta a zaokrouhlení
percent=round(10*sum(uspesnost)/radky/2*100)/10;
end