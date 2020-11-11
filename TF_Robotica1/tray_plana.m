clear
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

alfa=pi/4;
maxerror=0.0001;

paso=0.01;
x=0.5:paso:1.5;
% y=-0.7*x.^2+2*x;
y=0.3*sin(15*x);
% y=exp(-2.*x).*(1*sin(15.*x));
z(1:length(x))=D1/2;
tray=[x',y',z'];
for i=1:length(x)-1
    beta=atan((y(i+1)-y(i))/(x(i+1)-x(i)));
    orient(i,1:3)=[cos(beta);sin(beta);-sin(alfa)];
end
orient(length(x),1:3)=orient(length(x)-1,1:3);

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
q0=[0 pi/2 2 0 pi];
for j=1:length(x)
    j
    [CIpuntos(j,:),bool]=CI_optimizado(tray(j,1:3),orient(j,1:3),q0,DH,Lmax,Lmin,restheta1,maxerror);
    q0=CIpuntos(j,:);
    
    J=Robot.jacob0(q0);
    A=J'*J;
    
    Jacob_tray(j)=det(A);
end
num_discret=8;
for k=1:length(x)-1
    Qfinal((k-1)*num_discret+1:num_discret*k,:)=jtraj(CIpuntos(k,:),CIpuntos(k+1,:),num_discret);
    
end


L(1)= Link([0 D1 0 pi/2 0]);
L(2)= Link([0 D2 0 pi/2 0]);
L(3)= Link([0 0 0 0 1]); %consultar ese 1 que hace ahi
L(4)= Link([0 D4 0 -pi/2 0]);
L(5)=Link([0 D5 A5 0 0]);
Robot = SerialLink(L);
Robot.name = 'VEVO' ;

close all
Robot.plot(CIpuntos,...
    'workspace',[0,2,-2,2,-1,2],...
    'scale',0.7,'trail','-','view','x');

for i=1:size(CIpuntos,1)-1
    dq(i,:)=CIpuntos(i+1,:)-CIpuntos(i,:);
end

dq(size(CIpuntos,1),:)=dq(size(CIpuntos,1)-1,:);

figure(1)
plot(dq(:,1))
hold on 
plot(dq(:,2))
plot(dq(:,3))
plot(dq(:,4))
plot(dq(:,5))
hold off


for i=1:size(Qfinal,1)-1
    dQfinal(i,:)=Qfinal(i+1,:)-Qfinal(i,:);
end

dQfinal(size(Qfinal,1),:)=dQfinal(size(Qfinal,1)-1,:);
% plot(Jacob_tray)
% figure(2)
% plot(dQfinal(:,1))
% hold on 
% plot(dQfinal(:,2))
% plot(dQfinal(:,3))
% plot(dQfinal(:,4))
% plot(dQfinal(:,5))