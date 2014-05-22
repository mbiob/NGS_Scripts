#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#SNP Calling - Filter SNPs
echo ---------------------------- 7b.sh ----------------------------
echo SNP Calling - Filter SNPs
echo Using GATK. 
echo Input 654321_input.bam_snps.vcf
echo Output 654321_input.bam_snps.vcf_filtered.vcf
echo ----------------------------  go ------------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}_filtered.vcf
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-T VariantFiltration \
-V:variant,VCF ${infile} \
-o ${outfile} \
--clusterWindowSize 10 \
--filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" \
--filterName "HARD_TO_VALIDATE" \
--filterExpression "DP < 5 " \
--filterName "LowCoverage" \
--filterExpression "QUAL < 30.0 " \
--filterName "VeryLowQual" \
--filterExpression "QUAL > 30.0 && QUAL < 50.0 " \
--filterName "LowQual" \
--filterExpression "QD < 1.5 " \
--filterName "LowQD" \
--filterExpression "SB > -10.0 " \
--filterName "StrandBias" \
-log 7b_${fname}SNP-calling.log
#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"