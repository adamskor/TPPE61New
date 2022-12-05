function [p, f, e_p] = LevenbergFuncGeneral(func, p0, target, S0, K , TTM, rhoIn)


%************************************************
n = length(target); %Number of observed prices
m = length(p0); %Number of parameters, 5 for Heston


k = 0;
nu = 2;
p = p0; %n x 1

[f_p, J_p] = func(p, S0, K , TTM, rhoIn); %f_p: n x 1, J_p: n x m
if (size(f_p, 1) ~= n) && (size(f_p, 2) ~= 1) && (size(J_p, 1) ~= n) && (size(J_p, 2) ~= m) && (size(f_p) ~= size(target))
    error('func returns wrong dimensions')
end
A = J_p'*J_p; %m x m
e_p = target - f_p; %n x 1
g = J_p'*e_p; %m x 1
stop = 0; eps1 = 10e-12; eps2 = 10e-12; eps3 = 10e-12;
if norm(g, 'inf') <= eps1
    stop = 1;
    disp('Breaking on eps1')
end
mu = 10^-3*max(diag(A));
while ~stop && k < 10000
    k = k + 1;
    while true
        delta_p = (A + mu*eye(m))\g; %m x 1
        if norm(delta_p, 2) <= eps2*norm(p, 2)
            stop = 1;
            disp('Breaking on eps2')
        else
            p_new = p + delta_p; 
            [f_p_new, J_p_new] = func(p_new, S0, K , TTM, rhoIn);
            change = (norm(e_p, 2)^2 - norm(target - f_p_new, 2)^2);
            rho = change/(delta_p'*(mu*delta_p + g));   
            if rho > 0 
                p = p_new;
                A = J_p_new'*J_p_new;
                e_p = target - f_p_new;
                g = J_p_new'*e_p;
                if norm(g, 'inf') <= eps1 || norm(e_p, 2)^2 <= eps3
                    stop = 1;
                    disp('Breaking on eps1 or eps3')
                end
                mu = mu*max(1/3, 1 - (2*rho - 1)^3);
                nu = 2;
            else
                mu = mu*nu;
                nu = 2*nu;
            end
        end
        
        if stop || rho > 0
            break;
        end
    end
end
f = 0.5*(e_p')*e_p;
end