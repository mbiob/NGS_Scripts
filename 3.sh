#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Index bam file
echo ---------------------------- 3.sh ----------------------------
echo Creating index of 21_input.bam using Samtools
echo Input 21_input.bam
echo Output 21_input.bam.bai 
echo ----------------------------  go  ----------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}.bai
samtools index \
${infile} \
${outfile} \
-log 3_${fname}_INDEX.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"