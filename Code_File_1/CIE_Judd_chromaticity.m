function CIE_Judd_chromaticity(xyz_input, alp)
%  plot chromaticities within the Judd-Vos modified space from xyz data 
%  by : Shahram PEYVANDI
%  Affiliation : Rutgers, The State University of New Jersey-Newark
%                Visual Perception Lab
%                Department of Psychology
%                101 Warren Street, Smith Hall, Rm 355
%  DATE : 10/24/2013
%  Last UPDATE : 10/3/2016
%  potential bugs : none identified
%
%  Usuage : CIE_Judd_chromaticity(xyz_input, alp)
%  xyz_input : XYZ values normalized by the sum (sum(xyz) = 1)
%  alp : the patch size of a single chromaticity point


load('Judd_Vos_CMFs.mat') % loading Judd-Vos CMFs
xyz = Judd_Vos.CMFs;
if size(xyz,1) > size(xyz,2)
    xyz = xyz';
end
x = (xyz(1,:)./sum(xyz))';
y = (xyz(2,:)./sum(xyz))';
plot([x;x(1);x(end)], [y;y(1);y(end)], 'LineWidth',1.25,'Color','k'); box; hold on
clear x y xyz
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if size(xyz_input,1) ~= 3
    xyz_input = xyz_input';
end
rgb = xyz2srgb(xyz_input, 2.4)'; % Gamma in sRGB = 2.4
A = [xyz_input(1,:)-alp;xyz_input(1,:)+alp;xyz_input(1,:)+alp;xyz_input(1,:)-alp];
B = [xyz_input(2,:)-alp;xyz_input(2,:)-alp;xyz_input(2,:)+alp;xyz_input(2,:)+alp]; 
patch('XData', A, 'YData', B, ...
        'EdgeColor', 'none', ...
        'FaceColor', 'flat', ...
        'FaceVertexCData', rgb, 'FaceVertexAlphaData', 1, ...
        'FaceAlpha', 'flat', 'AlphaDataMapping','none'); 
xlabel('\it x'); ylabel('\it y');
xyz_avg = mean(xyz_input,2); clear xyz_input rgb
plot(xyz_avg(1), xyz_avg(2), '.k', 'MarkerSize', 2)
box
hold off
end

