%% MTFBWY Neugebauer

% Neugebauer and colleagues published papers in 2012 and 2014 estimating 
% peak vertical ground reaction forces from accelerations in children and adults
% These papers estimated force using a regression equation that, when simplified,
% can be represented using 3 constants, acceleration, and mass.

function [second] = MTFBWY_Neugebauer(data, location, coord_conv, participant)

% Check for appropriate accelerometer placement
if strcmp(location,'Left hip') || strcmp(location,'Right hip')
else
    warning('Inappropriate accelerometer placement for the Neugebauer method')
end

mass = participant(1);

% Previously derived constants
% % Neugebauer originally derived the constants:
% % % Neugebauer 2012 (children)
% % % % c1 = 5.387 + 0.799; % alpha 0 + alpha 3 from original
% % % % c2 = 0.159 - 0.142; % alpha 1 + alpha 4 from original
% % % % c3 = 0.016; % alpha 2 from original
% % % Neugebauer 2014 (adults)
% % % % c1 = 5.247 + 0.934; % alpha 0 + alpha 3 from original
% % % % c2 = 0.271 - 0.216; % alpha 1 + alpha 4 from original
% % % % c3 = 0.014; % alpha 2 from original
% % We derived the constants again using our 74 participants in each of 3 potential coordinate systems:
% % % WCS -- wearable coordinate system
% % % SCS -- segment coordinate system
% % % TCCS -- tilt-corrected coordinate system
switch coord_conv
    case 'WCS'
        c1 = 6.5732;
        c2 = 0.0140;
        c3 = 0.0125;
    case 'SCS'
        c1 = 6.5361;
        c2 = 0.0278;
        c3 = 0.0120;
    case 'TCCS'
        c1 = 6.5459;
        c2 = 0.0253;
        c3 = 0.0120;
end

% Find max acceleration
a_y_max = max(data(:,3));

% Estimate vGRF second peak magnitude
second = exp(c1 + c2*a_y_max + c3*mass);

end % function