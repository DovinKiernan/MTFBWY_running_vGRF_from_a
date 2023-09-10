%% MTFBWY Pogson

% Pogson et al. developed a multi-layer perceptron to estimate ground
% reaction forces from upper back accelerations. We adapted this method to
% the sacrum.

% For running these methods on big data sets, probably much faster to make
% the net global so it doesn't need to be loaded every time

function [first, rate, second, average, tseries] = MTFBWY_Pogson(data, location, coord_conv, submethod, participant, Fs)

% Check for appropriate accelerometer placement
if ~strcmp(location,'Sacrum')
    warning('Inappropriate accelerometer placement for the Pogson method')
end

mass = participant(1);

% Find stance time in ms
stance_t = size(data,1)*1000/Fs;

% We created networks for each of the 3 submethods in each of 3 potential 
% coordinate systems using our 74 participants
% % WCS -- wearable coordinate system
% % SCS -- segment coordinate system
% % TCCS -- tilt-corrected coordinate system
switch submethod
    case 'Pogson'
        % Zero pad the data to 400 ms
        a_zeros = zeros(1,round(Fs*0.4));
        a_zeros(1:size(data,1)) = data(:,3)';
        switch coord_conv
            case 'WCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_Pogson_WCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_zeros*Pogson_Pogson_a_PCA_coeff_WCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_Pogson_net_WCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_Pogson_F_PCA_coeff_WCS(:,1:8)' + Pogson_Pogson_F_PCA_mu_WCS;
            case 'SCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_Pogson_SCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_zeros*Pogson_Pogson_a_PCA_coeff_SCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_Pogson_net_SCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_Pogson_F_PCA_coeff_SCS(:,1:8)' + Pogson_Pogson_F_PCA_mu_SCS;
            case 'TCCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_Pogson_TCCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_zeros*Pogson_Pogson_a_PCA_coeff_TCCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_Pogson_net_TCCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_Pogson_F_PCA_coeff_TCCS(:,1:8)' + Pogson_Pogson_F_PCA_mu_TCCS;
        end
        % Remove zero padding
        % Find the max
        [~, max_t_temp] = max(estimated_tseries);
        % Then from the max to the end of the signal, find the first frame below 10 N
        first_below_10_temp = find(estimated_tseries(max_t_temp:end)<10,1,'first');
        first_below_10_temp = first_below_10_temp + max_t_temp - 1;
        % And the first frame where the derivative is positive
        first_pos_deriv_temp = find(diff(estimated_tseries(max_t_temp:end))>0,1,'first');
        first_pos_deriv_temp = first_pos_deriv_temp + max_t_temp - 1;
        if isempty(first_pos_deriv_temp) || first_pos_deriv_temp > first_below_10_temp
            cut_point = first_below_10_temp - 1;
        else
            cut_point = first_pos_deriv_temp;
        end
        tseries = ScaleTime(estimated_tseries(1:cut_point), 1, size(estimated_tseries(1:cut_point),2), size(data,1))';
    case 'xynorm'
        % Scale the x-axis from 0 to 100 percent stance
        a_scale = ScaleTime(data(:,3), 1, size(data,1), 101)';
        % Scale the y-axis by mass*gravity (BW)
        a_scale = a_scale.*mass.*9.8;
        switch coord_conv
            case 'WCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_xynorm_WCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_scale*Pogson_xynorm_a_PCA_coeff_WCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_xynorm_net_WCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_xynorm_F_PCA_coeff_WCS(:,1:8)' + Pogson_xynorm_F_PCA_mu_WCS;
            case 'SCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_xynorm_SCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_scale*Pogson_xynorm_a_PCA_coeff_SCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_xynorm_net_SCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_xynorm_F_PCA_coeff_SCS(:,1:8)' + Pogson_xynorm_F_PCA_mu_SCS;
            case 'TCCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_xynorm_TCCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_scale*Pogson_xynorm_a_PCA_coeff_TCCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_xynorm_net_TCCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_xynorm_F_PCA_coeff_TCCS(:,1:8)' + Pogson_xynorm_F_PCA_mu_TCCS;
        end
        tseries = ScaleTime(estimated_tseries,1,101,size(data,1))';
    case 'Auvinet'
        % Scale the x-axis from 0 to 100 percent stance
        a_scale = ScaleTime(data(:,3), 1, size(data,1), 101)';
        % Scale the y-axis by mass*gravity (BW)
        a_scale = a_scale.*mass.*9.8;
        switch coord_conv
            case 'WCS'
                warning('WCS-specific net was not calculated for Pogson_Auvinet')
            case 'SCS'
                % Load previously conducted acceleration and force PCAs and
                % previously trained network
                load('Pogson_Auvinet_SCS.mat')
                % Convert acceleration data to PCs based on previously conducted PCA
                input_a_PCs = a_scale*Pogson_Auvinet_a_PCA_coeff_SCS(:,1:6);
                % Add stance time
                input_data = [input_a_PCs stance_t];
                % Estimate force
                estimated_PCs = predict(Pogson_Auvinet_net_SCS,input_data);
                % Reconstruct the force signal with the estimated PCs
                estimated_tseries = estimated_PCs*Pogson_Auvinet_F_PCA_coeff_SCS(:,1:8)' + Pogson_Auvinet_F_PCA_mu_SCS;
            case 'TCCS'
                warning('TCCS-specific net was not calculated for Pogson_Auvinet')
        tseries = ScaleTime(estimated_tseries,1,101,size(data,1))';
        end
end

% Estimate the discrete variables from the tseries
[first, rate, second, average] = MTFBWY_discrete_extractor(tseries, Fs);

end % function