#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Haplotype Caller
echo ---------------------------- 3_HC.sh ----------------------------
echo HaplotypeCaller call SNPs and indels simultaneously via local 
echo de-novo assembly of haplotypes in an active region
echo using GATK225. 
echo Input BR_RA_3pCR_input.bam
echo Output BR_RA_3pCR_input.bam_raw.snps.indels.vcf
echo ----------------------------  go  -----------------------------
fname=$1
shift
infile=${fname}
outfile=${fname}_haplotypecaller_raw.snps.indels.vcf
java -Xmx12g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
--dbsnp /Volumes/OCZ1/Broad/dbsnp_135.b37.vcf \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture_copy.bed \
-minPruning 8 \
-o ${outfile} \
-I ${infile} \
-log HaplotypeCaller${fname}.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
