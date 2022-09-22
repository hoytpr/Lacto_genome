#!/bin/bash
#####################################################################
#### Bash script of Lactococcus lactis assembly including         ###
#### separation of plasmid reads prior to genome assembly.        ###
#### This is provided in the hopes it will be useful, but         ###
#### without ANY warranty whatsoever, not even                    ###
#### an implied warranty for fitness for a specific application.  ###
#### You should acquire a copy of the GNU General Public License  ###
#### which can be obtained at <http:gnu.org/licenses>.            ###
#### Author: Peter R. Hoyt                                        ###
#### © 2021 "Free to use"                                         ###
#####################################################################
#
### Primary read files:
### L_lactis_S1_LALL_R1.trim.fastq.gz 
### L_lactis_S1_LALL_R2.trim.fastq.gz
### Scripts used (specific for this project)
###
#
#### Trimmomatic Command: 

`java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 4 L_lactis_S1_LALL_R1.trim.fastq.gz L_lactis_S1_LALL_R2.trim.fastq.gz \
            L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R1.trim.un.Gtrim.fastq.gz \
            L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R2.trim.un.Gtrim.fastq.gz \
            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE-G.fa:2:40:15`

#### BBTools re-pair script:

`./repair.sh -Xmx10g in1=L_lactis_S1_LALL_R1.trim.Gtrim.fastq in2=L_lactis_S1_LALL_R2.trim.Gtrim.fastq out1=L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq out2=L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq outsingle=single.fq`

#### Splitting the fastq files into 1-million read chunks for assembly

```
split -l 4000000 L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq LacR1
split -l 4000000 L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq LacR2
cat LacR1aa LacR1ab LacR1ac LacR1ad > LacR1aaabacad.fastq
cat LacR2aa LacR2ab LacR2ac LacR2ad > LacR2aaabacad.fastq
spades/3.15.0
python3/3.6.4
spades.py -t 32 -m 96 -k 29,31,33,55 -1 LacR1aaabacad.fastq -2 LacR2aaabacad.fastq --careful --plasmid --cov-cutoff auto -o LACaaabR1R2acad_careful_plasmid
grep -E $'^S\t' LacR1R2_00_careful_plasmid/assembly_graph_with_scaffolds.gfa > LacR1R2_gfa.out
for line in LacR1R2_gfa.out 
    do 
    awk '{print ">" $2}''{print $3}' ${line} >> LacR1R2_gfa.out.fasta 
done 
```

#### Use Bandage to select plasmid nodes and export them as fasta files.
#### Create a Blast+ database to separate plasmid reads from genome reads.

```
blast+/2.8.1
makeblastdb -in Bandage_plasmid1.fasta -out /lactoplasmid/lactoplasmid/lactoplas_db -parse_seqids -dbtype nucl
makeblastdb -in Bandage_plasmid2.fasta -out /lactoplasmid/biglactoplasmid/biglactoplas_db -parse_seqids -dbtype nucl
cat LacR1aaabacad.fastq | grep -A1 NB501827 --no-group-separator > LacR1aaabacad.fasta
cat LacR2aaabacad.fastq | grep -A1 NB501827 --no-group-separator > LacR2aaabacad.fasta
blast+/2.8.1
blastn -db /lactoplasmid/lactoplasmid/lactoplas_db -num_threads 32 -evalue 0.001 -query LacR1aaabacad.fasta -out /lactoplasmid/lactoplasmid/R1aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/lactoplasmid/lactoplas_db -num_threads 32 -evalue 0.001 -query LacR2aaabacad.fasta -out /lactoplasmid/lactoplasmid/R2aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/biglactoplasmid/biglactoplas_db -num_threads 32 -evalue 0.001 -query LacR1aaabacad.fasta -out /lactoplasmid/biglactoplasmid/bigR1aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/biglactoplasmid/biglactoplas_db -num_threads 32 -evalue 0.001 -query LacR2aaabacad.fasta -out /lactoplasmid/biglactoplasmid/bigR2aaablactoplas.out -outfmt "6 qseqid"
awk '{print $1}' R1aaabacadlactoplas.out | uniq > R1aaabacadNames
awk '{print $1}' R2aaabacadlactoplas.out | uniq > R2aaabacadNames
awk '{print $1}' bigR1aaabacadlactoplas.out | uniq > bigR1aaabacadNames
awk '{print $1}' bigR2aaabacadlactoplas.out | uniq > bigR2aaabacadNames
```

#### Generate the Plasmid `.fastq` files.

```
grep -F -A3 --file=R1aaabacadNames LacR1aaabacad.fastq --no-group-separator > R1Plasmid1.fastq
grep -F -A3 --file=R2aaabacadNames LacR2aaabacad.fastq --no-group-separator > R2Plasmid1.fastq
grep -F -A3 --file=bigR1aaabacadNames LacR1aaabacad.fastq --no-group-separator > R1Plasmid2.fastq
grep -F -A3 --file=bigR2aaabacadNames LacR2aaabacad.fastq --no-group-separator > R2Plasmid2.fastq
```

#### Remove all plasmid read names to create genome read files. 

```
cat R1aaabacadNames bigR1aaabacadNames > plasmidnames
sort -u plasmidnames -o sortedallplasmidnames
grep NB501827 LacR1aaabacad.fastq > R1Allreadnames
grep NB501827 LacR2aaabacad.fastq > R2Allreadnames
awk '{print $1}' R1Allreadnames | uniq > R1aaabacadNames
awk '{print $1}' R2Allreadnames | uniq > R2aaabacadNames
grep -F -v --file=sortedallplasmidnames R1aaabacadNames > gR1aaabacadNames
grep -F -v --file=sortedallplasmidnames R2aaabacadNames > gR2aaabacadNames
grep -F -A3 --file=gR1aaabacadNames LacR1aaabacad.fastq --no-group-separator > gLacR1aaabacadfixed.fastq
grep -F -A3 --file=gR2aaabacadNames LacR2aaabacad.fastq --no-group-separator > gLacR2aaabacadfixed.fastq
```

#### Reassemble genome with plasmid reads removed:

```
$ wc -l gLacR1aaabacadfixed.fastq
$ wc -l gLacR2aaabacadfixed.fastq
spades.py -t 32 -m 768 -1 gLacR1aaabacadfixed.fastq -2 gLacR2aaabacadfixed.fastq --careful --plasmid --cov-cutoff auto -o gLACaaabacad_plasmid
Bowtie2/2.3.4.1
bowtie2-build CP065737.1.fasta lactococcus
bowtie2-inspect -a -s lactococcus
bowtie2 --threads 32 --end-to-end --no-unal -k 31 -I 300 -p 32 -X 600 -x lactococcus -q -1 gLacR1aaabacadfixed.fastq -2 gLacR2aaabacadfixed.fastq -S gLAC_final.sam
samtools/1.10
samtools view -bS gLAC_final.sam > gLAC_final.bam
samtools sort gLAC_final.bam -o gLAC_final.sorted.bam
samtools index -b gLAC_final.sorted.bam
```

#### Quast script to compare assemblies to reference genome

```
./quast.py lactodata/Lactococcus-lactis-PrHT3-with_plasmids.fasta \
           lactodata/Lactococcus-lactis-PrHT3.fasta \
           lactodata/Lactococcus-lactis-PrHT3-Plasmid1-novel.fasta \
           lactodata/Lactococcus-lactis-PrHT3-Plasmid2-scaff.fasta
        -r lactodata/FDAARGOS_865-sequence.fasta \
        -o lactodata_out
```


