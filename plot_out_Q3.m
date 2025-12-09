function plot_out_Q3(y_predict, ...
    input_gt, ema5, ema20, ema50, ...
    input_time, date_time, filter_name, ...
    M, Stock_name, ...
    start_date, end_date)


    if nargin < 4 || isempty(date_time)
        date_time = "day";
    end
    % === 1. Calculate Error Metrics ===
    % Calculate Absolute Error (l1 time series error)
    
    % === 2. Prepare Time Data ===
    % Extract the datetime array from the table.
    datetime_array = input_time;
    
    % ==========================================================
    %                  FIGURE 1: L1 (Absolute) Error
    % ==========================================================
    figure;
    hold on;
    
    % Plot 1: Predicted Price (y_predict)
    plot(datetime_array, y_predict, 'b', 'LineWidth', 2, 'DisplayName', 'Predicted Price');
    
    % Plot 2: Ground Truth Price (input_gt)
%     plot(datetime_array, input_gt, 'r--', 'LineWidth', 2, 'DisplayName', 'Ground Truth Price');
    
    % Plot 3: Absolute Error (l1 time-series error)
    plot(datetime_array, ema5,'-.','Color',[1 0.5 0], 'LineWidth', 2, 'DisplayName', 'Moving Average 5');
    plot(datetime_array, ema20, 'k-.', 'LineWidth', 2, 'DisplayName', 'Moving Average 20');
%     plot(datetime_array, ema200, 'm-.', 'LineWidth', 2, 'DisplayName', 'Moving Average 200');

    hold off;
    
    % === Formatting for Figure 1 ===
    title(Stock_name+' '+ filter_name + ' ('+ M + ') Vs Moving Average', 'FontSize', 25, 'Interpreter', 'latex');
    xlabel('Date', 'FontSize', 20);
    ylabel('Price / Absolute Error Magnitude', 'FontSize', 20);
    legend('show', 'Location', 'best', 'Interpreter', 'latex', 'Fontsize', 20);
    grid on;


    % Logical mask for the window
    mask = (input_time >= start_date) & (input_time <= end_date);

    if any(mask)
        % Stack all series in the window and get min/max
        y_window = [ y_predict(mask); ...
                     input_gt(mask);];

        y_min = min(y_window);
        y_max = max(y_window);

        % Small padding so curves aren’t touching the frame
        pad = 0.02 * (y_max - y_min);
        if pad == 0
            pad = max(1, 0.01 * y_max);  % fallback if flat
        end

        xlim([start_date, end_date]);
        ylim([y_min - pad, y_max + pad]);
    end
    
    %% ====== NEW: force daily x-ticks & format ======
    if any(mask)
        set(gca, 'XTick', start_date:end_date);
        datetick('x', 'mmm-dd', 'keepticks');
    end
    
    

end