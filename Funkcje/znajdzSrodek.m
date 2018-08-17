function srodek = znajdzSrodek(im)
sr=zeros(1,size(im,1));
a=zeros(1,254);
for i=1:size(im,1)
    hist=imhist(rgb2gray(im{i,1}));
    for j=2:254  %szukamy punktu, wzgledem ktorego sumy lewej i prawej czesci histogramu sa najbardziej zblizone
        a(j)=abs(sum(hist((j+1):256))-sum(hist(1:j)));
    end
    [~,sr(i)]=min(a(31:226));
end
sr=sr+30;
srodek=round(sum(sr)/length(sr));
end