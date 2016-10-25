function [x_out, fx_out] = histogram_generator(mu, sigma, xmin, xmax, dxi)
%  the function generates a histogram with the mean of mu and the standard deviation of sigma 
%  at x-poins from xmin to xmax with intervals of dxi

%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 8/2/2015
%  Last UPDATE : 10/7/2016
%  potential bugs : none identified
%
%  Usuage : [x_out, fx_out] = histogram_generator(mu, sigma, xmin, xmax, dxi)
%  internal function : normal_mix_dist_gen()

%  mu : a vector (or matrix) of means
%  sigma : a vector (or matrix) of standard deviations
%  xbins = xmin : dxi : xmax;

%  x_out : a cell of xbins
%  fx_out : a cell of histograms
%  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if size(mu) ~= size(sigma)
        disp('Warning: mu and sigma should have the same dimension');
        return
    end
    [x_out, fx_out] = deal(cell(size(mu,1), size(mu,2)));

    for i = 1:size(mu,1)
        for j = 1:size(mu,2)
            [x_out{i,j}, fx_out{i,j}] = normal_mix_dist_gen(mu(i,j), sigma(i,j), xmin, xmax, dxi);
        end
    end
end

function [X, Fx] = normal_mix_dist_gen(mu, sigma, xmin, xmax, dxi)
    x = xmin:dxi:xmax;
    x_1 = xmin - dxi/2 : dxi : xmax - dxi/2;
    x_2 = xmin + dxi/2 : dxi : xmax + dxi/2;
    if ~isrow(x)
        x = x';
    end
    pd = makedist('Normal', mu, sigma);
    cdf_x = cdf(pd, x);
    fx = cdf(pd, x_2) - cdf(pd, x_1) ;

    [~, indx] = uniquetol(cdf_x, 1E-12); % this line eliminates x-points where fx is very small (fx~0)
    X = x(indx(2) : indx(end-1));
    Fx = fx(indx(2) : indx(end-1));
end



