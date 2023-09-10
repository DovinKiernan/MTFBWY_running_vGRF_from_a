%% MTFBWY Day

% Day et al. attempted to estimate force time series and second peak magnitude 
% as a function of acceleration at the sacrum multiplied by participant mass

function [first, rate, second, average, tseries] = MTFBWY_Day(data, location, participant, Fs)

% Check for appropriate accelerometer placement
if ~strcmp(location,'Sacrum')
    warning('Inappropriate accelerometer placement for the Day method')
end

% Note that due to the aggressive filtering of this method (8th order 5,
% 10, or 30 Hz low pass Butterworth), stance-segmented signals can become
% highly distorted. Therefore, the time series should be filtered BEFORE
% stance segmenting and feeding into this function. For example:
% % % % Filter data
% % % Fc = 30; % Cut-off frequency
% % % order = 8; % 8th order recursive low-pass filter
% % % % Calculate parameters for a Low-Pass Butterworth filter
% % % [b1,b2] = butter(order,Fc/(Fs/2),'low');
% % % data_filt = filtfilt(b1,b2,data);
warning('Time series must be filtered before segmenting by stance and passing into the Day function. No filtering is executed by this function')

mass = participant(1);

tseries = data(:,3).*mass.*9.8;

% Estimate the discrete variables from the tseries
[first, rate, second, average] = MTFBWY_discrete_extractor(tseries, Fs);

end % function