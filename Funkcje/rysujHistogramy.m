function fig = rysujHistogramy(im1,im2,HDR)
im1Hist=[imhist(im1(:,:,1)) imhist(im1(:,:,2)) imhist(im1(:,:,3))];
im2Hist=[imhist(im2(:,:,1)) imhist(im2(:,:,2)) imhist(im2(:,:,3))];
HDRHist=[imhist(HDR(:,:,1)) imhist(HDR(:,:,2)) imhist(HDR(:,:,3))];

fig=figure;
subplot(3,1,1)
a=bar(im1Hist);
a(1).EdgeColor = 'red';
a(2).EdgeColor = 'green';
a(3).EdgeColor = 'blue';
xlim([0 255])
title('Obraz o krotkiej ekspozycji')
grid on

subplot(3,1,2)
b=bar(im2Hist);
b(1).EdgeColor = 'red';
b(2).EdgeColor = 'green';
b(3).EdgeColor = 'blue';
xlim([0 255])
title('Obraz o dlugiej ekspozycji')
grid on

subplot(3,1,3)
c=bar(HDRHist);
c(1).EdgeColor = 'red';
c(2).EdgeColor = 'green';
c(3).EdgeColor = 'blue';
xlim([0 255])
title('Wynik dzialania programu - HDR')
grid on

drawnow
end