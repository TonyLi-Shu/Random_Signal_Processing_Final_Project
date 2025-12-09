function [y_pred] = predict_filter(x, w, M, k)
    % PREDICT_MULTISTEP  Predict k-step ahead using Wiener weights
    %   x : input signal
    %   w : Wiener filter weights
    %   M : filter order
    %   k : look-ahead steps

    N = length(x);
    y_pred = zeros(N, 1);


    % ==== CASE: k = 1 (simple shift FIR) ====
    if k == 1
        y_pred = filter(w, 1, x);
        % y_pred = [0; y(1:end-1)]; % shift 1 step ahead
        return;
    end
    
    % ==== CASE: k >= 2 (autoregressive k-step ahead prediction) ====
    for n = M : N
       
        % real input regressor (past M samples)
        xn = x(n:-1:n-M+1);           % Mx1
        y1 = w.' * xn;                % predict t+1
    
        FUT = [y1; xn(1:M-1)];        % initial buffer (pred + past)
    
        % recursive prediction for t+2 ... t+k
        for kk = 2:k
            
            % build future regressor using predicted values
            FUT_prev = FUT(kk-1:-1:1);  % use newest predicted first
            
            if length(FUT_prev) >= M
                xk = FUT_prev(1:M);     % take only M samples
            else
                % pad with remaining past samples
                needed = M - length(FUT_prev);
                xk = [FUT_prev; xn(1:needed)];
            end
            
            xk = xk(:);                 % enforce column Mx1
            FUT(kk) = w.' * xk;         % safe multiplication
        end
    
        % store k-step ahead prediction
        y_pred(n) = FUT(k);
    end
                

end