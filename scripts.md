---
---
# Scripts used (specific for this project)

<a name="trim01"></a>
Trimmomatic Command: [Note 1:](/notes.md#01)

`java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 4 L_lactis_S1_LALL_R1.trim.fastq.gz L_lactis_S1_LALL_R2.trim.fastq.gz \
            L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R1.trim.un.Gtrim.fastq.gz \
            L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R2.trim.un.Gtrim.fastq.gz \
            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE-G.fa:2:40:15`

<a name="BB01"></a>
BBTools re-pair script:

`./repair.sh -Xmx10g in1=L_lactis_S1_LALL_R1.trim.Gtrim.fastq in2=L_lactis_S1_LALL_R2.trim.Gtrim.fastq out1=L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq out2=L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq outsingle=single.fq`

<a name="thresh01"></a>
Thresholding the reads into manageable chunks for assembly
```
tar -czf L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq
tar -czf L_lactis_S2_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S2_LALL_R1.trim.Gtrim.fixed.fastq
zcat L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz | split -l 4000000 - LacR1
zcat L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz | split -l 4000000 - LacR2
```
[Note 2:](/notes.md#02)

<a name="cat01"> </a>
Creating readfiles of known size and renaming them simultaneously:
```
cat LacR1aa LacR1ab LacR1ac LacR1ad > LacR1aaabacad.fastq
cat LacR2aa LacR2ab LacR2ac LacR2ad > LacR2aaabacad.fastq
```

#### Plasmid SPAdes

<a name="scr05"></a>
First assemblies are to locate plasmid sequences:
```
spades/3.15.0
python3/3.6.4
spades.py -t 32 -m 96 -k 29,31,33,55 -1 LacR1aaabacad.fastq -2 LacR2aaabacad.fastq --careful --plasmid --cov-cutoff auto -o LACaaabR1R2acad_careful_plasmid
```








1. For [figures click here](/fig/)