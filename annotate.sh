#!/bin/sh

#Record Start time
BEFORE=`date '+%s'`

#Annotate filtered SNPs using annovar (summarize_annovar.pl)

fname=$1
shift
infile=${fname}
outfile=${fname}.snps
# Juster etter behov, kun en skal være aktiv
# summarize_annovar.pl --buildver hg19 --verdbsnp 135 --ver1000g 1000g2012feb ${infile} ~/NGS/annovar/humandb -outfile ~/Runs_Solid/Annovar_Out/${outfile}
# summarize_annovar.pl --buildver hg19 --verdbsnp 135 --ver1000g 1000g2012feb ${infile} ~/NGS/annovar/humandb -outfile /Volumes/OCZ1/NGS_Annovar/Annovar_Out/${outfile}
sudo perl /Users/ovbr/NGS/annovar/summarize_annovar.pl --buildver hg19 --verdbsnp 135 --ver1000g 1000g2012feb ${infile} ~/NGS/annovar/humandb -outfile ${outfile}



#Recording End time
AFTER=`date '+%s'`
TIME=$(($AFTER - $BEFORE))
seconds=${TIME}

hours=$((seconds / 3600))
seconds=$((seconds % 3600))
minutes=$((seconds / 60))
seconds=$((seconds % 60))

echo Processing time was "$hours hour(s) $minutes minute(s) $seconds second(s)"

#sudo perl summarize_annovar.pl --buildver hg19 --verdbsnp 135 ~/Runs_Solid/Filtering/snp.annovar ./humandb -outfile snps