clc
close all
%dimenciones
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
        
        
%Posicion deseada
pdx=1;
pdy=1;
pdz=-1;
pd=[pdx pdy pdz]

%Orientacion deseada
nxd = 0;
nyd = 0;
nzd = 1;
od=[nxd nyd nzd];


q0=[pi/6 pi/4 Lmax pi/3 pi/3];
        
     
[var_articulares,bool]=CI_optimizado(pd,od,q0,DH,Lmax,Lmin,restheta1,maxerror)


%%
%verificacion
DHver=[var_articulares(1) D1 pi/2 0
            var_articulares(2) D2 pi/2 0
            0 var_articulares(3) 0 0
            var_articulares(4) D4 -pi/2 0
            var_articulares(5) D5 0 A5];
        
[verificacion1,bool2]=CD(DHver,Lmax,Lmin,restheta1)
% %%
%verificacion 2

L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]); 
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
% 
% 
% 
Robot = SerialLink(L);
verif2= Robot.fkine(var_articulares)





%%
%comparacion peter core
Tprueba=[0 cos(pi/4) -sin(pi/4) 1
         0 sin(pi/4) cos(pi/4) 1
         1 0 0 -1
         0 0 0 1];
     
ci_funcionpetercore=Robot.ikine(Tprueba,[0 pi/2 2 0 0],[1 1 1 0 1 1])
verif_petercore=Robot.fkine(ci_funcionpetercore)


