function [ Hankel ] = Hankel(signal,M)

Total = length(signal);

L = Total - M;  

h = hankel(1:L,L:L+M);

Hankel = signal(h);

end
