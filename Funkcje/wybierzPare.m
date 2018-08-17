function [shortIdx,longIdx] = wybierzPare(im,method,show)
%% Wstepne definicje
NF=size(im,1);      %odczytanie ilosci zdjec
switch(method)
    case 1      %podzial obrazow na jasne i ciemne, wybor najwiekszej sumy srodkow histogramow
        brightIdx=[];
        darkIdx=[];
        %% Podzial obrazow na jasniejsze i ciemniejsze
        srodek=znajdzSrodek(im);
        for m=1:NF
            hist = imhist(rgb2gray(im{m,1}));
            low = sum(hist(1:srodek));
            high = sum(hist((srodek+1):256));
            if low < high   %wiecej wartosci jasnych ni¿ ciemnych
                brightIdx=[brightIdx m];
                if(show)
                    figure
                    bar(hist)
                    xlim([0 255])
                    ylim([0 max(hist)+100])
                    grid on
                    hold on
                    plot([srodek srodek],[0 max(hist)+100],'r--')
                    hold off
                    title(['Bright (' num2str(low) ':' num2str(high) ')'])
                end
            else                             %wiecej wartosci ciemnych niz jasnych
                darkIdx=[darkIdx m];
                if(show)
                    figure
                    bar(hist)
                    xlim([0 255])
                    ylim([0 max(hist)+100])
                    grid on
                    hold on
                    plot([srodek srodek],[0 max(hist)+100],'r--')
                    hold off
                    title(['Dark (' num2str(low) ':' num2str(high) ')'])
                end
            end
        end, clear m;
        if isempty(brightIdx)
            brightness=0;
            for x=1:length(darkIdx)
                hist = imhist(rgb2gray(im{darkIdx(x),1}));
                high = sum(hist((srodek+1):256));
                if high > brightness
                    brightness = high;
                    brightIdx=darkIdx(x);
                end
            end
            
        end
        if isempty(darkIdx)
            brightness=0;
            for x=1:length(brightIdx)
                hist = imhist(rgb2gray(im{brightIdx(x),1}));
                low = sum(hist(1:srodek));
                if low > brightness
                    brightness = low;
                    darkIdx=brightIdx(x);
                end
            end
        end
        
        %% Przeprowadzenie klasyfikacji dla kazdej pary obrazow
        sumMatrix=zeros(length(brightIdx),length(darkIdx));    %zdefiniowanie macierzy klasyfikacyjnej obrazow
        for m=1:length(brightIdx)
            
            for n=1:length(darkIdx)
                if brightIdx(m)~=darkIdx(n)
                    %sumMatrix(m,n)=histGauss(im{m,1},false)+histGauss(im{n,1},false);
                    sumMatrix(m,n)=histGauss(im{m,1}+im{n,1},false);
                end
            end
        end, clear m n;
        %% Odczyt najlepszej klasyfikacji
        [~,I]=max(sumMatrix(:));
        [bIdx, dIdx]=ind2sub(size(sumMatrix),I);
        shortIdx=darkIdx(dIdx);
        longIdx=brightIdx(bIdx);
    case 2  %wybor najwiekszej sumy srodkow histogramow
        sumMatrix=zeros(NF);    %zdefiniowanie macierzy klasyfikacyjnej obrazow
        %% Przeprowadzenie klasyfikacji dla kazdej pary obrazow
        for m=1:NF
            for n=1:NF
                if m~=n
                    sumMatrix(m,n)=histGauss([im{m,1}+im{n,1}],false);
                end
            end
        end, clear m n;
        %% Odczyt najlepszej klasyfikacji
        [~,I]=max(sumMatrix(:));
        [im1, im2]=ind2sub(size(sumMatrix),I);
        %% Uszeregowanie wybranej pary wzgledem czasu ekspozycji
        hist1=imhist(rgb2gray(im{im1,1}));
        hist2=imhist(rgb2gray(im{im2,1}));
        if(sum(hist1(1:50))>sum(hist2(1:50)))
            shortIdx=im1;
            longIdx=im2;
        else
            shortIdx=im2;
            longIdx=im1;
        end
    case 3  %Przeprowadzenie oceny jakosci dzialania algorytmu HDR dla kazdej pary
        sumMatrix=zeros(NF);    %zdefiniowanie macierzy klasyfikacyjnej obrazow
        %% Przeprowadzenie algorytmu HDR dla kazdej pary obrazow
        for m=1:NF
            for n=1:NF
                if m~=n
                    disp(['m: ' num2str(m) ', n: ' num2str(n)])
                    tryHDR=algorytmHDR(im{m,1},im{n,1});
                    sumMatrix(m,n)=histGauss(tryHDR,false);
                end
            end
        end, clear m n;
        %% Odczyt najlepszej klasyfikacji
        [~,I]=max(sumMatrix(:));
        [im1, im2]=ind2sub(size(sumMatrix),I);
        %% Uszeregowanie wybranej pary wzgledem czasu ekspozycji
        hist1=imhist(rgb2gray(im{im1,1}));
        hist2=imhist(rgb2gray(im{im2,1}));
        if(sum(hist1(1:50))>sum(hist2(1:50)))
            shortIdx=im1;
            longIdx=im2;
        else
            shortIdx=im2;
            longIdx=im1;
        end
end
end