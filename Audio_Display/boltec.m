function [out] = boltec(azimut,elevace,in,Fs)

%Ondøej Glaser, 2010, Diplomová práce

x = in;                         % vstup
az = azimut;                    % poloha
el = elevace;
A = [1 5 5 5 5];                % tabulka 3.1
B = [2 4 7 11 13];
D = [1 0.5 0.5 0.5 0.5];
R = [0.5 -1 0.5 -0.25 0.25];
y = zeros(length(A),length(x)); % pomocne
%-------------------------------------------------------------------------%
% zpozdovaci linky
%-------------------------------------------------------------------------%
for k = 1:length(A)
tau(k) = A(k)*cos((az*pi/180)/2)*sin(D(k)*((90-el)*pi/180))+B(k); % r.(3.7)
M(k) = tau(k);                  
frac(k) = M(k)-floor(M(k));     % zbytek
M(k) = floor(M(k));             % nejblizsi nizsi cele cislo                       
            for i = (M(k)+1):(length(x)-1)  % zpozdene signaly -> matice
                y(k,i)=R(k)*(x(i-(M(k)-1))*frac(k)+x(i-M(k))*(1-frac(k)));
            end
end
y = sum(y);                     % soucet radku matice
y = y' + x;                     % pricteni puvodniho signalu
out = y/3;                      % urceno experimentalne - proti prebuzeni
end


