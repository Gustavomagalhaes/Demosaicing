function [img,newimg]=myPredict(img,X)

img=im2double(img);
%[raw img]=makeRAW(img,size(img,3));
[img, raw, ~]=UMSF(img);
[m n dim]=size(img);


% for a 3 band image : window size is 3 by 3 
%for 4 or 5 band images: window size is 5 by 5. 
%since we are not doing prediction for border values 
%therefore reconstructed image size will be reduced appropriately
% using the variable 'x'.

if dim==3
    x=2; win=[3 3]; 
elseif dim==4 || dim==5 || dim==6 || dim==7 || dim==8
    x=4; win=[5 5];
end

newimg=zeros(m-x,n-x,dim);
[mm nn dim]=size(newimg);

rawcols=im2col(raw,win);
%multiply by the parameter 'X' and do rearrangement
for i=1:dim
    A=rawcols(:,i:dim:end)';    
  for j=1:dim
    newimg((j-1)*mm*nn+i:dim:j*mm*nn)=A*X(:,j,i); 
  end
end

%make the 'size' of img same as that of 'newimg' by removing border lines
img=img(x/2+1:end-x/2,x/2+1:end-x/2,:);
