#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Mark PCR Duplicates
echo --------------------------- 4.sh ---------------------------
echo Marking PCR dups using Picardtools MarkDuplicates
echo Input 21_input.bam
echo Output 321_input.bam 
echo ---------------------------  go  ---------------------------
fname=$1
shift
infile=${fname}
outfile=3${fname}
java -Xmx4g -Djava.io.tmpdir=/tmp -jar ~/NGS/picard-tools-1.79/MarkDuplicates.jar  \
INPUT=${infile} \
OUTPUT=${outfile} \
METRICS_FILE=metrics \
ASSUME_SORTED=true \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT \


#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"