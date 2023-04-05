% function [a, b] = extraction(x, y)
%     log_x = log(x);
%     log_y = log(y);
%     p = polyfit(log_x, log_y, 1);
%     a = exp(p(2));
%     b = p(1);
% end


function [a, b] = extraction(x, y)
    % extraction des coefficients pour la représentation log-log
    log_x = log(x);
    log_y = log(y);
    coeffs_loglog = polyfit(log_x, log_y, 1);
    a_loglog = exp(coeffs_loglog(2));
    b_loglog = coeffs_loglog(1);

    % extraction des coefficients pour la représentation log-linéaire
    coeffs_loglin = polyfit(x, log_y, 1);
    a_loglin = exp(coeffs_loglin(2));
    b_loglin = coeffs_loglin(1);

    % extraction des coefficients pour la représentation linéaire-log
    coeffs_linlog = polyfit(log_x, y, 1);
    a_linlog = coeffs_linlog(2);
    b_linlog = coeffs_linlog(1);

    % création d'une figure pour afficher les trois représentations
    figure;
    % subplot pour la représentation log-log
    subplot(1, 3, 1);
    loglog(x, y, '+');
    hold on;
    loglog(x, a_loglog * x.^b_loglog);
    xlabel('log(x)');
    ylabel('log(y)');
    title('Log-Log');
    % subplot pour la représentation log-linéaire
    subplot(1, 3, 2);
    semilogy(x, y, 'o');
    hold on;
    semilogy(x, a_loglin * exp(b_loglin * x));
    xlabel('x');
    ylabel('log(y)');
    title('Log-Linéaire');
%     % subplot pour la représentation linéaire-log
%     subplot(1, 3, 3);
%     plot(x, y, '*');
%     hold on;
%     plot(x, a_linlog * log(x) + b_linlog);
%     xlabel('log(x)');
%     ylabel('y');
%     title('Linéaire-Log');
%     
    % renvoie des coefficients pour les trois représentations
    a = [a_loglog, a_loglin, a_linlog];
    b = [b_loglog, b_loglin, b_linlog];
end