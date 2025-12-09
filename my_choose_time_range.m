function result_table = my_choose_time_range(input_table, time_range, time_num)
    % input_table : input data that contains the Datetime, price
    % time_range: str, help usr to choose the time range they want 
    % options: '1 minute', '1 hour', '4 hours', '1 day', '1 week', '1 month'
    
    %% Defaults
    if nargin < 2 || isempty(time_range)
        time_range = "minute";
    end
    if nargin < 3 || isempty(time_num)
        time_num = 1;
    end
    
    %% ---------- Extract columns ----------
    dt = input_table{:,1};
    if ~isdatetime(dt)
        dt = datetime(dt, 'InputFormat','yyyy-MM-dd HH:mm:ss');
    end
    
    Open   = double(input_table{:,2});
    Close  = double(input_table{:,3});
    High   = double(input_table{:,4});
    Low    = double(input_table{:,5});
    Volume = double(input_table{:,6});
    
    %% ---------- U.S. market hours (09:30–16:00) ----------
    Topen  = duration(9,30,0);
    Tclose = duration(16,0,0);
    idx = (timeofday(dt) >= Topen) & (timeofday(dt) <= Tclose);
    
    dt = dt(idx);
    Open = Open(idx);
    Close = Close(idx);
    High = High(idx);
    Low = Low(idx);
    Volume = Volume(idx);
    
    %% ---------- Create bin timestamps ----------
    switch lower(time_range)
        case 'second'
            edges = dateshift(dt,'start','second');
            edges.Second = edges.Second - mod(edges.Second, time_num);
    
        case 'minute'
            edges = dateshift(dt,'start','minute');
            edges.Minute = edges.Minute - mod(edges.Minute, time_num);
    
        case 'hour'
            edges = dateshift(dt,'start','hour');
            edges.Hour = edges.Hour - mod(edges.Hour, time_num);
    
        case 'day'
            edges = dateshift(dt,'start','day');
            edges.Day = edges.Day - mod(day(edges)-1, time_num);
    
        case 'week'
            % weeks grouped by numeric week number
            wk = week(dt);
            edges = wk - mod(wk - min(wk), time_num);
            edges = edges(:);  % numeric labels
    
        case 'month'
            edges = dateshift(dt,'start','month');
            edges.Month = edges.Month - mod(month(edges)-1, time_num);
    
        otherwise
            error("time_range must be: second, minute, hour, day, week, month");
    end
    
    %% ---------- Handle week case (numeric edges) ----------
    if isduration(edges) || isdatetime(edges)
        % datetime → convert to a grouping key
        [G, bin_times] = findgroups(edges);
    else
        % numeric week bins
        [G, wk_group] = findgroups(edges);
        % convert numeric week groups into representative start times
        % choose min timestamp for each group
        bin_times = splitapply(@min, dt, G);
    end
    
    %% ---------- Apply OHLCV aggregation ----------
    Open_out   = splitapply(@(x)x(1),   Open,   G);
    Close_out  = splitapply(@(x)x(end), Close,  G);
    High_out   = splitapply(@max,       High,   G);
    Low_out    = splitapply(@min,       Low,    G);
    Volume_out = splitapply(@sum,       Volume, G);
    
    %% ---------- Construct output ----------
    result_table = table(bin_times, Open_out, Close_out, High_out, Low_out, Volume_out, ...
        'VariableNames', {'StartTime','Open','Close','High','Low','Volume'});
end