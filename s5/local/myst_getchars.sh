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
TAGS=local/tags.txt
touch $UCHAR
touch $TRANS
touch $TAGS

#sed -i "s/[[:space:]]\+/ /g" $FILE

while read line; do
	trans=$(cut -d ' ' -f2- <<< "$line")
	echo "$trans" >> $TRANS
done < $FILE

# Get all the unique characters
cat $TRANS | fold -w1 | sort -u > $UCHAR

# Get all the tags and labels for < >
grep -o "<[[:graph:]]*.>" $TRANS | sort -u >> $TAGS
# ( )
grep -o "([[:graph:]]*.)" $TRANS | sort -u >> $TAGS
# []
grep -o "\[[[:graph:]]*.\]" $TRANS | sort -u >> $TAGS
# + +
grep -o "\+[[:graph:]]*+" $TRANS | sort -u >> $TAGS

sort -o -u $TAGS
