%function for figuring satellites

function []=plot_sat(sat,user)

%global variables

global i;
global vis;
global GMO;
global measured_pseudo_distance;
global estimated_pseudo_distance;
global result_vector;
global distance;

global all_vis;
global all_GMO;
global all_measured_pseudo_distance;
global all_estimated_pseudo_distance;
global all_result_vector;
global all_distance;

r=20000+6378;
c=3e8;
dist=sat-user;

%function for decision of visiblity (90°)

CosTheta = dot(sat,user)/(norm(sat)*norm(user));

%visible satellites

if acos(CosTheta)<=acos(6.378/26.378); 
    plot3(sat(1),sat(2),sat(3),'o','MarkerFaceColor','g');
    axis([-r r -r r -r r]);
    hold on;
    
    vis=vis+1;
    
   %setting of bias of user, pseudobias of user and pseudoposition of user 
    user_aprox=user+100;
    bias_user=10e-9;
    bias_user_aprox=50e-9;
     
    if 1<i user_aprox=result_vector(1:3); end;
    if 1<i bias_user_aprox=result_vector(4); end;
    
     measured_pseudo_distance(vis)=norm(dist)+bias_user*c;
     result_vector = [user_aprox(1) user_aprox(2) user_aprox(3) bias_user_aprox];
     estimated_pseudo_distance(vis)=norm(sat-user_aprox)+bias_user_aprox*c;     
     distance(i)=norm(user-user_aprox);  
     
     I=(sat-user_aprox)/norm(sat-user_aprox);
     GMO(vis,1)=-I(1);
     GMO(vis,2)=-I(2);
     GMO(vis,3)=-I(3);
     GMO(vis,4)=1;  
     
%invisible satellites
     
else
    plot3(sat(1),sat(2),sat(3),'o');
    axis([-r r -r r -r r])
    hold on;
end;   

%same functions like above for all satellites

    all_vis=all_vis+1;
    all_user_aprox=user+100;
    bias_user=10e-9;
    all_bias_user_aprox=50e-9;
    
    if 1<i all_user_aprox=all_result_vector(1:3); end;
    if 1<i all_bias_user_aprox=all_result_vector(4); end;
    
     all_measured_pseudo_distance(all_vis)=norm(dist)+bias_user*c;  
     all_result_vector = [all_user_aprox(1) all_user_aprox(2) all_user_aprox(3) all_bias_user_aprox];
     all_estimated_pseudo_distance(all_vis)=norm(sat-all_user_aprox)+all_bias_user_aprox*c;     
     all_distance(i)=norm(user-all_user_aprox); 
          
     all_I=(sat-all_user_aprox)/norm(sat-all_user_aprox);     
     all_GMO(all_vis,1)=-all_I(1);
     all_GMO(all_vis,2)=-all_I(2);
     all_GMO(all_vis,3)=-all_I(3);
     all_GMO(all_vis,4)=1;
     

     
     