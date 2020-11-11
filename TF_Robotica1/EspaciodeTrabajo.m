clc
clear
close all
D1=0.6;%longitud eslabon 1
D2=0.1;%ancho de la articulacion 2
D4=0.3;%longitud del eslabon 4
D5=0;%ancho de la articulacion 4 %ojo!!%
A5=0.4; %longitud del eslabon 5
Lmin=0.4; %longitud minima del telescopico
Lmax=2;
restheta1=pi/6;






%5to tramo
q4=pi/6:pi/60:pi;



j=1;
%1er tramo
q2=pi:-pi/60:(pi/6);
for i=1:length(q2)
    q(i,:)=[0 q2(i) Lmax 0 -pi/2];
    j=j+1;
end

%2 tramo
q5=-pi/2:-pi/20:-pi;
for i=1:length(q5)
    q(j,:)=[0 pi/6 Lmax 0 q5(i)];
    j=j+1;
end

%3er tramo 
q3=Lmax:-0.1:Lmin;
for i=1:length(q3)
    q(j,:)=[0 pi/6 q3(i) 0 -pi];
    j=j+1;
end

% %4to tramo
q6=-pi:-pi/90:-pi-pi/6;
for i=1:length(q6)
    q(j,:)=[0 pi/6 Lmin 0 q6(i)];
    j=j+1;
end

%5to tramo
q4=pi/6:pi/60:pi;
for i=1:length(q4)
    q(j,:)=[0 q4(i) Lmin 0 -pi-pi/6];
    j=j+1;
end



q;
size(q);


%%



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
Robot.plot(q,...
    'workspace',[-3,3,-3,3,-3,5],...
    'scale',0.3,'trail','-','view','x');

