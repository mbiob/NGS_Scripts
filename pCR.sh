#!/bin/sh
fname=$1
shift 
java -Xmx4g -jar ~/GATK/GenomeAnalysisTK.jar \
-T PrintReads \
-I ${fname} \
-o pCR_${fname} \
-R ~/NGS/Reference_NGS/Broad/human_g1k_v37.fasta \
-L ~/NGS/Reference_NGS/SeqCapEZ_Exome_v3/SeqCap_EZ_Exome_v3_capture_copy.bed \
-log PrintCapturedReads_${fname}.log