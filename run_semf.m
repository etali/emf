% run_semf.m
% Author: Yitan Li@USTC
% Email: etali@mail.ustc.edu.cn

% Supervised Explicit Matrix Factorization
clear;

% Options
PREPROCESS_RAWXML = 1;
GET_COOCCURRENCE = 1;
EXECUTE_SEMF = 1;

% Configuration of pre-processing of wikipedia dataset
% We get wikipedia dataset from http://cs.fit.edu/~mmahoney/compression/textdata.html
raw_dataset = 'enwik9';                                         % wikipedia text dataset

% Configuration of co-occurrence matrix
data_filename = 'processed_text_sup';                           % preprocessed wikipedia text dataset
vocab_filename = 'dictc_sup.txt';                               % vocabulary filename
co_occurrence_matrix_filename = 'matrix_sup.txt';               % co-occurrence matrix filename
co_occurrence_mat_outfilename = 'w2vm_sup.mat';                 % co-occurrence matrix filename (matlab format)
question_txt_filename = 'q-words.txt';                          % google word analogy task(analogical reasoning task) queries
question_mat_filename = 'questions_sup.mat';                    % google word analogy task queries (matlab format)
window_size = 5;                                                % window size of word2vec(toolbox) that will influence the construction of co-occurrence matrix
window_size = floor(window_size/2);                             
min_count = 1000;                                               % min-count of word2vec(toolbox) that filters out words of low frequency

% Configuration of learning algorithm
maxiter = 100;                                                  % maximum number of iteration of main loop 
inner_maxiter = 50;                                             % maximum number of iteration of inner loop
stepsize = 5e-7;                                                % step-size of descending/ascending
negative = 4;                                                   % negative sampling parameter that is represented by k in our paper
embedding_vector_dim = 200;                                     % embedding dimentionality
lambda = 0.125;                                                 % lambda for controlling the degree of supervision 
training_questions_sample_ratio = 0.1;                          % training set ratio of word analogy queries
save_embedding_vector_filename = 'embedding_vector_sup.mat';    % filename for saving embedding vector
verbose = 5;                                                    % set verbose_acc to 0, there will be no verbose description

% Run pre-processing 
% We get pre-processing perl code from http://cs.fit.edu/~mmahoney/compression/textdata.html
if(PREPROCESS_RAWXML)
    display(['start preprocess ', raw_dataset]);
    system(['chmod u+x ', 'preprocess.sh']);
    system(['chmod u+x ', 'preprocessing']);
    cmd_line = ['./preprocess.sh', ' ', './data/', raw_dataset, ' ', './data/', data_filename];
    system(cmd_line);
    display(['end preprocess']);
end

% Run skip-gram negative sampling(SGNS) in word2vec and get the co-occurrence matrix
% where the element in i-th column and j-th row represent the co-occurrence count of i-th word and j-th word
if(GET_COOCCURRENCE)
    display('start extraction of co-occurrence matrix from SGNS');
    cd word2vec
    system('make'); % we only compile the word2vec.c
    system(['chmod u+x ', 'word2vec']);
    cmd_line = sprintf('time ./word2vec -train %s -save-vocab %s -matrix %s -output vectors.bin -saveW savedW.txt -saveC savedC.txt -nsc savednsc.txt -cbow 0 -size %d -window %d -negative %d -hs 0 -sample 1e-5 -threads 20 -binary 1 -iter 15 -min-count %d', ..., 
                        ['../data/', data_filename], ['../data/', vocab_filename], ['../data/', co_occurrence_matrix_filename], embedding_vector_dim, window_size, negative, min_count);
    display(cmd_line);
    system(cmd_line);
    cd ..
    w2vsetup(['./data/', co_occurrence_matrix_filename], ['./data/', co_occurrence_mat_outfilename], ...,
             ['./data/', question_txt_filename], ['./data/', question_mat_filename], ['./data/', vocab_filename]);
    display('end');
end

% Run Supervised Explicit Matrix Factorization
if(EXECUTE_SEMF)
    clc;
    % run SEMF
    display('start SEMF');
    w2vsbdsup(['./data/', co_occurrence_mat_outfilename], ['./data/', question_mat_filename], ...,
              maxiter, inner_maxiter, stepsize, negative, embedding_vector_dim, lambda, training_questions_sample_ratio, ...,
              verbose, ['./data/', save_embedding_vector_filename]);
    display('end SEMF');
end






