function [filename, number_of_files] = image_name_reader(root, N)
%  reading file names of *.raw extension from a folder

%  code by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 3/4/2011
%  Last UPDATE : 10/4/2016
%  potential bugs : None identified

%  Usage : [filename, number_of_files] = image_name_reader(root, N)
%  root example : 'D:\My Dataset\'
%  file type example :  BOTDIR
%  N : the name of N-th file is given in the output of "filename"

    inDir = dir([root '*' 'raw']);
    number_of_files = length(inDir);
    [~, filename, ~] = fileparts(inDir(N).name);
end
