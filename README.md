## Word Embedding Revisted: Explicit Matrix Factorization

### Introduction

1. We write matlab code to train skip-gram negative sampling(SGNS) originally provided by the famous NLP toolbox **word2vec**(https://code.google.com/p/word2vec/).
2. Our objective function is equivalent to SGNS, however, we design our algorithm in another way.
3. You can take our code(w2vsbd.m) as a matlab implementation of SGNS, which is quite simple.
4. Moveover, we provide a supervised explicit matrix factorization(w2vsbdsup.m) that will boost the perform through supervision.

### Usage

1. Download dataset 'enwik9.zip' from http://cs.fit.edu/~mmahoney/compression/textdata.html
2. Decompress 'enwik9.zip' and get 'enwik9', then put it in folder './data/' 
3. Run run_emf.m file in matlab, then you will get a result of the first experiment of our paper
4. Run run_semf.m file in matlab, then you will get a result of the second experiment of our paper
5. Refer to our paper(http://home.ustc.edu.cn/~etali/papers/EMF-IJCAI2015.pdf) and code

### Our Experimental Environment(Requirements)

1. Red Hat Enterprise Linux Server release 6.2 (64x)
2. perl 5.10
3. gcc 4.4.5
4. matlab R2011a

### Details

We adopt word2vec from https://code.google.com/p/word2vec/ to generate co-occurrence matrix, and our algorithm only bases on co-occurrence matrix. Our algorithm is a batch mode alternating minimization that is not as scalable as the algorithm in word2vec, however, it performs as good as skip-gram negative sampling(SGNS) provided by word2vec. We provide the word2vec.c code we used in our project under folder *emf/word2vec/*, in which we altered several snippets.

### Authors

Yitan Li, Linli Xu, Fei Tian, Liang Jiang, Xiaowei Zhong, Enhong Chen
etali@mail.ustc.edu.cn
University of Science and Technology of China

