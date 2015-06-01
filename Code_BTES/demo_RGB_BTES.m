%This is the demo of BTES algorithm for RGB images

clc; clear all ; close all;
    
    img=imread('testimg.png');
    img=im2double(img);
    %btes3 function will construct undersampled image and then 
    %it will reconstruct the full image and return both
    tic; [reconstImg,img_] = btes3(img); time=toc;    
    %format conversion is required for correct calculation of PSNR
    img_=im2uint8(img_);
    reconstImg=im2uint8(reconstImg);
    img_=im2uint8(img_);
    %calculte PSNR
    psnr=myPSNR(double(img_),double(reconstImg),10);    
    sprintf('BTES: PSNR=%f and time taken = %f sec',psnr,time)
    %Just show the results
    subplot(121);
    imshow(img_,'initialmagnification','fit');
    title('original image');
    subplot(122);
    imshow(reconstImg,'initialmagnification','fit');
    title('reconstruced image');
    