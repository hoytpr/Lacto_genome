---
---
# Scripts used (specific for this project)

<a name="trim01"></a>
Trimmomatic Command: [See Note 1 on Trimmomatic:](/notes.md#01)

`java -jar /opt/trimmomatic/0.38/prebuilt/trimmomatic-0.38.jar PE -threads 4 L_lactis_S1_LALL_R1.trim.fastq.gz L_lactis_S1_LALL_R2.trim.fastq.gz \
            L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R1.trim.un.Gtrim.fastq.gz \
            L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R2.trim.un.Gtrim.fastq.gz \
            SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE-G.fa:2:40:15`

<a name="BB01"></a>
BBTools re-pair script:

`./repair.sh -Xmx10g in1=L_lactis_S1_LALL_R1.trim.Gtrim.fastq in2=L_lactis_S1_LALL_R2.trim.Gtrim.fastq out1=L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq out2=L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq outsingle=single.fq`

<a name="thresh01"></a>
Script 2: Splitting the reads into 1-million read chunks for assembly

<!--

tar -czf L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq
tar -czf L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq
zcat L_lactis_S1_LALL_R1.trim.Gtrim.fastq.gz | split -l 4000000 - LacR1
zcat L_lactis_S1_LALL_R2.trim.Gtrim.fastq.gz | split -l 4000000 - LacR2

-->

```
split -l 4000000 L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq LacR1
split -l 4000000 L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq LacR2
```
[See Note 2 on the above outputs:](/notes.md#02)

<a name="cat01"> </a>
Script 3: Creating readfiles of known size and renaming them as `.fastq` simultaneously:
```
cat LacR1aa LacR1ab LacR1ac LacR1ad > LacR1aaabacad.fastq
cat LacR2aa LacR2ab LacR2ac LacR2ad > LacR2aaabacad.fastq
```

#### Plasmid SPAdes

<a name="scr04"> </a>
Script 4 is a command-line based method of extracting fasta-formatted plasmid reads from a 
SPAdes-generated `.gfa` file when using the `--plasmid` option.

```
grep -E $'^S\t' LacR1R2_00_careful_plasmid/assembly_graph_with_scaffolds.gfa > LacR1R2_gfa.out
for line in LacR1R2_gfa.out 
    do 
    awk '{print ">" $2}''{print $3}' ${line} >> LacR1R2_gfa.out.fasta 
done 
```

<a name="scr05"></a>
Script 5: First assemblies are to locate plasmid sequences. This *de novo* assembly
also provides relatively long contigs that can be used to identify 
any reference genome present on NCBI:

```
spades/3.15.0
python3/3.6.4
spades.py -t 32 -m 96 -k 29,31,33,55 -1 LacR1aaabacad.fastq -2 LacR2aaabacad.fastq --careful --plasmid --cov-cutoff auto -o LACaaabR1R2acad_careful_plasmid
```

<a name="scr06"></a>
Script 6: Use Bandage to select plasmid nodes and export them as fasta files, and use these to create a Blast+ database.
```
blast+/2.8.1
makeblastdb -in Bandage_plasmid1.fasta -out /lactoplasmid/lactoplasmid/lactoplas_db -parse_seqids -dbtype nucl
makeblastdb -in Bandage_plasmid2.fasta -out /lactoplasmid/biglactoplasmid/biglactoplas_db -parse_seqids -dbtype nucl
```

Script 7: Make `.fasta` files from the `.fastq` reads [See Note 3:](/notes.md#03)
<a name="scr07"></a>
```
cat LacR1aaabacad.fastq | grep -A1 @ --no-group-separator > LacR1aaabacad.fasta
cat LacR2aaabacad.fastq | grep -A1 @ --no-group-separator > LacR2aaabacad.fasta
```

<a name="scr08"></a>
Script 8 [See NOTE #6 on these scripts](/notes.md#06)
```
blast+/2.8.1
blastn -db /lactoplasmid/lactoplasmid/lactoplas_db -num_threads 32 -evalue 0.001 -query LacR1aaabacad.fasta -out /lactoplasmid/lactoplasmid/R1aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/lactoplasmid/lactoplas_db -num_threads 32 -evalue 0.001 -query LacR2aaabacad.fasta -out /lactoplasmid/lactoplasmid/R2aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/biglactoplasmid/biglactoplas_db -num_threads 32 -evalue 0.001 -query LacR1aaabacad.fasta -out /lactoplasmid/biglactoplasmid/bigR1aaablactoplas.out -outfmt "6 qseqid"
blastn -db /lactoplasmid/biglactoplasmid/biglactoplas_db -num_threads 32 -evalue 0.001 -query LacR2aaabacad.fasta -out /lactoplasmid/biglactoplasmid/bigR2aaablactoplas.out -outfmt "6 qseqid"
```

<a name="scr09"></a>
Script 9: Extracts only the plasmids read names (actually the "qseqid") to a file
```
awk '{print $1}' R1aaabacadlactoplas.out | uniq > R1aaabacadNames
awk '{print $1}' R2aaabacadlactoplas.out | uniq > R2aaabacadNames
awk '{print $1}' bigR1aaabacadlactoplas.out | uniq > bigR1aaabacadNames
awk '{print $1}' bigR2aaabacadlactoplas.out | uniq > bigR2aaabacadNames
```

<a name="scr10"></a>
Script 10: Generates the Plasmid2 read1 and read2 `.fastq` files.
```
grep -F -A3 --file=R1aaabacadNames LacR1aaabacad.fastq --no-group-separator > R1Plasmid1.fastq
grep -F -A3 --file=R2aaabacadNames LacR2aaabacad.fastq --no-group-separator > R2Plasmid1.fastq
grep -F -A3 --file=bigR1aaabacadNames LacR1aaabacad.fastq --no-group-separator > R1Plasmid2.fastq
grep -F -A3 --file=bigR2aaabacadNames LacR2aaabacad.fastq --no-group-separator > R2Plasmid2.fastq
```

<a name="scr11"></a>
Script 11: Create a file of all plasmid read names
```
cat R1aaabacadNames bigR1aaabacadNames > plasmidnames
sort -u plasmidnames -o sortedallplasmidnames
```

<a name="scr12"></a>
Script 12: Create a list of all read names, clean the list up, then remove all plasmid read names. 
This created a file of only genomic reads names
```
grep NB501827 LacR1aaabacad.fastq > R1Allreadnames
grep NB501827 LacR2aaabacad.fastq > R2Allreadnames
awk '{print $1}' R1Allreadnames | uniq > R1aaabacadNames
awk '{print $1}' R2Allreadnames | uniq > R2aaabacadNames
grep -F -v --file=sortedallplasmidnames R1aaabacadNames > gR1aaabacadNames
grep -F -v --file=sortedallplasmidnames R2aaabacadNames > gR2aaabacadNames
```

<a name="scr13"></a>
Script 13: Extract the fastq file of the genomic reads and clean it [See Note 4:](/notes.md#04)
```
grep -F -A3 --file=gR1aaabacadNames LacR1aaabacad.fastq --no-group-separator > gLacR1aaabacadfixed.fastq
grep -F -A3 --file=gR2aaabacadNames LacR2aaabacad.fastq --no-group-separator > gLacR2aaabacadfixed.fastq
```

<a name="scr14"></a>
Script 14: Reassemble genome with plasmid reads removed: [See Note 5](/notes.md#05)
```
$ wc -l gLacR1aaabacadfixed.fastq
14011972 gLacR1aaabacadfixed.fastq (3,502,993 reads)
$ wc -l gLacR2aaabacadfixed.fastq
14011972 gLacR2aaabacadfixed.fastq  (3,502,993 reads)
spades.py -t 32 -m 768 -k 29,31,33,55 -1 gLacR1aaabacadfixed.fastq -2 gLacR2aaabacadfixed.fastq --careful --plasmid --cov-cutoff auto -o gLACaaabacad_plasmid
```

### Creating SAM and BAM file outputs

<a name="scr15"></a>
Script 15: Creating `.SAM` file output
```
Bowtie2/2.3.4.1
bowtie2-build CP065737.1.fasta lactococcus
bowtie2-inspect -a -s lactococcus
bowtie2 --threads 32 --end-to-end --no-unal -k 31 -I 300 -p 32 -X 600 -x lactococcus -q -1 gLacR1aaabacadfixed.fastq -2 gLacR2aaabacadfixed.fastq -S gLAC_final.sam
```

<a name="scr16"></a>
Script 16: Creating a `.BAM` file output
```
samtools/1.10
samtools view -bS gLAC_final.sam > gLAC_final.bam
samtools sort gLAC_final.bam -o gLAC_final.sorted.bam
samtools index -b gLAC_final.sorted.bam
```


<a name="scr17"></a>
Script 18: Creating a consensus sequence (optional)
```
bcftools/1.8
samtools/1.10
samtools mpileup -uf CP065737.1.fasta gLAC_final.sorted.bam | bcftools call -c | vcfutils.pl vcf2fq > gLAC_consensus.fq
```

<a name="scr18"></a>
Quast script to compare assemblies to reference genome
```
./quast.py lactodata/Lactococcus-lactis-PrHT3-with_plasmids.fasta \
           lactodata/Lactococcus-lactis-PrHT3.fasta \
           lactodata/Lactococcus-lactis-PrHT3-Plasmid1-novel.fasta \
           lactodata/Lactococcus-lactis-PrHT3-Plasmid2-scaff.fasta
        -r lactodata/FDAARGOS_865-sequence.fasta \
        -o lactodata_out
```
 
  
   
    


| [To README Page](/README.md) | [To metadata page](/metadata.md) |
| --- | --- |


1. For [figures click here](/fig/)