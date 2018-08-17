function klasyfikacja = histGauss(obraz,show)
hist=imhist(rgb2gray(obraz));
if(show)
    figure
    bar(hist,'r')
    hold on
end
mean=127;
sigma=64;
x=0:255;
fx=1/sqrt(2*pi)/sigma*exp(-(x-mean).^2/2/sigma/sigma);
fx=fx-max(fx)/10;
fx=fx/max(fx);
for i=1:size(fx,2)
    if fx(i)<0
        fx(i)=0;
    end
end, clear i;

for i=1:size(hist,1)
    histfx(i)=hist(i)*fx(i);
end, clear i;
if(show)
    plot(fx*max(histfx),'Color',[0 0.3 1])
    bar(histfx,'g')
    ylim([0 max(histfx)])
    xlim([0 255])
    hold off
end
klasyfikacja=sum(histfx);
end