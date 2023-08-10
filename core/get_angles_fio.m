function [tth, om, chi, phi] = get_angles_fio_v1(filename)
% extracts tth , om, chi and phi from the virtual counters
% this means that it does not depend on the chi4c or chis, ...
% if omes is used for the scan, the om value has to be corrected by alpha ~= 4.27:
% omes = om + alpha

tth_n = lower('VC28_TWO_THETA');
om_n  = lower('VC29_OMEGA');
chi_n = lower('VC30_CHI');
phi_n = lower('VC31_PHI');

[d,dt]=bw5data(filename);
% dt=dt(2:end,:);

tth = d(:,strmatch(tth_n,dt,'exact'));
om  = d(:,strmatch( om_n,dt,'exact'));
chi = d(:,strmatch(chi_n,dt,'exact'));
phi = d(:,strmatch(phi_n,dt,'exact'));
end