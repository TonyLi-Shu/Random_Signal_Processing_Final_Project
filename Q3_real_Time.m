%% ===============================
%  Main script for Q1
%
%% ===============================

clear; clc; close all;


Stock_NAME = "GOOGL";
start_date = datetime(2025, 11, 25);
end_date   = datetime(2025, 12, 30);

% === load data ===
data_path = 'D:/ECE_PhD/Random_Signal_Analysis/Final_project/Q3/';
NVDA = fullfile(data_path, Stock_NAME + '.xlsx');
Table_price = sortrows(readtable(NVDA), 'Date');
[total_len,train_data,test_data] = split_train_test(Table_price, 0.8);

input_time = train_data(2:end, 1);
input_x = table2array(train_data(1:end - 1, 5));
input_gt = table2array(train_data(2:end, 5));
input_test_time = test_data(2:end, 1).Date;


extended_input_test_time = add_future_days_extend(input_test_time, 10);
input_test_x = table2array(test_data(1:end - 1, 5));
input_test_gt = table2array(test_data(2:end, 5));

M = 5;
test_k = 10;
[y_wiener, w1] = my_wiener_filter(input_x, input_gt, M);
R = 1e-8 * eye(M);
V = 100;
[y_kalman, w4] = my_kalman_filter(input_x, input_gt, M, R, V);


[y_pred1] = predict_filter(input_test_x, w1, M, test_k);
[y_pred4] = predict_filter(input_test_x, w4, M, test_k);
[extended_time, extended_price] = forecast_extend(input_test_x, w1, M, test_k, input_test_time);
[ema5] = my_moving_average(extended_price, 5);
[ema20] = my_moving_average(extended_price, 20);
[ema50] = my_moving_average(extended_price, 50);
plot_out_Q3(extended_price, ...
    extended_price, ema5, ema20, ema50, extended_time, 'day', "Wiener filter", M, Stock_NAME, start_date, end_date);


[extended_time, extended_price] = forecast_extend(input_test_x, w4, M, test_k, input_test_time);
[ema5] = my_moving_average(extended_price, 5);
[ema20] = my_moving_average(extended_price, 20);
[ema50] = my_moving_average(extended_price, 50);
plot_out_Q3(extended_price, ...
    extended_price, ema5, ema20, ema50, extended_time, 'day', "Kalman filter", M, Stock_NAME, start_date, end_date);
% [mean_abs_error,mean_sq_error,l_inf_error ] = Q2_cal_error(input_test_gt, y_pred1, M, "Wiener filter");
