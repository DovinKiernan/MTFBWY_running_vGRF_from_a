%% MTFBWY Kim

% Kim et al. presented a method of estimating force time series from sacral
% accelerations or displacements using a feed forward neural network

% For running these methods on big data sets, probably much faster to make
% the net global so it doesn't need to be loaded every time

function [first, rate, second, average, tseries] = MTFBWY_Kim(data, location, coord_conv, submethod, participant, Fs)

% Check for appropriate accelerometer placement
if ~strcmp(location,'Sacrum')
    warning('Inappropriate accelerometer placement for the Kim method')
end

mass = participant(1);

% Filter parameters
Fc = 10; % Cut-off frequency
order = 5; % 5th order recursive low-pass filter
% Calculate parameters for a Low-Pass Butterworth filter
[b1, b2] = butter(order, Fc/(Fs/2), 'low');

% Filter acceleration and transpose
a_filt = filtfilt(b1, b2, data(:,2:4));

% Separate networks were developed for each of the two submethods and each
% of the three coordinate conventions described in our paper
% Select the appropriate network and normalize the data
switch submethod
    case 'acceleration'
        % Rescale to 101 time points
        a_scale = ScaleTime(a_filt, 1, size(a_filt,1), 101);
        % Multiply by mass and gravity
        a_scale = (a_scale.*mass.*9.8)';
        % Add percent stance as 4th row
        a_scale = [a_scale; 1:1:101];
        switch coord_conv
            case 'WCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                a_scale(1,:) = a_scale(1,:) + 2453.85914885664;
                a_scale(1,:) = a_scale(1,:)./3972.46226673929;
                a_scale(2,:) = a_scale(2,:) + 1499.35870481808;
                a_scale(2,:) = a_scale(2,:)./4758.29391832714;
                a_scale(3,:) = a_scale(3,:) + 1756.38271254170;
                a_scale(3,:) = a_scale(3,:)./4307.11754497018;
                % Load the network
                load('Kim_acceleration_net_WCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_acceleration_net_WCS(a_scale);
            case 'SCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                a_scale(1,:) = a_scale(1,:) + 3037.28650510550;
                a_scale(1,:) = a_scale(1,:)./4635.97970305324;
                a_scale(2,:) = a_scale(2,:) + 1795.10920309314;
                a_scale(2,:) = a_scale(2,:)./4444.90519926996;
                a_scale(3,:) = a_scale(3,:) + 2048.03662347219;
                a_scale(3,:) = a_scale(3,:)./4443.75041916398;
                % Load the network
                load('Kim_acceleration_net_SCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_acceleration_net_SCS(a_scale);
            case 'TCCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                a_scale(1,:) = a_scale(1,:) + 2695.50766381768;
                a_scale(1,:) = a_scale(1,:)./5226.00521958867;
                a_scale(2,:) = a_scale(2,:) + 1777.72480637130;
                a_scale(2,:) = a_scale(2,:)./4521.01513182617;
                a_scale(3,:) = a_scale(3,:) + 1963.57387989178;
                a_scale(3,:) = a_scale(3,:)./5285.45934933976;
                % Load the network
                load('Kim_acceleration_net_TCCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_acceleration_net_TCCS(a_scale);
        end
    case 'displacement'
        % Double integrate and rescale to 101 time points
        d_scale = ScaleTime(cumtrapz(cumtrapz(a_filt*9.8)*1/Fs)*1/Fs, 1, size(a_filt,1), 101); % now in meters
        % Multiply by mass and gravity (body weight)
        % In original poster Force was estimated in BWs (N/(mass*gravity))
        % This is analogous to rearranging the equation and moving BW to the right side of the equation
        d_scale = (d_scale.*mass.*9.8)';
        % Add percent stance as 4th row
        d_scale = [d_scale; 1:1:101];
        switch coord_conv
            case 'WCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                d_scale(1,:) = d_scale(1,:) + 144.658646518291;
                d_scale(1,:) = d_scale(1,:)./326.072076989963;
                d_scale(2,:) = d_scale(2,:) + 126.938456521928;
                d_scale(2,:) = d_scale(2,:)./526.334941006991;
                d_scale(3,:) = d_scale(3,:) + 79.1158285344088;
                d_scale(3,:) = d_scale(3,:)./503.888885708349;
                % Load the network
                load('Kim_displacement_net_WCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_displacement_net_WCS(d_scale);
            case 'SCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                d_scale(1,:) = d_scale(1,:) + 377.103231147718;
                d_scale(1,:) = d_scale(1,:)./611.860470369459;
                d_scale(2,:) = d_scale(2,:) + 81.6987643485145;
                d_scale(2,:) = d_scale(2,:)./511.779949749847;
                d_scale(3,:) = d_scale(3,:) + 95.6261127694408;
                d_scale(3,:) = d_scale(3,:)./250.041220709557;
                % Load the network
                load('Kim_displacement_net_SCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_displacement_net_SCS(d_scale);
            case 'TCCS'
                % Normalize data by the values used to scale the training data from 0 to 1
                d_scale(1,:) = d_scale(1,:) + 130.124105795070;
                d_scale(1,:) = d_scale(1,:)./567.575689792321;
                d_scale(2,:) = d_scale(2,:) + 114.791645969255;
                d_scale(2,:) = d_scale(2,:)./566.455319143354;
                d_scale(3,:) = d_scale(3,:) + 281.993821615162;
                d_scale(3,:) = d_scale(3,:)./437.868117160373;
                % Load the network
                load('Kim_displacement_net_TCCS.mat')
                % Estimate the instantaneous force
                estimated_tseries = Kim_displacement_net_TCCS(d_scale);
        end
end

% Rescale to 101 time points and transpose
tseries = ScaleTime(estimated_tseries, 1, 101, size(a_filt,1))';

% Estimate the discrete variables from the tseries
[first, rate, second, average] = MTFBWY_discrete_extractor(tseries, Fs);

end % function