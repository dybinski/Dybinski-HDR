%%
% Projekt:    Program tworzacy zdjecie o szerokim zakresie dynamicznym
%             (HDR) z szeregu zdjec wykonanych bez statywu.
% Autor:      Nikodem Dybinski
%             Inzynieria Mechatroniczna, semestr VI
%             Wydzial Inzynierii Mechanicznej i Robotyki
%             Akademia Gorniczo Hutnicza im. Stanislawa
%             Staszica w Krakowie
% Przedmiot:  Techniki Wizyjne
% Prowadzacy: dr inz. Ziemowit Dworakowski
%             Katedra Robotyki i Mechatroniki
%%
clear all
close all
clc
addpath('Funkcje')
obrazy=dir('Obrazy');
disp('HDR bez statywu - Nikodem Dybinski')
disp('----------------------------------')
%% Parametry
disp('Dostepne bazy zdjec:')
for i=3:size(obrazy,1)
    disp(['   ' num2str(i-2) '. ' obrazy(i).name]);
end
wybor=input(['Wybierz baze zdjec (1-' num2str(size(obrazy,1)-2) '): ']);
name=obrazy(wybor+2).name;        %nazwa folderu zawierajacego zestaw zdjec
rozszerzenie='jpg'; %szukane rozszerzenie zdjec
disp('Dostepne algorytmy:')
disp('   1. Podzial obrazow na jasne i ciemne, wybor najwiekszej sumy srodkow histogramow.')
disp('   2. Wybor najwiekszej sumy srodkow histogramow.')
disp('   3. Przeprowadzenie oceny jakosci dzialania algorytmu HDR dla kazdej pary. (dlugi czas trwania)')
algorytm=input(['Wybierz rodzaj algorytmu wyboru pary zdjec (1-3): ']);
wybor=input('Wyswietlic kolejne kroki dzialania programu? (0-1): ');
if wybor == 1
    show = true;
else
    show = false;
end
clear wybor
disp('----------------------------------')
disp(['Wybrane parametry programu:'])
disp(['              Zestaw zdjec: "' name '" (rozszerzenie "' rozszerzenie '")'])
disp(['                  Algorytm: ' num2str(algorytm)])
disp('----------------------------------')
disp('Rozpoczecie pracy programu.')
%% Wczytanie zdjec
file = dir(fullfile('Obrazy',name,['*.' rozszerzenie])); %wczytanie obrazow z pliku
NF = length(file);  %ilosc wczytanych obrazow
if NF<2
    error('Nie odnaleziono wystarczajacej ilosci zdjec! (minimum 2)')
end
im = cell(NF,2);    %definiowanie przestrzeni danych
for i=1:1:NF        %wczytanie obrazow do przestrzeni danych
    im{i,1} = imread(fullfile('Obrazy',name, file(i).name)); %wczytanie obrazow
    im{i,2} = file(i).name;    %wczytanie nazw plikow
end, clear i file ;
if NF<5
    disp(['Wczytano ' num2str(NF) ' zdjecia.'])
else
    disp(['Wczytano ' num2str(NF) ' zdjec.'])
end
clear NF name rozszerzenie
%% Selekcja obrazow oraz ich prezentacja
[short,long]=wybierzPare(im,algorytm,false);
disp(['Obrazy wybrane jako wejscie do algorytmu HDR: ' im{short,2} ' oraz ' im{long,2}])
if(show)
    figure
    imshowpair(im{short,1},im{long,1},'montage')
    title(['Obrazy wybrane jako wejscie do algorytmu HDR: ' im{short,2} ' oraz ' im{long,2}])
    drawnow
end
%% Dopasowanie obrazow
outputView = imref2d(size(im{short,1}));
trans=obliczTransformacje(im{short,1},im{long,1},show); %liczenie transformacji
long_adjusted = imwarp(im{long,1},trans,'OutputView',outputView);  %wykonanie transformacji
%% Przeprowadzenie algorytmu HDR
HDR=algorytmHDR(im{short,1},long_adjusted);
%% Kadrowanie
disp('Wybierz obszar wspolny dopasowanych zdjec...')
figure
HDR = imcrop(HDR);
%% Prezentacja wynikow
figure
imshow(HDR);
title('Wynik dzialania programu')
drawnow
if(show)
    rysujHistogramy(im{short,1},im{long,1},HDR);
end
disp('Zakonczenie pracy programu.')