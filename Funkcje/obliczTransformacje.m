function tform = obliczTransformacje(im1,im2,show)
im1=histeq(rgb2gray(im1));
im2=histeq(rgb2gray(im2));
%%
% Wykryj i wyekstraktuj cechy z obu obrazow
pts1  = detectSURFFeatures(im1);
pts2 = detectSURFFeatures(im2);
[cechy1,validpts1] = extractFeatures(im1, pts1);
[cechy2,validpts2] = extractFeatures(im2,pts2);
%%
% Dopasuj cechy
pary = matchFeatures(cechy1,cechy2);
dopasowanepts1  = validpts1(pary(:,1));
dopasowanepts2 = validpts2(pary(:,2));
if(show)
    figure; showMatchedFeatures(im1,im2,dopasowanepts1,dopasowanepts2);
    title(['Dopasowane cechy. Ilosc cech: ' num2str(length(dopasowanepts1))]);
    drawnow
end
%%
% Odrzuc niepoprawne dopasowania i oblicz transformacje ('similarity')
[tform,poprawnepts1,poprawnepts2] = estimateGeometricTransform(dopasowanepts2,dopasowanepts1,'similarity');
if(show)
    figure; showMatchedFeatures(im1,im2,poprawnepts2,poprawnepts1);
    title(['Dopasowane cechy (po odrzuceniu blednych). Ilosc cech: ' num2str(length(poprawnepts1))]);
    drawnow
end
end