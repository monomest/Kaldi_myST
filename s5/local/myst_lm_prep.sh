# myst_lm_prep.sh
# About: This code preps all the data to get it ready for creating kaldi Language Model
#        To be run from s5 directory.
# Output:
#         local/uniqchar.txt: all unique characters in transcription 
#         local/uniqchar-new.txt: all unique characters in transcription fed to Language Model
#         local/trans.txt: the original transcription
#         local/trans_lm.txt: the normalised transcription for Language Model
#         local/trans_lm-tmp.txt
#         local/tags.txt: all the tags and labels from transcription

MYST_ROOT=$1
CUR_DIR=$(pwd)
MYST_ROOT=/srv/scratch/z5160268/2020_TasteofResearch/MyST_Kids_Corpus
FILE=transcripts.txt	# File to be created for storing all the transcription
FILE=$MYST_ROOT/$FILE	

UCHAR=local/uniqchar.txt	# Output file
NUCHAR=local/uniqchar-new.txt	# Output file
TRANS=local/trans.txt		# Output file
TRANS_LM=local/trans_lm.txt	# Output file
TTRANS_LM=local/trans_lm-tmp.txt	# Output file
TAGS=local/tags.txt		# Output file
touch $UCHAR
touch $NUCHAR
touch $TRANS
touch $TRANS_LM
touch $TTRANS_LM
touch $TAGS

#sed -i "s/[[:space:]]\+/ /g" $FILE

#echo "Creating local/trans.txt..."
#while read line; do
#	fields=$(echo "$line" | grep -o " " | wc -l)
#	if [ $fields -gt 0 ]; then
#		trans=$(cut -d ' ' -f2- <<< "$line")
#		echo "$trans" >> $TRANS
#	fi
#done < $FILE

#dos2unix -q $TRANS

#echo "Creating local/uniqchar.txt..."
## Get all the unique characters
#cat $TRANS | fold -w1 | sort -u > $UCHAR

echo "Creating local/tags.txt..."
# Get all the tags and labels for < >
echo "Getting the tags < >"
grep -o "<[^>]*>" $TRANS | sort -u >> $TAGS
# ( )
echo "Getting the tags ( )"
grep -o "([^)]*)" $TRANS | sort -u >> $TAGS
# []
echo "Getting the tags [ ]"
grep -o "\[[^]]*\]" $TRANS | sort -u >> $TAGS
# + +
echo "Getting the tags + +"
grep -o "\+[^+]*+" $TRANS | sort -u >> $TAGS
# * *
echo "Getting the tags * *"
grep -o "\*[[:graph:]]*\*" $TRANS | sort -u >> $TAGS

echo "Sorting..."
sort -o -u $TAGS

# Remove all the tags and event labels
echo "Removing all tags and event labels from transcription for Language Model. Creating $TTRANS_LM..."
sed 's/<[^>]*>/ /g; s/([^)]*)/ /g; s/\[[^]]*\]/ /g; s/\+[^+]*+/ /g; s/\*[[:graph:]]*\*/ /g;' $TRANS > $TTRANS_LM

# Remove floating < + [ ) > / (not too sure about what the slashes mean) and remove <no_signal <side_speech +um and remove and replace these characters ‘ ’ –…
echo "Cleaning up the transcription for Language Model. Creating $TRANS_LM..."
sed "s/<no_signal/ /g; s/<side_speech/ /g; s/+um/ /g; /^myst_/d; s/</ /g; s/\+/ /g; s/\[/ /g; s/)/ /g; s/>/ /g; s/\// /g; s/‘/'/g; s/’/'/g; s/–/-/g; s/…/ /g; s/ / /g" $TTRANS_LM > $TRANS_LM

# Normalise the text
local/text_normal.sh $CUR_DIR $TRANS_LM

echo "Creating $NUCHAR..."
# Get all the unique characters
cat $TRANS_LM | fold -w1 | sort -u > $NUCHAR

echo "DONE"
