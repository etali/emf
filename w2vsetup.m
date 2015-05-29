% w2vsetup.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

function w2vsetup(matrix_infilename, mat_outfilename, question_infilename, ...,
				  question_mat_outfilename, vocabulary_filename)
	txtq2matq(question_infilename, question_mat_outfilename, vocabulary_filename);
	temp = load(matrix_infilename); % 'word2vec/matrix.txt'
	w2vmatrix = spconvert(temp);
	save(mat_outfilename, 'w2vmatrix'); % './data/w2vm.mat'
end
