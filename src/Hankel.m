function [ Hankel ] = Hankel(signal,M)

Total = length(signal);

L = Total - M;  

h = hankel(1:L,1:M);

Hankel = signal(h);

end
