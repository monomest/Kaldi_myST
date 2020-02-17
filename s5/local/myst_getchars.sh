# myst_getchars.sh
# About: This code gets all the characters present in the MyST Corpus transcription. 
#        To be run from s5 directory.
# Output: uniqchar.txt
#         trans.txt

MYST_ROOT=/srv/scratch/z5160268/2020_TasteofResearch/MyST_Kids_Corpus
FILE=transcripts.txt
FILE=$MYST_ROOT/$FILE

UCHAR=local/uniqchar.txt
TRANS=local/trans.txt
TRANS_LM=local/trans_lm.txt
TAGS=local/tags.txt
touch $UCHAR
touch $TRANS
touch $TRANS_LM
touch $TAGS

#sed -i "s/[[:space:]]\+/ /g" $FILE

#echo "Creating local/trans.txt..."
#while read line; do
#	trans=$(cut -d ' ' -f2- <<< "$line")
#	echo "$trans" >> $TRANS
#done < $FILE

#echo "Creating local/uniqchar.txt..."
# Get all the unique characters
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
echo "Removing all tags and event labels..."
sed 's/<[^>]*>/ /g; s/([^)]*)/ /g; s/\[[^]]*\]/ /g; s/\+[^+]*+/ /g; s/\*[[:graph:]]*\*/ /g;' $TRANS > $TRANS_LM

echo "DONE"
