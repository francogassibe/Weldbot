%%dimencionamiento y diametro maximo
clc
clear
close all
D1=0.6;%longitud eslabon 1
D2=0.1;%ancho de la articulacion 2
D4=0.3;%longitud del eslabon 4
D5=0;%ancho de la articulacion 4 %ojo!!%
A5=0.4; %longitud del eslabon 5

syms r z0 x0 Dx Dz m beta Mx Mz longtelesc Le1 cx cz alfa L4
%parametros elejibles Le1, cx cz alfa L4
Lmin=0.4; %longitud minima del telescopico
Lmax=2;
cx=Lmin+(Lmax-Lmin)/2;
Le1=D1;
cz=Le1;
alfa=pi/2;
L4=A5;


beta=atan((cz-Le1)/cx);
Mx=((sqrt(cx^2+cz^2))+r)*cos(beta);
Mz=Le1+(sqrt(cx^2+cz^2)+r)*sin(beta);
Dx=Mx+L4*cos(alfa+beta);
Dz=Mz+L4*sin(alfa+beta);
m=-Dx/Dz;
% 
z0=simplify(Le1+(Dz/Dx)*((cz-m*cx-Le1)/(Dz/Dx-m)));
x0=simplify(((cz-m*cx-Le1)/(Dz/Dx-m)));
%  
simplify(solve(simplify(0==r^2-(z0-cz)^2 -(x0-cx)^2),r,'Real',true))
