function [option_price, vega] = BSmodel(S, K, r, sigma, T, type)
% BLACK_SCHOLES calculates the theoretical price of a European call or put option
% using the Black-Scholes model.
%   

    option_price_ = zeros(size(K));
    vega1 = zeros(size(K));
    nf = length(K);
    
% Inputs:
%   S: The current price of the underlying asset.
%   K: The strike price of the option.
%   r: The risk-free interest rate.
%   sigma: The volatility of the underlying asset.
%   T: The time to expiration of the option, expressed in years.
%   type: The type of option, either 'call' or 'put'.
%
% Output:
%   option_price: The theoretical price of the option.

for i = 1:nf

% Calculate d1 and d2
    d1 = (log(S / K(i)) + (r + 0.5 * sigma^2) * T(i)) / (sigma * sqrt(T(i)));
    d2 = d1 - sigma * sqrt(T(i));

% Calculate the option price
    if strcmpi(type, 'call')
        option_price_(i) = S * normcdf(d1) - K(i) * exp(-r * T(i)) * normcdf(d2);
    elseif strcmpi(type, 'put')
        option_price = K(i) * exp(-r * T(i)) * normcdf(-d2) - S * normcdf(-d1);
    else
        error('Invalid option type')
    end
    
    vega1(i) = S*sqrt(T(i))*normpdf(d1);
end

    option_price = option_price_;
    vega = vega1;
    