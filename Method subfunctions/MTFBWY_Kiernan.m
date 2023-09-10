%% MTFBWY Kiernan

% Kiernan et al presented a conference proceeding estimating peak vertical ground
% reaction force first and second peaks from accelerations, sex, mass, height, and leg length

function [first, second] = MTFBWY_Kiernan(data, location, coord_conv, participant, Fs)

% Check for appropriate accelerometer placement and define submethod
if strcmp(location,'Left hip') || strcmp(location,'Right hip')
    submethod = 'Hip';
elseif  strcmp(location,'Sacrum')
    submethod = 'Sacrum';
else
    warning('Inappropriate accelerometer placement for the Kiernan method')
end

mass = participant(1);
height = participant(2);
leg_length = participant(3);
sex = participant(4);

% We derived coefficients for the regression using our 74 participants in each of 3 potential coordinate systems:
% % WCS -- wearable coordinate system
% % SCS -- segment coordinate system
% % TCCS -- tilt-corrected coordinate system
switch coord_conv
    case 'WCS'
        switch submethod
            case 'Hip'
                c1_first = 5.714334265710179; % Intercept
                c2_first = 0.135759450475517; % LoF
                c3_first = 0.084624962538605; % HiF
                c4_first = 0.146779729426261; % Sex
                c5_first = 0.012933682016262; % Mass
                c6_first = 0.005130056422401; % Height
                c7_first = -0.006195809976133; % Leg length
                c1_second = 6.260088652896142;
                c2_second = 0.101361902220584;
                c3_second = 0.003380950887594;
                c4_second = 0.170991403695776;
                c5_second = 0.006518327239360;
                c6_second = 0.000910072457749534;
                c7_second = 0.004801491312290;
            case 'Sacrum'
                c1_first = 5.317867575086414;
                c2_first = 0.180461671213031;
                c3_first = 0.097883334703096;
                c4_first = 0.143157761037623;
                c5_first = 0.009493622972016;
                c6_first = 0.006669023769063;
                c7_first = -0.003876078732558;
                c1_second = 6.260911404573560;
                c2_second = 0.027756782062038;
                c3_second = -0.016572312843207;
                c4_second = 0.154815191646714;
                c5_second = 0.006032794321397;
                c6_second = 0.001648783365861;
                c7_second = 0.004358754563320;
        end
    case 'SCS'
        switch submethod
            case 'Hip'
                c1_first = 5.649799385118191;
                c2_first = 0.033127628591341;
                c3_first = 0.055340789787627;
                c4_first = 0.106225438316050;
                c5_first = 0.013247279653629;
                c6_first = 0.006058054619787;
                c7_first = -0.007602475155311;
                c1_second = 6.098770895052430;
                c2_second = 0.075610891843655;
                c3_second = 0.000163285844451891;
                c4_second = 0.134020990567674;
                c5_second = 0.006690644994741;
                c6_second = 0.001119344181930;
                c7_second = 0.004899690472656;
            case 'Sacrum'
                c1_first = 5.780100545274222;
                c2_first = -0.041829086459053;
                c3_first = 0.029171711101378;
                c4_first = 0.121649343889369;
                c5_first = 0.012448119344597;
                c6_first = 0.006325479728689;
                c7_first = -0.006569004662589;
                c1_second = 6.034590587456905;
                c2_second = 0.081009122604349;
                c3_second = 0.004156197550615;
                c4_second = 0.127606795945784;
                c5_second = 0.005993467443597;
                c6_second = 0.001592464297511;
                c7_second = 0.004790799520238;
        end
    case 'TCCS'
        switch submethod
            case 'Hip'
                c1_first = 5.614502146480338;
                c2_first = 0.038964492297898;
                c3_first = 0.054261306928069;
                c4_first = 0.099820724629823;
                c5_first = 0.013473977448509;
                c6_first = 0.006138566963136;
                c7_first = -0.007623359012566;
                c1_second = 6.131775680215776;
                c2_second = 0.072832145001792;
                c3_second = -0.000109523035556198;
                c4_second = 0.142250273429872;
                c5_second = 0.006537645584835;
                c6_second = 0.000977291516558892;
                c7_second = 0.004963230783972;
            case 'Sacrum'
                c1_first = 5.735577166331890;
                c2_first = -0.020019607791735;
                c3_first = 0.025589992465772;
                c4_first = 0.112203940491109;
                c5_first = 0.0127278231168381;
                c6_first = 0.005861884489974;
                c7_first = -0.005937923080674;
                c1_second = 6.065013385219930;
                c2_second = 0.079699820702454;
                c3_second = 0.002212693226513;
                c4_second = 0.132869555069679;
                c5_second = 0.006137827850439;
                c6_second = 0.001593805427820;
                c7_second = 0.004390085302098;
        end
end

% Convert y axis acceleration to LoF and HiF signals
% Use an adapted version of Blackmore et al's (2015) HiF surrogate function
% Use fft to observe the frequency content of the signal, zero padding to 1001
n = 2^nextpow2(size(data(:,3),1));
Y = fft(data(:,3), n, 1);
% The frames of the fft correspond to 0:Fs/2 and back
F = Fs*(0:(n/2))/n;
F = [F F(end-1:-1:2)];
% Zero out low frequencies (LoF) to isolate high frequency (HiF) signal
HiF_spec = Y;
HiF_spec(F < 10) = 0;
% Convert data from frequency to time domain
HiF_tseries = ifft(HiF_spec, n, 'symmetric');
HiF_tseries(size(data,1)+1:end) = [];
% Find value of first sample in signal
HiF_first = HiF_tseries(1);
% Start signal from 0
HiF0_tseries = (HiF_tseries - HiF_first);
% Repeat for low frequencies
LoF_spec = Y;
LoF_spec(F > 8) = 0;
LoF_tseries = (ifft(LoF_spec, n, 'symmetric'));
LoF_tseries(size(data,1)+1:end) = [];
LoF_first = LoF_tseries(1);
LoF0_tseries = (LoF_tseries - LoF_first);
% Find the single largest LoF peak
[LoF_pk, LoF_loc] = findpeaks(LoF0_tseries,'SortStr','descend','NPeaks',1);
if isempty(LoF_pk)
    [LoF_pk, LoF_loc] = max(LoF0_tseries);
end
% Find first peak magnitude
% Typically the largest HiF0_time peak, but can occassionally be a few large ones
% Therefore, take the first occurring after 5% of stance duration
% Constraining to look only to the LoF_loc doesn't always work so we just let it take the first occurring
[HiF_pk_temp, ~] = findpeaks(HiF0_tseries(round(size(HiF0_tseries,1)*0.05):end));
if ~exist('HiF_pk','var') || isempty(HiF_pk_temp)
    HiF_pk_temp = max(HiF0_tseries(round(size(HiF0_tseries,1)*0.05):end));
end
HiF_pk = HiF_pk_temp(1);

% Estimate vGRF first peak magnitude
first = exp(c1_first + c2_first*LoF_pk + c3_first*HiF_pk + c4_first*sex + ...
    c5_first*mass + c6_first*height + c7_first*leg_length);

% Estimate vGRF second peak magnitude
second = exp(c1_second + c2_second*LoF_pk + c3_second*HiF_pk + c4_second*sex + ...
    c5_second*mass + c6_second*height + c7_second*leg_length);

end % function