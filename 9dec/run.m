%%%Enligt Lourakis 2005   
nOptions = 36;
[S0, K, TTM, C_star] = getEikonDataSPX(); 
%[S0, K, TTM, C_star] = getBlackScholesData(nOptions)
%%% Normalize Data
C_star = C_star/S0 ;
K = K/S0 ;
S0 = 1;
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
nSamples = 20;
nParameters = 5;

%%% Define verification vectors
checkRho = zeros(4,nSamples);
objValuesRho = zeros(1,nSamples); 
e_pVecRho = zeros(numel(K),nSamples);
gradValuesRho = zeros(5,nSamples);

%%% Assign arbitrary starting point to calibrate Rho
p0 = [0.2, 2, 0.4, 0.1]';
%%% Assign start value for Rho calibration
rho = -0.01;
rho = linspace(-0.2707, 0.2707, 100)
%%% Rho calibration
gradCali2 = zeros(5, 100);
fCali2 = zeros(1, 100);
pCali2 = zeros(5, 100);
for k = 1:100
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho(k));
    objGrad = objGradient(C_star, [p; rho(k)], S0, K, TTM);
    %rho = rho - k*objGrad(5);
    fCali2(k) = f;
    gradCali2(:, k) = objGrad;
    pCali2(1:4,k) = p;
    pCali2(5, k) = rho(k);
    rho
    objGrad
    if abs(objGrad(5)) < 10^-15
        break;
    end
end
%%
%%% Generate random points from "suggested" intervals
[p0Vec] = getInitialPoints(nSamples, 4);
%%% Optimize for each starting point and save relevant information
for i = 1:nSamples
    p0 = p0Vec(:,i);
    [p, f, e_p, fVec, gradVec] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
    objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
    gradValuesRho(:, i) = objGrad;
    checkRho(:,i) = p;
    objValuesRho(i) = f;
    e_pVecRho(:,i) = e_p;
end

%%%Repricing of options from originial data
[S0, K, TTM, C_star] = getEikonDataSPX(); 
%[S0, K, TTM, C_star] = getBlackScholesData(nOptions);
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
repricedObjVal = zeros(nSamples,1);
for i = 1:nSamples
    [C, ~] = funcRhoFixed(checkRho(:,i), S0, K , TTM, rho);
    repricedObjVal(i) = 0.5*(C_star - C)'*(C_star - C);
end

%%% Check for overall convergence with respect to objective function value
checkSum = min(objValuesRho);
convergence = 0;
for i = 1:nSamples
    if objValuesRho(i) < checkSum*1.01
        convergence = convergence + 1;
    end
end
convergence/nSamples


%%% Checking if the ratio of parameter vectors that can be considered the
%%% same
medRho = median(checkRho')';
phi = 10^-3;
parameterConvergence = 0;
for i = 1:nSamples
    if norm(norm(medRho) - norm(checkRho(:, i))) < phi
        parameterConvergence = parameterConvergence + 1;
    end
end
parameterConvergenceMeas = parameterConvergence/nSamples
%%
%%% Plot the overall pricing error in relation to strike price and time to
%%% maturity in dollars
figure(2)
priceError = abs([e_pVecRho(1:9, 1) zeros(9,2) e_pVecRho(10:18, 1) zeros(9,1)  e_pVecRho(19:27, 1) zeros(9,2)  e_pVecRho(28:36, 1)]);
strike = [380 385 390 395 400 405 410 415 420];
timeToMat = [TTM(1) 0 0 TTM(20)  0 TTM(22) 0 0 TTM(29)];
stem3(timeToMat, strike, priceError)
xlim([timeToMat(1)-0.3, timeToMat(end)+0.2])
ylim([375, 425])
xlabel('Time to maturity')
ylabel('Strike Price')
zlabel('Pricing error ($)')



plotE_p(checkRho, 3)

