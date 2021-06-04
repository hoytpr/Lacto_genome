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









1. For [figures click here](/fig/)