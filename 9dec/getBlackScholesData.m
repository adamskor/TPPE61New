function [S0, K, TTM, C_star] = getBlackScholesData(nOptions)

    %%% Only varying TTM
    Vol = 0.3;
    S0 = 4000;
    K = linspace(3975, 4025, nOptions);
    C_star = zeros(nOptions,1);
    TTM = linspace(0.8, 1.6, nOptions);
    Vol = linspace(0.5, 0.48, nOptions);
    for i = 1:nOptions

        C_star(i) = blsprice(S0,K(i),0,TTM(i),0.3, 0.0162);
    end

    
end

