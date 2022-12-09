function [f, J] = func2(p, S0, K , TTM, rho)



r = 0;
div = 0;
n = numel(K);
m = numel(p);
f = zeros(n,1);
J = zeros(n,m);
for i = 1:n
    [C, grad] = mexOption_ps2('Heston', S0, K(i), r, div, TTM(i), p);
    f(i) = C;
    J(i, :) = grad;


end