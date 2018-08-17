function output = algorytmHDR(short, long)
% define HDR output variable
HDR = zeros(size(short));
[height, width, color] = size(HDR);
%% Create the Lum(Y) channels LUTs
% Pre-process
% Lumminance short LUT
ShortLut.x = [0    16    45    96   255];
ShortLut.y = [0    20    38    58   115];
% Lumminance long LUT
LongLut.x = [ 0 255];
LongLut.y = [ 0  140];

% Take the same points to plot the joined Lum LUT
plot_x = 0:1:255;
plot_y_short = interp1(ShortLut.x,ShortLut.y,plot_x); %LUT short
plot_y_long = interp1(LongLut.x,LongLut.y,plot_x); %LUT long


%% Create the HDR Lum channel
% The HDR algorithm
% read the Y channels

YIQ_short = rgb2ntsc(short);
YIQ_long = rgb2ntsc(long);

%% Stream image through HDR algorithm

for x=1:width
    for y=1:height
        YShort1 = round(YIQ_short(y,x,1)*255); %input short
        YLong1 = round(YIQ_long(y,x,1)*255); %input long
        
        YShort2 = YIQ_short(y,x,2); %input short
        YLong2 = YIQ_long(y,x,2); %input long
        
        YShort3 = YIQ_short(y,x,3); %input short
        YLong3 = YIQ_long(y,x,3); %input long
        
        valid_in = 1;
        
        [valid_out, x_out, y_out, HDR1, HDR2, HDR3] = mlhdlc_hdr(YShort1, YShort2, YShort3, YLong1, YLong2, YLong3, plot_y_short, plot_y_long, valid_in, x, y);
        
        % use x and y to reconstruct image
        if valid_out == 1
            HDR(y_out,x_out,1) = HDR1;
            HDR(y_out,x_out,2) = HDR2;
            HDR(y_out,x_out,3) = HDR3;
        end
    end
end
%% output HDR
output = ntsc2rgb(HDR);
end