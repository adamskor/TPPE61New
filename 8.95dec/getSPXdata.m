function [A] = getSPXdata()
    Raw = readtable('SPXOptionData.xlsx','Sheet', 'Sheet1', 'Range','L6:R6397');
    
    Name = table2array(Raw(:,1));
    Date = table2array(Raw(:,5));
    Strike = table2array(Raw(:,4));
    TTM = table2array(Raw(:,7));
    Ask = table2array(Raw(:,2));
    Bid = table2array(Raw(:,3));
    Type = table2array(Raw(:,6));
    Mid = (Bid + Ask)/2; 
    S = 400;
    
    Sinterval = [S-100, S+100];
    
    nRaw = [Strike, TTM, Mid];
   
     % Sorterar ut den datan jag vill  ha
    OutMtrx1 = zeros(sum(Type(:) == "C-AM"), 3);
    %Date2 = zeros(sum(Type(:) == "C-EU"), 1);
    
     num = length(TTM);
    counter = 1; 
    for i = 1:num
        if Type(i) == "C-AM"
           
            OutMtrx1(counter,:) = nRaw(i,:);
            Date2(counter) = Date(i);
            counter = counter +1; 
        end
    end
    
    counter =1; 
    for i = 1:length(OutMtrx1)
        if and(OutMtrx1(i,1) > Sinterval(1), OutMtrx1(i,1) <= Sinterval(2))
            OutMtrx2(counter, :) = OutMtrx1(i,:);
             Date3(counter) = Date2(i);
            counter = counter +1;
        end
    end
    
    outMtrx3 = zeros(sum(Date3(:) < "2024-01-01"),3);
    counter = 1; 
    for i = 1:length(Date3)
        if Date3(i) > "2024-01-01"
            outMtrx3(counter,:) = OutMtrx2(i,:);
            counter = counter +1;
        end
    end 
    A = outMtrx3;