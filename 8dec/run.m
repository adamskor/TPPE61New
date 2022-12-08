%%%Enligt Lourakis 2005   
nOptions = 36;
[S0, K, TTM, C_star] = getEikonDataSPX(); 

%%% Normalize Data
C_star = C_star/S0 ;
K = K/S0 ;
S0 = 1;
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
nSamples = 20;
nParameters = 5;

%%% Define control vectors
checkRho = zeros(4,nSamples);
objValuesRho = zeros(1,nSamples); 
e_pVecRho = zeros(numel(K),nSamples);
gradValuesRho = zeros(5,nSamples);

%%% Assign arbitrary starting point to calibrate Rho
p0 = [0.2, 2, 0.4, 0.1]';
%%% Assign start value for Rho calibration
rho = -0.1;
%%% Rho calibration
for k = 1:500
    [p, f, e_p] = LevenbergFuncGeneral(@funcRhoFixed, p0, C_star, S0, K , TTM, rho);
    objGrad = objGradient(C_star, [p; rho], S0, K, TTM);
    rho = rho - k*objGrad(5);
    rho
    objGrad
    if abs(objGrad(5)) < 10^-5
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
K = K(1:nOptions); TTM = TTM(1:nOptions); C_star = C_star(1:nOptions);
repricedObjVal = zeros(nSamples,1);
for i = 1:nSamples
    [C, ~] = funcRhoFixed(checkRho(:,i), S0, K , TTM, rho);
    repricedObjVal(i) = 0.5*(C_star - C)'*(C_star - C);
end

%%% Check for overall 
checkSum = min(objValuesRho);
convergence = 0;
for i = 1:nSamples
    if objValuesRho(i) < checkSum*1.01
        convergence = convergence + 1;
    end
end
convergence/nSamples
        
plotE_p(checkRho, 3)

