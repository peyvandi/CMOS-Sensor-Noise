function [mu, variance, SNR] = sensor_energy_dist_parameters(radiance_spectra, QE, pixel_area, f_number, t_lens, exp_time, wlinf, wlinc, wlsup)
%  estimation of the parameters (mean, variance) of a normal histogram distribution for the absorption in individual pixels of a sensor

%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 1/20/2015
%  Last UPDATE : 10/7/2016
%  potential bugs : none identified
%
%  Usuage : [mu, variance, SNR] = sensor_energy_dist_parameters(radiance_spectra, QE, pixel_area, f_number, t_lens, exp_time, wlinf, wlinc, wlsup)

%  radiance_spectra : (lambda*N) matrix of N spectral radiance functions of surface color stimuli, unit : W/sr m^2 nm 

%  QE : (lambda*3) matrix of quantum efficiencies (note: scale 0-1)

%  pixel_area : the collecting area of a single pixel (note: pixel_pitch^2), unit : micrometer^2

%  f_number : the effective f_number 
%  note: A/f^2 = (pi/4)*(1/f_number^2), where f is the effective distance
%  of the lens from the image plane, A: the lens aperture area

%  t_lens : the spectral transmittance of the lens + IR cutoff filter (note: scale 0-1)
%  exp_time : the exposure duration, unit : second 
%  wlinf : lower wavelength limit, unit : nanometer
%  wlsup : upper wavelength limit, unit : nanometer
%  wlinc : wavelength interval, unit : nanometer

%  mu : 1-by-3 vector of the average amount of energy absorbed by all the pixels of a specific channel 
%  variance : 1-by-3 vector of the variance of absorbed energy by individual pixels of a specific channel 
%  SNR : 1-by-3 vector of SNR (mean divided by the standard deviation)

%  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    wavelength = wlinf:wlinc:wlsup; % in nano_meter
    if size(radiance_spectra,1) ~= length(wavelength)
        radiance_spectra = radiance_spectra';
    end
    if size(QE,1) ~= length(wavelength)
        QE = QE';
    end
    c = 2.9979246E+8; % the speed of light in m/Sec 
    % Note : not necessary, 6.24150934E+18 is only used to convert energy unit from Joule to Electronvolt (eV) 
    h_eV = 6.6260755E-34*6.24150934E+18; hc_lambda = h_eV*c./(wavelength*1E-9); %  eV Sec
    % Note : retinal irradiance is calculated from the focal length of the eye lens = 16.6832 millimeters
    E_pixel = diag(t_lens)*radiance_spectra.*((pi/4)/(f_number^2))*6.24150934E+18; % eV/sec m^2 nm
    energy_at_pixel = exp_time*(pixel_area*1E-12)*E_pixel; clear E_pixel; % eV/nm
    mu = energy_at_pixel'*QE*wlinc;
    variance = (energy_at_pixel'*diag(hc_lambda))*QE*wlinc;
    SNR = mu./sqrt(variance);
end

