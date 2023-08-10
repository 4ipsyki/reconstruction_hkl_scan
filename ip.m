% name of the input par file to be saved
name_ip          = 'ip_v1';

% main directory
base_dirr='/asap/petra3/gpfs/p21.1/2022/data/11013053/';

% generic file name for frames
nm_base  = 'hasylab_';

% directory for .fio files
dirr_onl = [base_dirr,'raw/online/'];

savedirr        = [base_dirr,'processed/reconstructions/'];
savedirr_skipnr = [base_dirr,'processed/reconstructions_skipnr/'];
savedirr_ip     = [base_dirr,'processed/inputpar/'];

alpha  = 4.26973;            % beamline angle
bkg    = 0;                  % constant background (to be subtracted from raw frames)

% detector type and orientation:
% 1 - Pilatus100k horizontal mount;
% 2 - Pilatus100k vertical mount;
% 3 - Custom --> fill parameters section
detector  = 1;
% extension of the frames
data_type = 1; % 1 - TIF; 2 - CBF;

hor_angle  = 0*pi/180;                 % detector tilt angles
vert_angle = 0*pi/180;             

orgx0 = 112.5;                         % position of direct beam on detector
orgy0 = 200.2;                              

det_dist0 = 2000;                      % sample to center of rotation of tth at tth = 0
D1 = 330;                              % detector to center of rotation of tth

rot_ax = [0.0 1.0 0.0];                      % rotation axis

lambda = 12.3984/101.6;                      % x-ray wavelength
ki_vec = [0.0  0.0  1/lambda];               % incident beam direction
pol_deg = 0.920;                             % beam polarization
pol_plane_normal = [ 0.000  1.000  0.000 ];  % polarization plane normal

% reconstruction properties
% number of voxels for all three directions
n_steps = [501 501 501];  if length(n_steps)~=3; n_steps=ones(1,3)*n_steps(1); end
% half width of the reciprocal space dimension around the nominal point
hdelta  = 1.5;
kdelta  = 1.5;
ldelta  = 1.5;
% --> resolution = 2*q_delta/(n_steps-1);

% ub matrix taken from online. This is referred to om, chi, phi = 0
% thus, beside convertion to ub_hkl, also the rotation matrix has to be
% applied
ub_online = [ 1.27321969  0.92117702 -0.01640066
              0.00303473  0.10153508  0.67336943
              0.33012193 -0.93338182  0.05706422];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch detector
    case 1 % Pilatus100k horizontal mount
        det_x    = [ 0.00000   1.00000   0.00000];
        det_y    = [-1.00000   0.00000   0.00000];
        x_size   = 195; % number of pixels
        y_size   = 487;
        dx       = 0.172; % pixel size
        dy       = 0.172;
    case 2 % Pilatus100k vertical mount
        det_x    = [ 1.00000   0.00000   0.00000]; 
        det_y    = [ 0.00000   1.00000   0.00000];
        x_size   = 195; % number of pixels
        y_size   = 487; 
        dx       = 0.172; % pixel size
        dy       = 0.172;
    case 3 % Custom
        det_x    = [ 1.00000   0.00000   0.00000];
        det_y    = [ 0.00000   1.00000   0.00000];
        x_size   = 200; % number of pixels
        y_size   = 500; 
        dx       = 0.01; % pixel size
        dy       = 0.01;
end

if ~exist(savedirr, 'dir')
       mkdir(savedirr)
end

if ~exist(savedirr_skipnr, 'dir')
       mkdir(savedirr_skipnr)
end

if ~exist(savedirr_ip, 'dir')
       mkdir(savedirr_ip)
end

save([savedirr_ip,name_ip,'.mat'], ...
                        'base_dirr','nm_base','dirr_onl', ...
                        'savedirr','savedirr_skipnr','savedirr_ip', ...
                        'alpha','bkg','detector','data_type', ...
                        'det_x','det_y','x_size','y_size','dx','dy', ...
                        'hor_angle','vert_angle','orgx0','orgy0', ...
                        'det_dist0','D1', ...
                        'rot_ax','lambda','ki_vec', ...
                        'pol_deg','pol_plane_normal', ...
                        'n_steps','hdelta','kdelta','ldelta', ...
                        'ub_online');

clear                   nm_base dirr_onl ...
                        savedirr savedirr_skipnr savedirr_ip ...
                        alpha bkg detector data_type ...
                        det_x det_y x_size y_size dx dy ...
                        hor_angle vert_angle orgx0 orgy0 ...                        
                        det_dist0 D1 ...
                        rot_ax lambda ki_vec ...
                        pol_deg pol_plane_normal ...
                        n_steps hdelta kdelta ldelta ...
                        ub_online

