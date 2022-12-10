function [p0] = getInitialPoints(nSamples, nParameters)
    p0 = zeros(nParameters, nSamples);
    nu0LB = 0.05; nu0UB = 0.95; nu0 = (nu0UB-nu0LB).*rand(nSamples,1) + nu0LB;
    kappaLB = 0.5; kappaUB = 5; kappa = (kappaUB-kappaLB).*rand(nSamples,1) + kappaLB;
    etaLB = 0.05; etaUB = 0.95; eta = (etaUB-etaLB).*rand(nSamples,1) + etaLB;
    thetaLB = 0.05; thetaUB = 0.95; theta = (thetaUB-thetaLB).*rand(nSamples,1) + thetaLB;
    rhoLB = -0.1; rhoUB = -0.9; rho = (rhoUB-rhoLB).*rand(nSamples,1) + rhoLB;
    p0(1,:) = nu0;
    p0(2,:) = kappa;
    p0(3,:) = eta;
    p0(4,:) = theta;
    if nParameters > 4
        p0(5,:) = rho;
    end
end

