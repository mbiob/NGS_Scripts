#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`
# Convert format from vcf to annovar 

fname=$1
infile=${fname}
shift

echo ---------------------------------- cta.sh ----------------------------------
echo Converting vcf file to annovar format
echo Input infile.vcf
echo Output infile.vcf.snp.annovar
echo ----------------------------------  go  ----------------------------------

convert2annovar.pl \
--format vcf4 \
--includeinfo \
${infile} > ${infile}.snp.annovar


#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"