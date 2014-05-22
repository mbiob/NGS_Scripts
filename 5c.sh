#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Local Realignment Around Indels_fix mate information - very time consuming process!
echo --------------------------- 5c.sh ---------------------------
echo Local Realignment Around Indels - Fix mate information 
echo using picard-tools. 
echo Input 4321_input.bam
echo Output 54321_input.bam 
echo ---------------------------  go -----------------------------
fname=$1
shift
infile=${fname}
outfile=5${fname}
java -Djava.io.tmpdir=/Volumes/LaCie/tmp -Xmx4g -jar ~/NGS/picard-tools-1.79/FixMateInformation.jar \
INPUT=${fname} \
OUTPUT=${outfile} \
TMP_DIR=/Volumes/LaCie/tmp \
SO=coordinate \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true \


#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
