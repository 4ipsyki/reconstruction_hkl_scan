base_dirr='~/3dhkl_scan/test/';
savedirr_ip     = [base_dirr,'processed/inputpar/'];
% name_ip          = 'ip_hor';
name_ip          = 'ip_ver';
load([savedirr_ip,name_ip,'.mat']);

% adding scripts directories to the mathlab path
addpath(base_dirr);
addpath('~/3dhkl_scan/core/');

% mask for bad pixels and gaps.
% pixels marked (as 1) in the mask will not be used in the reconstruction.
mask = load([base_dirr,'mask_pilatus100k.mat']); mask=mask.mask_pilatus100k;

% if skip_flag = 1, an additional reconstruction without skipnr frames will be performed (see below)
skip_flag = 0;

% scan numbers to be reconstructed
% nr=10;
nr=191;

for idx = nr
    % scan name
    fl_name   = [nm_base,sprintf('%05d',idx)];
    % scan directory
    dirr      = [base_dirr,'raw/pilatus2/',fl_name,'/'];
    % frame generic-name without the number 
    file      = [fl_name,'_'];
    
    fid=fopen([dirr_onl,fl_name,'.fio'],'r');
    if ~(fid <0) 
        disp([fl_name,'.fio'])
        % transformations: det_dist, orgx, orgy, ub
        [tth, om, chi, phi] = get_angles_fio([dirr_onl,fl_name,'.fio']);
        ld=length(tth); det_dist=zeros(ld,1);
        orgx=zeros(ld,1); orgy=zeros(ld,1); ub=cell(ld,1);
        for jj=1:ld
            det_dist(jj) = det_dist0 * cosd(alpha) / cosd(alpha+tth(jj)) + D1;
            switch detector
                case 1
                    orgx(jj) = orgx0;
                    orgy(jj) = orgy0 + det_dist(jj)*tand(tth(jj))/dx;
                case 2
                    orgx(jj) = orgx0 + det_dist(jj)*tand(tth(jj))/dx;
                    orgy(jj) = orgy0;
            end
            ub{jj} = online2hkl_matrix(ub_online,om(jj),chi(jj),phi(jj));
        end

        [d,dt]=bw5data([dirr_onl,fl_name,'.fio']);
        framenr = 1:size(d,1);
        
        % virtual counters for h, k, and l to extract automatically
        % the center h0, k0, l0 coordinates for the reconstruction.
        % when not applicable, define h0, k0 and l0 manually.
        % instead of defining the counter, one can specify the collumn
        % number instead of strmatch(...).
        vc='vc25_h';        tt=d(:,strmatch(vc,dt,'exact')); h0=mean(tt);
        vc='vc26_k';        tt=d(:,strmatch(vc,dt,'exact')); k0=mean(tt);
        vc='vc27_l';        tt=d(:,strmatch(vc,dt,'exact')); l0=mean(tt);
        hmin = h0 - hdelta; hmax= h0 + hdelta;
        kmin = k0 - kdelta; kmax= k0 + kdelta;
        lmin = l0 - ldelta; lmax= l0 + ldelta;

        % counter for the incident flux (before absorbers)
        % instead of defining the counter, one can specify the collumn
        % number instead of strmatch(...).
        vc='exp_c01'; tt=d(:,strmatch(vc,dt,'exact'));
        % the intensity correction is sdcaled back by the average flux per second.
        % in this way, the intensity of each voxel in the reconstruction will be in cts/s.
        % adjust the below number when necessary, (it should be the same for all the reconstructions in a particular experiment)
        int_corr = 1./tt*2.4e+05;
        
        % scaling factor from absorber
        atten = get_atten([dirr_onl,fl_name,'.fio']);
        % 1/mu of Ta at 101.61 keV = 0.148320480 mm
        % each absorber tickeness is atten * 0.1 mm Ta
        % adjust if energy is different from http://www.csrri.iit.edu/periodic-table.html
        ab_corr = exp(atten*0.1/0.148320480);
        int_corr = int_corr * ab_corr;
        
        % virtual counter for temperature reading from vti/cold-finger sensor
        vc='vc6_t_ctrl'; tt=d(:,strmatch(vc,dt,'exact'));
        Tctrl = mean(tt); err_Tctrl = std(tt);
        
        % virtual counter for temperature reading from sample sensor
        vc='vc7_t_sample'; tt=d(:,strmatch(vc,dt,'exact'));
        Ts = mean(tt); err_Ts = std(tt);
        
        % searching for abnomalous-background frames
        skipnr = find_out_image(dirr,file,framenr,mask);
        
        % calculating fixed parameters and matrices
        for idxf=framenr
        [dk{idxf},P{idxf}] = calc_dk_P(orgx(idxf),orgy(idxf),det_dist(idxf),ki_vec,rot_ax,...
                                       pol_plane_normal,pol_deg,x_size,y_size,hor_angle,...
                                       det_x,det_y,vert_angle,dx,dy,lambda);
        end
        
        try
            % normal reconstruction with all frames
            [Itot,ztot] = image2hkl(framenr,dirr,file,...
                                    0,x_size,y_size,...
                                    rot_ax,ub,dk,P,mask,hmax,hmin,kmax,kmin,...
                                    lmax,lmin,n_steps,bkg,int_corr,data_type);
            %         % Lorentz correction
            %         Int_total_t = Itot ./ double(ztot);              
            %         Int_total_t(isnan(Int_total_t)) = 0;

            % saving
            save_name = [savedirr,fl_name,'.mat'];
            save(save_name,'Itot','ztot',...
                       'hmin','hmax','kmin','kmax','lmin','lmax',...
                       'Tctrl','err_Tctrl','Ts','err_Ts','-v7.3')
            
            if skip_flag
                % reconstruction wthouth outlier frames listed in skipnr
                framenr(skipnr)=[]; 
                [Itot,ztot] = image2hkl(framenr,dirr,file,...
                                    0,x_size,y_size,...
                                    rot_ax,ub,dk,P,mask,hmax,hmin,kmax,kmin,...
                                    lmax,lmin,n_steps,bkg,int_corr,data_type);
                %         % Lorentz correction
                %         Int_total_t = Itot ./ double(ztot);              
                %         Int_total_t(isnan(Int_total_t)) = 0;

                % saving
                save_name = [savedirr_skipnr,fl_name,'.mat'];
                save(save_name,'Itot','ztot',...
                           'hmin','hmax','kmin','kmax','lmin','lmax',...
                           'Tctrl','err_Tctrl','Ts','err_Ts','-v7.3')
             end
        catch
            warning('Reconstruction error');
            warning(['Skipping reconstruction of ',file(1:end-1)]);
        end
    else
        warning(['File not found: ',[dirr_onl,fl_name,'.fio']]);
        warning(['Skipping reconstruction of ',file(1:end-1)]);
    end
end

