function [x,y,xz,yz] = move(x,y,x_zpatky,y_zpatky,handles)

%Semestr�ln� projekt A2M32MKS
%Alan �tolc, Alexandr Po�ta
%�VUT FEl 2013
%
%funkce po��taj�c� budouc� polohu z aktu�ln� a minul� polohy
global mapa;
global odboceni;
%nastven� pravd�podobnosti odbo�en� pomoc� posuvn�o slideru
pst=get(handles.slider1,'Value');

%co v�echno se m��e st�t a jak se zachov�
%jde nahoru
if y_zpatky<y
%ulo�en� p�vodn�ch zp�te�n�ch hodnot
xz=x;
yz=y;
    %rovn� ��ry
               if mapa(x+1,y)==0&&mapa(x-1,y)==0
               y=y+1;
    %rohy
               elseif mapa(x+1,y)==0&&mapa(x-1,y)==1&&mapa(x,y+1)==0
               x=x-1; 
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==0&&mapa(x,y+1)==0
               x=x+1; 
    %k�i�ovatka
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==1&&mapa(x,y+1)==1
               zatoci=rand(); 
                  if zatoci>pst
                    y=y+1;
                    odboceni(1)=odboceni(1)+1;
                  else
                    strana=rand(); if strana>0.5 x=x+1; else x=x-1; end;
                    odboceni(2)=odboceni(2)+1;
                  end;     
    %Tcka
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==1&&mapa(x,y+1)==0
                  strana=rand(); if strana>0.5 x=x+1; else x=x-1; end;
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==0&&mapa(x,y+1)==1
                  strana=rand(); if strana<pst x=x+1; odboceni(2)=odboceni(2)+1; 
                  else y=y+1; odboceni(1)=odboceni(1)+1; end;
               elseif mapa(x+1,y)==0&&mapa(x-1,y)==1&&mapa(x,y+1)==1
                  strana=rand(); if strana<pst x=x-1; odboceni(2)=odboceni(2)+1;  
                  else y=y+1; odboceni(1)=odboceni(1)+1; end;
               end;        
                
%jde dolu
elseif y_zpatky>y
xz=x;
yz=y;   
    %rovn� ��ry
               if mapa(x+1,y)==0&&mapa(x-1,y)==0
               y=y-1;
    %rohy
               elseif mapa(x+1,y)==0&&mapa(x-1,y)==1&&mapa(x,y-1)==0
               x=x-1; 
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==0&&mapa(x,y-1)==0
               x=x+1; 
    %k�i�ovatka
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==1&&mapa(x,y-1)==1
               zatoci=rand(); 
                  if zatoci>pst
                    y=y-1; odboceni(1)=odboceni(1)+1; 
                  else
                     odboceni(2)=odboceni(2)+1; 
                     strana=rand(); if strana>0.5 x=x+1; else x=x-1; end;
                  end;     
    %Tcka
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==1&&mapa(x,y-1)==0
                  strana=rand(); if strana>0.5 x=x+1; else x=x-1; end;
               elseif mapa(x+1,y)==1&&mapa(x-1,y)==0&&mapa(x,y-1)==1
                  strana=rand(); if strana<pst x=x+1;  odboceni(2)=odboceni(2)+1; 
                  else y=y-1; odboceni(1)=odboceni(1)+1;  end;
               elseif mapa(x+1,y)==0&&mapa(x-1,y)==1&&mapa(x,y-1)==1
                  strana=rand(); if strana<pst x=x-1;  odboceni(2)=odboceni(2)+1; 
                  else y=y-1; odboceni(1)=odboceni(1)+1;  end;
               end;   
           
%jde doleva
elseif x_zpatky>x
xz=x;
yz=y;   
    %rovn� ��ry
               if mapa(x,y+1)==0&&mapa(x,y-1)==0
               x=x-1;
    %rohy
               elseif mapa(x,y+1)==0&&mapa(x,y-1)==1&&mapa(x-1,y)==0
               y=y-1; 
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==0&&mapa(x-1,y)==0
               y=y+1; 
    %k�i�ovatka
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==1&&mapa(x-1,y)==1
               zatoci=rand(); 
                  if zatoci>pst
                    x=x-1; 
                    odboceni(1)=odboceni(1)+1; 
                  else
                    strana=rand(); if strana>0.5 y=y+1; else y=y-1; end;
                     odboceni(2)=odboceni(2)+1; 
                  end;     
    %Tcka
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==1&&mapa(x-1,y)==0
                  strana=rand(); if strana>0.5 y=y+1; else y=y-1; end;
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==0&&mapa(x-1,y)==1
                  strana=rand(); if strana>pst x=x-1; odboceni(1)=odboceni(1)+1;  
                  else y=y+1; odboceni(2)=odboceni(2)+1; end;
               elseif mapa(x,y+1)==0&&mapa(x,y-1)==1&&mapa(x-1,y)==1
                  strana=rand(); if strana>pst x=x-1; odboceni(1)=odboceni(1)+1;  
                  else y=y-1; odboceni(2)=odboceni(2)+1; end;
               end; 
                
%jde doprava
elseif x_zpatky<x
xz=x;
yz=y;  
    %rovn� ��ry
               if mapa(x,y+1)==0&&mapa(x,y-1)==0
               x=x+1;
    %rohy
               elseif mapa(x,y+1)==0&&mapa(x,y-1)==1&&mapa(x+1,y)==0
               y=y-1; 
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==0&&mapa(x+1,y)==0
               y=y+1; 
    %k�i�ovatka
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==1&&mapa(x+1,y)==1
               zatoci=rand(); 
                  if zatoci>pst
                    x=x+1; 
                    odboceni(1)=odboceni(1)+1; 
                  else
                    strana=rand(); if strana>0.5 y=y+1; else y=y-1; end;
                    odboceni(2)=odboceni(2)+1; 
                  end;     
    %Tcka
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==1&&mapa(x+1,y)==0
                  strana=rand(); if strana>0.5 y=y+1; else y=y-1; end;
               elseif mapa(x,y+1)==1&&mapa(x,y-1)==0&&mapa(x+1,y)==1
                  strana=rand(); if strana>pst x=x+1; odboceni(1)=odboceni(1)+1;  
                  else y=y+1; odboceni(2)=odboceni(2)+1; end;
               elseif mapa(x,y+1)==0&&mapa(x,y-1)==1&&mapa(x+1,y)==1
                  strana=rand(); if strana>pst x=x+1; odboceni(1)=odboceni(1)+1; 
                  else y=y-1; odboceni(2)=odboceni(2)+1;  end;
               end; 
               
    end;
    

end
