%%%Enligt Lourakis 2005   
%[S0, K, TTM, C_star] = getEikonData();
nOptions = 30;
[S0, K, TTM, C_star] = getBlackScholesData(nOptions);

%[f, p] = gridSearch(C_star, S0, K , TTM)
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
nSamples = 3;
nParameters = 5;
[p0Vec] = getInitialPoints(nSamples, nParameters);
figure(1)
check = zeros(5,nSamples); checkRho = zeros(4,nSamples); objValues = zeros(1,nSamples);
objValuesRho = zeros(1,nSamples); e_pVec = zeros(numel(K),nSamples); e_pVecRho = zeros(numel(K),nSamples);

for i = 1:nSamples
    p0 = p0Vec(:,i);
    [p, f, fIter, e_p] = LevenbergFuncGeneral(@func2, p0, C_star, S0, K , TTM);
    check(:,i) = p;
    objValues(i) = f;
    e_pVec(:,i) = e_p;
end

[p0Vec] = getInitialPoints(nSamples, 4);
for i = 1:nSamples
    p0 = p0Vec(:,i);
    [p, f, fIter, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM);
    checkRho(:,i) = p;
    objValuesRho(i) = f;
    e_pVecRho(:,i) = e_p;
end
% for i = 1:nSamples
%     p0 = [nu0(i); kappa(i); eta(i); theta(i); rho(i)];
%     [f, J] = func2(p0, S0, K , TTM);
%     objValues(i) = 0.5*(C_star - f)'*(C_star - f);
% end



objGrad = objGradient(C_star, [p; -0.99], S0, K, TTM);

plot(objValues)
%scatter(1:1:nSamples ,objValuesRho)
plotE_p(check, 2)
plotE_p(checkRho, 3)

