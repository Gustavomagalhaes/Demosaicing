clc; clear all ; close all;

%Load the learned interpolation weights.
    load weight5bands; 
    load MultiSpectralImage;
        
    [img_,reconstImg] = myPredict(img,X);
    
    for i=1:5
       reconstImg(:,:,i)=wiener2(reconstImg(:,:,i),[3,3]);
    end
    
    img_=im2uint16(img_);reconstImg=im2uint16(reconstImg);
    img_=im2uint8(img_);reconstImg=im2uint8(reconstImg);
    psnr=myPSNR(double(img_),double(reconstImg),10);%    
    
    %img_=im2uint16(img_);reconstImg=im2uint16(reconstImg);
    
    fprintf('psnr = %f\n',psnr);

    for i=1:5
        
        img_(:,:,i)=histeq(img_(:,:,i));
        reconstImg(:,:,i)=histeq(reconstImg(:,:,i));
    end
imshow(img_(:,:,[1 3 5]),'initialmagnification','fit');
title('orignal image');
figure,
imshow(reconstImg(:,:,[1 3 5]),'initialmagnification','fit');
title('Reconstructed Image');