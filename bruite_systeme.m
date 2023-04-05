function bruite_systeme(type, N, class, Moy, sigma)
%   type : type du système
%   N : nombre de réalisations du bruit
%   classe : nombre de classes pour l'histogramme du bruit
%   Moy : moyenne du bruit
%   sigma : écart-type du bruit
% Appel de la fonction système pour créer la courbe initiale
type = 1; % 1 pour exponentielle, 2 pour logarithmique, 3 pour linéaire, 4 pour puissance
% Génération de la sortie du système
[x,y] = systeme(type);

% Génération du bruit gaussien
bruit_gaussien = Moy + sigma * randn(1, length(y));

% Génération du bruit uniforme
bruit_uniforme = Moy + sigma * rand(1, length(y)) - sigma/2;

% Combinaison du système et du bruit gaussien
y_bruite_gaussien = y + bruit_gaussien;

% Combinaison du système et du bruit uniforme
y_bruite_uniforme = y + bruit_uniforme;

% Affichage des sorties bruitées
subplot(2,2,1)
plot(x, y_bruite_gaussien)
title('Sortie du système avec bruit gaussien')
xlabel('x')
ylabel('y')

subplot(2,2,3)
plot(x, y_bruite_uniforme)
title('Sortie du système avec bruit uniforme')
xlabel('x')
ylabel('y')
end
