function [f, J] = func(p)
    f = [sqrt(p(1)^2 + p(2)^2);
         sqrt(p(1)^2 + p(2)^2)];
    J = [p(1)/(sqrt(p(1)^2 + p(2)^2)), p(2)/(sqrt(p(1)^2 + p(2)^2));
         p(1)/(sqrt(p(1)^2 + p(2)^2)), p(2)/(sqrt(p(1)^2 + p(2)^2))];
end