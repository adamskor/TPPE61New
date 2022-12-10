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
nS = 100;
rho1 = linspace(-0.9999,-0.98, nS);
rho2 = linspace(-0.98, -0.97, nS);
rho3 = linspace(-0.97, -0.9, nS);
rho4 = linspace(-0.9,-0.86, nS);
rho5 = linspace(-0.86, -0.6, nS);
rho6 = linspace(-0.6, -0.4, nS);
rho7 = linspace(-0.4, -0.25, nS);
rho8 = linspace(-0.25, -0.2, nS);
rho9 = linspace(-0.2, -0.1, nS);
rho10 = linspace(-0.1, -0.01, nS);
rho11 = linspace(-0.01, 0.01, nS);
rho12 = linspace(0.01, 0.1, nS);
rho13 = linspace(0.1, 0.2, nS);
rho14 = linspace(0.2, 0.25, nS);
rho15 = linspace(0.25, 0.4, nS);
rho16 = linspace(0.4, 0.6, nS);
rho17 = linspace(0.6, 0.86, nS);
rho18 = linspace(0.86, 0.9, nS);
rho19 = linspace(0.9, 0.97, nS);
rho20 = linspace(0.97, 0.98, nS);
rho21 = linspace(0.98, 0.9999, nS);
rho = [rho1 rho2 rho3 rho4 rho5 rho6 rho7 rho8 rho9 rho10 rho11 rho12 rho13 rho14 rho15 rho16 rho17 rho18 rho19 rho20 rho21];
total = length(rho);
%% This section takes between 8-12 hours to run
%%% Rho calibration
gradCali = zeros(5, total);
fCali = zeros(1, total);
pCali = zeros(5, total);
normCali = zeros(1, total);
for k = 1:total
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho(k));
    objGrad = objGradient(C_star, [p; rho(k)], S0, K, TTM);
    objGrad = objGrad*S0;
    fCali(k) = f;
    gradCali(:, k) = objGrad;
    pCali(1:4,k) = p;
    pCali(5, k) = rho(k);
    normCali(k) = norm(objGrad);
    k
    if abs(objGrad(5)) < 10^-15
        break;
    end
end
%%
rho = -0.0001;
for k = 1:500
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
    objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
    rho = rho - 0.01*objGrad(5);
%     objGrad = objGrad*S0;
%     fCali(k) = f;
%     gradCali(:, k) = objGrad;
%     pCali(1:4,k) = p;
%     pCali(5, k) = rho(k);
%     normCali(k) = norm(objGrad);
    objGrad
    rho
    
    if abs(objGrad(5)) < 10^-15
        break;
    end
end

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

