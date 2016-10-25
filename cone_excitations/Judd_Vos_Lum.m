function [Luminance_Judd, XYZ_Judd, xyz_Judd] = Judd_Vos_Lum(Spectra, wlinf, wlinc, wlsup)
% % Spectra is a (Lambda*n) column vector for n = 1 sample or matrix whose n columns are the spectra
load('Judd_Vos_CMFs.mat');
if nargin == 4
	in = max(wlinf, Judd_Vos.Wavelength(1));
    out = min(wlsup, Judd_Vos.Wavelength(end));
elseif nargin < 4
    disp('not enough input')
    return
end

xyz_judd = interp1(Judd_Vos.Wavelength, Judd_Vos.CMFs, in:wlinc:out)'; xyz_judd(isnan(xyz_judd)) = 0; clear Judd_Vos
Spectra = interp1(wlinf:wlinc:wlsup, Spectra, (in:wlinc:out)');

XYZ_Judd = xyz_judd*Spectra; 
xyz_Judd = XYZ_Judd./(ones(3,1)*sum(XYZ_Judd));

Luminance_Judd = 683.002*wlinc*xyz_judd(2,:)*Spectra; clear xyz_judd
XYZ_Judd = XYZ_Judd.*repmat(Luminance_Judd./XYZ_Judd(2,:),3,1);




