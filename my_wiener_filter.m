function [y_pred, w] = my_wiener_filter(x, gt, M)
    % x : input training data
    % gt : desired signal (next-step target)
    % M : filter order

    N = length(x);
    tic; % Start the timer


%     Rxx_raw = xcorr(x, M, 'biased');
% choosing non-negative lag from (-M, M) to (0, M)
%     Rxx = toeplitz(Rxx_raw(M+1:end - 1));

    % Full biased autocorrelation
    Rxx_full = xcorr(x, 'biased'); 
    
    % Extract lags 0,1,...,M-1
    mid = length(Rxx_full)/2 + 0.5;  % index of lag=0
    Rxx_lags = Rxx_full(mid : mid+M-1);
    Rxx = toeplitz(Rxx_lags);
    
%     Rxx = Rxx + + 1e-6 * eye(size(Rxx));
    Ryx = xcorr(gt, x, M, "biased");
    % choosing non-negative lag from (-M, M) to (0, M)
    p = Ryx(M+1:end - 1);
    
    w = Rxx \ p;
    y_pred = filter(w, 1, x);

    elapsed_time = toc; % Stop the timer and store the elapsed time
    % --- 3. Print the Time Consumption ---
    fprintf('Wiener Filter Execution Time (N=%d samples): %.4f seconds\n', N, elapsed_time);
end

