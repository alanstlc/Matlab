function [out] = shadow(theta,fs,in)

%Ondøej Glaser, 2010, Diplomová práce

usi = 0.215;                              % polomer hlavy
theta = theta + 90;                     % azimut
theta0 = 150;
alfa_min = 0.05;         
c = 334;                                % rychlost zvuku
peak=max(max(in));

w0 = c/usi;                              % rovnice (3.4)
alfa = 1+alfa_min/2+(1- alfa_min/2)* cos(theta/ theta0* pi) ;	
b0 = (alfa+w0/fs)/(1+w0/fs);            % rov. (5.5) - koeficienty filtru
b1 = (-alfa+w0/fs)/(1+w0/fs);
a1 = -(1-w0/fs)/(1+w0/fs);

out = filter([b0,b1],[1,a1],in); % filtrace hlavou - ILD 
end
