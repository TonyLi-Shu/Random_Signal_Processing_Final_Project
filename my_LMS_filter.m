function [y_pred, w] = my_LMS_filter(x, gt, M, iters, ratio)
    % x : input training data
    % gt : desired signal (next-step target)
    % M : filter order
    % lr: step size
    % iters: iterations 
    
    N = size(x, 1);
    w = zeros(M, 1);
    y_pred = zeros(N, 1);
    
    

    % Rxx = (1/N) * X' * X 
    Rxx = (1 / N) * (x' * x);
    % 3. Find the Maximum Eigenvalue (lambda_max)
    lambda = eig(Rxx);
    lambda_max = max(lambda);
    % === Calculate the Learning Rate (lr) ===
    % We choose a value slightly less than 2/lambda_max for guaranteed convergence, 
    % often a fraction of the maximum theoretical bound.
    mu_max = 2 / lambda_max;
    lr = ratio * mu_max; % Choosing 50% of the maximum allowed rate
    
    % --- 2. Time the Function Execution ---
    tic; % Start the timer

    for i = 1:iters
        for n = M:N-1
            % [x_{t}, x_{t-1}, x_{t-2}, ...]
            xn = x(n:-1:n-M+1); 
            y = w' * xn;
            err = gt(n) - y;
            w = w + lr * err * xn; % / (xn' * xn);
        end
    end
   
    y_pred = filter(w, 1, x);
    

    elapsed_time = toc; % Stop the timer and store the elapsed time
    % --- 3. Print the Time Consumption ---
    fprintf('Least Mean Square Execution Time (N=%d samples): %.4f seconds\n', N, elapsed_time);
end

