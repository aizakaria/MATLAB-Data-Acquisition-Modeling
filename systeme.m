function systeme(type)
    tic %metre dans le rapport switch est plus rapide que if
    switch type
        case 1
            a = input('saisir a :')
            b = input('saisir b :')
            n = input('saisir n :')
            exponentiel(a,b,n)
        case 2
            a = input('saisir a :')
            b = input('saisir b :')
            n = input('saisir n :')
            logarithmique(a,b,n)
        case 3
            a = input('saisir a :')
            b = input('saisir b :')
            n = input('saisir n :')
            lineaire(a,b,n)
        case 4
            a = input('saisir a :')
            b = input('saisir b :')
            n = input('saisir n :')
            puissance(a,b,n)

    end
    toc
end
function exponentiel(a,b,n)
    global x y
    x = linspace(0,5, n);
    y = a*exp(b*x);
    % Affichage de la courbe
    plot(x, y)
    xlabel('x')
    ylabel('y')
    title('Fonction exponentielle')
    return
end
function logarithmique(a,b,n)
    global x y
    x = linspace(0,5,n);
    y = a*log(b*x);
    plot(x,y);
    xlabel('x');
    ylabel('y');
    title('Fonction logarithmique');
    return
end

function lineaire(a,b,n)
    global x y
    x = 0 : 0.01 : n;
    f = @(x) a * x + b;
    y = f(x);
    plot(x, y)
    xlabel('x')
    ylabel('y')
    title('Fonction linéaire')
    return
end
function puissance(a,b,n)
    global x y
    x = linspace(0,10,n);
    y = a*x.^b;
    plot(x,y);
    xlabel('x');
    ylabel('y');
    title('Fonction puissance');
    return
end
