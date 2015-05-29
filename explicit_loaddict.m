% explicit_loaddict.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [words, freqs] = explicit_loaddict(filename)
    fid = fopen(filename, 'r');
    fscanf(fid, '%s %d\n', 2);
    [words, temp] = textscan(fid, '%s %s');
    freq = words(:,2);
    freq = freq{1};
    freqs = zeros(length(freq),1);
    for i = 1:length(freq)
        freqs(i) = str2num(freq{i});
    end
    words = words(:,1);
    words = words{1};
    fclose(fid);
end

