function [total_len, train_data, test_data] = split_train_test(Table_price, Ratio)
    
    if nargin < 2 || isempty(Ratio)
        Ratio = 0.9;
    end
    
    total_len = size(Table_price, 1);
    train_data = Table_price(1:floor(Ratio * total_len), :);
    test_data = Table_price(floor(Ratio * total_len)+1:end, :);
end