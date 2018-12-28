%------------------------Color Based Segmentation-------------------------%
%------Classification d'une image en utilisant le k-means Clustering------%

%Initialisation
tic
close all
clear
he=imread('D:\Polytech\APP\Prog_imagerie\Images_test\w3.jpeg');

%%
subplot(3,2,1), imshow(he), title('image originale');

%Transformer l'image en espace coloromètrique L*a*b
cform = makecform('srgb2lab');
lab_he = applycform(he,cform);

%Transformer l'image en double et transformer en matrice [nb de lignes
%de l'image * nb de colonnes de l'image,2]
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

%Nombre de clusters
nColors = 4;

%Spécifier les paramètres du clustering
[cluster_idx, cluster_center] = kmeans(ab,nColors,'Distance','sqeuclidean','Replicates',5); 
    %'cluster_idx' est un vecteur n lignes 1 colonne qui contient les
    %indices des différents clusters pour chaque observation
    %'cluster_center' est une matrice (k*colonnes) qui contient les 
    %positions des centroides pour les k clusters 
        %'Distance' spécifie la formule avec laquelle kmeans calcule la
        %distance entre une observation x et un centroide
        %En choisissant 'sqeuclidian' ce centroide est la moyenne des points du
        %cluster
        %'Replicates' est le nombre de fois que l'on répète le clustering 
        %pour augmenter la précision (parfois kmeans trouve un minimum qui 
        %n'est pas global, on répète pour être sûre d'avoir un minimum global 
        
%Mettre les indices des clusters dans une matrice 
pixel_labels = reshape(cluster_idx,nrows,ncols);

%Afficher les différentes classes présentes
subplot(3,2,2), imshow(pixel_labels,[]), title('image labeled by cluster index');

%Transformer la matrices des indices des clusters en un tableau 1*3
segmented_images = cell(1,3);

%Dupliquer le tableau 3 fois en colonnes seulement (en gardant le même
%nombre de lignes)
rgb_label = repmat(pixel_labels,[1 1 3]);

%Diviser l'image en k images en fonction de la couleur
%Le résultat est k images chacune représentant un cluster
for k = 1:nColors
    color = he;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;

end

%Afficher les clusters séparèment
subplot(3,2,3), imshow(segmented_images{1}), title('objects in cluster 1');
subplot(3,2,4), imshow(segmented_images{2}), title('objects in cluster 2');
subplot(3,2,5), imshow(segmented_images{3}), title('objects in cluster 3');
subplot(3,2,6), imshow(segmented_images{4}), title('objects in cluster 4');

toc
%%
%{
mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value);
blue_cluster_num = idx(1);
L = lab_he(:,:,1);
blue_idx = find(pixel_labels == blue_cluster_num);
L_blue = L(blue_idx);
is_light_blue = imbinarize(L_blue);

nuclei_labels = repmat(uint8(0),[nrows ncols]);
nuclei_labels(blue_idx(is_light_blue==false)) = 1;
nuclei_labels = repmat(nuclei_labels,[1 1 3]);
blue_nuclei = he;
blue_nuclei(nuclei_labels ~= 1) = 0;


subplot(3,2,6),imshow(blue_nuclei), title('blue nuclei');
%}