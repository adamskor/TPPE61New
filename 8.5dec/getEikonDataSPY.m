function [S0, K, TTM, C_star] = getEikonDataSPY()
    S0 = 401;
    K_n = readmatrix('SPYOptionData.xlsx','Range','O5136:O5217');
    TTM_n = readmatrix('SPYOptionData.xlsx','Range','R5136:R5217');
    C_star_n = readmatrix('SPYOptionData.xlsx','Range','M5136:M5217');
    count = 1;
    for i = 1:2:length(K_n)
       K(count) = K_n(i);
       TTM(count) = TTM_n(i);
       C_star(count) = C_star_n(i);
       count = count + 1;
    end
end

