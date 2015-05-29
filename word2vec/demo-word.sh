make
#if [ ! -e text8 ]; then
#  wget http://mattmahoney.net/dc/text8.zip -O text8.gz
#  gzip -d text8.gz -f
#fi
time ./word2vec -train result9 -save-vocab dictc.txt -matrix matrix.txt -output vectors.bin -saveW savedW.txt -saveC savedC.txt -nsc savednsc.txt -cbow 0 -size 200 -window 2 -negative 4 -hs 0 -sample 1e-5 -threads 20 -binary 1 -iter 15 -min-count 1000
#./distance vectors.bin
