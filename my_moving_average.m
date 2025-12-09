function ema = my_moving_average(input_x, window)
    % x : input training data
    % window : filter size

    kernel = ones(window,1)/window;
    ema = filter(kernel,1,input_x);
    
end