function xyzout = macLeod_boynton_chromaticity(LMS_data, alp)
%  plot chromaticities within the MacLeod-Boynton chromaticity space 
%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 10/24/2013
%  Last UPDATE : 10/3/2016
%  potential bugs : none identified
%
%  Usuage : macLeod_boynton_chromaticity(LMS_data, alp)
%  LMS_data : LMS values calculated from Smith Pokorny cone fundamentals
%  alp : the patch size of a single chromaticity point

%  xyzout : 3-by-m matrix, where m is the number of data points in LMS_data,
%           the CIE 1931 XYZ normalized by the sum (xyz), obtained from a linear transformation of LMS_data

load('Smith_Pokorny.mat')
lms = interp1(Smith_Pokorny.wavelength, Smith_Pokorny.cf, 400:5:700);
if size(lms,1)<size(lms,2)
    lms = lms';
end
if size(LMS_data,2)~=3
    LMS_data = LMS_data';
end 
scaling_factor = (sum(lms(1,1:2))/lms(1,3)); % the factor is used to make L/L+M = 1 at 400 nm 
lms(:,3) = scaling_factor*lms(:,3);
l = (lms(:,1)./(lms(:,1)+lms(:,2)));
s = (lms(:,3)./(lms(:,1)+lms(:,2)));
plot([l;l(1);l(end)], [s;s(1);s(end)], 'LineWidth',0.5,'Color','k'); box; hold on
clear l s lms
% ********************************************************************************************
l_data = (LMS_data(:,1)./(LMS_data(:,1)+LMS_data(:,2)));
s_data = (scaling_factor*LMS_data(:,3)./(LMS_data(:,1)+LMS_data(:,2)));
lms_avg = [mean(l_data), mean(s_data)];
% ********************************************************************************************
%                                Transformation 
M_tr = [0.15514 0.54312 -0.03286;-0.15514 0.45684 0.03286;0 0 0.00801];
xyz = M_tr\LMS_data'; clear LMS_data 
xyzout = [xyz(1,:)./sum(xyz); xyz(2,:)./sum(xyz); xyz(3,:)./sum(xyz)]; clear xyz
rgb = xyz2srgb(xyzout, 2.4)';
A = [l_data'-alp; l_data'+alp; l_data'+alp; l_data'-alp]; 
B = [s_data'-alp; s_data'-alp; s_data'+alp; s_data'+alp]; clear l_data s_data
patch('XData', A, 'YData', B, ...
        'EdgeColor', 'none', ...
        'FaceColor', 'flat', ...
        'FaceVertexCData', rgb, 'FaceVertexAlphaData', 1, ...
        'FaceAlpha', 'flat', 'AlphaDataMapping','none');
xlabel('\it l'); ylabel('\it s');
plot(lms_avg(1), lms_avg(2), '.k', 'MarkerSize', 4);
box
hold off
end

function sRGBout = xyz2srgb(XYZ, Gamma)
    % Gamma no Less than 1.96. Proposed Gamma = 2.4
    % See IEC_61966-2-1.pdf
    if size(XYZ,1) ~= 3
        XYZ = XYZ';
    end
	% Forward transformation from 1931 CIE XYZ to sRGB (Eqn 6 in IEC_61966-2-1.pdf).
    M = [3.2406255 -1.537208 -0.4986286
        -0.9689307 1.8757561 0.0415175
        0.0557101 -0.2040211 1.0569959];
    sRGB = M*XYZ; clear XYZ
    l = 12.92*sRGB.*(sRGB<=0.0031308);
    u = (1.055*((sRGB.*(sRGB > 0.0031308)).^(1/Gamma))) - 0.055;
    sRGBout = max(l,0) + max(u,0); clear l u sRGB
end
