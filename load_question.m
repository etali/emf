% load_question.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [A, B, C, D] = load_question(filename)
    fid = fopen(filename, 'r');
    temp = textscan(fid, '%s %s %s %s');
    A = lower(temp{1});
    B = lower(temp{2});
    C = lower(temp{3});
    D = lower(temp{4});
    fclose(fid);
end

