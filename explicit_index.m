% explicit_index.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [index] = explicit_index(words, word)
    index = find(1 == strcmp(words, word));
end

