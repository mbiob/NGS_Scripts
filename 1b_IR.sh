#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

# RealignerTargetCreator_Create table of possible indels
echo ---------------------------- 5a.sh ----------------------------
echo RealignerTargetCreator_Create table of possible indels
echo using GATK222. 
echo Input 3pCR_input.bam, captured region only_fixed mates 
echo Output 3pCR_input.bam.list 
echo ----------------------------  go  -----------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}.list
java -Xmx4g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK222/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-known /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-known /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
-o ${outfile} \
-I ${infile} \
-log 5a_${fname}_LRAI.log

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
echo ---------------------------- 5a.sh ----------------------------
echo Local Realignment Around Indels_Create table of possible indels
echo using GATK. 
echo Input 3pCR_input.bam
echo Output RA_3pCR_input.bam 
echo ----------------------------  go  -----------------------------

java -Xmx4g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK222/GenomeAnalysisTK.jar \
-I ${infile} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-T IndelRealigner \
-targetIntervals ${outfile} \
-o RA${infile} \
-known /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-known /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
--consensusDeterminationModel KNOWNS_ONLY \
-LOD 0.4

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
