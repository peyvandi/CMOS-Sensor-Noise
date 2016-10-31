
%                                     FIGURE 1
%                                   Description

%	Photoreceptors of like-type exposed to a uniform stimulating light absorb different amounts of energy. 
%   Due to such spatial variation in individual cells absorption, a trichromatic stimulation produces a distribution of responses 
%   within the cone excitation space. 

%   Title : Distribution of Photon Energy among a Population of Interleaved Photoreceptors"
%   by Shahram Peyvandi, Vebjorn Ekroll, Alan Gilchrist
%   submitted to JOSA A in 2016

%  This is a demo, for generating random excitations from indiviudal LMS cone cells 
%  when the human retina is stimulated by arbitrary light from a surface color patch 

%  code by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 3/3/2015
%  Last UPDATE : 10/3/2016
%  potential bugs : None identified


clc
clear
close all

wlinf = 380; wlinc = 5; wlsup = 780;
wavelength = wlinf:wlinc:wlsup;
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FWHM = 30;
lambda_prim = [455, 520, 650];
sig = FWHM ./ 2*sqrt(2*log(2));
irr_primary = zeros(length(wavelength),3);
for i = 1:3
    irr_primary(:,i) = exp(-(wavelength - lambda_prim(i)).^2./sig.^2)'; 
end
[Spectra_Max] = irr_primary*diag(50./Judd_Vos_Lum(irr_primary, wlinf, wlinc, wlsup)); % Primaries Lum = 50
[Lum_J_prim, XYZ_Max, ~] = Judd_Vos_Lum(Spectra_Max, wlinf, wlinc, wlsup); % check "Lum_J_prim" 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
xy_MacAdam = importdata('MacAdam_Chromaticities.xlsx');
X = Lum_J_prim(1).*xy_MacAdam(:,1)./xy_MacAdam(:,2);
Y = Lum_J_prim(1)*ones(size(xy_MacAdam,1),1);
Z = (X./xy_MacAdam(:,1)).*(1 - sum(xy_MacAdam,2)); 
XYZ_MacAdam = [X Y Z]; clear X Y Z 
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
XYZ_Black = [0;0;0]; Spectra_Black = 0*wavelength'; zeros(length(wavelength),1);
irr_MacAdam = XYZmix2Spectra(XYZ_Max, Spectra_Max, XYZ_Black, Spectra_Black, XYZ_MacAdam, wlinf, wlinc, wlsup);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
load('Smith_Pokorny.mat')
receptor_fundamental = interp1(Smith_Pokorny.wavelength, Smith_Pokorny.cf, wavelength);

receptor_area = 2;
exp_time = 1;
% "PupilDiameterFromLum" is a psychtoolbox function, pupil area estimated from luminance
[~ , pupil_area, ~] = PupilDiameterFromLum(50); 

[mu, variance, SNR] = energy_dist_parameters(irr_MacAdam, receptor_fundamental, receptor_area, pupil_area, exp_time, wlinf, wlinc, wlsup);
for i = 1:25
    out = rnd_excitation_generator(mu(i,:), variance(i,:), 1000); % generating 1000 random chromaticity points
	hold on; subplot(1,2,1); xyzout = macLeod_boynton_chromaticity(out, 0.0005); clear out
    title({'distribution of cone excitations','represented in M-B space'}, 'FontSize', 9)
    axis([0.4 1 0 0.25])

    hold on; subplot(1,2,2); CIE_Judd_chromaticity(xyzout, 0.0005)
    title({'The same excitations, transformed to CIE XYZ',' represented in xy-space'}, 'FontSize', 9)
end


