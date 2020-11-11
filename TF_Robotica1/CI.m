function [q,bool]=CI(pd,od,q,DH,Lmax,Lmin,restheta1,maxerror)
%%

D1=DH(1,2);
D2=DH(2,2);
D5=DH(5,2);
A5=DH(5,3);

%%Verificacion del punto sobre el espacio de trabajo
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

syms E(q1,q2,q3,q4,q5)
syms q1 q2 q3 q4 q5 
[T,B]=CD(DH,Lmax,Lmin,restheta1);
E=(((pd(1) - T(1,4))^2 + (pd(2) - T(2,4))^2 + (pd(3) - T(3,4))^2)*3 + (od(1) - T(1,1))^2 + (od(2) - T(2,1))^2 + (od(3) - T(3,1))^2);

%Gradiente
DEq1 = diff(E,q1);
DEq2 = diff(E,q2);
DEq3 = diff(E,q3);
DEq4 = diff(E,q4);
DEq5 = diff(E,q5);



%Escalamiento de paso
alfa=0.07;


%Vector semilla
q1=q(1);
q2=q(2);
q3=q(3);
q4=q(4);
q5=q(5);



%Actualizacion iterativa
for i=0:200
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
    if eval(subs(E))<= maxerror
        i
        break;
    end
    if i==200
        warning= 'Se supero el maximo de iteraciones, el valor del error es:'
        eval(subs(E))
    end
end
q=[q1,q2,q3,q4,q5];




    
end


