function plot_1d(data,qh,qk,ql,n,dlq,hlim,klim,llim,clim,figlabel)

if nargin==10
    figlabel='';
end

if length(n)==1
    n=ones(3,1)*n;
end

dht=round(abs(hlim(1)-hlim(2))/4,2); htick=round(mean(hlim),2)+dht*[-2:2];
dht=round(abs(klim(1)-klim(2))/4,2); ktick=round(mean(klim),2)+dht*[-2:2];
dht=round(abs(llim(1)-llim(2))/4,2); ltick=round(mean(llim),2)+dht*[-2:2];
dht=round(abs(clim(1)-clim(2))/4,2); ctick=round(mean(clim),2)+dht*[-2:2];

clf
dime(30,20)
inx=0.07;finx=0.02;iny=0.1;finy=0.1;delx=0.07;% dely=0.1;
dx=(1-inx-finx-2*delx)/3; dy=1-iny-finy;

axes('position',[inx iny dx dy])
[xp,dp]=cut_cube(data,qh,qk,ql,hlim,[-dlq dlq]+n(2),[-dlq dlq]+n(3),[0 1 1]);
hold on
plot(xp,dp,'-sr','markersize',10)
hold off
xlim(hlim), ylim(clim+[-1 1]) 
xlabel('h in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('Intensity [cts/s]','interpreter','latex',...
    'fontsize',25)
grid on, box on
set(gca,'fontsize',17,'xtick',htick,'ytick',ctick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

axes('position',[inx+dx+delx iny dx dy])
[xp,dp]=cut_cube(data,qh,qk,ql,[-dlq dlq]+n(1),klim,[-dlq dlq]+n(3),[1 0 1]);
hold on
plot(xp,dp,'-sr','markersize',10)
hold off,box on
xlim(klim), ylim(clim+[-1 1]) 
xlabel('k in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('Intensity [cts/s]','interpreter','latex',...
    'fontsize',25)
grid on
set(gca,'fontsize',17,'xtick',ktick,'ytick',ctick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

axes('position',[inx+2*dx+2*delx iny dx dy])
[xp,dp]=cut_cube(data,qh,qk,ql,[-dlq dlq]+n(1),[-dlq dlq]+n(2),llim,[1 1 0]);
hold on
plot(xp,dp,'-sr','markersize',10)
hold off, box on
xlim(llim), ylim(clim+[-1 1]) 
xlabel('{\it{l}} in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('Intensity [cts/s]','interpreter','latex',...
    'fontsize',25)
grid on
set(gca,'fontsize',17,'xtick',ltick,'ytick',ctick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

dim = [(1-finx)/2-inx/2 .9 0.1 finy];
annotation('textbox',dim,'String',figlabel,'FitBoxToText','on',...
    'Interpreter','latex','FontSize',30,'fitboxtotext','on',...
    'linestyle','none','HorizontalAlignment','center','VerticalAlignment','top');
end