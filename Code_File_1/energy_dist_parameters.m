function [mu, variance, SNR] = energy_dist_parameters(Spectra, receptor_fundamental, receptor_area, pupil_area, exp_time, wlinf, wlinc, wlsup)
%  estimation of the parameters (mean, variance) of a normal histogram distribution of individual cells absorption

%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 2/1/2015
%  Last UPDATE : 10/3/2016
%  potential bugs : none identified
%
%  Usuage : [mu, variance, SNR] = energy_dist_parameters(Spectra, receptor_fundamental, receptor_area, pupil_area, exp_time, wlinf, wlinc, wlsup)

%  Spectra : (lambda*N) matrix of N spectral radiance functions of surface color stimuli, unit : W/sr m^2 nm 
%  receptor_fundamental : (lambda*3) matrix of cone fundamentals, e.g. Smith-Pokorny or Vos-Walraven
%  receptor_area : the collecting area of a single cell (2-4), unit : micrometer^2
%  pupil_area : the pupil area is used to calculate the retinal irradiance, unit : millimeters^2
%  exp_time : the exposure duration, unit : second 
%  wlinf : lower wavelength limit, unit : nanometer
%  wlsup : upper wavelength limit, unit : nanometer
%  wlinc : wavelength interval, unit : nanometer

%  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

wavelength = wlinf:wlinc:wlsup; % in nano_meter
if size(Spectra,1) ~= length(wavelength)
    Spectra = Spectra';
end
if size(receptor_fundamental,1) ~= length(wavelength)
    receptor_fundamental = receptor_fundamental';
end
c = 2.9979246E+8; % the speed of light in m/Sec 
% Note : not necessary, 6.24150934E+18 is only used to convert energy unit from Joule to Electronvolt (eV) 
h_eV = 6.6260755E-34*6.24150934E+18; hc_lambda = h_eV*c./(wavelength*1E-9); %  eV Sec
% Note : retinal irradiance is calculated from the focal length of the eye lens = 16.6832 millimeters
E_retina = Spectra.*(pupil_area/(16.6832^2))*6.24150934E+18; % eV/sec m^2 nm
energy_at_receptor = exp_time*(receptor_area*1E-12)*E_retina; clear E_retina; % eV/nm
mu = energy_at_receptor'*receptor_fundamental*wlinc;
variance = (energy_at_receptor'*diag(hc_lambda))*receptor_fundamental*wlinc;
SNR = mu./sqrt(variance);
end