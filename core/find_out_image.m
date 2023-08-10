function n_out=find_out_image(dirr, file, n_all, mask)

med_im=zeros(1,length(n_all));
ii=1;
for idx=n_all
    try
        img=get_pe_new5(dirr,file,idx);
    catch
        ii=ii+1;
        warning(['Missing frame: ',dirr, file, sprintf('%0d',idx),'.tif']);
        continue;
    end
    med_im(ii)=median(img(~mask));
    ii=ii+1;
end

thr=median(med_im)+3*1.4826*median(abs(med_im-median(med_im)));

n_out=n_all(med_im>thr);

end