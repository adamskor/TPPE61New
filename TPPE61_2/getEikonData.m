function [S0, K, TTM, C_star] = getEikonData()
    S0 = readmatrix('optionData.xlsx','Range','B2:B2');
K = readmatrix('optionData.xlsx','Range','I2:I37');
TTM = readmatrix('optionData.xlsx','Range','K2:K37');
C_star = readmatrix('optionData.xlsx','Range','H2:H37');
end

