%function for recouning from ECI to EC-EF

function [x,y,z]=xyz(phase,elevation,angle)

phase=phase*pi/180;
elevation=elevation*pi/180;
angle=angle*pi/180;

r=20000+6378;

x=r*(cos(phase)*cos(angle)-sin(phase)*cos(elevation)*sin(angle));
y=r*(sin(phase)*cos(angle)*cos(elevation)+cos(phase)*sin(angle));
z=r*(sin(phase)*sin(elevation));

