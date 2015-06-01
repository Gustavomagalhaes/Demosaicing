clc; clear all ; close all;

%Load the learned interpolation weights.
    load wtRGB; 
    fname='testimg.png';
    img=imread(fname);
    img=im2double(img);
    
    [img_,reconstImg] = myPredict(img,X);
    img_=im2uint8(img_);
    reconstImg=im2uint8(reconstImg);
    psnr=myPSNR(double(img_),double(reconstImg),10);%    
    
    fprintf('psnr = %f\n',psnr);


imshow(img_);title('orignal image');
figure,
imshow(reconstImg)
title('Reconstructed Image');