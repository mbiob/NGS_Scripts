#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Local Realignment Around Indels_Realign reads around possible Indels
echo ------------------------------- 5b.sh -------------------------------
echo Local Realignment Around Indels_Realign reads around possible Indels
echo using GATK. 
echo Input 321_input.bam 321_input.bam.list
echo Output 4321_input.bam
echo -------------------------------  go  --------------------------------
fname=$1
lname=$2
shift
infile=${fname}
inlist=${lname}
outfile=4${fname}
java -Xmx4g -Djava.io.tmpdir=/tmp \
-jar ~/GATK/GenomeAnalysisTK.jar  \
-I ${infile} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-T IndelRealigner \
-known /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-known /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
-targetIntervals ${inlist} \
-o ${outfile} \
-log 5b_${fname}_LRAI.log

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

