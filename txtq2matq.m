% txtq2matq.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function txtq2matq(question_infilename, question_mat_outfilename, vocabulary_filename)
	[A, B, C, D] = load_question(question_infilename); % 'data/q-words.txt'
	[words, freq] = explicit_loaddict(vocabulary_filename); % 'word2vec/dictc.txt'
	[query_num, available_count, iqAL, iqBL, iqCL, iqDL] = get_question_id(A, B, C, D, words);
	save(question_mat_outfilename, 'query_num', 'available_count', 'iqAL', 'iqBL', 'iqCL', 'iqDL'); % './data/questions.mat'
end

