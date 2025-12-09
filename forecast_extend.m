function [extended_time, extended_price] = forecast_extend(x, w, M, k, time_vec)

    % ===== Safety: Convert table column to datetime =====
    if istable(time_vec)
        time_vec = time_vec{:,1};
    end
    if ~isdatetime(time_vec)
        error("time_vec must be a datetime vector.");
    end

    % ===== Safety: Check filter order =====
    if length(x) < M
        error("Filter order M (%d) is greater than data length (%d).", M, length(x));
    end

    %% ---- 1) Predict K future samples ----
    last_window = x(end:-1:end-M+1);
    forecast_future = zeros(k,1);

    for kk = 1:k
        if kk == 1
            reg = last_window;
        else
            combined = [forecast_future(kk-1:-1:1); last_window];
            reg = combined(1:M);
        end
        forecast_future(kk) = w.' * reg;
    end

    %% ---- 2) Extend Dates ----
    last_date = time_vec(end);
    future_time = NaT(k,1);
    d = last_date;
    idx = 1;

    while idx <= k
        d = d + 1;
        if ~ismember(weekday(d), [1,7])
            future_time(idx) = d;
            idx = idx + 1;
        end
    end

    %% ---- 3) Merge ----
    extended_time  = [time_vec; future_time];
    extended_price = [x; forecast_future];
end