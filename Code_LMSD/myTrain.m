function X=myTrain(img)
%Run this function if you want to learn interpolation weights on your
%image dataset. The input "img" will be a big image that we can obtain by
%vertically concatenating our training images. For example we can
%concatenate 4 images of 512 by 512 to make a 2096 by 512 image for training.
%which can be passed as input in this function.

[img raw umsf]=UMSF(img); %do uniform sampling on it.
[m,n,dim]=size(img);
%set the window size for different dimensions.
if dim==3
    w=3;
elseif dim==4 || dim==5 || dim==6 || dim==7 || dim==8
    w=5;
end

%use rawimg to extract training data.
%These are the three variables in y=AX
y=zeros((m-w+1)*(n-w+1)/dim,dim,dim);
A=zeros(((m-w+1)*(n-w+1))/dim,w*w,dim);
X=zeros(w*w,dim,dim);
%midp=zeros(((m-2)*(n-2))/3,3,dim);

%Make the matrix A
cols=im2col(raw,[w w]);
for i=1:dim
    temp=cols(:,i:dim:end);
    A(:,:,i)=temp';        
end

%Make the vectors y using orgiginal image
p=ceil(w/2);
temp=img(p:end-p+1,p:end-p+1,:);
tempu=umsf(p:end-p+1,p:end-p+1);
for i=1:dim
    for j=1:dim
        temp1=temp(:,:,j);
        y(:,j,i)=temp1(tempu==i);
    end
end

%find the least square solution
for i=1:dim
    for j=1:dim
        X(:,j,i)=A(:,:,i)\y(:,j,i);
    end
end
