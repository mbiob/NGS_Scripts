#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Table recalibration
echo --------------------------- 6b.sh ---------------------------
echo Quality score recalibration -  Table recalibration
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
-resource:hapmap,VCF,known=false,training=true,truth=true,prior=15.0 /Volumes/OCZ1/Broad/hapmap_3.3.b37.sites.vcf \
-resource:omni,VCF,known=false,training=true,truth=false,prior=12.0 /Volumes/OCZ1/Broad/1000G_omni2.5.b37.sites.vcf \
-resource:dbsnp,VCF,known=true,training=false,truth=false,prior=6.0 /Volumes/OCZ1/Broad/dbsnp_135.b37.vcf \
-resource:mills,VCF,known=false,training=true,truth=true,prior=12.0 /Volumes/OCZ1/Broad/gold.standard.indel.b37.vcf \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-I ${fname} \
-BQSR ${recfile} \
-o 6${fname} \
-log 6b_${fname}_QSR.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

