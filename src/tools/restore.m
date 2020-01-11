function [ signal ] = restore(Hs)

[L,M]=size(Hs);

signal = zeros(1,L+M-1);

%Anti diagnoals, triangle supérieur. 
for ii=1:(L-1)

    Val = 0;
    l=ii;
    c=1;
    compteur = 0;
    
    while(l>=1 && c<M)
        Val = Val + Hs(l,c);
        l = l-1;
        c = c+1;
        compteur = 1+compteur;
    end
    
    signal(1,ii)=Val/compteur;
    
end

%Anti diagnoals, triangle inférieur. 
for ii=1:M

    Val = 0;
    l=L;
    c=ii;
    compteur = 0;
    
    while(c<=M)
        Val = Val + Hs(l,c);
        l = l-1;
        c = c+1;
        compteur = 1+compteur;

    end
    
    signal(1,(L-1)+ii)=Val/compteur;
    
end

end

