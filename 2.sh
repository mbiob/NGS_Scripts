#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Sort bam file
echo ---------------------------- 2.sh ----------------------------
echo Sorting input.bam file, using Picardtools SortSam
echo Input 1_input.bam
echo Output 21_input.bam 
echo ----------------------------  go  ----------------------------
fname=$1
shift
infile=${fname}
outfile=2${fname}
java -Xmx4g -jar ~/NGS/picard-tools-1.79/SortSam.jar \
INPUT=${infile} \
OUTPUT=${outfile} \
SORT_ORDER=coordinate \
VALIDATION_STRINGENCY=LENIENT \
TMP_DIR=/Volumes/LaCie/tmp \
CREATE_INDEX=True \
VERBOSITY=INFO \
#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}
	
hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"