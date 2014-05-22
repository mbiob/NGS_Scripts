#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#SNP Calling - produce raw SNP calls
echo --------------------------- 7a.sh ---------------------------
echo SNP Calling - produce raw SNP calls
echo Using GATK. 
echo Input 654321_input.bam 
echo Output 654321_input.bam_snps_raw.vcf
echo ---------------------------  go -----------------------------

fname=$1
shift
infile=${fname}
outfile=${fname}_snps_raw.vcf
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar \
-glm BOTH \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-B:intervals,BED ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture.bed
-T UnifiedGenotyper \
-I ${infile} \
-D  /Volumes/OCZ1/dbsnp_135.b37.excluding_sites_after_129.vcf \
-metrics snps.metrics \
-stand_call_conf 50.0 \
-stand_emit_conf 20.0 \
-dcov 1000 \
-A DepthOfCoverage \
-A AlleleBalance \
-o ${outfile} \
-log 7a_${fname}_UnifiedGenotyper.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

