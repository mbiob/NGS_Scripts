#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Haplotype Caller
echo ---------------------------- 3_UG.sh ----------------------------
echo A variant caller which unifies the approaches of several disparate
echo callers -- Works for single-sample and multi-sample data.
echo using GATK225. 
echo Input BR_RA_3pCR_input.bam
echo Output BR_RA_3pCR_input.bam_UG.snps.raw.vcf
echo ----------------------------  go  -----------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}_UG.snps.raw.vcf
java -Xmx4g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-T UnifiedGenotyper \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
--dbsnp /Volumes/OCZ1/Broad/dbsnp_135.b37.vcf \
-stand_call_conf [50.0] \
-stand_emit_conf 10.0 \
-dcov 100 \
-nct 3 \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture_copy.bed \
-o ${outfile} \
-I ${infile} \
-log UG_${fname}.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
