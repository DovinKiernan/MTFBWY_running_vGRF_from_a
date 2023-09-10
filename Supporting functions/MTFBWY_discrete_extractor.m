function [first, rate, second, average] = MTFBWY_discrete_extractor(tseries, Fs)

% Derive discrete estimates from time series
% Find second peak magnitude
% Typically this is just max, however, occassionally there can be a
% first peak magnitude with a higher value
% Therefore, find up to two peaks
[second_mag, second_ind] = findpeaks(tseries,'npeaks',2);
if size(second_mag,1) == 2
    % If there's two, then take the second in time
    second = second_mag(2);
    second_ind(1) = [];
elseif size(second_mag,1) == 1
    % If there's one take it
    second = second_mag(1);
elseif isempty(second_mag)
    % If there's no peaks take the max
    [second_mag, second_ind] = max(tseries);
    second = second_mag;
end
% Use an adapted version of Blackmore et al's (2015) HiF surrogate function
% Use fft to observe the frequency content of the signal, zero padding to 1001
n = 2^nextpow2(size(tseries,1));
Y = fft(tseries, n, 1);
% The frames of the fft correspond to 0:Fs/2 and back
F = Fs*(0:(n/2))/n;
F = [F F(end-1:-1:2)];
% Zero out low frequencies (LoF) to isolate high frequency (HiF) signal
HiF_spec = Y;
HiF_spec(F < 10) = 0;
% Convert data from frequency to time domain
HiF_tseries = ifft(HiF_spec, n, 'symmetric');
HiF_tseries(size(tseries,1)+1:end) = [];
% Find value of first sample in signal
HiF_first = HiF_tseries(1);
% Start signal from 0
HiF0_tseries = (HiF_tseries - HiF_first);
% Find first peak magnitude
% Typically the largest HiF0_time peak, but can occassionally be a few large ones
% Therefore, take the first occurring after 5% of stance duration and before the second peak
[first_mag, first_ind] = findpeaks(HiF0_tseries(round(size(HiF0_tseries,1)*0.05):second_ind));
if isempty(first_ind)
    [first_mag, first_ind] = max(HiF0_tseries(round(size(HiF0_tseries,1)*0.05):second_ind));
end
first_ind = first_ind + round(size(HiF0_tseries,1)*0.05);
% Correct if rounding put the signal outside the bounds
% (trying to grab first or last frame but rounds to last + 1 or 0)
% (this shouldn't happen unless the stance has been mis-segmented or the sampling rate is REALLY low)
if first_ind > size(HiF0_tseries,1)
    first_ind = size(HiF0_tseries,1);
elseif first_ind < 1
    first_ind = 1;
end
% Call tseries magnitude at first occuring HiF peak 'first'
first = tseries(first_ind(1));
% Also grab the timing
first_t = first_ind(1)/size(tseries,1);
% Find loading rate
rate = (tseries(round(first_ind(1)*0.8))-tseries(round(first_ind(1)*0.2)))/(round(first_ind(1)*0.8)-round(first_ind(1)*0.2))*Fs; % N/s
% Find average
average = mean(tseries);

end % function