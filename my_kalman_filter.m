function [y_pred,w] = my_kalman_filter(x, gt, M, R, V)
    % x : input training data
    % gt : desired signal (next-step target)
    % M : filter order
    % A : signal model
    % H : observation model


    if nargin < 5 || isempty(R)
        R = 1e-6 * eye(M);
    end

    if nargin < 5 || isempty(V)
        V = 1e-2;
    end

    N = length(x);
    w = zeros(M,1);
    P = 1e3 * eye(M);
    I = eye(M);
    y_pred = zeros(N, 1);
    % --- 2. Time the Function Execution ---
    tic; % Start the timer

    for n = M:N-1
        xn = x(n:-1:n-M+1);

        P = P + R;
        Kn = (P * xn) / (xn.' * P * xn + V); 
        
        err = gt(n+1) - w.' * xn;
        w = w + Kn * err;
    
        P = (I- Kn * xn.') * P;
        y_pred(n) = w.' * xn;
    end
%     y_pred =
     y_pred = filter(w, 1, x);
    elapsed_time = toc; % Stop the timer and store the elapsed time

    % --- 3. Print the Time Consumption ---
    fprintf('Kalman Filter Execution Time (N=%d samples): %.4f seconds\n', N, elapsed_time);
end