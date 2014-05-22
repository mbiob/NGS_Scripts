#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Base Recalibrator
echo -------------------part 1: 2_BR.sh ---------------------------
echo Quality score recalibration - Base Recalibrator
echo Using GATK225. 
echo Input RA_3pCR_input.bam
echo Output RA_3pCR_input.bam_recal_data.grp 
echo ---------------------------  go ------------------------------

fname=$1
shift
infile1=${fname} 
outfile1=${fname}_recal_data.grp 

java -Xmx12g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-I ${infile1} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-knownSites /Volumes/OCZ1/Broad/dbsnp_135.b37.vcf \
-knownSites /Volumes/OCZ1/Broad/Mills_and_1000G_gold_standard.indels.b37.sites.vcf \
-knownSites /Volumes/OCZ1/Broad/1000G_phase1.indels.b37.vcf \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture_copy.bed \
-minPruning 4 \
-nct 3 \
-o ${outfile1} \
-log ${infile1}_QSR.log
#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

sleep 5s

#Record Start time
BEFORE=`date '+%s'`

#Quality score recalibration - Base Recalibrator
echo -------------------part 2: 2_BR.sh ---------------------------
echo Quality score recalibration - Base Recalibrator_Print Reads
echo Using GATK225. 
echo Input RA_3pCR_input.bam 
echo Output BR_RA_3pCR_input.bam
echo ---------------------------  go ------------------------------

infile2=${infile1}
recfile=${outfile1}
outfile2=BR_${infile2}
java -Xmx8g -Djava.io.tmpdir=/tmp \
-jar /Users/ovbr/GATK225/GenomeAnalysisTK.jar \
-T PrintReads \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture_copy.bed \
-I ${infile2} \
-BQSR ${recfile} \
-o ${outfile2} \
--read_filter MappingQualityZero \
-log PR${infile2}_QSR.log \

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))