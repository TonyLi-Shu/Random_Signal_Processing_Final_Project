%% ===============================
%  Main script for Q1
%
%% ===============================

clear; clc; close all;

% === load data ===
data_path = 'D:/ECE_PhD/Random_Signal_Analysis/Final_project/MINUTE_AMZN_2012-2021.mat';

load(data_path);
Table_price = sortrows(AMZN, 'Datetime');

Table_price_at_minute = my_choose_time_range(Table_price);
Table_price_at_date = my_choose_time_range(Table_price, 'day', 1);
[total_len,train_data,test_data] = split_train_test(Table_price_at_date);

% Using close price as training
input_time = train_data(2:end, 1);
input_x = table2array(train_data(1:end - 1, 3));
input_gt = table2array(train_data(2:end, 3));

input_test_time = test_data(2:end, 1);
input_test_x = table2array(test_data(1:end - 1, 3));
input_test_gt = table2array(test_data(2:end, 3));

Stock_NAME = "AMZN";
M = 10;
test_k = 10;
% Wiener

[y_wiener, w1] = my_wiener_filter(input_x, input_gt, M);
iters = 100;
lr_ratio = 1;
[y_lms, w2] = my_LMS_filter(input_x, input_gt, M, iters, lr_ratio);
lambda = 0.9998;
[y_rls,w3] = my_RLS_filter(input_x, input_gt, M, lambda);
R = 1e-8 * eye(M);
V = 100;
[y_kalman, w4] = my_kalman_filter(input_x, input_gt, M, R, V);



[ema5] = my_moving_average(input_test_x, 5);
[ema20] = my_moving_average(input_test_x, 20);
[ema50] = my_moving_average(input_test_x, 50);
[ema200] = my_moving_average(input_test_x, 200);

[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, ema5, 5, 'Moving Average 5');
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, ema50, 50, 'Moving Average 50');
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, ema200, 200, 'Moving Average 200');



[y_pred1] = predict_filter(input_test_x, w1, M, test_k);
plot_out_Q2(y_pred1, ...
    input_test_gt, ema5, ema50, ema200, input_test_time, 'day', "Wiener filter", M, Stock_NAME);
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, y_pred1, M, "Wiener filter");

[y_pred2] = predict_filter(input_test_x, w2, M, test_k);
plot_out_Q2(y_pred2, ...
    input_test_gt, ema5, ema50, ema200, input_test_time, 'day', "LMS filter", M, Stock_NAME);
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, y_pred2, M, "LMS filter");

[y_pred3] = predict_filter(input_test_x, w3, M, test_k);
plot_out_Q2(y_pred3, ...
    input_test_gt, ema5, ema50, ema200, input_test_time, 'day', "RLS filter", M, Stock_NAME);
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, y_pred3, M, "RLS filter");

[y_pred4] = predict_filter(input_test_x, w4, M, test_k);
plot_out_Q2(y_pred4, ...
    input_test_gt, ema5, ema50, ema200, input_test_time, 'day', "Kalman filter", M, Stock_NAME);
[mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, y_pred4, M, "Kalman filter");



% % Least Square
% iters = 5;
% lr_ratio = 1;
% [y_lms, w2] = my_LMS_filter(input_x, input_gt, M, iters, lr_ratio);
% [abs_error,sq_error, l_inf_error] = cal_error(y_lms, input_gt);
% [abs_error,sq_error, l_inf_error] = plot_out(y_lms, ...
%     input_gt, input_time, 'minute', "Least Mean Square filter", M, Stock_NAME);
% print_error(abs_error,sq_error, l_inf_error, "Least Mean Square filter")
% 
% % Recursive Least Square
% lambda = 0.9998;
% [y_rls,w3] = my_RLS_filter(input_x, input_gt, M, lambda);
% [abs_error,sq_error, l_inf_error] = cal_error(y_rls, input_gt);
% [abs_error,sq_error, l_inf_error] = plot_out(y_rls, ...
%     input_gt, input_time, 'minute', "Recursive Least Square filter", M, Stock_NAME);
% print_error(abs_error,sq_error, l_inf_error, "Recursive Least Square filter")
% 
% 
% % Kalman
% R = 1e-8 * eye(M);
% V = 100;
% [y_kalman, w4] = my_kalman_filter(input_x, input_gt, M, R, V);
% [abs_error,sq_error, l_inf_error] = cal_error(y_kalman, input_gt);
% [abs_error,sq_error, l_inf_error] = plot_out(y_kalman, ...
%     input_gt, input_time, 'minute', "Kalman filter", M, Stock_NAME);
% print_error(abs_error, sq_error, l_inf_error, "Kalman filter")


%% ====================================
% Compute the moving average MVA
% ema5 = my_moving_average(input_x, 5);
% ema50 = my_moving_average(input_x, 50);
% ema200 = my_moving_average(input_x, 200);



