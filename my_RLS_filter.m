function [y_pred,w] = my_RLS_filter(x, gt, M, lambda)
    % x : input training data
    % gt : desired signal (next-step target)
    % M : filter order
    % lambda: forgetting factor
    % delta: initial covariance scale

    N = length(x);
    w = zeros(M, 1);
    P = eye(M);
    y_pred = zeros(N, 1);
    
    % --- 2. Time the Function Execution ---
    tic; % Start the timer


    for n = M:N-1
        xn = x(n:-1:n-M+1);
        gn = (P*xn) / (lambda + xn'*P*xn);
        err = gt(n+1) - w.'*xn;
        w = w + gn*err;
        P = (1/lambda)*(P - gn*xn.'*P);
%         y_pred(n+1) = w.' * xn;
    end
    
    y_pred = filter(w, 1, x);
    elapsed_time = toc; % Stop the timer and store the elapsed time
    % --- 3. Print the Time Consumption ---
    fprintf('Recursive Filter Execution Time (N=%d samples): %.4f seconds\n', N, elapsed_time);

end