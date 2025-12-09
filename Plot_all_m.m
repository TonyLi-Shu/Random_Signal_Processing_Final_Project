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

iters = 10;
lr_ratio = 0.01;
lambda = 0.9998;

V = 100;


M_range = 1:20;
test_k = 10;
mse_wiener = zeros(length(M_range),1);
mse_lms    = zeros(length(M_range),1);
mse_rls    = zeros(length(M_range),1);
mse_kalman = zeros(length(M_range),1);


for idx = 1:length(M_range)
    M = M_range(idx);
    R = 1e-8 * eye(M);
    [y_wiener, w1] = my_wiener_filter(input_x, input_gt, M);
    [y_lms, w2] = my_LMS_filter(input_x, input_gt, M, iters, lr_ratio);
    [y_rls,w3] = my_RLS_filter(input_x, input_gt, M, lambda);
    [y_kalman, w4] = my_kalman_filter(input_x, input_gt, M, R, V);
    

    [y_pred1] = predict_filter(input_test_x, w1, M, test_k);
    [y_pred2] = predict_filter(input_test_x, w2, M, test_k);
    [y_pred3] = predict_filter(input_test_x, w3, M, test_k);
    [y_pred4] = predict_filter(input_test_x, w4, M, test_k);

    [~, mse_wiener(idx),~] = Q2_cal_error(input_test_gt, y_pred1, M, "Wiener");
    [~, mse_lms(idx),   ~] = Q2_cal_error(input_test_gt, y_pred2, M, "LMS");
    [~, mse_rls(idx),   ~] = Q2_cal_error(input_test_gt, y_pred3, M, "RLS");
    [~, mse_kalman(idx),~] = Q2_cal_error(input_test_gt, y_pred4, M, "Kalman");
end


% === Plotting ===
figure; hold on; grid on;
plot(M_range, mse_wiener, '-o', 'LineWidth',2, 'Color',[0 0.2 0.6]);
% plot(M_range, mse_lms,    '-s', 'LineWidth',2, 'Color',[0.1 0.6 0.1]);
plot(M_range, mse_rls,    '-^', 'LineWidth',2, 'Color',[0.8 0 0.1]);
plot(M_range, mse_kalman, '-d', 'LineWidth',2, 'Color',[0.3 0.3 0.3]);

xlabel('Filter Order M', 'FontSize', 20);
ylabel('Test Mean Squared Error', 'FontSize', 20);
title('Mean Square error on different Order M for Different Filters', 'FontSize', 20);
legend('Wiener','RLS','Kalman', 'Location','best', 'FontSize', 15);
