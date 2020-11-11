clc
close all

D1=0.6;%longitud eslabon 1
D2=0.1;%ancho de la articulacion 2
D4=0.3;%longitud del eslabon 4
D5=0;%ancho de la articulacion 4 %ojo!!%
A5=0.4; %longitud del eslabon 5
Lmin=0.4; %longitud minima del telescopico
Lmax=2;
restheta1=pi/6;


syms q1 q2 q3 q4 q5
q=[q1 q2 q3 q4 q5];
q=[pi/4 pi 0.8 pi/4 -pi/2];

DH=[q(1) D1 pi/2 0
            q(2) D2 pi/2 0
            0 q(3) 0 0
            q(4) D4 -pi/2 0
            q(5) D5 0 A5];
        
        
[T1,verif_spacework]=CD(DH,Lmax,Lmin,restheta1)


% %%CD con funciones libreria

L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]);
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
% 
% 
% 
Robot = SerialLink(L);
Robot.name = 'VEVO' ;
Robot.offset = [0,0,0,0,0]; %%si le pones no te queda igual la matriz T
T = Robot.fkine(q)
Robot.plot(q,...
    'workspace',[-2,2,-2,2,-3,3],...
    'scale',1);

Robot.qlim(3,:)=[Lmin Lmax];%nX2, modificar la fila de la variable prismatica pape
Robot.qlim(2,:)=[pi/6 (2*pi-pi/6)];
Robot.qlim(5,:)=[pi/6 (2*pi-pi/6)];
Robot.teach
%%
Robot.teach('callback', @(r,q) r.vellipse(q))


