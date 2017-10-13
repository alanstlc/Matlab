function [out] = ILD(uhel,in)

%-------------------------------------------------------------------------
%vystupni signal=ild(uhel, vstupni signal)
%Funkce vrací virtuálnì polohovaný stereo signál pomocí panoramy
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

[length,channel]=size(in);

if channel==2 in=(in(:,1)/2+in(:,1)/2); end;	%upravení stereo signálu na mono
peak=max(max(in));	%zjištìní špièkové hodnoty pùvodního signálu

%pøedpoklad, že gL+gR=2 a v 90 se gL=0
if uhel>0
gL=1-uhel/90;
gR=2-gL;
else
gR=1+uhel/90;
gL=2-gR;
end;
if uhel==0 gL=1;gR=1;end;

out(:,1)=in*gL;
out(:,2)=in*gR;

gain=max(max(out));	%zjištìní špièkové hodnoty výstupního
out=out./gain.*peak;	%ochrana pøed pøebuzením výstupního signálu

