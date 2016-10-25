function [demosaic_image_out, image_input] = demosaic_bayer2rgb(filename, img_row, img_column, cfa_pattern, bit_depth, pedestal)
%  bilinear demosaicing of a raw image, it reads a raw image from a directory folder first, then demosaicing  

%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 9/5/2012
%  Last UPDATE : 10/6/2016
%  potential bugs : none identified
%
%  Usuage : [demosaic_image_out, image_input] = demosaic_bayer2rgb(filename, img_row, img_column, cfa_pattern, bit_depth, pedestal)
%  functions called : img_RAW_read_bayer()

%  filename : raw image directory e.g. D:\<foolder_name>\<image_name>.raw
%  img_row / img_column : the number of row / column in the raw Bayer image
%  cfa_pattern : Bayer pattern, color filter array (CFA) of filters
%  arrangement, possible inputs : 'rggb' 'grbg' 'bggr' or 'gbrg'
%  bit_depth : Bit Depth, e.g. 10
%  pedestal : the image pedestal specified by sensor manufacturer 

%  image_input : the input image (obtained from *.raw)
%  demosaic_image_out : 4 channel demosaiced image
%  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

    if ~ischar(cfa_pattern)
        disp('Error : cfa_pattern is a character, CFA : rggb, grbg, bggr, or gbrg') 
        return
    end
    image_input = img_RAW_read_bayer(filename, img_row, img_column, bit_depth, pedestal);
    demosaic_image_out = bilinear_demosaic(image_input, cfa_pattern, bit_depth);
end

% bilinear_demosaic() : demosaicing the image_input
function img_demosaic_out = bilinear_demosaic(image_input, cfa_pattern, bit_depth)
    RB_conv_kernel = (1/4)*[1, 2, 1; 2, 4, 2; 1, 2, 1];
    G_conv_kernel = (1/4)*[0, 1, 0; 1, 4, 1; 0, 1, 0];

    img = image_input./(2^bit_depth - 1) ;     
    img_demosaic_out = zeros(size(img,1), size(img,2), 3);
    img_channel = zeros(size(img,1), size(img,2), 4);

    img_channel(1:2:end, 1:2:end, 1) = img(1:2:end, 1:2:end);
    img_channel(1:2:end, 2:2:end, 2) = img(1:2:end, 2:2:end);
    img_channel(2:2:end, 1:2:end, 3) = img(2:2:end, 1:2:end);
    img_channel(2:2:end, 2:2:end, 4) = img(2:2:end, 2:2:end); clear img
    
    if strcmpi(cfa_pattern, 'grbg')  
        img_demosaic_out(:,:,1) = imfilter(img_channel(:, :, 2), RB_conv_kernel, 'same');
        img_demosaic_out(:,:,2) = imfilter(img_channel(:, :, 1) + img_channel(:, :, 4), G_conv_kernel, 'same');
        img_demosaic_out(:,:,3) = imfilter(img_channel(:, :, 3), RB_conv_kernel, 'same');
    elseif strcmpi(cfa_pattern, 'gbrg')
        img_demosaic_out(:,:,1) = imfilter(img_channel(:,:, 3), RB_conv_kernel, 'same');
        img_demosaic_out(:,:,2) = imfilter(img_channel(:,:, 1) + img_channel(:,:, 4), G_conv_kernel, 'same');
        img_demosaic_out(:,:,3) = imfilter(img_channel(:,:, 2), RB_conv_kernel, 'same');
    elseif strcmpi(cfa_pattern, 'bggr')
        img_demosaic_out(:,:,1) = imfilter(img_channel(:, :, 4), RB_conv_kernel, 'same');
        img_demosaic_out(:,:,2) = imfilter(img_channel(:, :, 2) + img_channel(:, :, 3), G_conv_kernel, 'same');
        img_demosaic_out(:,:,3) = imfilter(img_channel(:,:, 1), RB_conv_kernel, 'same');
    elseif strcmpi(cfa_pattern, 'rggb')
        img_demosaic_out(:,:,1) = imfilter(img_channel(:, :, 1), RB_conv_kernel, 'same');
        img_demosaic_out(:,:,2) = imfilter(img_channel(:, :, 2) + img_channel(:, :, 3), G_conv_kernel, 'same');
        img_demosaic_out(:,:,3) = imfilter(img_channel(:, :, 4), RB_conv_kernel, 'same');
    else
        disp('the color filter pattern is not identified');
        return
    end
   
    clear img_channel
end