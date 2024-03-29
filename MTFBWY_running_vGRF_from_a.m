%% MAY THE FORCE BE WITH YOU -- running vertical GRF from acceleration

% Dovin Kiernan
% University of California Davis Human Performance Lab
% 23/08/25

%% LICENSING

% Original content distributed under GNU GENERAL PUBLIC LICENSE v3

%% PURPOSE

% This function takes accelerometer data from either the shank or low-back/sacrum 
% and enters it into the user's choice of one of several possible vertical ground reaction
% force estimation methods. The function then returns estimated force parameters including:
% % first peak magnitude,
% % loading rate to the first peak,
% % second peak magnitude,
% % average force, and/or
% % time series

%% INPUTS

% Data 
% % A matrix with data from a single segmented stance. Each row
% % corresponding to a single frame and columns correspond to:
% % % Column 1 -- Time stamps (in ms)
% % % Columns 2:4 -- Linear acceleration x, y, and z in g (~9.8 m/s^2 depending on location data were collected)

% Note on data conventions
% % All coordinate systems per ISB and as described in Wu & Cavanagh 1995 and our paper
% % +x is anterior (direction of progression)
% % +y is proximal (or vertical)
% % +z is right

% Location
% String specifying wearable location
% % 'Left shank'
% % 'Right shank'
% % 'Left hip'
% % 'Right hip'
% % 'Sacrum'

% Coordinate convention (coord_conv)
% % 'WCS' -- wearable coordiante system
% % 'SCS' -- segment coordinate system
% % 'TCCS' -- tilt-corrected coordinate system

% Method
% % String specifying the method to be used (last name of first author)
% % % 'Neugebauer'-- Neugebauer et al. 2012 and 2014
% % % 'Charry' -- Charry et al. 2013
% % % 'Wundersitz' -- Wundersitz et al. 2013
% % % 'Meyer' -- Meyer et al. 2015
% % % 'Gurchiek' -- Gurchiek et al. 2017
% % % 'Thiel' -- Thiel et al. 2018
% % % 'Kiernan' -- Kiernan et al. 2020
% % % 'Kim' -- Kim et al. 2020
% % % 'Pogson' -- Pogson et al. 2020
% % % 'Day' -- Day et al. 2021
% % % 'Higgins' -- Higgins et al. 2021
% % % 'Veras' -- Veras et al. 2022

% Sub-method (only for methods specified below)
% % Several of the methods have submethods
% % % Wundersitz submethods based on filter 
% % % % '10 Hz'
% % % % '15 Hz'
% % % % '20 Hz'
% % % % '25 Hz'
% % % % 'Raw'
% % % Kiernan submethod is auto-specified based on location (no input necessary)
% % % Kim submethods based on input
% % % % 'acceleration'
% % % % 'displacement'
% % % Pogson submethods based on input and/or training data set
% % % % 'Pogson'
% % % % 'xynorm'
% % % % 'Auvinet'
% % % Day submethods based on filter -- but filtering must be done OUTSIDE
% this function; thus, no submethod input is required
% % % % '5 Hz'
% % % % '10 Hz'
% % % % '30 Hz'
% % % Higgins submethod is auto-specified based on location (no input necessary)
% % % Veras submethod based on location and input (location auto-specified)
% % % % 'y'
% % % % 'res'

% Participant
% % 1x5 array containing sex, age, and anthropometric details on the participant
% % Not required for all methods, leave uneccessary fields blank or NaN-fill
% % (1) Mass
% % % Participant mass in kg
% % (2) Height
% % % Participant height in cm
% % (3) Leg length
% % % Distance from greater trochanter to ground in cm
% % (4) Sex
% % % 1 for 'Male' or 0 for 'Female' (no methods were developed with non-binary participants)
% % (5) Age
% % % Participant age in years

%% OUTPUTS
% Not all methods are capable of estimating all parameters
% See Table 2 of our paper for an overview
% To the extent the selected method is capable the following outputs are provided:
% % Discrete values:
% % % First peak magnitude
% % % Loading rate to first peak
% % % Second peak magnitude
% % % Average force
% % Continuous values:
% % % Force time series

%% DEPENDENCIES

% This main function calls on sub-functions for each method
% Some of these method sub-functions are dependent on supporting data that are included with the download
% The only other necessary function is: ScaleTime
% % Jan (2023). ScaleTime (https://www.mathworks.com/matlabcentral/fileexchange/25463-scaletime), MATLAB Central File Exchange. Retrieved September 10, 2023.
% % https://www.mathworks.com/matlabcentral/fileexchange/25463-scaletime

%% CODE

% This wrapper function...
% (1) finds the necessary sub- and supporting-functions
% (2) defines some constants
% (3) calls the sub-function for the specified method

function [first, rate, second, average, tseries] = MTFBWY_running_vGRF_from_a(data, location, coord_conv, method, submethod, participant)

% % UI select the path where the sub-functions are stored
% subfunction_path = uigetdir('Path to gait event ID subfunctions folder');
% addpath(subfunction_path);
%  Alternatively, get rid of UI
addpath(genpath('D:\Research\Davis_Human Performance Lab\2_1_May the force be with you\Code\MTFBWY and tester\MTFBWY'))

% Calculate sample frequency from time stamps
Fs = 1000/mean(diff(data(:,1)));
% % Alternatively, UI specify your sample frequency
% Fs = cell2mat(inputdlg('Enter sample frequency'));

% Fill outputs with NaNs
% Methods that are capable of estimating will overwrite
first = NaN; rate = NaN; second = NaN; average = NaN; tseries = NaN;

% Choose which method to call
switch method
    case 'Neugebauer'
        [second] = MTFBWY_Neugebauer(data, location, coord_conv, participant);
    case 'Charry'
        [second] = MTFBWY_Charry(data, location, coord_conv, participant);
    case 'Wundersitz'
        [second] = MTFBWY_Wundersitz(data, location, submethod, participant, Fs);
    case 'Meyer'
        [second] = MTFBWY_Meyer(data, location, participant);
    case 'Gurchiek'
        [first, rate, second, average, tseries] = MTFBWY_Gurchiek(data, location, participant, Fs);
    case 'Thiel'
        [second] = MTFBWY_Thiel(data, location, coord_conv);
    case 'Kiernan'
        [first, second] = MTFBWY_Kiernan(data, location, coord_conv, participant, Fs); % submethod autospecified based on location
    case 'Kim'
        [first, rate, second, average, tseries] = MTFBWY_Kim(data, location, coord_conv, submethod, participant, Fs);
    case 'Pogson'
        [first, rate, second, average, tseries] = MTFBWY_Pogson(data, location, coord_conv, submethod, participant, Fs);
    case 'Day' % If running the Day method you must filter the time series before segmenting by stance
        [first, rate, second, average, tseries] = MTFBWY_Day(data, location, participant, Fs);
    case 'Higgins'
        [first, rate] = MTFBWY_Higgins(data, location, coord_conv, participant); % submethod autospecified based on location
    case 'Veras'
        [rate, second] = MTFBWY_Veras(data, location, coord_conv, submethod, participant); % location part of submethod autospecified
end % switch method

end % function
