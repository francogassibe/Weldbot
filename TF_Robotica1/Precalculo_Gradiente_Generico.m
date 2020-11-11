function [Grad,E]=Precalculo_Gradiente_Generico(DH,mask)

switch nargin
  case 1
    mask=[];
  
if isempty(mask)
    mask=[1 1 1 1 1 1];
end
if ~isempty(mask) && lenght(mask)~=6
    print('la mascara debe ser de 6 componentes')
end
if isnumeric(DH)
    print('La matriz DH debe ser de variables articulares simbolicas, aunque de dimenciones fisicas numericas')
end
if size(DH,1)>7 
    print('Solo se pueden resolver robots de hasta 7 GDL')
end
%DH debe ser una matriz simbolica (warning)
syms q1 q2 q3 q4 q5 q6 q7
qt=[q1 q2 q3 q4 q5 q6 q7];
q=qt(1:size(DH,1));
T = SerialLink(DH).fkine(q);

syms E(q1,q2,q3,q4,q5,q6,q7)
%syms E(q)
syms q1 q2 q3 q4 q5 q6 q7
syms pdx pdy pdz odx ody odz ndx ndy ndz mdx mdy mdz
E= mask(1)*(pdx - T(1,4))^2 + mask(2)*(pdy - T(2,4))^2 + mask(3)*(pdz - T(3,4))^2 + mask(4)*((odx - T(1,1))^2 + (ody - T(2,1))^2 + (odz - T(3,1))^2) + mask(5)*((ndx - T(1,2))^2 + (ndy - T(2,2))^2 + (ndz - T(3,2))^2) + mask(6)*((mdx - T(1,3))^2 + (mdy - T(2,3))^2 + (mdz - T(3,3))^2);

%Gradiente
for i=1:lenght(q)
    Grad(i)=diff(E,q(i));
end

    



end
