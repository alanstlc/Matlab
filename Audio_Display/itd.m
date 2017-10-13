function [ out ] = itd( angle, fs, in )


%-------------------------------------------------------------------------
%vystupni signal=itd(uhel, vzorkovací frekvence, vstupni signal)
%Funkce vrací virtuálnì polohovaný stereo signál pomocí ITD
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------


[delka,channel]=size(in);	%zjištìní délky a poètu kanálù vstupního signálu

if channel==1 in(:,2)=(in(:,1)); end;	%pøevedení mono signálu na stereo
usi=0.215;	%vzdálenost uší
polomer=1;	%vzdálenost zvukového zdroje od hlavy
c=334;		%rychlost zvuku
peak=max(max(in));	%zjištìní špièky vstipního signálu

angle_stred_leve=pi()/2+pi()/180*angle;	%zjištìní vlastního úhlu pro levé ucho
angle_stred_prave=pi()/2-pi()/180*angle;	%zjištìní vlastního úhlu pro pravé ucho
                    
vzdalenost_leve=sqrt(polomer^2+(usi/2)^2-2*polomer*usi/2*cos(angle_stred_leve));	%vzdálenost zvukového zdroje od levého ucha
vzdalenost_prave=sqrt(polomer^2+(usi/2)^2-2*polomer*usi/2*cos(angle_stred_prave));	%vzdálenost zvukového zdroje od pravého ucha
                                                 
t_leve=vzdalenost_leve/c;	%èas dopadu pro levé ucho
t_prave=vzdalenost_prave/c;	%èas dopadu pro pravé ucho
                        
rozdil=abs(t_leve-t_prave);	%èasový rozdíl mezi pravým a levým uchem
rozdil_vzorky=rozdil*fs;	%rozdíl ve vzorcích mezi pravým a levým uchem
                        
k=round(abs(rozdil_vzorky));	%zaokrouhlení na celé kladné vzorky
                        
                        
if angle<=0			%posunutí jednoho ze signálù o k vzorkù
out(1:delka,1)=in(:,1);
out(1+k:delka+k,2)=in(:,2);
else
out(1+k:delka+k,1)=in(:,1);
out(1:delka,2)=in(:,2);
end;
gain=max(max(out));		%zjištìní pøebuzení výstupu
out=out./gain.*peak;		%vyrovnání pøebuzení výstupu
                                           
             
