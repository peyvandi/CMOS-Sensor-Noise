function out = XYZmix2Spectra(XYZ_Max, Spectra_Max, XYZ_Black, Spectra_Black, XYZ_Mix, wlinf, wlinc, wlsup)
%  spectral estimation of a color from the spectra of primary RGB colors
%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 1/24/2014
%  Last UPDATE : None
%  potential bugs : None identified
%
%  Usuage  : out = XYZmix2Spectra(input)

%  XYZ_Max = [Xr, Xg, Xb;
%             Yr, Yg, Yb;
%             Zr, Zg, Zb]
%  Spectra_Max : 3*n matrix of spectral (ir)radiance of three primary colors

%  XYZ_Black = [X_blk; X_blk; X_blk]
%  Spectra_Black : spectral (ir)radiance of a black reproduced

%  wlinf : lower wavelength limit
%  wlsup : upper wavelength limit
%  wlinc : wavelength interval

if size(XYZ_Mix, 1) ~= 3
    XYZ_Mix = XYZ_Mix';
end
if size(XYZ_Black, 1) ~= 3
    XYZ_Black = XYZ_Black';
end 
if size(Spectra_Max, 1) ~= length(wlinf:wlinc:wlsup)
    Spectra_Max = Spectra_Max';
end
if isrow(Spectra_Black)
    Spectra_Black = Spectra_Black';
end 
coef = XYZ_Max\(XYZ_Mix - XYZ_Black*ones(1,size(XYZ_Mix,2)));
out = Spectra_Max*coef + Spectra_Black*ones(1,size(XYZ_Mix,2));
out = max(out,0);
end
