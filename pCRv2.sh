#!/bin/sh


#Record Start time
BEFORE=`date '+%s'`

#Remove reads not in capture
echo --------------------------- pCR.sh ---------------------------
echo Printing out reads captured
echo Input input.bam
echo Output pCR_input.bam 
echo ---------------------------  go  ---------------------------


fname=$1
shift 
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar \
-T PrintReads \
-I ${fname} \
-o pCR_${fname} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v2/SeqCap_EZ_Exome_v2_copy.bed \
-log PrintCapturedReads_${fname}.log
#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
echo 
echo 
#Record Start time
BEFORE=`date '+%s'`

#Mark PCR Duplicates
echo --------------------------- 4.sh ---------------------------
echo Marking PCR dups using Picardtools MarkDuplicates
echo Input 21_input.bam
echo Output 321_input.bam 
echo ---------------------------  go  ---------------------------

infile=pCR_${fname}
outfile=3pCR_${fname}
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