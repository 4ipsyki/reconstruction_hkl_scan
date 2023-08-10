function [Int_total,z_total] = image2hkl(framenr,dirr,file,...
                                         omega,...
                                         x_size,y_size,rot_ax,ub,dk,P,...
                                         mask,hmax,hmin,kmax,kmin,...
                                         lmax,lmin,n_steps,bkg,scaling,...
                                         data_type)

hdelta=(hmax-hmin)/(n_steps(1)-1);
kdelta=(kmax-kmin)/(n_steps(2)-1);
ldelta=(lmax-lmin)/(n_steps(3)-1);

Int_total = zeros(n_steps);
z_total   = zeros(n_steps);

% disabling the TIFF warning
warning('off','MATLAB:imagesci:rtifc:missingPhotometricTag')

for filenumber = framenr
    disp(filenumber)
    
    if data_type==1
        try
            image = double(get_pe_new5(dirr, file, filenumber));
        catch
            warning(['Missing frame: ',dirr, file, sprintf('%05d',filenumber),'.tif']);
            continue
        end
    elseif data_type==2
        try
            image = permute(double(read_cbf([dirr, file, sprintf('%05d.cbf',filenumber)]).data),[2 1]);
        catch
            warning(['Missing frame: ',dirr, file, sprintf('%05d',filenumber),'.cbf']);
            continue
        end
    else
        disp("Data type not specified properly.")
        break
    end
    
    image = double(image*scaling(filenumber)-bkg);
    
    phi=-omega*pi/180;

    a1=cos(phi)+rot_ax(1)^2*(1-cos(phi));
    a2=rot_ax(1)*rot_ax(2)*(1-cos(phi))-rot_ax(3)*sin(phi);
    a3=rot_ax(1)*rot_ax(3)*(1-cos(phi))+rot_ax(2)*sin(phi);
    b1=rot_ax(1)*rot_ax(2)*(1-cos(phi))+rot_ax(3)*sin(phi);
    b2=cos(phi)+rot_ax(2)^2*(1-cos(phi));
    b3=rot_ax(2)*rot_ax(3)*(1-cos(phi))-rot_ax(1)*sin(phi);
    c1=rot_ax(3)*rot_ax(1)*(1-cos(phi))-rot_ax(2)*sin(phi);
    c2=rot_ax(3)*rot_ax(2)*(1-cos(phi))+rot_ax(1)*sin(phi);
    c3=cos(phi)+rot_ax(3)^2*(1-cos(phi));

    rot_phi=[a1,a2,a3;b1,b2,b3;c1,c2,c3];

    ub_rot_phi=rot_phi*ub{filenumber};

    % Zeile mal Spalte
    h=dk{filenumber}(:,:,1).*ub_rot_phi(1,1)+dk{filenumber}(:,:,2).*ub_rot_phi(2,1)+dk{filenumber}(:,:,3).*ub_rot_phi(3,1);
    k=dk{filenumber}(:,:,1).*ub_rot_phi(1,2)+dk{filenumber}(:,:,2).*ub_rot_phi(2,2)+dk{filenumber}(:,:,3).*ub_rot_phi(3,2);
    l=dk{filenumber}(:,:,1).*ub_rot_phi(1,3)+dk{filenumber}(:,:,2).*ub_rot_phi(2,3)+dk{filenumber}(:,:,3).*ub_rot_phi(3,3);

    pix_h = round(h/hdelta -(hmin-hdelta)/hdelta); %.*A.*B.*C;
    pix_k = round(k/kdelta -(kmin-kdelta)/kdelta); %.*A.*B.*C;
    pix_l = round(l/ldelta -(lmin-ldelta)/ldelta); %.*A.*B.*C;

    % apply P-corection here
    Intens = image ./P{filenumber};
    %
    final = [pix_h(1:x_size*y_size)', pix_k(1:x_size*y_size)',...
        pix_l(1:x_size*y_size)', Intens(1:x_size*y_size)',...
        mask(1:x_size*y_size)'];

    for nn=1:size(final,1)
        if final(nn,1)<n_steps(1) && final(nn,1)>0 && ...
           final(nn,2)<n_steps(2) && final(nn,2)>0 && ...
           final(nn,3)<n_steps(3) && final(nn,3)>0 && ...
           final(nn,5)==0
           Int_total(final(nn,1),final(nn,2),final(nn,3)) = ...
               Int_total(final(nn,1),final(nn,2),final(nn,3))+final(nn,4);
           z_total(final(nn,1),final(nn,2),final(nn,3))   = ...
               z_total(final(nn,1),final(nn,2),final(nn,3))+1;
        end
    end
end

% restoring the TIFF warning
warning('on','MATLAB:imagesci:rtifc:missingPhotometricTag')

end