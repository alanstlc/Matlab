%Alan Stolc
%Semestral project
%UPV ETSIT
%Class of GPS 2011/2012

clc;
close all;
clear all;

%%%%%%%%%%%%%%
%input data
%user position
%%%%%%%%%%%%%%

u_elevation=90;
u_angle=0;
landing_height=10000;   %Earth radius set to 6378
t_unit=12*15;           %12 hours times 15 minutes

%%%%%%%%%%%%%%


r=20000+6378;           %height of satellites
c=3e8;                  %speed of light


%block of variables

global i;

global vis;
global result_vector;
global distance;

global all_vis;
global all_result_vector;
global all_distance;


landing_speed=1;
distance(1)=0;
all_distance(1)=0;
visible=zeros(t_unit,1);

%loop function

for i=1:1:t_unit

%user position    

[u_x,u_y,u_z]=xyz(90,u_elevation,u_angle);  %user position to xyz

actual_height=landing_height+landing_speed*(i-1);
landing_speed=-(landing_height-6378)/t_unit;

u_x=u_x/26378*actual_height;
u_y=u_y/26378*actual_height;
u_z=u_z/26378*actual_height;

vector_user = [u_x u_y u_z];    

height(i)=norm(vector_user);

time_shift=360/t_unit-i*360/t_unit;

%another block of variables for usage os visible satellites functions

clear global measured_pseudo_distance estimated_pseudo_distance pseudo_distance_residual x_estimated_pseudo_distance x_pseudo_distance_residual GMO;
global measured_pseudo_distance estimated_pseudo_distance pseudo_distance_residual x_estimated_pseudo_distance x_pseudo_distance_residual GMO;
vis=0;

%block of variables for usage of all satellites functions

clear global all_measured_pseudo_distance all_estimated_pseudo_distance all_pseudo_distance_residual all_x_estimated_pseudo_distance all_x_pseudo_distance_residual all_GMO;
global all_measured_pseudo_distance all_estimated_pseudo_distance all_pseudo_distance_residual all_x_estimated_pseudo_distance all_x_pseudo_distance_residual all_GMO;
all_vis=0;

%input data / recount on xyz

[sat01_x,sat01_y,sat01_z]=xyz(time_shift+0,55,0);
[sat02_x,sat02_y,sat02_z]=xyz(time_shift+90,55,0);
[sat03_x,sat03_y,sat03_z]=xyz(time_shift+180,55,0);
[sat04_x,sat04_y,sat04_z]=xyz(time_shift+270,55,0);

sat01=[sat01_x,sat01_y,sat01_z];
sat02=[sat02_x,sat02_y,sat02_z];
sat03=[sat03_x,sat03_y,sat03_z];
sat04=[sat04_x,sat04_y,sat04_z];


[sat11_x,sat11_y,sat11_z]=xyz(time_shift+15,55,30);
[sat12_x,sat12_y,sat12_z]=xyz(time_shift+105,55,30);
[sat13_x,sat13_y,sat13_z]=xyz(time_shift+195,55,30);
[sat14_x,sat14_y,sat14_z]=xyz(time_shift+285,55,30);

sat11=[sat11_x,sat11_y,sat11_z];
sat12=[sat12_x,sat12_y,sat12_z];
sat13=[sat13_x,sat13_y,sat13_z];
sat14=[sat14_x,sat14_y,sat14_z];


[sat21_x,sat21_y,sat21_z]=xyz(time_shift+30,55,60);
[sat22_x,sat22_y,sat22_z]=xyz(time_shift+120,55,60);
[sat23_x,sat23_y,sat23_z]=xyz(time_shift+210,55,60);
[sat24_x,sat24_y,sat24_z]=xyz(time_shift+300,55,60);

sat21=[sat21_x,sat21_y,sat21_z];
sat22=[sat22_x,sat22_y,sat22_z];
sat23=[sat23_x,sat23_y,sat23_z];
sat24=[sat24_x,sat24_y,sat24_z];


[sat31_x,sat31_y,sat31_z]=xyz(time_shift+45,55,90);
[sat32_x,sat32_y,sat32_z]=xyz(time_shift+135,55,90);
[sat33_x,sat33_y,sat33_z]=xyz(time_shift+225,55,90);
[sat34_x,sat34_y,sat34_z]=xyz(time_shift+315,55,90);

sat31=[sat31_x,sat31_y,sat31_z];
sat32=[sat32_x,sat32_y,sat32_z];
sat33=[sat33_x,sat33_y,sat33_z];
sat34=[sat34_x,sat34_y,sat34_z];


[sat41_x,sat41_y,sat41_z]=xyz(time_shift+60,55,120);
[sat42_x,sat42_y,sat42_z]=xyz(time_shift+150,55,120);
[sat43_x,sat43_y,sat43_z]=xyz(time_shift+240,55,120);
[sat44_x,sat44_y,sat44_z]=xyz(time_shift+330,55,120);

sat41=[sat41_x,sat41_y,sat41_z];
sat42=[sat42_x,sat42_y,sat42_z];
sat43=[sat43_x,sat43_y,sat43_z];
sat44=[sat44_x,sat44_y,sat44_z];


[sat51_x,sat51_y,sat51_z]=xyz(time_shift+75,55,150);
[sat52_x,sat52_y,sat52_z]=xyz(time_shift+165,55,150);
[sat53_x,sat53_y,sat53_z]=xyz(time_shift+240,55,150);
[sat54_x,sat54_y,sat54_z]=xyz(time_shift+345,55,150);

sat51=[sat51_x,sat51_y,sat51_z];
sat52=[sat52_x,sat52_y,sat52_z];
sat53=[sat53_x,sat53_y,sat53_z];
sat54=[sat54_x,sat54_y,sat54_z];

%functions of figures

hold off;
figure(2);subplot(4,1,1),plot(visible);title('Visible satellites');xlim([0 t_unit]);
hold off;
figure(2);subplot(4,1,2),plot(distance);title('Distance of pseudoposition from measured - Visible satellites');xlim([0 t_unit]);ylabel('Distance (km)');
hold off;
figure(2);subplot(4,1,3),plot(all_distance);title('Distance of pseudoposition from measured - All satellites');xlim([0 t_unit]);ylabel('Distance (km)');
hold off;
figure(2);subplot(4,1,4),plot(height);title('Height of landing point');xlim([0 t_unit]);ylabel('Height (km)');
hold off;

%figure of Earth

figure(1);plot3(u_x,u_y,u_z,'o','MarkerFaceColor','k');title('GPS - Earth model');
axis([-r r -r r -r r])
grid off;
hold on;
[x,y,z] = sphere;
axis([-r r -r r -r r])
grid off;
hold on;
mesh(6378*x,6378*y,6378*z);
axis([-r r -r r -r r])
grid off;
hold on;

%figures of satellites

plot_sat(sat01,vector_user);
plot_sat(sat02,vector_user);
plot_sat(sat03,vector_user);
plot_sat(sat04,vector_user);

plot_sat(sat11,vector_user);
plot_sat(sat12,vector_user);
plot_sat(sat13,vector_user);
plot_sat(sat14,vector_user);

plot_sat(sat21,vector_user);
plot_sat(sat22,vector_user);
plot_sat(sat23,vector_user);
plot_sat(sat24,vector_user);

plot_sat(sat31,vector_user);
plot_sat(sat32,vector_user);
plot_sat(sat33,vector_user);
plot_sat(sat34,vector_user);

plot_sat(sat41,vector_user);
plot_sat(sat42,vector_user);
plot_sat(sat43,vector_user);
plot_sat(sat44,vector_user);

plot_sat(sat51,vector_user);
plot_sat(sat52,vector_user);
plot_sat(sat53,vector_user);
plot_sat(sat54,vector_user);

%algorithm for delta distance using visible satellites

for k=1:length(measured_pseudo_distance)
x_estimated_pseudo_distance(1:100,k)=normrnd(estimated_pseudo_distance(k),1:100);
end;

for k=1:100
pseudo_distance_residual(k,:)=x_estimated_pseudo_distance(k,:)-measured_pseudo_distance;
end;

for k=1:length(measured_pseudo_distance)
x_pseudo_distance_residual(1,k)=mean(pseudo_distance_residual(:,k));
end;

GMO_inv=((GMO.' * GMO) \ GMO.');
delta_result=x_pseudo_distance_residual*GMO_inv';
delta_result(4) = delta_result(4)/c;
result_vector = result_vector - delta_result;

visible(i)=vis;

%algorithm for delta distance using all satellites

for k=1:length(all_measured_pseudo_distance)
all_x_estimated_pseudo_distance(1:100,k)=normrnd(all_estimated_pseudo_distance(k),1:100);
end;

for k=1:100
all_pseudo_distance_residual(k,:)=all_x_estimated_pseudo_distance(k,:)-all_measured_pseudo_distance;
end;

for k=1:length(all_measured_pseudo_distance)
all_x_pseudo_distance_residual(1,k)=mean(all_pseudo_distance_residual(:,k));
end;

all_GMO_inv=((all_GMO.' * all_GMO) \ all_GMO.');
all_delta_result=all_x_pseudo_distance_residual*all_GMO_inv';
all_delta_result(4) = all_delta_result(4)/c;
all_result_vector = all_result_vector - all_delta_result;


end;