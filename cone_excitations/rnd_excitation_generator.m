
%  generating random numbers from a normal distribution truncated at zero
%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 2/1/2015
%  Last UPDATE : 10/3/2016
%  potential bugs : None identified
%
%  Usuage  : out = rnd_excitation_generator(mu, variance, n_sample)
%  mu : m-by-1 vector, of the average amounts of energy absorbed by all the
%  cells (m refers to the number of cone classes)
%  variance : m-by-1 vector, the spatial variance of absorbed energy by individual cells
%  n_sample : a scalar, the number of points (cells)

%  out : n_sample-by-m matrix, points in each column refers to a specific receptor class, 
%        randomly generated from a normal distribution truncated at zero

function out = rnd_excitation_generator(mu, variance, n_sample)
if length(mu) ~= length(variance)
    out = 0;
    disp('Warning: Not correct input');  return
end
out = zeros(n_sample, length(mu)); 
for i = 1:length(mu)
    out(:,i) = Normal_gen_trunc_rnd(mu(i), variance(i), n_sample);
end
end

function x = Normal_gen_trunc_rnd(mu, variance, N_sample)
pd = makedist('Normal', mu, sqrt(variance));
pdt = truncate(pd,0,inf); clear pd
x = random(pdt, N_sample, 1);
% x(x==0 | x<0) = nan;
end
