
%                              DEMO

%	Like-type pixels of a particular channel absorb different amounts of
%	light energy when exposed to a uniformly illuminated color patch.

%   Title : Distribution of Photon Energy among a Population of Interleaved Photoreceptors"
%   by Shahram Peyvandi, Vebjorn Ekroll, Alan Gilchrist
%   submitted to JOSA A in 2016

%  This is a demo, for estimation of the histogram distribution of absorbed light energy by 
%  individual pixles of a particular channel. 

%  code by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 6/2/2015
%  Last UPDATE : 10/7/2016
%  potential bugs : None identified

clc
clear
close all
%       the spectral range of the spectroradiometer, PR650
wlinf = 380; wlinc = 4; wlsup = 780;
wavelength = wlinf:wlinc:wlsup;

%+++++++++++++++ making access to the data and required functions +++++++++++++++++
[path, ~] = fileparts(pwd);
function_folder_eng_dist = [path, '\model_functions_eng_dist'];
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('WARNING : my function path is added to your MATLAB search paths')
addpath(function_folder_eng_dist); % adding the path
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
data_folder = [path, '\sensor_data'];
image_data_folder = [path, '\image_data\']; 

% %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%              The raw image informaiton
img_column = 3264;
img_row = 2448;
pedestal = 42;
bit_depth = 10;  
cfa_pattern = 'rggb';

xbins = 0:2^bit_depth-1;
% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
no_of_image_analyzed = 20 % select the number of images to be analyzed
select_patch = 19 % select a patch from the 24 patches of the CC by an integer number, 1-24 
color_patch_position = importdata([data_folder, '\CCS_50ms_color_patch_position_rect.xlsx']); % reading the position of the selected patch
rect_position = color_patch_position(select_patch,:);

% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%         changing the number of pixels within the selected patch
%         the histogram will be obtained from those pixels within the rect
fraction = 1; % choose a fraction value, e.g. 1, 0.56, or 0.3, the lower the fraction, the lower the number of pixels (N_cells)
w_n = fraction*rect_position(3);
xypos_n = rect_position(1:2) + 0.5*(1-fraction)*rect_position(3); 
clear rect_position
rect_position = [xypos_n w_n w_n]; clear xypos_n w_n
% % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

f_d_img = zeros(length(xbins), no_of_image_analyzed, 4); 
[mu_img, vari_img] = deal(zeros(no_of_image_analyzed, 4));
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for i = 1:no_of_image_analyzed
    [filename, ~] = image_name_reader(image_data_folder, i);
    img_dir = [image_data_folder filename '.raw']; clear filename
    img_out = img_RAW_read_bayer(img_dir, img_row, img_column, bit_depth, pedestal); clear img_dir
    
    c1 = img_out(1:2:end, 1:2:end); c2 = img_out(2:2:end, 1:2:end);
    c3 = img_out(1:2:end, 2:2:end); c4 = img_out(2:2:end, 2:2:end); clear img_out
    
    img_r = imcrop(c1, rect_position./2); r = mean(img_r(:)); clear c1
    img_g1 = imcrop(c2, rect_position./2); g1 = mean(img_g1(:)); clear c2
    img_g2 = imcrop(c3, rect_position./2); g2 = mean(img_g2(:)); clear c3
    img_b = imcrop(c4, rect_position./2);  b = mean(img_b(:));  clear c4
    
    N_cells = numel(img_r);
	
    mu_img(i,:) = [r, g1, g2, b]; clear r g1 g2 b
	
    f_d_img(:, i, 1) = hist(img_r(:), xbins);
    f_d_img(:, i, 2) = hist(img_g1(:), xbins);
    f_d_img(:, i, 3) = hist(img_g2(:), xbins);
    f_d_img(:, i, 4) = hist(img_b(:), xbins);
	     
    vari_img(i,:) = [var(img_r(:)) var(img_g1(:)) var(img_g2(:)) var(img_b(:))];
end
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
fprintf('     The total number of pixels/channel analyzed is %i.\n', N_cells)
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%       Sensor Parameters for estimating the histogram
%       distribution of absorbed energy in individual pixels

pixel_area = 1.96; % the collecting area of a pixel (microexposure duration = 50 milliseconds
f_number = 2.75;
exp_time = 50E-3; % exposure duration = 50 milliseconds

%       retrieving the sensor quantum efficiently +++++++++++++++++
load([data_folder, '\cmos_sensor_data.mat'])
QE = interp1(cmos_sensor_data.wavelength, cmos_sensor_data.QE, wavelength')./100; QE = max(QE,0); clear cmos_sensor_data
subplot(1,2,1); plot(wavelength, QE); axis([wlinf wlsup 0 0.7]); xlabel('Wavelength, nm', 'FontSize', 10); ylabel('QE', 'FontSize', 10);

%       retrieving the transmittance of the lens and IR-cutoff filter +++++++++++++++++
load([data_folder, '\SUNEX_DSL945D_650_IRC_30_Curve.mat'])
t_lens = interp1(SUNEX_DSL945D_650_IRC_30_Curve.wavelength, SUNEX_DSL945D_650_IRC_30_Curve.transmittance, wavelength')./100; t_lens = max(t_lens,0); clear SUNEX_DSL945D_650_IRC_30_Curve
subplot(1,2,2); plot(wavelength, diag(t_lens)*QE); axis([wlinf wlsup 0 0.7]); xlabel('Wavelength, nm', 'FontSize', 10); ylabel('QE * T-Lens', 'FontSize', 10);

%       retrieving the spectral radiance data of the 24 color patches +++++++++++++++++                   
radiance_spectra = importdata([data_folder, '\CC_radiance_Jan_2016.csv']);

%       estimation of the distribution parameters +++++++++++++++++ 
[mu_energy, variance_energy, SNR_energy] = sensor_energy_dist_parameters(radiance_spectra, QE, pixel_area, f_number, t_lens, exp_time, wlinf, wlinc, wlsup);

%       transformation of the distribution parameters, centering at the mean for each of the four sensor channel+++++++++++++++++ 
std_rggb_hat =  (mean(mu_img,1)./mu_energy(select_patch,:)).*sqrt(variance_energy(select_patch,:));

xmin = min(xbins); xmax = max(xbins); dxi = 1;
[x_out, fx_out] = histogram_generator(mean(mu_img,1), std_rggb_hat, xmin, xmax, dxi); clear std_rggb_hat

%       plot the estimated histogram distribution +++++++++++++++++ 
colors = {'r', 'g', 'g', 'b'}; % array of colors
titles = {'Red', 'Green 1', 'Green 2', 'Blue'}; % array of titles
figure
for i = 1:4
    f_x_hat = interp1(xbins, f_d_img(:,:,i), x_out{i}); 
    plt(i) = subplot(2,2,i); plot(x_out{i}, f_x_hat, 'k'); hold on; 
    plot(x_out{i}, N_cells*fx_out{i}, 'color', colors{i}, 'LineWidth',2); title(titles{i}); clear f_x_hat
end
xlabel(plt(4),'Digital Count'); ylabel(plt(1),'Histogram frequencies'); 

figure
for i = 1:4
    f_x_hat = interp1(xbins, f_d_img(:,:,i), x_out{i}); 
    plt(i) = subplot(2,2,i); plot(x_out{i}, mean(f_x_hat, 2), 'k'); hold on; 
    plot(x_out{i}, N_cells*fx_out{i}, 'color', colors{i}, 'LineWidth',2); title(titles{i}); clear f_x_hat
end
xlabel(plt(4),'Digital Count'); ylabel(plt(1),{'Average of the','histogram frequencies'});

figure
for i = 1:4
    f_x_hat = interp1(xbins, f_d_img(:,:,i), x_out{i}); 
    plt(i) = subplot(2,2,i); plot(x_out{i}, var(f_x_hat, 0, 2), 'k'); hold on; 
    plot(x_out{i}, N_cells*fx_out{i}, 'color', colors{i}, 'LineWidth',2); title(titles{i}); clear f_x_hat
end
xlabel(plt(4),'Digital Count'); ylabel(plt(1),{'Variance of the','histogram frequencies'});

%       display the patch from which we obtained the channel-wise histograms
%       note: image is not color corrected
[filename, ~] = image_name_reader(image_data_folder, 1);
img_dir = [image_data_folder filename '.raw']; clear filename
[demosaic_image_out, ~] = demosaic_bayer2rgb(img_dir, img_row, img_column, cfa_pattern, bit_depth, pedestal); clear img_dir
figure
imshow(demosaic_image_out.^0.4, 'Border', 'tight')
imrect(gca, rect_position);

disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('WARNING : the added function path is now removed from your MATLAB search paths')
rmpath(function_folder_eng_dist); % removing the path
clear function_folder_eng_dist
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++')

