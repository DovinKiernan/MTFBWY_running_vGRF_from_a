%% MTFBWY_Veras

% Veras et al. estimated forces for 131 participants using y-axis or resultant
% accelerations from the shank, hip, or sacrum

function [rate, second] = MTFBWY_Veras(data, location, coord_conv, submethod, participant)

% Check for appropriate accelerometer placement
if strcmp(location,'Left shank') || strcmp(location,'Right shank')
    location_submethod = 'Shank';
elseif strcmp(location,'Left hip') || strcmp(location,'Right hip')
    location_submethod = 'Hip';
elseif strcmp(location,'Sacrum')
    location_submethod = 'Sacrum';
else
    warning('Inappropriate accelerometer placement for the Veras method')
end

mass = participant(1);

% % We derived the constants again using our 74 participants for each of
% % the 3 potential placement locations, 2 potential inputs (y or res), and
% % in each of our 3 coordinate systems:
% % % WCS -- wearable coordinate system
% % % SCS -- segment coordinate system
% % % TCCS -- tilt-corrected coordinate system
switch submethod
    case 'res'
        % Find max accleration
        a_y_max = max(vecnorm(data(:,2:4)));
        % Find max jerk
        j_y_max = max(diff(vecnorm(data(:,2:4))));
        switch location_submethod
            case 'Shank'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 3.0531e+04;
                        c2_rate = -7.5759e+04;
                        c3_rate = 33.2779;
                        c4_rate = 2.4704e+03;
                        c1_second = -8.7698;
                        c2_second = 44.1206;
                        c3_second = 23.2623;
                        c4_second = -0.3459;
                    case 'SCS'
                        c1_rate = 3.0531e+04;
                        c2_rate = -7.5759e+04;
                        c3_rate = 33.2779;
                        c4_rate = 2.4704e+03;
                        c1_second = -8.7698;
                        c2_second = 44.1206;
                        c3_second = 23.2623;
                        c4_second = -0.3459;
                    case 'TCCS'
                        c1_rate = 3.2413e+04;
                        c2_rate = -8.3920e+04;
                        c3_rate = 22.3623;
                        c4_rate = 2.5182e+03;
                        c1_second = 40.2641;
                        c2_second = 38.1274;
                        c3_second = 22.8244;
                        c4_second = -0.2924;
                end % coord conv
            case 'Hip'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 2.2622e+04;
                        c2_rate = -7.3323e+04;
                        c3_rate = -45.7215;
                        c4_rate = 5.1500e+03;
                        c1_second = -435.3358;
                        c2_second = 265.6864;
                        c3_second = 28.1566;
                        c4_second = -2.7037;
                    case 'SCS'
                        c1_rate = 2.2622e+04;
                        c2_rate = -7.3323e+04;
                        c3_rate = -45.7215;
                        c4_rate = 5.1500e+03;
                        c1_second = -435.3358;
                        c2_second = 265.6864;
                        c3_second = 28.1566;
                        c4_second = -2.7037;
                    case 'TCCS'
                        c1_rate = 2.2617e+04;
                        c2_rate = -7.4296e+04;
                        c3_rate = -43.2309;
                        c4_rate = 5.1443e+03;
                        c1_second = -438.5406;
                        c2_second = 266.6685;
                        c3_second = 28.1790;
                        c4_second = -2.7090;
                end % coord conv
            case 'Sacrum'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 1.6452e+04;
                        c2_rate = 4.8662e+04;
                        c3_rate = 370.2739;
                        c4_rate = 1.1905e+03;
                        c1_second = -916.2907;
                        c2_second = 462.5585;
                        c3_second = 34.4358;
                        c4_second = -5.2486;
                    case 'SCS'
                        c1_rate = 1.6452e+04;
                        c2_rate = 4.8662e+04;
                        c3_rate = 370.2739;
                        c4_rate = 1.1905e+03;
                        c1_second = -916.2907;
                        c2_second = 462.5585;
                        c3_second = 34.4358;
                        c4_second = -5.2486;
                    case 'TCCS'
                        c1_rate = 1.2798e+04;
                        c2_rate = 7.8823e+04;
                        c3_rate = 437.4907;
                        c4_rate = 624.7131;
                        c1_second = -910.2889;
                        c2_second = 461.8584;
                        c3_second = 34.3326;
                        c4_second = -5.2314;
                end % coord conv
        end % location submethod
    case 'y'
        % Find max accleration
        a_y_max = max(data(:,3));
        % Find max jerk
        j_y_max = max(diff(data(:,3)));
        switch location_submethod
            case 'Shank'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 3.7054e+04;
                        c2_rate = -1.1505e+05;
                        c3_rate = 120.5422;
                        c4_rate = 2.2477e+03;
                        c1_second = 463.5728;
                        c2_second = -82.4436;
                        c3_second = 17.0538;
                        c4_second = 2.0563;
                    case 'SCS'
                        c1_rate = 4.1232e+04;
                        c2_rate = -1.1075e+05;
                        c3_rate = -179.3213;
                        c4_rate = 2.7814e+03;
                        c1_second = -152.2766;
                        c2_second = 71.9925;
                        c3_second = 25.5236;
                        c4_second = -0.7283;
                    case 'TCCS'
                        c1_rate = 2.7659e+04;
                        c2_rate = -7.9481e+04;
                        c3_rate = 12.1163;
                        c4_rate = 2.3318e+03;
                        c1_second = 254.0833;
                        c2_second = 10.7009;
                        c3_second = 20.5150;
                        c4_second = 0.0509;
                end % coord conv
            case 'Hip'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 1.8597e+04;
                        c2_rate = 2.6190e+04;
                        c3_rate = 414.1389;
                        c4_rate = 1.7390e+03;
                        c1_second = -374.0819;
                        c2_second = 783.8300;
                        c3_second = 30.8150;
                        c4_second = -11.2693;
                    case 'SCS'
                        c1_rate = 3.1754e+04;
                        c2_rate = -1.4905e+05;
                        c3_rate = -214.9012;
                        c4_rate = 6.7334e+03;
                        c1_second = -365.6536;
                        c2_second = 308.4419;
                        c3_second = 26.5702;
                        c4_second = -2.7490;
                    case 'TCCS'
                        c1_rate = 2.7474e+04;
                        c2_rate = -1.0870e+05;
                        c3_rate = -129.2996;
                        c4_rate = 5.9677e+03;
                        c1_second = -356.0690;
                        c2_second = 309.7272;
                        c3_second = 27.0165;
                        c4_second = -2.9686;
                end % coord conv
            case 'Sacrum'
                switch coord_conv
                    case 'WCS'
                        c1_rate = 2.8603e+04;
                        c2_rate = -2.4815e+04;
                        c3_rate = -60.0882;
                        c4_rate = 5.2798e+03;
                        c1_second = 202.0893;
                        c2_second = 44.2054;
                        c3_second = 24.6610;
                        c4_second = -1.9194;
                    case 'SCS'
                        c1_rate = -2.6666e+04;
                        c2_rate = 3.0775e+05;
                        c3_rate = 1.2035e+03;
                        c4_rate = -4.4052e+03;
                        c1_second = -749.3547;
                        c2_second = 448.6681;
                        c3_second = 33.0755;
                        c4_second = -5.2295;
                    case 'TCCS'
                        c1_rate = -2.8737e+04;
                        c2_rate = 3.3480e+05;
                        c3_rate = 1.2076e+03;
                        c4_rate = -4.5719e+03;
                        c1_second = -709.7040;
                        c2_second = 448.8259;
                        c3_second = 32.0335;
                        c4_second = -5.0350;
                end % coord conv
        end % location submethod
end % y or res submethod

% Estimate rate of loading
rate = c1_rate + c2_rate*j_y_max + c3_rate*mass + c4_rate*mass*j_y_max;

% Estimate vGRF second peak magnitude
second = c1_second + c2_second*a_y_max + c3_second*mass + c4_second*mass*a_y_max;

end % function