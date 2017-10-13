function [ out ] = itd( angle, fs, in )


%-------------------------------------------------------------------------
%vystupni signal=itd(uhel, vzorkovac� frekvence, vstupni signal)
%Funkce vrac� virtu�ln� polohovan� stereo sign�l pomoc� ITD
%Alan �tolc, �VUT FEl, 2013
%-------------------------------------------------------------------------


[delka,channel]=size(in);	%zji�t�n� d�lky a po�tu kan�l� vstupn�ho sign�lu

if channel==1 in(:,2)=(in(:,1)); end;	%p�eveden� mono sign�lu na stereo
usi=0.215;	%vzd�lenost u��
polomer=1;	%vzd�lenost zvukov�ho zdroje od hlavy
c=334;		%rychlost zvuku
peak=max(max(in));	%zji�t�n� �pi�ky vstipn�ho sign�lu

angle_stred_leve=pi()/2+pi()/180*angle;	%zji�t�n� vlastn�ho �hlu pro lev� ucho
angle_stred_prave=pi()/2-pi()/180*angle;	%zji�t�n� vlastn�ho �hlu pro prav� ucho
                    
vzdalenost_leve=sqrt(polomer^2+(usi/2)^2-2*polomer*usi/2*cos(angle_stred_leve));	%vzd�lenost zvukov�ho zdroje od lev�ho ucha
vzdalenost_prave=sqrt(polomer^2+(usi/2)^2-2*polomer*usi/2*cos(angle_stred_prave));	%vzd�lenost zvukov�ho zdroje od prav�ho ucha
                                                 
t_leve=vzdalenost_leve/c;	%�as dopadu pro lev� ucho
t_prave=vzdalenost_prave/c;	%�as dopadu pro prav� ucho
                        
rozdil=abs(t_leve-t_prave);	%�asov� rozd�l mezi prav�m a lev�m uchem
rozdil_vzorky=rozdil*fs;	%rozd�l ve vzorc�ch mezi prav�m a lev�m uchem
                        
k=round(abs(rozdil_vzorky));	%zaokrouhlen� na cel� kladn� vzorky
                        
                        
if angle<=0			%posunut� jednoho ze sign�l� o k vzork�
out(1:delka,1)=in(:,1);
out(1+k:delka+k,2)=in(:,2);
else
out(1+k:delka+k,1)=in(:,1);
out(1:delka,2)=in(:,2);
end;
gain=max(max(out));		%zji�t�n� p�ebuzen� v�stupu
out=out./gain.*peak;		%vyrovn�n� p�ebuzen� v�stupu
                                           
             
