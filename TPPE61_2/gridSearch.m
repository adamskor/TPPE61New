function [f, p] = gridSearch(target, S0, K , TTM)
%%% Introduce reasonable parameter ranges
m = 5;
n = numel(K);
pointsPerParameter = 10;
nu0 = linspace(0.05, 0.95, pointsPerParameter);
kappa = linspace(0.5, 5, pointsPerParameter);
eta = linspace(0.05, 0.95, pointsPerParameter);
theta = linspace(0.05, 0.95, pointsPerParameter);
rho = linspace(-0.1, -0.9, pointsPerParameter);



obj_best = 10^10;
p_best = [0 0 0 0 0]';
for i1 = 1:pointsPerParameter
    i1
    for i2 = 1:pointsPerParameter
        i2
        for i3 = 1:pointsPerParameter
            for i4 = 1:pointsPerParameter
                for i5 = 1:pointsPerParameter
                    p = [nu0(i1), kappa(i2), eta(i3), theta(i4), rho(i5)]';
                    obj = getF(p, target, S0, K , TTM, n);
                    if obj < obj_best
                        obj_best = obj;
                        p_best = p;
                    end
                end
            end
        end
    end
end
p = p_best;
f = obj_best;
end              


function obj = getF(p, target, S0, K , TTM, n)
    e_p = zeros(n, 1);
    for i = 1:n
        [C, ~] = mexOption_ps2('Heston', S0, K(i), 0, 0, TTM(i), p);
        e_p(i) = target(i) - C;
    end
    obj = 0.5*(e_p')*e_p;
end


    
    
                    