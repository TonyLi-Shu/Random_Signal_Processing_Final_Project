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
[total_len,train_data,test_data] = split_train_test(Table_price_at_minute);

% Using close price as training
input_time = train_data(1:end-1, 1);
input_x = table2array(train_data(1:end - 1, 3));
input_gt = table2array(train_data(2:end, 3));
input_train = table2array(train_data(:, 3));
input_train_time = train_data(:, 1);
% input_train_gt = table2array(input_gt(:, 3));

Stock_NAME = "AMZN";
M = 5;
% Wiener

[y_wiener, w1] = my_wiener_filter(input_x, input_gt, M);
[abs_error,sq_error, l_inf_error] = cal_error(y_wiener, input_gt);
[abs_error,sq_error, l_inf_error] = plot_out(y_wiener, ...
    input_gt, input_time, 'minute', "Wiener filter", M, Stock_NAME);
print_error(abs_error,sq_error, l_inf_error, "Wiener filter")


% Least Square
iters = 5;
lr_ratio = 1;
[y_lms, w2] = my_LMS_filter(input_x, input_gt, M, iters, lr_ratio);
[abs_error,sq_error, l_inf_error] = cal_error(y_lms, input_gt);
[abs_error,sq_error, l_inf_error] = plot_out(y_lms, ...
    input_gt, input_time, 'minute', "Least Mean Square filter", M, Stock_NAME);
print_error(abs_error,sq_error, l_inf_error, "Least Mean Square filter")

% Recursive Least Square
lambda = 0.9998;
[y_rls,w3] = my_RLS_filter(input_x, input_gt, M, lambda);
[abs_error,sq_error, l_inf_error] = cal_error(y_rls, input_gt);
[abs_error,sq_error, l_inf_error] = plot_out(y_rls, ...
    input_gt, input_time, 'minute', "Recursive Least Square filter", M, Stock_NAME);
print_error(abs_error,sq_error, l_inf_error, "Recursive Least Square filter")


% Kalman
R = 1e-8 * eye(M);
V = 100;
[y_kalman, w4] = my_kalman_filter(input_x, input_gt, M, R, V);
[abs_error,sq_error, l_inf_error] = cal_error(y_kalman, input_gt);
[abs_error,sq_error, l_inf_error] = plot_out(y_kalman, ...
    input_gt, input_time, 'minute', "Kalman filter", M, Stock_NAME);
print_error(abs_error, sq_error, l_inf_error, "Kalman filter")


%% ====================================
% Compute the moving average MVA
% ema5 = my_moving_average(input_x, 5);
% ema50 = my_moving_average(input_x, 50);
% ema200 = my_moving_average(input_x, 200);



