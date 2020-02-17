# myst_lm_prep.sh
# Author: Renee Lu
# About: This code uses the files 'trans.txt' and 'tags.txt' generated from myst_getchars.sh
#        to remove tags and event labels from the original transcription so that it is ready
#        to be formatted and used to create the kaldi Language Model.
#        To be run from s5 directory.
# Output: trans_lm.txt

perl -lpe 'BEGIN{open(A,"local/tags.txt"); chomp(@k = <A>)} 
                 for $w (@k){s/\b\Q$w\E\b//ig}' local/trans.txt > local/trans_lm.txt
