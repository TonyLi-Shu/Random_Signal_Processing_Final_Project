function plot_out_Q2(y_predict, ...
    input_gt, ema5, ema50, ema200, input_time, date_time, filter_name, M, Stock_name)


    if nargin < 4 || isempty(date_time)
        date_time = "day";
    end
    % === 1. Calculate Error Metrics ===
    % Calculate Absolute Error (l1 time series error)
    
    % === 2. Prepare Time Data ===
    % Extract the datetime array from the table.
    datetime_array = input_time{:, 1};
    
    % ==========================================================
    %                  FIGURE 1: L1 (Absolute) Error
    % ==========================================================
    figure;
    hold on;
    
    % Plot 1: Predicted Price (y_predict)
    plot(datetime_array, y_predict, 'b', 'LineWidth', 2, 'DisplayName', 'Predicted Price');
    
    % Plot 2: Ground Truth Price (input_gt)
    plot(datetime_array, input_gt, 'r--', 'LineWidth', 2, 'DisplayName', 'Ground Truth Price');
    
    % Plot 3: Absolute Error (l1 time-series error)
    plot(datetime_array, ema5,'-.','Color',[1 0.5 0], 'LineWidth', 2, 'DisplayName', 'Moving Average 5');
    plot(datetime_array, ema50, 'k-.', 'LineWidth', 2, 'DisplayName', 'Moving Average 50');
    plot(datetime_array, ema200, 'm-.', 'LineWidth', 2, 'DisplayName', 'Moving Average 200');

    hold off;
    
    % === Formatting for Figure 1 ===
    title(Stock_name+' '+ filter_name + ' ('+ M + ') Vs Moving Average', 'FontSize', 25, 'Interpreter', 'latex');
    xlabel('Date', 'FontSize', 20);
    ylabel('Price / Absolute Error Magnitude', 'FontSize', 20);
    legend('show', 'Location', 'best', 'Interpreter', 'latex', 'Fontsize', 20);
    grid on;
    switch lower(date_time)
    case 'second'
        % Displays Month, Day, Year, Hour, Minute, and Second 
        % (e.g., 'Dec-06-25 22:12:00')
        datetick('x', 'mmm-dd-yy HH:MM:SS', 'keeplimits');
    case 'minute'
        % Displays Month, Day, Year, Hour, and Minute 
        % (e.g., 'Dec-06-25 22:12')
        datetick('x', 'mmm-dd-yy HH:MM', 'keeplimits');
    case 'hour'
        % Displays Month, Day, Year, and Hour 
        % (e.g., 'Dec-06-25 22:00')
        datetick('x', 'mmm-dd-yy HH:00', 'keeplimits');
    case 'day'
        % Displays Month and Year (already in your original format)
        datetick('x', 'mmm-yy', 'keeplimits');
    end
    
%     % ==========================================================
%     %                  FIGURE 2: L2 (Squared) Error
%     % ==========================================================
%     figure;
%     hold on;
%     
%     % Plot 1: Predicted Price (y_predict)
%     plot(datetime_array, y_predict, 'b', 'LineWidth', 1.5, 'DisplayName', 'Predicted Price');
%     
%     % Plot 2: Ground Truth Price (input_gt)
%     plot(datetime_array, input_gt, 'r--', 'LineWidth', 1, 'DisplayName', 'Ground Truth Price');
%     
%     % Plot 3: Squared Error (l2 time-series error)
%     % Note: Squared Error values might be significantly smaller than price, 
%     % making them hard to see on the same axis if prices are large and errors are small.
%     % This plot explicitly shows how large errors are penalized.
%     plot(datetime_array, sq_error, 'm:', 'LineWidth', 1.5, 'DisplayName', 'Squared Error ($l_2$)');
%     
%     hold off;
%     
%     % === Formatting for Figure 2 ===
%     title(Stock_name+' '+ filter_name + ' ('+ M + '): Price Prediction and Squared Error ($l_2$)', 'FontSize', 25, 'Interpreter', 'latex');
%     xlabel('DateTime', 'FontSize', 20);
%     ylabel('Price / Squared Error Magnitude', 'FontSize', 20);
%     legend('show', 'Location', 'best', 'Interpreter', 'latex');
%     grid on;
    
    
     

end