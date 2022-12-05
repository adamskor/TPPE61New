%%%Enligt Lourakis 2005   
[S0, K, TTM, C_star] = getEikonData();
nOptions = 30;
%[S0, K, TTM, C_star] = getBlackScholesData(nOptions);

%[f, p] = gridSearch(C_star, S0, K , TTM)
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
nSamples = 10000;
nParameters = 5;
[p0Vec] = getInitialPoints(nSamples, nParameters);
check = zeros(5,nSamples); checkRho = zeros(4,nSamples); objValues = zeros(1,nSamples);
objValuesRho = zeros(1,nSamples); e_pVec = zeros(numel(K),nSamples); e_pVecRho = zeros(numel(K),nSamples);
gradValuesRho = zeros(5,nSamples);


p0 = [0.2, 2, 0.4, 0.1]';
rho = -0.99;
for k = 1:100
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
    objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
    rho = rho - 0.001*objGrad(5);
    k
    if abs(objGrad(5)) < 10^-5
        k
        objGrad
        break;
    end
end
% rho = -0.99 - 0.00004706970056;
% rho = -0.99 + 0.00087106970056;
% rho = -0.99 - 0.001*-0.5821 - 0.001*-0.1717 -0.001*-0.0677 - 0.001*-0.0287305137863427 -0.001*0.012503447870927 -0.001* -0.019540375877966 -0.001*-0.008555835429263 -0.001* -0.003776020710177 -0.001*-0.001671349802450;
% %rho = -0.99;
% [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
% objGrad = objGradient(C_star, [p; rho], S0, K, TTM);


% for i = 1:nSamples
%     p0 = p0Vec(:,i);
%     [p, f, e_p] = LevenbergFuncGeneral(@func2, p0, C_star, S0, K , TTM, 0);
%     check(:,i) = p;
%     objValues(i) = f;
%     e_pVec(:,i) = e_p;
% end
% 
[p0Vec] = getInitialPoints(nSamples, 4);
for i = 1:nSamples
    p0 = p0Vec(:,i);
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
    objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
    gradValuesRho(:, i) = objGrad;
    checkRho(:,i) = p;
    objValuesRho(i) = f;
    e_pVecRho(:,i) = e_p;
end
%%
checkSum = min(objValuesRho);
convergence = 0;
for i = 1:nSamples
    if objValuesRho(i) < checkSum*1.01
        convergence = convergence + 1;
    end
end
convergence/nSamples
        

% for i = 1:nSamples
%     p0 = [nu0(i); kappa(i); eta(i); theta(i); rho(i)];
%     [f, J] = func2(p0, S0, K , TTM);
%     objValues(i) = 0.5*(C_star - f)'*(C_star - f);
% end



% objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
% 
% % plot(objValues)
% % %scatter(1:1:nSamples ,objValuesRho)
% plotE_p(check, 2)
plotE_p(checkRho, 3)

