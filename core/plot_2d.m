function plot_2d(data,qh,qk,ql,n,dlq,hlim,klim,llim,clim,figlabel)

if nargin==10
    figlabel='';
end

if length(n)==1
    n=ones(3,1)*n;
end

dht=round(abs(hlim(1)-hlim(2))/4,2); htick=round(mean(hlim),2)+dht*[-2:2];
dht=round(abs(klim(1)-klim(2))/4,2); ktick=round(mean(klim),2)+dht*[-2:2];
dht=round(abs(llim(1)-llim(2))/4,2); ltick=round(mean(llim),2)+dht*[-2:2];

clf
dime(35,15)
inx=0.07;finx=0.1;iny=0.08;finy=0.1;delx=0.07;
dx=(1-inx-finx-2*delx)/3; dy=1-iny-finy;

%data
axes('position',[inx iny dx dy])
[dp,xp,yp,~]=slice_cube(data,qh,qk,ql,[-dlq dlq]+n(1),klim,llim,[1 0 0]);
imagesc(yp,xp,dp)
colormap(jet), caxis(clim)
xlim(llim), ylim(klim)
title(['h = ',sprintf('%7.4f',n(1)),' in (h,k,{\it{l}}) [r.l.u.]'],...
    'interpreter','latex','fontsize',25)
xlabel('{\it{l}} in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('k in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
axis square%, grid on
set(gca,'fontsize',17,'xtick',ltick,'ytick',ktick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

axes('position',[inx+dx+delx iny dx dy])
[dp,xp,yp,~]=slice_cube(data,qh,qk,ql,hlim,[-dlq dlq]+n(2),llim,[0 1 0]);
imagesc(yp,xp,dp)
colormap(jet), caxis(clim)
xlim(llim), ylim(hlim)
title(['k = ',sprintf('%7.4f',n(2)),' in (h,k,{\it{l}}) [r.l.u.]'],...
    'interpreter','latex','fontsize',25)
xlabel('{\it{l}} in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('h in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
axis square%, grid on
set(gca,'fontsize',17,'xtick',ltick,'ytick',htick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

axes('position',[inx+2*dx+2*delx iny dx dy])
[dp,xp,yp,~]=slice_cube(data,qh,qk,ql,hlim,klim,[-dlq dlq]+n(3),[0 0 1]);
imagesc(yp,xp,dp)
colormap(jet), caxis(clim)
cl=colorbar;
cl.Position = [inx+3*dx+2*delx+delx*0.2 0.5-cl.Position(4)*0.5/2 cl.Position(3:4)*0.5];
cl.Label.String='Intensity [cts/s]';
cl.Label.Interpreter='latex';
cl.FontSize=17;
xlim(klim), ylim(hlim)
title(['{\it{l}} = ',sprintf('%7.4f',n(3)),' in (h,k,{\it{l}}) [r.l.u.]'],...
    'interpreter','latex','fontsize',25)
xlabel('k in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
ylabel('h in (h,k,{\it{l}}) [r.l.u.]','interpreter','latex',...
    'fontsize',25)
axis square%, grid on
set(gca,'fontsize',17,'xtick',ktick,'ytick',htick,'linewidth',1,...
    'xcolor','k','ycolor','k','YTickLabelRotation',90,...
    'GridColor','w','linewidth',1,'gridalpha',1)

dim = [(1-finx)/2-inx/2 .9 0.1 finy];
annotation('textbox',dim,'String',figlabel,'FitBoxToText','on',...
    'Interpreter','latex','FontSize',30,'fitboxtotext','on',...
    'linestyle','none','HorizontalAlignment','center','VerticalAlignment','top');

end
