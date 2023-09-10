%% MTFBWY_Charry

% Charry 2013 developed a logarithmic equation to estimate vertical ground
% reaction force second peak magnitude based on the minimum acceleration in
% the longitudinal axis of a shank-worn accelerometer, participant mass,
% and constants they derived

function [second] = MTFBWY_Charry(data, location, coord_conv, participant)

% Check for appropriate accelerometer placement
if strcmp(location,'Left shank') || strcmp(location,'Right shank')
else
    warning('Inappropriate accelerometer placement for the Charry method')
end

mass = participant(1);

% Previously derived constants
% % Charry originally derived the constants:
% % % s1 = 4.66;
% % % s2 = -76.6;
% % % i1 = 24.98;
% % % i2 = -566.83;
% % We derived the constants again using our 74 participants in each of 3 potential coordinate systems:
% % % WCS -- wearable coordinate system
% % % SCS -- segment coordinate system
% % % TCCS -- tilt-corrected coordinate system
switch coord_conv
    case 'WCS'
        s1 = -1.0922;
        s2 = 103.6462;
        i1 = 26.6511;
        i2 = -197.6452;
    case 'SCS'
        s1 = -0.6598;
        s2 = 98.9072;
        i1 = 24.0457;
        i2 = -25.3910;
    case 'TCCS'
        s1 = 2.5680;
        s2 = -96.4324;
        i1 = 17.0107;
        i2 = 402.8931;
end

% Find min accleration
a_y_min = min(data(:,3));

% Estimate vGRF second peak magnitude
second = (s1*mass + s2)*log2(-a_y_min + 1)+(i1*mass + i2);

end % function