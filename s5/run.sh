#!/bin/bash

# run.sh
# Author: Renee Lu
# About: This code is for using the MyST Kids' Speech Corpus for kaldi ASR training.

. ./cmd.sh	# Setting local system jobs (local CPU - no external clusters)
. ./path.sh	# Setting paths
set -e

n=15	# Number of jobs
CUR_DIR=$(pwd)	# Path to current s5 directory
MYST_ROOT=/srv/scratch/z5160268/2020_TasteofResearch/MyST_Kids_Corpus	# Path to CU Kids Speech Corpus on supercomputer

stage=4	# This controls what stage to start running from

if [ $stage -le 0 ]; then
	echo
	echo "===== STAGE 0/11 PREPARING RAW DATA ====="
	echo "Run once in the first time after unzipping data"
	echo

	# format.sh only needs to be run once, in the first time after unzipping speech corpus file 
	#echo "Formatting transcription files (e.g. removing all empty spaces)..."
	#. ./format.sh $CU_ROOT
	#cd $CUR_DIR

	# fix.sh only needs to be run once, in the first time after unzipping speech corpus file
	#echo "Applying some fixes to the data to remove edge cases..."
	#. ./fix.sh $CU_ROOT

	# raw2wav.sh only needs to be run once, in the first time after unzipping speech corpus file
	#echo "Converting .raw audio files into .wav formatted files..."
	#. ./raw2wav.sh $CU_ROOT
	#cd $CUR_DIR
fi

if [ $stage -le 1 ]; then
	echo
	echo "===== STAGE 1/11 PREPARING ACOUSTIC DATA ====="
	echo "Cleaning acoustic data and splitting it into train, test and dev portions"
	echo

	# Prepare data: generate local/uttspkr.txt which has all the information needed for required kaldi files. 
#	echo "Generating local/uttspkr.txt which has all the information required for kaldi data preparation..."
#	local/cu_data_prep.sh $CU_ROOT $CUR_DIR

	# Creating 'text', 'wav.scp', 'segments', 'utt2spk' and 'spk2utt'
#	echo "Creating 'text' 'wav.scp' 'segments' 'utt2spk' and 'spk2utt' files in 'data/train 'data/test' and 'data/dev'..."
#        local/cu_split_data.sh

	# Normalising the transcription
#	echo "Normalising transcription of 'text' files..."
#	local/textfile_normal.sh

	# Copying these created files into local/data directory
#	echo "Copying files into local/data directory..."
#	local/data2local.sh $CUR_DIR

	# Find the number of speakers and utterances in train, test and dev data
#	for portion in train test dev; do
#        	numspkrs=$(wc -l < data/$portion/spkrs)
#        	numutt=$(wc -l < data/$portion/utt2spk)
#        	echo "There are $numspkrs speakers and $numutt utterances in $portion data."
#	done
fi

if [ $stage -le 2 ]; then
	echo
	echo "===== STAGE 2/11 EXTRACTING FEATURES ====="
	echo "Extracing Mel Frequency Cepstral Coefficients (MFCC) features"
	echo

	# Create feats.scp file in data/train, data/test and data/dev
#	echo "Creating 'feats.scp' in 'data/train' 'data/test' and 'data/dev'..."
#    	for part in train test dev; do
#        	mfccdir=data/$part/mfcc
#        	mfcclog=exp/make_mfcc/$part
#        	mkdir -p $mfccdir $mfcclog
#        	steps/make_mfcc.sh --nj $n --cmd "$train_cmd" data/$part $mfcclog $mfccdir      # Making feats.scp files for training
#        	steps/compute_cmvn_stats.sh data/$part $mfcclog $mfccdir        		# Making cmvn.scp files for training
	
#		utils/validate_data_dir.sh data/$part	# Validate the data and check for errors
#		utils/fix_data_dir.sh data/$part	# Fix the errors
#	done
fi

if [ $stage -le 3 ]; then
	echo 
	echo "===== STAGE 3/11 PREPARING LANGUAGE DATA ====="
	echo "Cleaning language data in preparation for training Language Model"
	echo

	# Prepare dict directory
	# lexicon.txt               [ <word> <phone 1> <phone 2> ... ]
	# nonsilence_phones.txt     [<phone>]
	# silence_phones.txt        [<phone>]
	# optional_silence.txt      [<phone>]

	# Prepare the dict
#	local/cu_dict_prep.sh $CU_ROOT || exit 1  #I'm using set -e in the begining not sure if exit 1 needed
	#Prepare lang directory
#	utils/prepare_lang.sh data/local/dict "<UNK>" data/local/lang data/lang || exit 1
fi

if [ $stage -le 4 ]; then
	echo
	echo "===== STAGE 4/11 TRAINING LANGUAGE MODEL ====="
	echo "Training the Language Model (LM)"
	echo

	# Train bigram LM
	echo "Training bigram LM..."
	local/myst_train_srilm.sh $MYST_ROOT $CUR_DIR

fi


echo "===== SUCCESS: run.sh has completed. ====="
