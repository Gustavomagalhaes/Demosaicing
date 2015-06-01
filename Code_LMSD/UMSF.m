
function [img raw umsf]=UMSF(img)
%This function will generate a mosaiced raw image for upto 6 bands using
% our proposed unifrom multispectral filter.
%Input is a multispectral image of size m*n*k and output "raw" will be 
%of size m*n 


img=im2double(img);
[m,n,dim]=size(img);
%set the window size for different dimensions.
if dim==3
    w=3;
elseif dim==4 || dim==5 || dim==6 || dim==7 || dim==8
    w=5;
end
%update the rows and columns so that correct no. of samples are picked up.
m=floor((m-w)/dim)*dim+w;
n=floor((n-w+1)/dim)*dim+w-1;
img=img(1:m,1:n,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msf=zeros(dim,dim);
z=1:dim;

%Generate the uniform pattern for K dimensional image
for i=1:dim
    msf(i,:)=circshift(z,[0 -(i-1)]);
end
%shift one row up for the case of 3 and 5 dimensions. for 4 dim it does not
%require any change.
if(dim==3 || dim==5)
        msf=circshift(msf,[0 -1]);        
elseif(dim==6)
    msf=circshift(msf,[0 -2]);
    
end

umsf=repmat(msf,ceil(m/dim),ceil(n/dim));
umsf=umsf(1:m,1:n);

%Now use this pattern to make raw image.
rawimg=zeros(size(img));
for i=1:dim
   temp=umsf==i;
   rawimg(:,:,i)=temp.*img(:,:,i);
end
raw=sum(rawimg,3);