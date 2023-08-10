function [xa,ya,za,datacut]=extract_cube(vx,vy,vz,data,dx,dy,dz)

    i1=find(vx<=dx(1),1,'last'); i2=find(vx>=dx(2),1,'first');
    if isempty(i1); i1 = 1; end; if isempty(i2); i2 = length(vx); end
    idxx=i1:i2;

    i1=find(vy<=dy(1),1,'last'); i2=find(vy>=dy(2),1,'first');
    if isempty(i1); i1 = 1; end; if isempty(i2); i2 = length(vy); end
    idxy=i1:i2;

    i1=find(vz<=dz(1),1,'last'); i2=find(vz>=dz(2),1,'first');
    if isempty(i1); i1 = 1; end; if isempty(i2); i2 = length(vz); end
    idxz=i1:i2;

xa=vx(idxx); ya=vy(idxy); za=vz(idxz); % vectors
datacut = data(idxx,idxy,idxz);  % intensities
datacut(isnan(datacut))=0;
end