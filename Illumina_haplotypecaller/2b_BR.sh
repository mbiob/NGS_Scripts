#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Base Recalibrator
echo -------------------part 2: 2_BR.sh ---------------------------
echo Quality score recalibration - Base Recalibrator_Print Reads
echo Using GATK225. 
echo Input RA_3pCR_input.bam 
echo Output BR_RA_3pCR_input.bam
echo ---------------------------  go ------------------------------
fname=$1
recfile=$2
infile2=${fname}
recfile=${recfile}
outfile2=BR_${infile2}
java -Xmx12g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-T PrintReads \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-I ${infile2} \
-BQSR ${recfile} \
-o ${outfile2} \
--read_filter MappingQualityZero \
-log PR${infile2}_QSR.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))