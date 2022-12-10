function [] = plotE_p(E_p, figureNr)
    if size(E_p, 1) > 4
        figure(figureNr)
        subplot(2,3,1)
        plot(E_p(1,:))
        title('Nu0')
        subplot(2,3,2)
        plot(E_p(2,:))
        title('Kappa')
        subplot(2,3,3)
        plot(E_p(3,:))
        title('Eta')
        subplot(2,3,4)
        plot(E_p(4,:))
        title('Theta')

        subplot(2,3,5)
        plot(E_p(5,:))
        title('Rho')
    else
        figure(figureNr)
        subplot(2,2,1)
        plot(E_p(1,:))
        title('Nu0')
        subplot(2,2,2)
        plot(E_p(2,:))
        title('Kappa')
        subplot(2,2,3)
        plot(E_p(3,:))
        title('Eta')
        subplot(2,2,4)
        plot(E_p(4,:))
        title('Theta')
    end

        

end