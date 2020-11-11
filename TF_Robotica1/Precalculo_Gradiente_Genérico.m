function Precalculo_gradiente_Generico(DH)

%DH debe ser una matriz simbolica (warning)
syms q1 q2 q3 q4 q5 q6 
qt=[q1 q2 q3 q4 q5 q6];
q=qt(1:size(DH,1));
T = SerialLink(DH).fkine(q);

syms E(q1,q2,q3,q4,q5,q6)
syms q1 q2 q3 q4 q5 q6
syms pdx pdy pdz odx ody odz ndx ndy ndz mdx mdy mdz

if 
    
else 
    



end