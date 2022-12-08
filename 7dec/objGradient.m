function objGrad = objGradient(C_star, p, S0, K, TTM)
    n = numel(K);
    objGrad = zeros(5,1);
    for i = 1:n
        [C, grad] = mexOption_ps2('Heston', S0, K(i), 0, 0.0162, TTM(i), p);
        temp = -2*C_star(i)*grad + 2*grad*C;      
        objGrad = objGrad + temp;
    end
end