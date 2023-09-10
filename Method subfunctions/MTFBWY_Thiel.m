%% MTFBWY_Thiel

% Thiel 2018 developed a linear regression to estimate maximum vertical
% ground reaction force from tri-axial acceleration

function [second] = MTFBWY_Thiel(data, location, coord_conv)

% Check for appropriate accelerometer placement
if strcmp(location,'Left shank') || strcmp(location,'Right shank')
else
    warning('Inappropriate accelerometer placement for the Thiel method')
end

% Previously derived constants:
% % The coefficients originally published by Thiel varied as a function of stride number
% % However, they noted their participants achieved ~steady-state between strides 8-13
% % Thus, we could use an average of the coefficients from strides 8-13 as an
% % approximation of their steady-state coefficients:
% % % for stride_count = 8:13
% % %     c1(stride_count-7) = -4*stride_count - 143; % their y is ISB x
% % %     c2(stride_count-7) = 9.47*stride_count - 111; % their x is ISB y
% % %     c3(stride_count-7) = -47.6*stride_count + 180; % their z is ISB z
% % % end % stride count
% % % c1 = mean(c1);
% % % c2 = mean(c2);
% % % c3 = mean(c3);
% % We derived the constants again using our 74 participants in each of 3 potential coordinate systems:
% % % WCS -- wearable coordinate system
% % % SCS -- segment coordinate system
% % % TCCS -- tilt-corrected coordinate system
switch coord_conv
    case 'WCS'
        c1 = 249.6466;
        c2 = 339.4468;
        c3 = 286.9037;
    case 'SCS'
        c1 = 139.6692;
        c2 = 441.7490;
        c3 = -34.6945;
    case 'TCCS'
        c1 = 118.0989;
        c2 = 431.7105;
        c3 = 28.6142;
end

% Find max acclerations
a_x_max = max(data(:,2));
a_y_max = max(data(:,3));
if strcmp(location(1:4),'Left')
    a_z_max = max(data(:,4)); % left is positive medial per ISB
else
    a_z_max = max(data(:,4)); % right is positive lateral per ISB, so multiply by -1
end

% Calculate vGRF second peak magnitude
second = c1*a_x_max + c2*a_y_max + c3*a_z_max;

end