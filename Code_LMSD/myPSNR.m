
function cpsnr=myPSNR(org,recon,skip)
org=org(skip+1:end-skip,skip+1:end-skip,:);
recon=recon(skip+1:end-skip,skip+1:end-skip,:);
[m, n,~]=size(org);
if (strcmp(class(org),'double') && strcmp(class(recon),'double'))
    
    sse=sum(sum((org-recon).^2));   
    mse=sse/(m*n);
    rmse=sqrt(sum(mse)/numel(mse));
    
    cpsnr=20*log10(255/rmse);
else
    disp('Data type should be double with values 0 to 255');
end
end
