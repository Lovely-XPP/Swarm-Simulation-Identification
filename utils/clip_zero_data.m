function [f_idx, b_idx] = clip_zero_data(data)
%CLIP_ZERO_DATA 删除数据前后段的0值
%   data: 输入数据
%   f_idx:  非0值的第一个索引
%   b_idx:  非0值的最后一个索引
zero_idx = data == 0;
zero_idx_new = zero_idx;
zero_idx_new(1) = [];
zero_idx_new = [zero_idx_new; 1];
zero_d_idx = zero_idx - zero_idx_new;
idxs = find(zero_d_idx ~= 0);
if data(1) ~= 0
    f_idx = 1;
else
    f_idx = idxs(1) + 1;
end
if data(end) ~= 0
    b_idx = length(data);
else
    b_idx = idxs(end) + 1;
end
end

