%-----------------------------Classification------------------------------%
%--Divise l'image en deux classes selon la moyenne et la variance d'une---% 
%--------------------------------fenêtre----------------------------------%

%% Initialisation
tic

clear
close all
im = imread('tiger1.jpg'); %L'image qu'il faut classifier
figure
imtool(im) % Nous utilisons imtool pour voir la fenêtre va de quel à quel pixel

%% Classification

%Coordonnées en pixel de la fenêtre échantillon
idx =250:400;
idy = 1000:1150;

%Afficher la fenêtre échantillon
figure
imshow(im(idx,idy, :))

im = double(im); %Transformer les valeurs des pixels en double pour pouvoir les traiter

%Moyenne et variance de l'échantillon
%Chaîne rouge
Xr = im(idx,idy, 1);
Xr = Xr(:);
mu_Xr = mean(Xr);
sigma_Xr = var(Xr);

%Chaîne verte
Xg = im(idx,idy, 2);
Xg = Xg(:);
mu_Xg = mean(Xg);
sigma_Xg = var(Xg);

%Chaîne bleue
Xb = im(idx,idy, 3);
Xb = Xb(:);
mu_Xb = mean(Xb);
sigma_Xb = var(Xb);

%La grande image
[NL, NR, NC] = size(im); %NL: Nombre de lignes
                         %NR: Nombre de colonnes
                         %NC: Nombre de couleurs (Chaînes)

%Initialiser les 'dissimilarités' qui seront les résultats de la
%comparaison entre la grande image et la fenêtre échantillon
dissimilariteR = zeros(NL, NR);
dissimilariteG = zeros(NL, NR);
dissimilariteB = zeros(NL, NR);

rayon = 17; %Le rayon et la taille en pixels de la fenêtre qui va parcourir 
%la grande image pour comparer avec la fenêtre échantillon

% for m=1:NL
%     for n=1:NC

h = waitbar(0,'Please wait...'); %Barre de chargement

for m=rayon+1:NL-rayon %Parcourir les lignes 
    
%Il ne faut pas commencer au pixel 0,0 car l'image n'existe pas à gauche et
%en haut de ces pixels.

    for n=rayon+1:NR-rayon %Parcourir les colonnes
%Y est la grande image
        Yr = im(m-rayon:m+rayon,n-rayon:n+rayon,1);
        Yg = im(m-rayon:m+rayon,n-rayon:n+rayon,2);
        Yb = im(m-rayon:m+rayon,n-rayon:n+rayon,3);
        
 %Calculer la moyenne et la variance de chaque chaîne de couleur       
        Yr = Yr(:);
        mu_Yr = mean(Yr);
        sigma_Yr = var(Yr);
       
        Yg = Yg(:);
        mu_Yg = mean(Yg);
        sigma_Yg = var(Yg);

        Yb = Yb(:);
        mu_Yb = mean(Yb);
        sigma_Yb = var(Yb);

%Calculer la fonction de similarité
        dissimilariteR(m,n) = (sigma_Xr - sigma_Yr)^2 + (mu_Xr - mu_Yr)^2 *(sigma_Xr + sigma_Yr) ;
        dissimilariteR(m,n) =  dissimilariteR(m,n) / (2*sigma_Xr * sigma_Yr);
        
        dissimilariteG(m,n) = (sigma_Xg - sigma_Yg)^2 + (mu_Xg - mu_Yg)^2 *(sigma_Xg + sigma_Yg) ;
        dissimilariteG(m,n) =  dissimilariteG(m,n) / (2*sigma_Xg * sigma_Yg);
        
        dissimilariteB(m,n) = (sigma_Xb - sigma_Yb)^2 + (mu_Xb - mu_Yb)^2 *(sigma_Xb + sigma_Yb) ;
        dissimilariteB(m,n) =  dissimilariteB(m,n) / (2*sigma_Xb * sigma_Yb);
    end

    waitbar(m/NL,h)

end

close(h);

%Afficher les images résultanes 
figure
imagesc(dissimilariteR, [0,1]) %[0,15] permet d'afficher les résultats des
%fonctions de similarités qui sont comprises entre 0 et 15.

axis image
figure
imagesc(dissimilariteG, [0,1])

axis image
figure
imagesc(dissimilariteB, [0,1])

axis image
toc