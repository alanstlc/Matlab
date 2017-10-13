function [y] = filter_comb( x,fs,odraz)

%-------------------------------------------------------------------------
%vystupni signal=filter_comb(vstupni signal,vzorkovací frekvence, poèet ms zpodìní)
%Funkce pøièítá ztlumenı a zpodìnı signál
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------

[length,channel]=size(x);
if channel==1 x(:,2)=x(:,1); end;
%vytvoøení vektoru pro zpodìnı signál
y=zeros(length+odraz*round(fs/1000),2);
%nahrání pùvodního signálu do nového vektoru
y(1:length,1)=x(:,1);
y(1:length,2)=x(:,2);
%pøiètení zpodìného a ztlumeného signálu k sinálu pùvodnímu
if odraz>0
y(odraz*round(fs/1000)+1:end,1)=0.6*(y(odraz*round(fs/1000)+1:end,1)+x(:,1));
y(odraz*round(fs/1000)+1:end,2)=0.6*(y(odraz*round(fs/1000)+1:end,2)+x(:,2));
end;
end

