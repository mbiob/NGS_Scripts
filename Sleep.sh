#!/bin/sh
#Record Start time
BEFORE=`date '+%s'`
# Get input from user
fname=$1
echo "There are two parameters that needs to be recorded before start:"
echo " "
echo " "
echo "Enter ID number of sample and press [ENTER]: "
read ID
runname=${ID}
shift
echo "Enter sequencing platform (Solid/Illumina) and press [ENTER]:"
read platform
ngs=${platform}
shift

echo "Input file is: $fname, ID of sample is: $runname and platform is: $ngs" 
echo "proceeding..."
echo " "
echo " "
#Modifying Solid bam file, AddOrReplaceReadGroups
#Check header of bam file with 'samtools view -H input.bam | grep ^@RG 
echo ---------------------------------- 1.sh ----------------------------------
echo Modifying Solid bam file ,infile.bam,  Picardtools AddOrReplaceReadGroups
echo Input infile.bam RGID Patform
echo Output 1_infile.bam
echo Check with "samtools view -H input.bam | grep ^@RG" 
echo ----------------------------------  go  ----------------------------------

infile=${fname} \
runname=${runname} \
platform=${ngs} \
outfile=1_${fname} \
java -Xmx2g -jar ~/NGS/picard-tools-1.79/AddOrReplaceReadGroups.jar \
INPUT=${infile} \
OUTPUT=${outfile} \
SORT_ORDER=coordinate \
IGNORE=INVALID_MAPPING_QUALITY \
RGLB=1 \
RGID=${runname} \
RGPL=${platform} \
RGPU=1 \
RGSM=KTS_OB \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true \
-log 1_${fname}_AORRG.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
