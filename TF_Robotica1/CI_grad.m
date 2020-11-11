function CI_grad(T,q)


%Se pueden normalizar las direcciones
%se puede verificar que sea dextrogiro

pdx=T(1,4);
pdy=T(2,4);
pdz=T(3,4);
odx=T(1,1);
ody=T(2,1);
odz=T(3,1);
ndx=T(1,2);
ndy=T(2,2);
ndz=T(3,2);
mdx=T(1,3);
mdy=T(2,3);
mdz=T(3,3);





%Escalamiento de paso
alfa=0.035;
maxiter=1000;


%Vector semilla
q1=q(1);
q2=q(2);
q3=q(3);
q4=q(4);
q5=q(5);




%Actualizacion iterativa
for i=0:maxiter
    %Gradiente
    DEq1=;
    DEq2=;
    DEq3=;
    DEq4=;
    DEq5=;
    DEq6=;
    
    
    q1 = q1 - alfa*DEq1;
    q2 = q2 - alfa*DEq2;
    q3 = q3 - alfa*DEq3;
    q4 = q4 - alfa*DEq4;
    q5 = q5 - alfa*DEq5;
    q6= q6 - alfa*DEq6;
    E=;
    if E<= maxerror
        break;
    end
    if i==maxiter-1
        print('Se supero el maximo de iteraciones, el valor del error es: ')
        E
        print('Puede probar disminuyendo alfa y/o aumentando el numero de iteaciones máximas en la implementacion de la función')
    end
end
q=[q1,q2,q3,q4,q5];




    
end