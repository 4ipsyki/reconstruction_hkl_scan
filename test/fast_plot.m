base_dirr='~/3dhkl_scan/test/';
savedirr_ip     = [base_dirr,'processed/inputpar/'];
% name_ip          = 'ip_hor';
name_ip          = 'ip_ver';
load([savedirr_ip,name_ip,'.mat']);

% file number
% nr=10;
nr=191;

% loading the reconstruction
fl_name   = [nm_base,sprintf('%05d',nr)];
save_name = [savedirr,fl_name,'.mat'];
%save_name = [savedirr_skipnr,fl_name,'.mat'];
load(save_name,'Itot','ztot',...
               'hmin','hmax','kmin','kmax','lmin','lmax',...
               'Tctrl','err_Tctrl','Ts','err_Ts')

%%
% Lorentz normalization
data=Itot./ztot;
data(isnan(data))=0;

% Q vectors for the current voxl map
qh=linspace(hmin,hmax,n_steps(1));
qk=linspace(kmin,kmax,n_steps(2));
ql=linspace(lmin,lmax,n_steps(3));

% n is the Q-point where the plots will be performed [h0 k0 l0]
% n=[5.0 1.5 0.0];
n=[mean([hmin hmax]), mean([kmin kmax]), mean([lmin lmax])];

% half-width of the out of plane integration
dlq=0.02;

% plotting limits
hlim=[-1 1]*0.2+n(1); 
klim=[-1 1]*0.2+n(2);
llim=[-1 1]*0.2+n(3);

% colormap limits
% clim=[0 50];
clim=[0 0.1*max(data(:))];

figlabel=['file \#',num2str(nr(end)),'   ---   T = ',sprintf('%5.2f',Ts),' K'];

% for a proper plot both Itot and ztot should be given to a binning
% function. Nevertheless, in most cases, no evident difference can be seen
% 2D plot
figure(11), clf
plot_2d(data,qh,qk,ql,n,dlq,hlim,klim,llim,clim,figlabel)
% colormap viridis
% savepng([base_dirr,'processed/plots/'],[fl_name,'_2D'],200)

% 1D plot
% intlim = [0 6000]; % y-axis limits for the plot
intlim=[0 0.1*max(data(:))];
n=[mean([hmin hmax]), mean([kmin kmax]), mean([lmin lmax])]; % Q point of the cut
dlq=0.02; % half of the binning size
figure(12), clf
plot_1d(data,qh,qk,ql,n,dlq,hlim,klim,llim,intlim,figlabel)
% savepng([base_dirr,'processed/plots/'],[fl_name,'_1D'],200)

