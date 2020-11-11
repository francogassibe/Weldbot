function [T,bool]= CD(DH,Lmax,Lmin,restheta1)
%Verificacion de dimenciones
if (size(DH,2)~=4 | size(DH,1)~=5)
   warning='Error en las dimenciones de la matriz de Denavit-Hatenberg, la misma debe ser de 5 filas y 4 columnas '
end

%Calculo de T
T=eye(4);
for i=1:size(DH,1)
    
    a=trotz(DH(i,1))*transl(0,0,DH(i,2))*transl(DH(i,4),0,0)*trotx(DH(i,3));
    T=T*a;
end

%%
%%Verificacion del espacio de trabajo

%Se consideró como espacio de trabajo a 
%los puntos dentro del alcance con
%la capacidad de
%orientacion del efector final

bool=1;
if isnumeric(DH) 
D1=DH(1,2);
A5=DH(5,4);
x=T(1,4);
y=T(2,4);
z=T(3,4);
pos=[x,y,z];
r=norm(pos-[0 0 D1]);
Rmax=(Lmax-A5);
Rmin=(Lmin+A5);
   
    if (r>Rmax)
        warning='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
        bool=0;
        p=(pos-[0 0 D1])*Rmax/r + [0 0 D1]
    end
    if (r<Rmin)
        warning='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
        bool=0;
       p=(pos-[0 0 D1])*Rmin/r + [0 0 D1]
    end
    

if((sqrt(T(1,4)^2+T(2,4)^2)<tan(restheta1)*(D1-T(3,4))))
    warning='El punto seleccionado se encuentra fuera del espacio de trabajo, el punto mas cercano es: '
%     rc=D1-T(3,4)+tan(restheta1)*norm(T(1:2,4));
%     zc=D1-tan(pi/2 - restheta1)*rc;
    r0=sqrt(x^2+y^2);
    zc=(D1+z/(tan(restheta1)^2)-r0/(tan(restheta1)))/(1+1/(tan(restheta1)^2));
    rc=r0+(zc-z)/tan(restheta1);
    
    xc=rc*T(1,4)/norm(T(1:2,4));
    yc=rc*T(2,4)/norm(T(1:2,4));
    p=[xc yc zc]
    bool=0;
    
end
end



end