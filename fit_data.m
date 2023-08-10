
Eq = @(b,xyz) abs(b(1)).*exp(-0.5*((xyz(:,1)-b(2))/abs(b(3))).^2)...
                       .*exp(-0.5*((xyz(:,2)-b(4))/abs(b(5))).^2)...
                       .*exp(-0.5*((xyz(:,3)-b(6))/abs(b(7))).^2)+b(8);

qh=linspace(hmin,hmax,n_steps(1);
qk=linspace(kmin,kmax,n_steps(2));
ql=linspace(lmin,lmax,n_steps(3));

h0=mean([hmin hmax]);
k0=mean([kmin kmax]);
l0=mean([lmin lmax]);

hlim=[-0.04 0.04]+h0;
klim=[-0.04 0.04]+k0;
llim=[-0.6 0.6]+l0;

[xx,yy,zz,II]=extract_cube(qh,qk,ql,Int_total_t,hlim,klim,llim);

[xc,yc,zc]=meshgrid(yy,xx,zz); % meshgrid swaps x and y
xyz=[xc(:),yc(:),zc(:)];

% max number of fitting attempts
nmax=100;
% min and max limits for each parameter
parlim=[0 50 k0-0.02 k0+0.02 0.003 0.007 h0-0.02 h0+0.02 0.003 0.007 l0-0.07 l0+0.07 0.1 0.3 0 30];
% initial guess
par0=[30 k0 0.015 h0 0.015 l0 0.25 2];
% fitting
int_f=fit_func(xyz,II(:),Eq,par0,parlim,nmax);

% evaluating the fit
fitted=Eq(int_f,xyz);
fitted=reshape(fitted,size(II));

%use fitted,xx,yy,zz to plot the fit
%use data,qh,qk,ql to plot the experiment
