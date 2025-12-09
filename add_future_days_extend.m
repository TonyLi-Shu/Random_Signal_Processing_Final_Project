function extended_time = add_future_days_extend(input_time, N)
% ADD_FUTURE_DAYS_EXTEND
%   Extends input_time by adding N future business days (skipping weekends).
%   Returns the combined vector [input_time; future_days].

    last_date = input_time(end);

    % Preallocate as datetime (very important!)
    future_time = NaT(N,1);   % Create empty datetime array

    d = last_date;
    idx = 1;

    while idx <= N
        d = d + 1;  % next calendar day
        if ~ismember(weekday(d), [1,7])  % skip Sunday(1) & Saturday(7)
            future_time(idx) = d;
            idx = idx + 1;
        end
    end

    % Combine original and future dates
    extended_time = [input_time; future_time];
end