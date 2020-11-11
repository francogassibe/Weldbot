function [q,bool]=CI_optimizado(pd,od,q,DH,Lmax,Lmin,restheta1,maxerror)

%

D1=DH(1,2);
D2=DH(2,2);
D5=DH(5,2);
A5=DH(5,3);

%%
%Verificacion del punto sobre el espacio de trabajo
bool=1;
r=norm(pd-[0 0 D1]);
Rmax=(Lmax-A5);
Rmin=(Lmin+A5);

    if (r>Rmax)
        warning='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
        bool=0;
        p=(pd-[0 0 D1])*Rmax/r + [0 0 D1]
    end
    if (r<Rmin)
        warning='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
        bool=0;
        p=(pd-[0 0 D1])*Rmin/r + [0 0 D1]
    end
    %pd=p; puedo reemplazarlo
 %%esta parte del cono esta mal, copial de la funcion CD
if((sqrt(pd(1)^2+pd(2)^2)<tan(restheta1)*(D1-pd(3))))
    s='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
    rc=D1-pd(3)+tan(restheta1)*norm(pd(1:2));
    zc=D1-tan(pi/2 - restheta1)*rc;
    xc=rc*pd(1)/norm(pd(1:2));
    yc=rc*pd(2)/norm(pd(1:2));
    p=[xc yc zc]
    bool=0
    %pd=p; puedo reemplazarlo
end

%%
%%Gradiente por descenso


od=od/norm(od);

pdx=pd(1);
pdy=pd(2);
pdz=pd(3);
odx=od(1);
ody=od(2);
odz=od(3);





%Escalamiento de paso
alfa=0.035;


%Vector semilla
q1=q(1);
q2=q(2);
q3=q(3);
q4=q(4);
q5=q(5);

maxiter=800;

%Actualizacion iterativa
for i=0:maxiter
    %Gradiente
    DEq1 = 6*(cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2))*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5) - 6*(sin(q1)/10 + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5)*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2)) - 2*(cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5))*(odx - cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*sin(q2)*sin(q5)) - 2*(cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) - cos(q1)*sin(q2)*sin(q5))*(ody + cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5));
    DEq2 = 2*(cos(q2)*sin(q1)*sin(q5) + cos(q4)*cos(q5)*sin(q1)*sin(q2))*(ody + cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5)) - 6*((3*sin(q2))/10 - (2*sin(q2)*sin(q5))/5 + q3*sin(q2) + (2*cos(q2)*cos(q4)*cos(q5))/5)*(pdz + (3*cos(q2))/10 - (2*cos(q2)*sin(q5))/5 + q3*cos(q2) - (2*cos(q4)*cos(q5)*sin(q2))/5 - 3/5) + 6*((3*cos(q1)*cos(q2))/10 + q3*cos(q1)*cos(q2) - (2*cos(q1)*cos(q2)*sin(q5))/5 - (2*cos(q1)*cos(q4)*cos(q5)*sin(q2))/5)*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5) - 6*((3*cos(q2)*sin(q1))/10 + q3*cos(q2)*sin(q1) - (2*cos(q2)*sin(q1)*sin(q5))/5 - (2*cos(q4)*cos(q5)*sin(q1)*sin(q2))/5)*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2)) + 2*(cos(q1)*cos(q2)*sin(q5) + cos(q1)*cos(q4)*cos(q5)*sin(q2))*(odx - cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*sin(q2)*sin(q5)) - 2*(sin(q2)*sin(q5) - cos(q2)*cos(q4)*cos(q5))*(cos(q2)*sin(q5) - odz + cos(q4)*cos(q5)*sin(q2));
    DEq3 = 6*cos(q2)*(pdz + (3*cos(q2))/10 - (2*cos(q2)*sin(q5))/5 + q3*cos(q2) - (2*cos(q4)*cos(q5)*sin(q2))/5 - 3/5) - 6*sin(q1)*sin(q2)*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2)) + 6*cos(q1)*sin(q2)*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5);
    DEq4 = (12*cos(q5)*(cos(q1)*cos(q4) + cos(q2)*sin(q1)*sin(q4))*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2)))/5 + 2*cos(q5)*(cos(q1)*cos(q4) + cos(q2)*sin(q1)*sin(q4))*(ody + cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5)) + (12*cos(q5)*(cos(q4)*sin(q1) - cos(q1)*cos(q2)*sin(q4))*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5))/5 - 2*cos(q5)*(cos(q4)*sin(q1) - cos(q1)*cos(q2)*sin(q4))*(odx - cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*sin(q2)*sin(q5)) - 2*cos(q5)*sin(q2)*sin(q4)*(cos(q2)*sin(q5) - odz + cos(q4)*cos(q5)*sin(q2)) + (12*cos(q5)*sin(q2)*sin(q4)*(pdz + (3*cos(q2))/10 - (2*cos(q2)*sin(q5))/5 + q3*cos(q2) - (2*cos(q4)*cos(q5)*sin(q2))/5 - 3/5))/5;
    DEq5 = 2*(sin(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*cos(q5)*sin(q2))*(odx - cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*sin(q2)*sin(q5)) - 6*((2*cos(q2)*cos(q5))/5 - (2*cos(q4)*sin(q2)*sin(q5))/5)*(pdz + (3*cos(q2))/10 - (2*cos(q2)*sin(q5))/5 + q3*cos(q2) - (2*cos(q4)*cos(q5)*sin(q2))/5 - 3/5) - 6*((2*sin(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 - (2*cos(q5)*sin(q1)*sin(q2))/5)*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2)) - 2*(sin(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) - cos(q5)*sin(q1)*sin(q2))*(ody + cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5)) + 2*(cos(q2)*cos(q5) - cos(q4)*sin(q2)*sin(q5))*(cos(q2)*sin(q5) - odz + cos(q4)*cos(q5)*sin(q2)) - 6*((2*sin(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + (2*cos(q1)*cos(q5)*sin(q2))/5)*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5);

    q1 = q1 - alfa*DEq1;
    q2 = q2 - alfa*DEq2;
    q3 = q3 - alfa*DEq3;
    q4 = q4 - alfa*DEq4;
    q5 = q5 - alfa*DEq5;
    E=3*(sin(q1)/10 - pdx + (3*cos(q1)*sin(q2))/10 + (2*cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)))/5 + q3*cos(q1)*sin(q2) - (2*cos(q1)*sin(q2)*sin(q5))/5)^2 + 3*(pdz + (3*cos(q2))/10 - (2*cos(q2)*sin(q5))/5 + q3*cos(q2) - (2*cos(q4)*cos(q5)*sin(q2))/5 - 3/5)^2 + (cos(q2)*sin(q5) - odz + cos(q4)*cos(q5)*sin(q2))^2 + (odx - cos(q5)*(sin(q1)*sin(q4) + cos(q1)*cos(q2)*cos(q4)) + cos(q1)*sin(q2)*sin(q5))^2 + 3*(pdy + cos(q1)/10 - (3*sin(q1)*sin(q2))/10 + (2*cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)))/5 + (2*sin(q1)*sin(q2)*sin(q5))/5 - q3*sin(q1)*sin(q2))^2 + (ody + cos(q5)*(cos(q1)*sin(q4) - cos(q2)*cos(q4)*sin(q1)) + sin(q1)*sin(q2)*sin(q5))^2;
    if E<= maxerror
        break;
    end
    if i==maxiter-1
        warning= 'Se supero el maximo de iteraciones, el valor del error es:'
        E
    end
end
q=[q1,q2,q3,q4,q5];




    
end


