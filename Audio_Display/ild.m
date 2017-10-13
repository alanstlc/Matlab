function [out] = ILD(uhel,in)

%-------------------------------------------------------------------------
%vystupni signal=ild(uhel, vstupni signal)
%Funkce vrac� virtu�ln� polohovan� stereo sign�l pomoc� panoramy
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------

[length,channel]=size(in);

if channel==2 in=(in(:,1)/2+in(:,1)/2); end;	%upraven� stereo sign�lu na mono
peak=max(max(in));	%zji�t�n� �pi�kov� hodnoty p�vodn�ho sign�lu

%p�edpoklad, �e gL+gR=2 a v 90 se gL=0
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

gain=max(max(out));	%zji�t�n� �pi�kov� hodnoty v�stupn�ho
out=out./gain.*peak;	%ochrana p�ed p�ebuzen�m v�stupn�ho sign�lu

