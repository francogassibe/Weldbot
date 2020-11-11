clc
close all
%%
D1=0.6;%longitud eslabon 1
D2=0.1;%ancho de la articulacion 2
D4=0.3;%longitud del eslabon 4
D5=0;%ancho de la articulacion 5
A5=0.4; %longitud del eslabon 5
Lmin=0.4; %longitud minima del telescopico
Lmax=2;
restheta1=pi/6;
%%
%%Cinematica directa propia


 syms q1 q2 q3 q4 q5 
%introducir aqui valores o volverlos simbolicos


q=[pi/4 pi/6 2 pi/3 pi/5];
%q=[q1 q2 q3 q4 q5];




Parametros=[q(1) D1 pi/2 0 0
            q(2) D2 pi/2 0 0
            0 q(3) 0 0 1
            q(4) D4 -pi/2 0 0
            q(5) D5 0 A5 0];
T=eye(4);
for i=1:5
    
    transf=trotz(Parametros(i,1))*transl(0,0,Parametros(i,2))*trotx(Parametros(i,3))*transl(Parametros(i,4),0,0);
    T=T*transf;
end
T
%%Verificacion del espacio de trabajo

%Se consideró como espacio de trabajo a 
%los puntos dentro del alcance con
%la capacidad de
%orientacion del efector final
bool=1;
r=norm(T(1:3,4)-[0 0 D1]); 
Rmax=(Lmax-A5);
Rmin=(Lmin+A5);
if ((Rmin>r>Rmax))
    bool=0;
    s='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
    if (r>Rmax)
        p=(T(1:3,4)-[0 0 D1])*Rmax/r + [0 0 D1]
    end
    if (r<Rmin)
       p=(T(1:3,4)-[0 0 D1])*Rmin/r + [0 0 D1]
    end
    
end
if((sqrt(T(1,4)^2+T(2,4)^2)<tan(restheta1)*(D1-T(3,4))))
    bool=0;
    s='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
    rc=D1-T(3,4)+tan(restheta1)*norm(T(1:2,4));
    zc=D1-tan(pi/2 - restheta1)*rc;
    xc=rc*T(1,4)/norm(T(1:2,4));
    yc=rc*T(2,4)/norm(T(1:2,4));
    p=[xc yc zc]
    
    
end
bool
%%
%Cinematica inversa

%Posicion deseada
pxd = 1;
pyd = 1;
pzd = -1;

%Orientacion deseada
nxd = pi/4;
nyd = pi/4;
nzd = 0;

%Funcion Error
syms E(q1,q2,q3,q4,q5) 
E=((pxd - T(1,4))^2 + (pyd - T(2,4))^2 + (pzd - T(3,4))^2 + (nxd - T(1,1))^2 + (nyd - T(2,1))^2 + (nzd - T(3,1))^2);

%Gradiente
DEq1 = diff(E,q1);
DEq2 = diff(E,q2);
DEq3 = diff(E,q3);
DEq4 = diff(E,q4);
DEq5 = diff(E,q5);

%Vector semilla
q1=pi/4;
q2=pi/4;
q3=2;
q4=0;
q5=0;

%Escalamiento de paso
alfa=0.1;



%Actualizacion iterativa
for i=0:140
    G1=eval(subs(DEq1));
    G2=eval(subs(DEq2));
    G3=eval(subs(DEq3));
    G4=eval(subs(DEq4));
    G5=eval(subs(DEq5));
    q1 = q1 - alfa*G1;
    q2 = q2 - alfa*G2;
    q3 = q3 - alfa*G3;
    q4 = q4 - alfa*G4;
    q5 = q5 - alfa*G5;
%     if eval(subs(E))<= 0.01
%         break;
%     end
end

q=[q1,q2,q3,q4,q5];

% q1=pi/4;
% q2=pi/6;
% q3=2;
% q4=pi/3;
% q5=pi/5;
% T



%Matrices individuales de cada transformacion     
%  T1=trotz(Parametros(1,1))*transl(0,0,Parametros(1,2))*trotx(Parametros(1,3))*transl(Parametros(1,4),0,0);
%  T2=trotz(Parametros(2,1))*transl(0,0,Parametros(2,2))*trotx(Parametros(2,3))*transl(Parametros(2,4),0,0);
%  T3=trotz(Parametros(3,1))*transl(0,0,Parametros(3,2))*trotx(Parametros(3,3))*transl(Parametros(3,4),0,0);
%  T4=trotz(Parametros(4,1))*transl(0,0,Parametros(4,2))*trotx(Parametros(4,3))*transl(Parametros(4,4),0,0);
%  T5=trotz(Parametros(5,1))*transl(0,0,Parametros(5,2))*trotx(Parametros(5,3))*transl(Parametros(5,4),0,0);



% %%CD con funciones libreria

q=[pi/4 pi/6 2 pi/3 pi/5];
L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]); %consultar ese 1 que hace ahi
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
% 
% 
% 
Robot = SerialLink(L);
Robot.name = 'VEVO' ;
Robot.offset = [0 , 0, 0, 0, 0];
T = Robot.fkine(q)
Robot.plot(q,...
    'workspace',[-2,2,-2,2,-2,3],...
    'scale',1);
% 
Robot.qlim(3,:)=[Lmin Lmax];%nX2, modificar la fila de la variable prismatica pape
%  Robot.qlim(2,:)=[pi/6 (2*pi-pi/6)];
%  Robot.qlim(5,:)=[pi/6 (2*pi-pi/6)];
  Robot.teach
% T = simplify(Robot.fkine(q))
% p0=T*[0;0;0;1];
% 
% 
