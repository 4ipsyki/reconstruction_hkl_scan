% simple 2D Gaussian-profile fit for the origin determination
% the scan has to be made on the direct beam at the final ydt,
% and at tth = 0 (with tthan = 0). don't forget the absorbers!

base_dirr='/asap/petra3/gpfs/p21.1/2022/data/11013053/';
savedirr_ip     = [base_dirr,'processed/inputpar/'];
name_ip          = 'ip_v1';
load([savedirr_ip,name_ip,'.mat'],'x_size','y_size','data_type');

% directory, scan name and scan number
scannr=10;
dirr = ['/asap3/petra3/gpfs/p21.1/2022/data/11013053/raw/pilatus2/hasylab_',sprintf('%05d',scannr),'/'];
file = ['hasylab_',sprintf('%05d',scannr),'_'];

%% automatic fit and plots
img=zeros(x_size,y_size);
totframes=0;

ok=1;
while ok
    try
        if data_type==1
            im=double(get_pe_new5(dirr,file,totframes+1));
        elseif data_type==2
            im=permute(double(read_cbf([dirr, file, sprintf('%05d.cbf',totframes+1)]).data),[2 1]);
        end
    catch
        break
    end
    img=img+im;
    totframes=totframes+1;
end

if totframes
    img=img/totframes;
else
    error('Couldn''t load the frame(s). Check directory and name.')
end

[maxint, maxidx]=max(img(:));

figure(1001),clf
imagesc(img)
caxis([0 maxint/2])
axis equal
title('data')

[x1,x2]=meshgrid(1:487,1:195);

ft=fittype('p00*exp(-((x1-p01)/p02).^2).*exp(-((x2-p10)/p20).^2)+p11',...
           'coefficients',{'p00','p01','p02','p10','p20','p11'},...
           'independent',{'x1','x2'});

myf=fit([x1(:),x2(:)],img(:),ft,...
        'StartPoint',[maxint x1(maxidx) 2 x2(maxidx) 2 0]);

myfeval=myf([x1(:),x2(:)]);
myfeval=reshape(myfeval,size(img));

figure(1002),clf
imagesc(myfeval)
caxis([0 maxint/2])
axis equal
title('fit')

disp(myf)
disp([newline,'orgx0 = ',num2str(myf.p10),';'])
disp(['orgy0 = ',num2str(myf.p01),';'])

