#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Modifying Solid bam file, AddOrReplaceReadGroups
#Check header of bam file with 'samtools view -H input.bam | grep ^@RG 
echo ---------------------------------- 1.sh ----------------------------------
echo Modifying Solid bam file ,infile.bam,  Picardtools AddOrReplaceReadGroups
echo Input infile.bam RGID Patform
echo Output 1_infile.bam
echo Check with "samtools view -H input.bam | grep ^@RG" 
echo ----------------------------------  go  ----------------------------------

echo " "
echo " "
fname=$1

# 

echo "There are two parameters that needs to be recorded before start:"
echo " "
echo " "
shift
echo "Enter ID number of sample and press [ENTER]: "
read ID
runid=${ID}
shift
echo "Enter sequencing platform ( Solid/Illumina) and press [ENTER]:"
read platform
ngs=${platform}


echo "Input file is: $fname, ID of sample is: $runname and platform is: $ngs" 
echo "proceeding..."

# shift
# 
# idname=$2
# ngs=$3
shift
infile1=${fname}
runname=${runid}
platform=${ngs}
outfile1=1_${fname}
java -Xmx2g -jar ~/NGS/picard-tools-1.72/AddOrReplaceReadGroups.jar \
INPUT=${infile1} \
OUTPUT=${outfile1} \
SORT_ORDER=coordinate \
RGLB=1 \
RGID=${runname} \
RGPL=${platform} \
RGPU=1 \
RGSM=ID_439_01 \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true \

echo " "
echo " "


#Sort bam file
echo ---------------------------- 2.sh ----------------------------
echo Sorting input.bam file, using Picardtools SortSam
echo Input 1_input.bam
echo Output 21_input.bam 
echo ----------------------------  go  ----------------------------
echo " "
echo " "
shift
infile2=${outfile1}
outfile2=2${outfile1}
java -Xmx4g -jar ~/NGS/picard-tools-1.72/SortSam.jar \
INPUT=${infile2} \
OUTPUT=${outfile2} \
SORT_ORDER=coordinate

echo " "
echo " "

#Index bam file
echo ---------------------------- 3.sh ----------------------------
echo Creating index of 21_input.bam using Samtools
echo Input 21_input.bam
echo Output 21_input.bam.bai 
echo ----------------------------  go  ----------------------------
echo " "
echo " "
shift
infile3=${outfile2}
outfile3=${outfile2}.bai
samtools index \
${infile3} \
${outfile3}
echo " "
echo " "


#Mark PCR Duplicates
echo --------------------------- 4.sh ---------------------------
echo Marking PCR dups using Picardtools MarkDuplicates
echo Input 21_input.bam
echo Output 321_input.bam 
echo ---------------------------  go  ---------------------------
echo " "
echo " "
shift
infile4=${outfile2}
outfile4=3${outfile2}
java -Xmx4g -Djava.io.tmpdir=/tmp -jar ~/NGS/picard-tools-1.72/MarkDuplicates.jar  \
INPUT=${infile4} \
OUTPUT=${outfile4} \
METRICS_FILE=metrics \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=LENIENT

echo " "
echo " "

#Local Realignment Around Indels_Create table of possible indels
echo ---------------------------- 5a.sh ----------------------------
echo Local Realignment Around Indels_Create table of possible indels
echo using GATK. 
echo Input 321_input.bam
echo Output 321_input.bam.list 
echo ----------------------------  go  -----------------------------
echo " "
echo " "
shift
infile5=${outfile4}
outfile5=${outfile4}.list
java -Xmx4g -jar /Users/ovbr/GATK/dist/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R ~/NGS/Reference_NGS/chromFa/hg19.fa \
-o ${outfile5} \
-I ${infile5}

echo " "
echo " "

#Local Realignment Around Indels_Realign reads around possible Indels
echo ------------------------------- 5b.sh -------------------------------
echo Local Realignment Around Indels_Realign reads around possible Indels
echo using GATK. 
echo Input 321_input.bam 321_input.bam.list
echo Output 4321_input.bam
echo -------------------------------  go  --------------------------------
echo " "
echo " "
shift
inlist=${outfile5}
outfile6=4${outfile4}
java -Xmx4g -Djava.io.tmpdir=/tmp \
-jar ~/GATK/dist/GenomeAnalysisTK.jar  \
-I ${infile5} \
-R ~/NGS/Reference_NGS/chromFa/hg19.fa \
-T IndelRealigner \
-targetIntervals ${inlist} \
-o ${outfile6}

echo " "
echo " "

#Local Realignment Around Indels_fix mate information - very time consuming process!
echo --------------------------- 5c.sh ---------------------------
echo Local Realignment Around Indels - Fix mate information 
echo using GATK. 
echo Input 4321_input.bam
echo Output 54321_input.bam 
echo ---------------------------  go -----------------------------
echo " "
echo " "
shift
infile6=${outfile6}
outfile7=5${outfile6}
java -Djava.io.tmpdir=/tmp/ \
-jar -Xmx4g ~/NGS/picard-tools-1.72/FixMateInformation.jar \
INPUT=${infile6} \
OUTPUT=${outfile7} \
SO=coordinate \
VALIDATION_STRINGENCY=LENIENT \
CREATE_INDEX=true

echo " "
echo " "

#Quality score recalibration - Count covariates
echo --------------------------- 6a.sh ---------------------------
echo Quality score recalibration - Count covariates
echo Using GATK. 
echo Input 54321_input.bam
echo Output 54321_input.bam.recal_data.csv 
echo ---------------------------  go -----------------------------
echo " "
echo " "
shift
infile7=${outfile7}
outfile8=${outfile7}.recal_data.csv
java -Xmx4g -jar ~/GATK/dist/GenomeAnalysisTK.jar \
-l INFO \
-R ~/NGS/Reference_NGS/chromFa/hg19.fa \
-knownSites:name,VCF ~/NGS/Reference_NGS/dbsnp_135.hg19.sort.vcf \
--solid_nocall_strategy PURGE_READ \
-I ${infile7} \
-T CountCovariates \
-cov ReadGroupCovariate \
-cov QualityScoreCovariate \
-cov CycleCovariate \
-cov DinucCovariate \
-recalFile ${outfile8}

echo " "
echo " "

#Quality score recalibration - Table recalibration
echo --------------------------- 6b.sh ---------------------------
echo Quality score recalibration -  Table recalibration
echo Using GATK. 
echo Input 54321_input.bam 54321_input.bam.recal_data.csv 
echo Output 654321_input.bam
echo ---------------------------  go -----------------------------
echo " "
echo " "
recalfile=${outfile8}
shift
infile8=${infile7}
recfile=${recalfile}
outfile9=6${infile7}
java -Xmx4g -jar ~/GATK/dist/GenomeAnalysisTK.jar  \
-l INFO \
--solid_nocall_strategy PURGE_READ \
-R ~/NGS/Reference_NGS/chromFa/hg19.fa \
-I ${infile8} \
-T TableRecalibration \
-o ${outfile9} \
-recalFile ${recfile}

echo " "
echo " "

#SNP Calling - produce raw SNP calls
echo --------------------------- 7a.sh ---------------------------
echo SNP Calling - produce raw SNP calls
echo Using GATK. 
echo Input 654321_input.bam 
echo Output 654321_input.bam_snps.vcf
echo ---------------------------  go -----------------------------

fname=$1
shift
infile9=${outfile9}
outfile10=${outfile9}_snps.vcf
java -Xmx4g -jar ~/GATK/dist/GenomeAnalysisTK.jar \
-glm BOTH \
-R ~/NGS/Reference_NGS/chromFa/hg19.fa \
-T UnifiedGenotyper \
-I ${infile9} \
-D  ~/NGS/Reference_NGS/dbsnp_135.hg19.sort.vcf \
-metrics snps.metrics \
-stand_call_conf 50.0 \
-stand_emit_conf 10.0 \
-dcov 1000 \
-A DepthOfCoverage \
-A AlleleBalance \
-L /Users/ovbr/NGS/Reference_NGS/wgenome_interval_list.hg19.bed \
-o ${outfile10}

#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))
echo " "
echo " "
echo '??????????????????????????????????????????????????????????????????????????'
echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"
echo ¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿
echo " "
echo " "






