###################################
### Generating reads needed     ###
### from a large fastq dataset  ###
### for a specific genome size  ###
### and coverage; using bash    ###
### Author: Peter R. Hoyt       ###
### © 2021 "Free to use"        ###
###################################
n2=2
sr=75
fs="genus"
fs1=${fs}1
fs2=${fs}2
genome=2500000
coverage=100
tbp=$((genome*coverage))
echo "We need at least ${tbp} for the requested coverage"
gffq1=G-trimmed-Cleaned-Re-paired-Reads1.fastq
gffq2=G-trimmed-Cleaned-Re-paired-Reads2.fastq
sed -n '1~4s/^@/>/p;2~4p' ${gffq1} > gffa1  
sed -n '1~4s/^@/>/p;2~4p' ${gffq2} > gffa2 
r1=`wc -l < gffa1`
r2=`wc -l < gffa2`
rd1=$((r1/n2))
rd2=$((r2/n2))
tords=$((rd1+rd2))
tobp=$((tords*sr))
numrds=$((tbp/sr))
numlns=$((numrds*n2)) 
split -d -l${numlns} ${gffq1} ${fs1} 
split -d -l${numlns} ${gffq2} ${fs2}
cp ${fs1}00 ${fs1}_00.fastq
cp ${fs2}00 ${fs2}_00.fastq