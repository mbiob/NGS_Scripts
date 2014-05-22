#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Local Realignment Around Indels_Create table of possible indels
echo ---------------------------- 5a.sh ----------------------------
echo Local Realignment Around Indels_Create table of possible indels
echo using GATK. 
echo Input 321_input.bam
echo Output 321_input.bam.list 
echo ----------------------------  go  -----------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}.list
java -Xmx4g -jar /Users/ovbr/GATK222/GenomeAnalysisTK.jar \
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
