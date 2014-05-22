#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Table recalibration
echo --------------------------- 6b.sh ---------------------------
echo Quality score recalibration -  PrintReads
echo Using GATK. 
echo Input 54321_input.bam 54321_input.bam.recal_data.csv 
echo Output 654321_input.bam
echo ---------------------------  go -----------------------------
fname=$1
recalfile=$2
shift
infile=${fname}
recfile=${recalfile}
outfile=6${fname}
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar  \
-T PrintReads \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-I ${infile} \
-BQSR ${recfile} \
-o ${outfile} \
--read_filter MappingQualityZero \
-log 6b_illumina_test_${fname}_QSR.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

