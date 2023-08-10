base_dirr='/asap/petra3/gpfs/p21.1/2022/data/11013053/';
savedirr_ip     = [base_dirr,'processed/inputpar/'];
name_ip          = 'ip_v1';
load([savedirr_ip,name_ip,'.mat']);

% loading data1
nr1=292;
fl_name   = [nm_base,sprintf('%05d',nr1)];
save_name = [savedirr,fl_name,'.mat'];
%save_name = [savedirr_skipnr,fl_name,'.mat'];
load(save_name,'Itot','ztot',...
               'hmin','hmax','kmin','kmax','lmin','lmax',...
               'Tctrl','err_Tctrl','Ts','err_Ts')
data1=Itot./ztot;
data1(isnan(data1))=0;
Ts1=Ts;

% loading data2
nr2=501;
fl_name   = [nm_base,sprintf('%05d',nr2)];
save_name = [savedirr,fl_name,'.mat'];
%save_name = [savedirr_skipnr,fl_name,'.mat'];
load(save_name,'Itot','ztot',...
               'hmin','hmax','kmin','kmax','lmin','lmax',...
               'Tctrl','err_Tctrl','Ts','err_Ts')
data2=Itot./ztot;
data2(isnan(data2))=0;
Ts2=Ts;

diff_data = data2-data1;

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
hlim=[-1 1]+n(1); 
klim=[-1 1]+n(2);
llim=[-1 1]+n(3);

% colormap limits
% clim=[0 50];
clim=[0 0.25*max(data(:))];

figlabel=['file \#',num2str(nr2(end)),' - \#',,num2str(nr1(end)),...
          '   ---   T = ',sprintf('%5.2f',Ts2),' - ',sprintf('%5.2f',Ts1),' K'];

% for a proper plot both Itot and ztot should be given to a binning
% function. Nevertheless, in most cases, no evident difference can be seen
% 2D plot
figure(11), clf
plot_2d(data,qh,qk,ql,n,dlq,hlim,klim,llim,clim,figlabel)
% colormap viridis

% 1D plot
% intlim = [0 6000]; % y-axis limits for the plot
intlim=[0 0.1*max(data(:))];
n=[mean([hmin hmax]), mean([kmin kmax]), mean([lmin lmax])]; % Q point of the cut
dlq=0.02; % half of the binning size
figure(12), clf
plot_1d(data,qh,qk,ql,n,dlq,hlim,klim,llim,intlim,figlabel)

