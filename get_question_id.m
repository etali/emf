% get_question_id.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function [query_num, available_count, iqAL, iqBL, iqCL, iqDL] = get_question_id(A, B, C, D, words)
    available_count = 0;
    query_num = length(A);
    iqAL = [];
    iqBL = [];
    iqCL = [];
    iqDL = [];

    for ind = 1:query_num
        iqA = explicit_index(words, A{ind}); % A
        iqB = explicit_index(words, B{ind}); % B
        iqC = explicit_index(words, C{ind}); % C
        iqD = explicit_index(words, D{ind}); % D
        if(0 == length(iqA) || 0 == length(iqB) || 0 == length(iqC) || 0 == length(iqD))
            continue;
        end
        iqAL = [iqAL; iqA];
        iqBL = [iqBL; iqB];
        iqCL = [iqCL; iqC];
        iqDL = [iqDL; iqD];
        available_count = available_count + 1;
        if 0 == mod(ind,100)
            disp([num2str((100.0*ind)/query_num), '%(', num2str(ind),',',num2str(query_num),')']);
        end
    end
end

