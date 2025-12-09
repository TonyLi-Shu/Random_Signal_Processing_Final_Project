function [abs_error,sq_error,l_inf_error ] = cal_error(input_gt,y_predict)
    % === 1. Calculate Error Metrics ===
    % Calculate Absolute Error (l1 time series error)
    abs_error = abs(input_gt - y_predict);
    % Calculate Squared Error (l2 time series error)
    sq_error = (input_gt - y_predict).^2;
    % Calculate the L_infinity norm (Maximum Absolute Error)
    % This is a single scalar representing the peak error over the period.
    l_inf_error = max(abs_error);

end