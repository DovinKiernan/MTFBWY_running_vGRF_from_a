%% MTFBWY Wundersitz

% Wundersitz et al. attempted to estimate vertical ground reaction force second peak magnitude
% as a function of acceleration at T2 multiplied by participant mass

function [second] = MTFBWY_Wundersitz(data, location, submethod, participant, Fs)

% Check for appropriate accelerometer placement
if ~strcmp(location,'Sacrum')
    warning('Inappropriate accelerometer placement for the Wundersitz method')
end

mass = participant(1);

% Wundersitz tried 5 potential filter conditions: a 10, 15, 20, 25 Hz low pass Butterworth and unfiltered raw data
if strcmp(submethod,'25 Hz')
    Fc = 25;
elseif strcmp(submethod,'20 Hz')
    Fc = 20;
elseif strcmp(submethod,'15 Hz')
    Fc = 15;
elseif strcmp(submethod,'10 Hz')
    Fc = 10;
end

if ~strcmp(submethod,'Raw')
    order = 4; % 4th order recursive low-pass filter
    % Calculate parameters for a Low-Pass Butterworth filter
    [b1, b2] = butter(order, Fc/(Fs/2), 'low');
    % Filter acceleration multiplied by mass to estimate force
    F_y_est(:,1) = filtfilt(b1, b2, data(:,3)*9.8*mass);
else
    % For 'raw' do not filter
    F_y_est(:,1) = data(:,3)*9.8*mass;
end

% Estimate vGRF second peak magnitude
second = max(F_y_est);

end % function