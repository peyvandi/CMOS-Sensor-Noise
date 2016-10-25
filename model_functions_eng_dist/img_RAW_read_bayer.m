function imgout = img_RAW_read_bayer(filename, img_row, img_column, bit_depth, pedestal)
%  read RAW image format from a local file 
%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 1/24/2014
%  Last UPDATE : 10/7/2016
%  potential bugs : data int 16
%
%  Usuage  : imgout = img_RAW_read_bayer(filename, Row, Col, bits, pedestal)
%  filename : raw image directory e.g. D:\<foolder_name>\<image_name>.raw
%  img_row / img_column : the number of row / column in the raw Bayer image
%  bit_depth : Bit Depth, e.g. 10
%  pedestal : the image pedestal specified by sensor manufacturer 

%  imgout : the image obtained from *.raw

    if nargin<5
        pedestal = 0;
    end
    if isempty(filename)
        error('Error: no filename is given');
    end
    disp([' ... retrieving image ... ' filename ' ...']);
    f_id = fopen(filename,'rb');
    
    if (f_id == -1)
        error('Error: Can not retrieve/open image file\n');
    end
    
    if bit_depth > 16
        g_out = fread(f_id, img_row*img_column, 'integer*4');
    elseif bit_depth > 8
        g_out = fread(f_id, img_row*img_column, 'integer*2');
    else
        g_out = fread(f_id, img_row*img_column, 'int8');
    end
    
    fclose(f_id);
    img = reshape(g_out, img_column, img_row)'; clear g_out
    imgout = max(img-pedestal,0); clear img
end
