%This is 'our' Implementation of BTES algorithm of paper titled
%"binary tree-based generic demosaicking algorithm for
%multispectral filter arrays" by Lidan Miao et al.
%Vol 15 No. 11 Nov 2006, Transactions on image processing

%This code will firstly create raw image by applying their filter arrya
%and then reconstructs 3band, 4band and 5band multispectral images.
%The outputs are PSNR values, time taken and final reconstruction 
%resulting image for 5 bands case in false color composite
clc; clear all; close all;
load multiSpectralImage;
img=im2uint8(img);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reconstruction of 3 bands multispectral image
tic
[reconstImg img_] = btes3(im2double(img(:,:,1:3)));
time=toc;
reconstImg=im2uint8(reconstImg); img_=im2uint8(img_);
psnr1=myPSNR(double(img_),double(reconstImg),10);
sprintf('BTES outputs')
sprintf('3 bands: PSNR value=%f, Time Taken =%f seconds',psnr1,time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reconstruction of 4 bands multispectral image
tic
[reconstImg img_] = btes4(im2double(img(:,:,1:4)));
time=toc;
reconstImg=im2uint8(reconstImg); img_=im2uint8(img_);
psnr2=myPSNR(double(img_),double(reconstImg),10);
sprintf('4 bands: PSNR value=%f, Time Taken =%f seconds',psnr2,time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
[reconstImg img_ ]= btes5(im2double(img(:,:,1:5)));
time=toc;
reconstImg=im2uint8(reconstImg); img_=im2uint8(img_);
psnr3=myPSNR(double(img_),double(reconstImg),10);
sprintf('5 bands: PSNR value=%f, Time Taken =%f seconds',psnr3,time)

%Now we show the output of 5 bands reconstruction by doing
%histogram equilization
for i=1:5
    img_(:,:,i)=histeq(img_(:,:,i));
    reconstImg(:,:,i)=histeq(reconstImg(:,:,i));
end

imshow(img_(:,:,[1 3 5]),'initialmagnification','fit');
figure,
imshow(reconstImg(:,:,[1 3 5]),'initialmagnification','fit');
title('Reconstruced 5band multispectral image with BTES');


