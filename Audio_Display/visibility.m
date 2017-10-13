function [ ] = visibility( handles, testing )

%-------------------------------------------------------------------------
%visibility(handles,bool)
%Funkce zviditelòující a zneviditelòující nastavovací rozhraní 
%Alan Štolc, ÈVUT FEl, 2013
%-------------------------------------------------------------------------


string ano;
string ne;

if testing==1  ano ='off';  ne ='on';
else ano ='on'; ne ='off';
end;

%zviditelnìní podle vstupního parametru
set(handles.slider1,'Visible',ano);
set(handles.slider2,'Visible',ano);
set(handles.text1,'Visible',ano);
set(handles.text2,'Visible',ano);
set(handles.text3,'Visible',ano);
set(handles.text_azimuth,'Visible',ano);
set(handles.text_elevation,'Visible',ano);
set(handles.text11,'Visible',ano);
set(handles.togglebutton1,'Visible',ano);
set(handles.togglebutton2,'Visible',ano);
set(handles.togglebutton3,'Visible',ano);
set(handles.togglebutton4,'Visible',ano);
set(handles.togglebutton5,'Visible',ano);
set(handles.togglebutton6,'Visible',ano);
set(handles.uipanel1,'Visible',ano);
set(handles.uipanel2,'Visible',ano);
set(handles.uipanel3,'Visible',ano);
set(handles.checkbox2,'Visible',ano);
set(handles.edit1,'Visible',ano);
set(handles.edit2,'Visible',ano);
set(handles.edit3,'Visible',ano);
set(handles.slider6,'Visible',ano);
set(handles.pushbutton3,'Visible',ano);
set(handles.text12,'Visible',ne);
set(handles.edit4,'Visible',ne);
set(handles.axes3,'Visible',ne);
set(handles.axes1,'Visible',ano);
set(handles.axes2,'Visible',ano);
set(handles.checkbox3,'Enable',ano);
set(handles.checkbox4,'Enable',ano);
end

