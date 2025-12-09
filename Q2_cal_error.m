function [mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_gt,y_predict, M, filter_name)
    abs_error = abs(input_gt - y_predict);
    sq_error = (input_gt - y_predict).^2;
    l_inf_error = max(abs_error(M:end-1));

    mean_abs_error = sum(abs_error(M:end-1))/ (length(input_gt) - M);
    mean_sq_error = sum(sq_error(M:end-1))/ (length(input_gt) - M);
    fprintf(['%s', ...
    'abs_error: %.4f sq_error: %.4f l_inf_error: %.4f\n'], ...
    filter_name, ...
    mean_abs_error,  mean_sq_error,  l_inf_error);
end