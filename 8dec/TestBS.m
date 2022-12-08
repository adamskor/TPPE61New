%%% Testar att implementera en funktion som Beräknar IV enligt
%%% Levenberg-Marquardt

[S0, K, TTM, C_star] = getEikonDataSPX(); 


% C_star = C_star/S0;
% K = K/S0;
% S0 = 1;
nOptions = 36; 
%[S0, K, TTM, C_star] = getBlackScholesData(nOptions);
TTM = TTM;
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
nSamples = 20;
nParameters = 5;
%[p0Vec] = getInitialPoints(nSamples, nParameters);
check = zeros(5,nSamples); checkRho = zeros(4,nSamples); objValues = zeros(1,nSamples);
objValuesRho = zeros(1,nSamples); e_pVec = zeros(numel(K),nSamples); e_pVecRho = zeros(numel(K),nSamples);
gradValuesRho = zeros(5,nSamples);

sigma = 0.001;
for k = 1:50
    [p, f, e_p] = LevenbergFuncGeneralBS(@BSmodel, sigma, C_star, S0, K , TTM);
    %objGrad = objGradient(C_star, sigma, S0, K, TTM);
    f
    %rho = rho - 0.001*objGrad(5);
    %rho
    %if abs(objGrad(5)) < 10^-5
     %   k
      %  objGrad
       % break;
    %end
end

[S0, K, TTM, C_star] = getEikonDataSPX(); 
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
repricedObjVal = zeros(nSamples,1);
for i = 1:nSamples
    [C,  ~] = BSmodel(S0, K, 0.0162, p , TTM, "call");
    repricedObjVal(i) = 0.5*(C_star - C)'*(C_star - C);
end



