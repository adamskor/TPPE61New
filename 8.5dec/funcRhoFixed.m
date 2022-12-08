function [f, J] = funcRhoFixed(p, S0, K , TTM, rho)



r = 0;
div = 0;
n = numel(K);
m = numel(p);
f = zeros(n,1);
J = zeros(n,m);

for i = 1:n
    [C, grad] = mexOption_ps2('Heston', S0, K(i), r, 0.0162, TTM(i), [p; rho]);
    f(i) = C;
    J(i, :) = grad(1:4);


end