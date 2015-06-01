function [] = BID()

%===============================================================
% Bilinear Interpolation of the missing pixels using 9 primaries
% 9 Primaries Bilinear Interpolation
%   1 2 3
%   4 5 6 
%   7 8 9
% Single Panel Image
%===============================================================

format long;
load('/Users/gustavopereira/Documents/MATLAB/9primaries.mat')
load('/Users/gustavopereira/Documents/MATLAB/RGB.mat')

imgCol = 512;
imgRow = 512;
imgs = 31;
SPI = zeros(imgRow,imgCol);

Xo1 = 0;
Xo2 = 0;
Xo3 = 0;
Xo4 = 0;
Xo5 = 0;
Xo6 = 0;
Xo7 = 0;
Xo8 = 0;
Xo9 = 0;

%===============================================================
% DEFINING THE SINGLE PANEL IMAGE #1
for (index = 1:imgs)
    img = imread(strcat('/Users/gustavopereira/Documents/MATLAB/beads_ms/beads_ms_',num2str(index),'.png'));
    
    Xo1 = Xo1 + (img * p9(1,index));
    Xo2 = Xo2 + (img * p9(2,index));
    Xo3 = Xo3 + (img * p9(3,index));
    Xo4 = Xo4 + (img * p9(4,index));
    Xo5 = Xo5 + (img * p9(5,index));
    Xo6 = Xo6 + (img * p9(6,index));
    Xo7 = Xo7 + (img * p9(7,index));
    Xo8 = Xo8 + (img * p9(8,index));
    Xo9 = Xo9 + (img * p9(9,index));
    
    img(1:3:imgRow,1:3:imgCol) = img(1:3:imgRow,1:3:imgCol)*p9(1,index);
    img(1:3:imgRow,2:3:imgCol) = img(1:3:imgRow,2:3:imgCol)*p9(2,index); 
    img(1:3:imgRow,3:3:imgCol) = img(1:3:imgRow,3:3:imgCol)*p9(3,index); 
    
    img(2:3:imgRow,1:3:imgCol) = img(2:3:imgRow,1:3:imgCol)*p9(4,index); 
    img(2:3:imgRow,2:3:imgCol) = img(2:3:imgRow,2:3:imgCol)*p9(5,index);
    img(2:3:imgRow,3:3:imgCol) = img(2:3:imgRow,3:3:imgCol)*p9(6,index); 
    
    img(3:3:imgRow,1:3:imgCol) = img(3:3:imgRow,1:3:imgCol)*p9(7,index); 
    img(3:3:imgRow,2:3:imgCol) = img(3:3:imgRow,2:3:imgCol)*p9(8,index); 
    img(3:3:imgRow,3:3:imgCol) = img(3:3:imgRow,3:3:imgCol)*p9(9,index);
    
    SPI = SPI + im2double(img); 
end

%===============================================================
% DEFINING THE SINGLE PANEL IMAGE #2 - This is the old code with loops
% counter = 1;
% level = 0;
% for (index = 1:imgs)
%     query = strcat('/Users/gustavopereira/Documents/MATLAB/beads_ms/beads_ms_',num2str(index),'.png');
%     img = imread(query);
%     for (row = 1:imgRow)
%         for (col = 1:imgCol)
%             SPI(row,col) = SPI(row,col) + img(row,col) * p9(counter+level,index);
%             
%             if (counter == 1)
%                 counter = 2;  
%             elseif (counter == 2)
%                 counter = 3;
%             elseif (counter == 3)
%                 counter = 1;
%             end
%         end
%     if (level == 0)
%         level = 3;
%     elseif (level == 3)
%        level = 6;
%     elseif (level == 6)
%        level = 0;
%     end
%     counter = 1;
%     end 
% end
%===============================================================

M = 513;
N = 513;

mask1 = repmat([1 0 0; 0 0 0; 0 0 0], M/3, N/3);
mask2 = repmat([0 1 0; 0 0 0; 0 0 0], M/3, N/3);
mask3 = repmat([0 0 1; 0 0 0; 0 0 0], M/3, N/3);
mask4 = repmat([0 0 0; 1 0 0; 0 0 0], M/3, N/3);
mask5 = repmat([0 0 0; 0 1 0; 0 0 0], M/3, N/3);
mask6 = repmat([0 0 0; 0 0 1; 0 0 0], M/3, N/3);
mask7 = repmat([0 0 0; 0 0 0; 1 0 0], M/3, N/3);
mask8 = repmat([0 0 0; 0 0 0; 0 1 0], M/3, N/3);
mask9 = repmat([0 0 0; 0 0 0; 0 0 1], M/3, N/3);
 
P1=SPI.*mask1(1:512,1:512);
P2=SPI.*mask2(1:512,1:512);
P3=SPI.*mask3(1:512,1:512);
P4=SPI.*mask4(1:512,1:512);
P5=SPI.*mask5(1:512,1:512);
P6=SPI.*mask6(1:512,1:512);
P7=SPI.*mask7(1:512,1:512);
P8=SPI.*mask8(1:512,1:512);
P9=SPI.*mask9(1:512,1:512);

%===============================================================
zero = [0 0 0 0 0 0 0];
doubleZero = [0 0 0 0 0 0 0; 0 0 0 0 0 0 0];
first = [1 0 0 1 0 0 1];
second = [0 0 1 0 0 1 0];
third = [0 1 0 0 1 0 0];

M2 = [second; doubleZero; second; doubleZero; second]/6; 
M3 = [third; doubleZero; third; doubleZero; third]/6; 

M4 = [doubleZero; first; doubleZero; first; zero]/6;
M5 = [doubleZero; second; doubleZero; second; zero]/4;
M6 = [doubleZero; third; doubleZero; third; zero]/4;

M7 = [zero; first; doubleZero; first; doubleZero]/6;
M8 = [zero; second; doubleZero; second; doubleZero]/4;
M9 = [zero; third; doubleZero; third; doubleZero]/4;


% PIXEL PRIMARY 1
pixel_1 = P1(1:3:imgRow,1:3:imgCol);

P1 = P1 + imfilter(P1, M2);
pixel_2 = P1(1:3:imgRow,2:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M3);
pixel_3 = P1(1:3:imgRow,3:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M4);
pixel_4 = P1(2:3:imgRow,1:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M5);
pixel_5 = P1(2:3:imgRow,2:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M6);
pixel_6 = P1(2:3:imgRow,3:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M7);
pixel_7 = P1(3:3:imgRow,1:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M8);
pixel_8 = P1(3:3:imgRow,2:3:imgCol);

P1=SPI.*mask1(1:512,1:512);
P1 = P1 + imfilter(P1, M9);
pixel_9 = P1(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi1 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 2
pixel_2 = P2(1:3:imgRow,2:3:imgCol);

P2 = P2 + imfilter(P2, M3);
pixel_1 = P2(1:3:imgRow,1:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M2);
pixel_3 = P2(1:3:imgRow,3:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M6);
pixel_4 = P2(2:3:imgRow,1:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M4);
pixel_5 = P2(2:3:imgRow,2:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M5);
pixel_6 = P2(2:3:imgRow,3:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M9);
pixel_7 = P2(3:3:imgRow,1:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M7);
pixel_8 = P2(3:3:imgRow,2:3:imgCol);

P2=SPI.*mask2(1:512,1:512);
P2 = P2 + imfilter(P2, M8);
pixel_9 = P2(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi2 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 3
pixel_3 = P3(1:3:imgRow,3:3:imgCol);

P3 = P3 + imfilter(P3, M2);
pixel_1 = P3(1:3:imgRow,1:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M3);
pixel_2 = P3(1:3:imgRow,2:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M5);
pixel_4 = P3(2:3:imgRow,1:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M6);
pixel_5 = P3(2:3:imgRow,2:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M4);
pixel_6 = P3(2:3:imgRow,3:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M8);
pixel_7 = P3(3:3:imgRow,1:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M9);
pixel_8 = P3(3:3:imgRow,2:3:imgCol);

P3=SPI.*mask3(1:512,1:512);
P3 = P3 + imfilter(P3, M7);
pixel_9 = P3(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi3 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 4
pixel_4 = P4(2:3:imgRow,1:3:imgCol);

P4 = P4 + imfilter(P4, M7);
pixel_1 = P4(1:3:imgRow,1:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M8);
pixel_2 = P4(1:3:imgRow,2:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M9);
pixel_3 = P4(1:3:imgRow,3:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M2);
pixel_5 = P4(2:3:imgRow,2:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M3);
pixel_6 = P4(2:3:imgRow,3:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M4);
pixel_7 = P4(3:3:imgRow,1:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M5);
pixel_8 = P4(3:3:imgRow,2:3:imgCol);

P4=SPI.*mask4(1:512,1:512);
P4 = P4 + imfilter(P4, M6);
pixel_9 = P4(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi4 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 5
pixel_5 = P5(2:3:imgRow,2:3:imgCol);

P5 = P5 + imfilter(P5, M9);
pixel_1 = P5(1:3:imgRow,1:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M7);
pixel_2 = P5(1:3:imgRow,2:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M8);
pixel_3 = P5(1:3:imgRow,3:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M3);
pixel_4 = P5(2:3:imgRow,1:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M2);
pixel_6 = P5(2:3:imgRow,3:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M6);
pixel_7 = P5(3:3:imgRow,1:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M4);
pixel_8 = P5(3:3:imgRow,2:3:imgCol);

P5=SPI.*mask5(1:512,1:512);
P5 = P5 + imfilter(P5, M5);
pixel_9 = P5(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi5 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 6
pixel_6 = P6(2:3:imgRow,3:3:imgCol);

P6 = P6 + imfilter(P6, M8);
pixel_1 = P6(1:3:imgRow,1:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M9);
pixel_2 = P6(1:3:imgRow,2:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M7);
pixel_3 = P6(1:3:imgRow,3:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M2);
pixel_4 = P6(2:3:imgRow,1:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M3);
pixel_5 = P6(2:3:imgRow,2:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M5);
pixel_7 = P6(3:3:imgRow,1:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M6);
pixel_8 = P6(3:3:imgRow,2:3:imgCol);

P6=SPI.*mask6(1:512,1:512);
P6 = P6 + imfilter(P6, M4);
pixel_9 = P6(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi6 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 7
pixel_7 = P7(3:3:imgRow,1:3:imgCol);

P7 = P7 + imfilter(P7, M4);
pixel_1 = P7(1:3:imgRow,1:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M5);
pixel_2 = P7(1:3:imgRow,2:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M6);
pixel_3 = P7(1:3:imgRow,3:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M7);
pixel_4 = P7(2:3:imgRow,1:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M8);
pixel_5 = P7(2:3:imgRow,2:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M9);
pixel_6 = P7(2:3:imgRow,3:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M2);
pixel_8 = P7(3:3:imgRow,2:3:imgCol);

P7=SPI.*mask7(1:512,1:512);
P7 = P7 + imfilter(P7, M3);
pixel_9 = P7(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi7 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 8
pixel_8 = P8(3:3:imgRow,2:3:imgCol);

P8 = P8 + imfilter(P8, M6);
pixel_1 = P8(1:3:imgRow,1:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M4);
pixel_2 = P8(1:3:imgRow,2:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M5);
pixel_3 = P8(1:3:imgRow,3:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M9);
pixel_4 = P8(2:3:imgRow,1:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M7);
pixel_5 = P8(2:3:imgRow,2:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M8);
pixel_6 = P8(2:3:imgRow,3:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M3);
pixel_7 = P8(3:3:imgRow,1:3:imgCol);

P8=SPI.*mask8(1:512,1:512);
P8 = P8 + imfilter(P8, M2);
pixel_9 = P8(3:3:imgRow,3:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi8 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

% PIXEL PRIMARY 9
pixel_9 = P9(3:3:imgRow,3:3:imgCol);

P9 = P9 + imfilter(P9, M5);
pixel_1 = P9(1:3:imgRow,1:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M6);
pixel_2 = P9(1:3:imgRow,2:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M4);
pixel_3 = P9(1:3:imgRow,3:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M8);
pixel_4 = P9(2:3:imgRow,1:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M9);
pixel_5 = P9(2:3:imgRow,2:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M7);
pixel_6 = P9(2:3:imgRow,3:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M2);
pixel_7 = P9(3:3:imgRow,1:3:imgCol);

P9=SPI.*mask9(1:512,1:512);
P9 = P9 + imfilter(P9, M3);
pixel_8 = P9(3:3:imgRow,2:3:imgCol);

fullHD(1:3:imgRow,1:3:imgCol) = pixel_1;
fullHD(1:3:imgRow,2:3:imgCol) = pixel_2;
fullHD(1:3:imgRow,3:3:imgCol) = pixel_3;
fullHD(2:3:imgRow,1:3:imgCol) = pixel_4;
fullHD(2:3:imgRow,2:3:imgCol) = pixel_5;
fullHD(2:3:imgRow,3:3:imgCol) = pixel_6;
fullHD(3:3:imgRow,1:3:imgCol) = pixel_7;
fullHD(3:3:imgRow,2:3:imgCol) = pixel_8;
fullHD(3:3:imgRow,3:3:imgCol) = pixel_9;
Xi9 = fullHD;
clear fullHD;
clear pixel_1;
clear pixel_2;
clear pixel_3;
clear pixel_4;
clear pixel_5;
clear pixel_6;
clear pixel_7;
clear pixel_8;
clear pixel_9;

%===============================================================
% imshow(Xi9/max(Xi9(:)))
% imshow(SPI/max(SPI(:))) % See Single Panel Image
% imshow(fullHD/max(fullHD(:))) % See image of only one primary
end
