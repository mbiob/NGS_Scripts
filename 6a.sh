#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Base Recalibrator
echo --------------------------- 6a.sh ---------------------------
echo Quality score recalibration - Base Recalibrator
echo Using GATK. 
echo Input infile.bam
echo Output 6a_infile_QSR.log 
echo ---------------------------  go -----------------------------

fname=$1
shift
infile=${fname} \
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-I ${fname} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-knownSites /Volumes/OCZ1/Broad/dbsnp_135.b37.excluding_sites_after_129.vcf \
-knownSites /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-knownSites /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
-o recal_data.grp \
-log 6a_${fname}_QSR.log
#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

