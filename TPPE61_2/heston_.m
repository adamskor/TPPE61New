function [p_,grad_] = heston_(S0, K, r, div, TTM, x_)

nu0    = x_(1); 
kappa  = x_(2); 
eta_   = x_(3); 
theta_ = x_(4); 
rho    = x_(5); 

eta = eta_;
theta = theta_;
paramS = [nu0;kappa;eta;theta;rho];

[p_,grad] = mexOption_ps2('Heston', S0, K, r, div, TTM, paramS);

grad_ = grad;

% p_(nu0, kappa, eta_, theta_, rho) = p(nu0, kappa, eta_/kappa, sqrt(theta_), rho)

%   d p(nu0, kappa, eta_/kappa, sqrt(theta_), rho) / d kappa
% = d p / d kappa - d p / d eta * eta_ / kappa^2

grad_(2) = grad(2) - grad(3) * eta_ / kappa^2;

%   d p(nu0, kappa, eta_/kappa, sqrt(theta_), rho) / d eta_
% = d p / d eta * 1 / kappa

grad_(3) = grad(3) / kappa;

%   d p(nu0, kappa, eta_/kappa, sqrt(theta_), rho) / d theta_
% = d p / d theta * 0.5 / sqrt(theta_)

grad_(4) = grad(4) * 0.5 / sqrt(theta_);
