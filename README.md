Procedures and algorithms for converting step point-detector-like scans
into 3D hkl space by using a small 2D detector.
Scripts as ip.m, find_ub.m, calc_dk_P.m and imga2hkl.m are written by
M. v. Zimmermann (DESY), and esthetically modified by O. Ivashko (DESY).
The rest of the scripts are written by O. Ivashko (DESY).

August 2023
================================================================================
The following list is orginized in an ordered fashion and serves only as a
generalized guideline. Scripts and relative parameters need to be adjusted
case-by-case. These scripts are polished from analyses on several data taken
with PILATUSX CdTe 100k at P21.1 at PETRAIII, DESY.
The detector is mounted on the two-theta (tth) arm which is made of two 
bottom translational motors (ydt "nearly" along the beam and xdt "nearly"
perpendicular to the beam), followed by a rotation motor (having an angle equal
to tth with respect to the beam), and an additional two-that analyser motor
(in case an analyser is mounted on an omega motor situated at the center of
rotation for tth). The beam has an angle of about 4.3 degree with respect to ydt.
For simplicity ydt is kept fixed for different tth positions, and thus the
sample-to-detecor distance is slightly different for each tth. This is taken
into account in the scripts, but two nominal distances have to be measured
for tth=0: det_dist0 from sample to the center of rotation for the tth arm; and
D1 from the center of rotation of the tth arm to the detector. Additionally, a
dummy scan on the direct beam (with proper absorbers) and at tth=0 has to be
perfomed. From the latter, the center for the direct beam parameters are extracted.
At P21.1, Online is used as the beamline control software. When making step scans
a .fio file is saved containing the motor positions and all the necessary counters
and monitors. A ub matrix has to be defined either the hkl scans are performed
or not. The best way to acquire a complete 3D volume around a particular (h0,k0,l0)
point is to make an omega (rocking-width) scan, but any other scans can be
performed and converted into hkl scan in a completely automatic way.
The following counters and values need to be present in the fio files: 
tth, omega, chi, phi, h, k, l, exp_c01 (monitor before the absorbers),
atten (absorber value), T_sam (sample sensor temperature), T_ctrl (control sensor),
ub matrix.
================================================================================

<> calibrate beam origin (orgx0 and orgy0) perameters by perfomring a direct beam
   scan for tth=0. when possible use an appropriate calibrant to also calibrate
   the abgles.
   --> use origin_fit_q0.m for the direct beam scan analysis.

<> create [input_parameters].mat file. this contains the neccesarry parameters
   and directories for the reconstruction.
   --> use ip.m as an example.

<> (OPTIONAL) create custom mask.
   This must contain bad pixels and gaps of the detector.
   Include beamstop and its holder if necessary.
   NOTE: a basic mask (dead pixels / blank) must be incuded anyway.

<> perform the reconstruction.
   --> use reconstruct_hkl_scan.m as an example

<> (OPTIONAL) plot the reconstruction.
   Basic plotting along the three principle axes with choosen Q point and
   out-of-plane binning.
   --> use fast_plot.m as an example.

<> (OPTIONAL) lpot difference between two scans.
   --> use difference.m as an axample

<> (OPTIONAL) fit the reconstructed data in the 3D hkl space.
   --> use fit_data.m as an example

