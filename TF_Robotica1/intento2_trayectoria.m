clear
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
alfa=pi/4;
maxerror=0.0001;


%generar un circulo
Cx=Lmin+(Lmax-Lmin)/2;
Cz=D1;
r=0.21;
paso=pi/70;
theta=0:paso:pi;
x=Cx+r*cos(theta);
z=Cz+r*sin(theta);
for i=1:length(x) 
    orient(i,1:3)=[-cos(theta(i)+alfa) 0 -(sin(theta(i)+alfa))];
end 
y=zeros([1,length(x)]);
tray=[x',y',z'];

%%
syms q1 q2 q3 q4 q5
q=[q1 q2 q3 q4 q5];
DH=[q(1) D1 pi/2 0
            q(2) D2 pi/2 0
            0 q(3) 0 0
            q(4) D4 -pi/2 0
            q(5) D5 0 A5];

        
        
L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]);
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
% 
% 
% 
Robot = SerialLink(L);
% 
% 

% %CI de los puntos
size(tray);
size(orient);
q0=[0 pi/2 2 0 pi];

for j=1:length(x)
    j
    [CIpuntos(j,:),bool]=CI_optimizado(tray(j,1:3),orient(j,1:3),q0,DH,Lmax,Lmin,restheta1,maxerror);
    q0=CIpuntos(j,:);
    
    J=Robot.jacob0(q0);
    A=J'*J;
    
    Jacob_tray(j)=det(A);
end
CIpuntos;

% Qfinal;

%%
gama=alfa+pi:-0.05:-alfa+pi;
for i=1:length(gama)
  
    orient2(i,1:3)=[-cos(gama(i)) 0 -(sin(gama(i)))];
    tray2(i,1:3)=tray(length(tray),1:3);
   
end 


for j=1:length(gama)
    j
    [CIpuntos2(j,:),bool]=CI_optimizado(tray2(j,1:3),orient2(j,1:3),q0,DH,Lmax,Lmin,restheta1,maxerror);
    q0=CIpuntos2(j,:);
    
    J=Robot.jacob0(q0);
    A=J'*J;
    
    Jacob_tray2(j)=det(A);
end
%%
theta=pi:paso:2*pi;
x=Cx+r*cos(theta);
z=Cz+r*sin(theta);
alfa=-alfa;
for i=1:length(x)
  
    orient3(i,1:3)=[-cos(theta(i)+alfa) 0 -(sin(theta(i)+alfa))];
   
end 
y=zeros([1,length(x)]);
tray3=[x',y',z'];

for j=1:length(x)
    j
    [CIpuntos3(j,:),bool]=CI_optimizado(tray3(j,1:3),orient3(j,1:3),q0,DH,Lmax,Lmin,restheta1,maxerror);
    q0=CIpuntos3(j,:);
    J=Robot.jacob0(q0);
    A=J'*J;
    
    Jacob_tray3(j)=det(A);
   
end





%%
num_discret=2;
CItotal=[CIpuntos;CIpuntos2;CIpuntos3];
for k=1:length(x)-1
    Qfinal((k-1)*num_discret+1:num_discret*k,:)=jtraj(CItotal(k,:),CItotal(k+1,:),num_discret);
    
end

%derivada

for i=1:size(CItotal,1)-1
    dq(i,:)=CItotal(i+1,:)-CItotal(i,:);
end

dq(size(CItotal,1),:)=dq(size(CItotal,1)-1,:);

figure(1)
plot(dq(:,1))
hold on 
plot(dq(:,2))
plot(dq(:,3))
plot(dq(:,4))
plot(dq(:,5))
hold off




L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]); %consultar ese 1 que hace ahi
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
Robot = SerialLink(L);
Robot.name = 'VEVO' ;

close all
Robot.plot([CItotal],...
    'workspace',[0,2,-2,2,-1,2],...
    'scale',0.7,'trail','-','view','x');
Jacob_traytotal=[Jacob_tray Jacob_tray2 Jacob_tray3];
plot(Jacob_traytotal)

