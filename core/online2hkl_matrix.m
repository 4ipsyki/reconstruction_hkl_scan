function [ub_hkl,lattice]=online2hkl_matrix(ub_online,om,chi,phi)
% converts UB matrix from online to hkl (xds like)

switch nargin
    case 0
        print('USAGE: [ub_hkl,lattice]=online2hkl_matrix(ub_online[,om,chi,phi])');
    case 1
        om  = 0;
        chi = 0;
        phi = 0;
    case 2
        chi = 0;
        phi = 0;
    case 3
        phi = 0;
end

% lattice parameter values:
a_val = 2*pi/norm(ub_online(:,1));
b_val = 2*pi/norm(ub_online(:,2));
c_val = 2*pi/norm(ub_online(:,3));
lattice = [a_val, b_val, c_val];

% rotations
rot_phi = [ cosd(phi), 0, -sind(phi);
               0,      1,     0;
            sind(phi), 0,  cosd(phi)];    % rotation around y
       
rot_chi = [ 1,      0,       0;
            0,  cosd(chi), -sind(chi);
            0,  sind(chi),  cosd(chi)];    % rotation around z
        
rot_om  = [ cosd(om), 0, -sind(om);
              0,     1,    0;
            sind(om), 0, cosd(om)];    % rotation around y

ub_rot = rot_om*rot_chi*rot_phi*ub_online;

% exchange axis
ub_prov=[-ub_rot(3,:);
         -ub_rot(2,:);
          ub_rot(1,:)];
      
% real space to reciprocal space
rez_vol = dot(ub_prov(:,1),cross(ub_prov(:,2),ub_prov(:,3)));
a = 2*pi* cross(ub_prov(:,2),ub_prov(:,3))/rez_vol;
b = 2*pi* cross(ub_prov(:,3),ub_prov(:,1))/rez_vol;
c = 2*pi* cross(ub_prov(:,1),ub_prov(:,2))/rez_vol;

% exchange axis
ub_hkl = [a,b,c];
end
