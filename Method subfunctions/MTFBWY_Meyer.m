%% MTFBWY Meyer

% Meyer et al. attempted to estimate force as a function of maximal
% acceleration at the hip and participant mass

function [second] = MTFBWY_Meyer(data, location, participant)

% Check for appropriate accelerometer placement
if strcmp(location,'Left hip') || strcmp(location,'Right hip')
else
    warning('Inappropriate accelerometer placement for the Meyer method')
end

mass = participant(1);

% Find max acceleration
a_y_max = max(data(:,3));

% Find vGRF second peak magnitude
second = 9.8*mass*a_y_max;

end % function