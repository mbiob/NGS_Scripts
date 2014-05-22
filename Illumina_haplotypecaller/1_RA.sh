#!/bin/sh

set -o errexit

#Record Start time
BEFORE=`date '+%s'`

# RealignerTargetCreator_Create table of possible indels
echo ----------------------part 1: 1_RA.sh ----------------------------
echo RealignerTargetCreator_Create table of possible indels
echo using GATK225. 
echo Input 3pCR_input.bam, captured region only_fixed mates_dedup 
echo Output 3pCR_input.bam.list 
echo ----------------------------  go  --------------------------------
fname="$1"
shift
infile=${fname}
outfile=${fname}.list
java -Xmx12g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK222/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-nct 3 \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-known /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-known /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
-o ${outfile} \
-I ${infile} \
-log 1_RA_${fname}_LRAI.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

#Record Start time
BEFORE=`date '+%s'`

# IndelRealigner - output realigned bam
echo ----------------------part 2: 1_RA.sh ----------------------------
echo Local Realignment Around Indels_Create table of possible indels
echo using GATK225. 
echo Input 3pCR_input.bam
echo Output RA_3pCR_input.bam 
echo ----------------------------  go  --------------------------------

java -Xmx12g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-I ${infile} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-T IndelRealigner \
-nct 3 \
-targetIntervals ${outfile} \
-o RA${infile} \
-known /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-known /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
--consensusDeterminationModel KNOWNS_ONLY \
-LOD 0.4 \
-log 1b_RA_${fname}_LRAI.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
