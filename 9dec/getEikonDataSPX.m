function [S0, K, TTM, C_star] = getEikonData()
ask = readmatrix('SPXOptionData.xlsx','Range','M4438:M6397');
bid = readmatrix('SPXOptionData.xlsx','Range','N4438:N6397');
K_temp = readmatrix('SPXOptionData.xlsx','Range','O4438:O6397');
TTM_temp = readmatrix('SPXOptionData.xlsx','Range','R4438:R6397');
count = 1;
for i = 1:2:length(K_temp)
    
    C_star(count) = (ask(i) + bid(i))*0.5;
    K(count) = K_temp(i);
    TTM(count) = TTM_temp(i); 
    count = count + 1;
end
count = 1;
for i = 1:length(K)
   if K(i) == 4000
       for p = i-3:i+3
           C_star_new(count) = C_star(p);
           TTM_new(count) = TTM(p);
           K_new(count) = K(p);
           count = count + 1;
       end
   end
end    
K = K_new';
TTM = TTM_new';
C_star = C_star_new';
S0 = 3937.05;

