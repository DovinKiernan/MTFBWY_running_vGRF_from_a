%% MTFBWY Gurchiek

% Gurchiek et al. attempted to estimate force as a function of
% acceleration at the sacrum multiplied by participant mass

function [first, rate, second, average, tseries] = MTFBWY_Gurchiek(data, location, participant, Fs)

% Check for appropriate accelerometer placement
if ~strcmp(location,'Sacrum')
    warning('Inappropriate accelerometer placement for the Gurchiek method')
end

mass = participant(1);

% Filter parameters
Fc = 10; % Cut-off frequency
order = 5; % 5th order recursive low-pass filter
% Calculate parameters for a Low-Pass Butterworth filter
[b1, b2] = butter(order, Fc/(Fs/2), 'low');
% Filter y-axis acceleration
a_y_filt(:,1) = filtfilt(b1, b2, data(:,3));

% Estimate force time series
tseries = 9.8*mass*a_y_filt;

% Estimate the discrete variables from the tseries
[first, rate, second, average] = MTFBWY_discrete_extractor(tseries, Fs);

end % function