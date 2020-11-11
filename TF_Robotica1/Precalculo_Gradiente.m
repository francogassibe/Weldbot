clc
close all
%%
D1=0.6;%longitud eslabon 1
D2=0.1;%ancho de la articulacion 2
D4=0.3;%longitud del eslabon 4
D5=0;%ancho de la articulacion 4 %ojo!!%
A5=0.4; %longitud del eslabon 5
Lmin=0.4; %longitud minima del telescopico
Lmax=2;
restheta1=pi/6;
maxerror=0.0001; 

syms q1 q2 q3 q4 q5
q=[q1 q2 q3 q4 q5];
DH=[q(1) D1 pi/2 0
            q(2) D2 pi/2 0
            0 q(3) 0 0
            q(4) D4 -pi/2 0
            q(5) D5 0 A5];
syms E(q1,q2,q3,q4,q5)
syms q1 q2 q3 q4 q5
syms pdx pdy pdz odx ody odz 
[T,B]=CD(DH,Lmax,Lmin,restheta1);
E=(pdx - T(1,4))^2 + (pdy - T(2,4))^2 + (pdz - T(3,4))^2 + (odx - T(1,1))^2 + (ody - T(2,1))^2 + (odz - T(3,1))^2

%Gradiente
DEq1 = diff(E,q1)
DEq2 = diff(E,q2)
DEq3 = diff(E,q3)
DEq4 = diff(E,q4)
DEq5 = diff(E,q5)