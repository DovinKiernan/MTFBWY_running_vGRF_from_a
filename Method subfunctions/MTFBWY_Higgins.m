%% MTFBWY Higgins

% Higgins et al estimated vertical GRF first peak magnitude and rate of
% loading using accelerometers on the shank and hip. They developed
% participant-specific equations, some of which included age as an
% additional predictor variable. Here we provide generalizable versions of
% their method.

function [first, rate] = MTFBWY_Higgins(data, location, coord_conv, participant)

% Check for appropriate accelerometer placement
if strcmp(location,'Left shank') || strcmp(location,'Right shank')
    submethod = 'Shank';
elseif strcmp(location,'Left hip') || strcmp(location,'Right hip')
    submethod = 'Hip';
else
    warning('Inappropriate accelerometer placement for the Higgins method')
end

age = participant(5);

% Previously derived constants
% Higgins derived their constants based on 30 participants jogging, running, and performing other activities (e.g., jumping)
% % Higgins accepted model iteration 2 from their "Supplemental Digital
% % Content 2 as the final model for both first peak and loading rate estimation for hip, didn't report for shank
% c1_first = 1.16 + 1.5*0.749; % average intercept across participants plus average intercept for jogging and running
% c2_first = -0.035; % coefficient for vertical hip acceleration
% c1_rate = 64.91 + 1.5*32.15; % average intercept across participants plus average intercept for jogging and running
% c2_rate = 5.58; % coefficient for vertical hip acceleration
% c3_rate = -2.19; % coefficient for age

% We derived the constants again using our 74 participants in each of 3 potential coordinate systems:
% % WCS -- wearable coordinate system
% % SCS -- segment coordinate system
% % TCCS -- tilt-corrected coordinate system
switch submethod
    case 'Hip'
        switch coord_conv
            case 'WCS'
                c1_first = 942.017395239943;
                c2_first = 208.948122120049;
                c1_rate = 46903.2240548302;
                c2_rate = 11764.7132067461;
                c3_rate = -343.206162287446;
            case 'SCS'
                c1_first = 589.948202389263;
                c2_first = 211.128942530990;
                c1_rate = 24265.5421284364;
                c2_rate = 11948.2618768678;
                c3_rate = -247.586763783346;
            case 'TCCS'
                c1_first = 600.145884594014;
                c2_first = 210.635672808109;
                c1_rate = 25185.5419467504;
                c2_rate = 11692.7958053290;
                c3_rate = -235.707265150058;
        end
    case 'Shank'
        switch coord_conv
            case 'WCS'
                c1_first = 999.808936374970;
                c2_first = 42.3885819671885;
                c1_rate = 30883.3201472815;
                c2_rate = 4487.18100552047;
                c3_rate = -40.2009358298026;
            case 'SCS'
                c1_first = 794.439816083814;
                c2_first = 36.6930861562499;
                c1_rate = 8909.91710545937;
                c2_rate = 3545.22510985652;
                c3_rate = 111.186211093659;
            case 'TCCS'
                c1_first = 838.362031228118;
                c2_first = 35.9827538521278;
                c1_rate = 12741.3378120604;
                c2_rate = 3606.26056986594;
                c3_rate = 76.1686849735226;
        end
end

% Find max acceleration
a_y_max = max(data(:,3));

% Find vGRF first peak magnitude
first = c1_first + c2_first*a_y_max;

% Find vGRF rate of loading from to 20-80% of first peak
rate = c1_rate + c2_rate*a_y_max + c3_rate*age;

end % function