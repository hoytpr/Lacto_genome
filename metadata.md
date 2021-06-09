---
---
[HOME](/README.md)


# Lactococcus Metadata

Genomic DNA was received on 2021-02-26 at the Oklahoma State University Genomics Center.


Library kit: KAPA/Roche HyperPlus (Cat.# KK8512)

Sequencing Kit: Illumina (2 X 75bp) MID-output kit (150 cycles)

Sequencing Start Date: 2021-03-09

Sequencing Completed Date: 2021-03-10

Sequencing Output: 18.85 GB

Run Number: 210309_NB501827_0133_AHMV5HAFX2

Data Archive Date: 2021-03-10

Archive Location: The University of Oklahoma Petastore (soon to be OURRstore)

Primary Data Filenames: L_lactis_S1_LALL_R1_001.fastq.gz, L_lactis_S1_LALL_R2_001.fastq.gz

Files processed through `bcl2fastq`?: YES

Number of Reads Passed Filter Read1:144,378,652

Number of Reads Passed Filter Read2:144,378,652

Post-sequencing QC:Trimmomatic v. 0.38 

Trimmomatic Command: ***[Script 1](/scripts.md#trim01)**

Orphaned reads from Trimmomatic were discarded and trimmed reads were repaired using BBTools `re-pair` software v. 38.90 **[Script 2](/scripts.md#BB01)**

Number of Reads surviving Trimmomatic and `re-pair` Read1:135,271,743

Number of Reads surviving Trimmomatic and `re-pair` Read2:135,271,743

### ASSEMBLY

Current readfile names: L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq, L_lactis_S1_LALL_R2
.trim.Gtrim.fixed.fastq

Genome reads are thresholded to 1-million read chunks **[Script 3](/scripts.md#thresh01)**

Thresholded `.fastq` files containing 1M-4M reads each are created by `split` at defined sizes to be tested for best assembly. Smaller and larger sizes were tested. The use of ≤4M reads total gave good overall genome coverage for identifying plasmid elements, while higher numbers (8M) could be used with read mapping. 
**[Script 4](/scripts.md#cat01)**

After testing, 2M read `fastq` files were named: `LacR1aaab.fastq`, and `LacR2aaab.fastq`. Similarly, 4M read `fastq` files were named: `LacR1aaabacad.fastq`, and `LacR2aaabacad.fastq`.

#### Pre-Assembly (Assembly with plasmids)

Initially 8M reads were assembled using SPAdes 3.15.0 using the `--careful` and `--plasmid` options as in **[Script 5](/scripts.md#scr05)**. This step allowed for the visualization and removal of any plasmid sequences from the genomic assembly. 

Plasmid output assembly graph pathways (`.gfa` files) are the most important part of this output. In this case the file `assembly_graph_after_simplification.gfa` is output. The `.gfa` file was opened using `Bandage` v. 0.8.1 [http://rrwick.github.io/Bandage/](http://rrwick.github.io/Bandage/). The default assembly graph image created (colored by read depth) is shown below:

![Lactococcus assembly using --plasmid --careful](/fig/graph1.png).

This graph shows several important issues:
1. The Illumina sequencing was very high quality as there are no "dead-ends".
2. This graph clearly shows at least one separate high-copy-number plasmid.
3. The graph *implies* there is another disproportionately high-copy region within the genome assembly.

Additional outputs are the files `assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which contain only the SPAdes predicted plasmid sequence elements. The `assembly_graph.fastg` file is visualized with `Bandage` as shown below:

![Lactococcus predicted plasmids from SPAdes using --plasmid --careful](/fig/graph0_scaffolding.png)

Now we can see that SPAdes predicts at least two plasmids with one set of predicted plasmid scaffolds having much higher read counts than the other. Based on these data, three processes were performed to allow for independent assemblies:

1. Isolation of the high-copy read plasmid sequences (Plasmid1) 
2. Isolation of the lower-copy read plasmid sequences (Plasmid2)
3. Removal of the presumptive plasmid reads from the rest of the genomic reads for assembly. 

The metadata for the SPAdes assembly from 8M reads using the --careful --plasmid options is shown below:

  | Node count:	| 1,743	| N50:	| 37,182 bp* |
  | :------------- | :----------: | -----------: | ----- |
  | Edge count:	 | 2,358	|Shortest node:	| 32 bp|
  | Edge overlaps:	| 31 bp	| Lower quartile node:	| 45 bp|
  | Total length:	 | 2,579,211 bp	| Median node:	| 63 bp|
  | Total length (no overlaps):	 | 2,525,178bp	| Upper quartile node:	| 116 bp|
  | Longest node:	| 15  | 6,326 bp | |

  | Graph connectivity| 	| Depth	| |
  | :------------- | :----------: | -----------: | ----- |
  | Dead ends:	 |0	|Median depth:	| 57x|
  | Percentage dead ends:	| 0.0%	| Estimated sequence length:	| 2,845,043 bp|
  | Connected components:	 | 1	| 	|  |
  | Largest component:	 |  2,579,211 bp (100.00%}	| 	| |
  | Total length orphaned nodes:	| 0 bp | | |
  #*
  #### [NOTE](/notes.md#n50)
  
  ### Read data separation
  
  - The nodes of the presumptive plasmids can be selected, and the sequences can be output from Bandage as `.fasta` files (*e.g.* "Bandage_plasmid1.fasta" and "Bandage_plasmid2.fasta"). 
  - To identify reads corresponding to these plasmid sequences, the Bandage `.fasta` outputs were converted into a Blast+ database (v. 2.8.1) **[Script 6](/scripts.md#scr06)**.
  - The complete set of Lactococcus reads `.fastq` files was converted to `.fasta` files **[Script 7](/scripts.md#scr07)**.
  - The Blast database was queried with the Lactococcus reads `.fasta` files outputting the read names that match the plasmid node sequences **[Script 8](/scripts.md#scr08)**.
  - The read names were cleaned up with an `awk` script **[Script 9](/scripts.md#scr09)** to make a file with ***only*** read names  
  - The cleaned read names can then be used directly on the original read `fastq` files to output the presumptive plasmid reads **[Script 10](/scripts.md#scr10)** or to combine plasmid read names **[Script 11](/scripts.md#scr11)** and create a ***genomic*** read names file by creating a file of **all** read names and removing all presumptive plasmid read names from the file **[Script 12](/scripts.md#scr12)**.
  - Use the genomics read names to extract the genomics fastq reads **[Script 13](scripts.md#scr13)**.
  - Determine the number of genomic reads remaining.

```
$ wc -l gLacR1aaabacadfixed.fastq
14011972 gLacR1aaabacadfixed.fastq  #(3,502,993 reads)
$ wc -l gLacR2aaabacadfixed.fastq
14011972 gLacR2aaabacadfixed.fastq  #(3,502,993 reads)
```

 - Reassemble the genome **[Script 14](scripts.md#scr14)**. 
 
 ### Creating SAM and BAM files
 
 Genome SAM and BAM files were generated using Bowtie2 v. 2.3.4.1 
 
 The Bowtie2 process begins with and building and "inspection" of the reference genome, genome followed by alignment 
 of the reads to the reference genome, generating a `.SAM` file. Our reference genome was NCBI accession CP065737.1 throughout. **[Script 15](/scripts.md#15)**
 
 The `.SAM` file was converted to a BAM file, sorted, and indexed by Samtools v. 1.10 **[Spript 16](/scripts.md#16)**
 
 If needed, a consensus sequence of the newly assembled genome can be generated by bcftools/1.8 and samtools/1.10 **[Script 17](/scripts.md#17)** and was submitted with a scaffolded contig assembly to NCBI as Bioproject PRJNA731925.
 
 The Plasmid 2 consensus sequence was found by Blast (NCBI) to be over 98% identical to [CP065736.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065736.1), an unnamed 58,335 bp plasmid asociated with our reference strain [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1)
 
 We used CP065736.1 as a reference "genome" to map our Plasmid 2 sequences as a `.SAM` files, and similarly to a `.BAM` file for submission to NCBI with assemblies under BioProject PRJNA731925. 
 
 The Plasmid 1 consensus sequence did not show an overall homology greater than 60% to any plasmids or genomes in the NCBI databases. We determined that Plasmid 1 was "novel" and would have to be submitted as `.fastq` reads to the SRA, and assembly sequence as contigs only to NCBI with BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925). 
 
 To determine the N50 of the separate molecules, I used quast software on each of the `.fasta` files 
 and used [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1) as the reference genome. Notice that the N50 greatly improved over what was reported by the SPAdes output. 
 The integration of the plasmid into the genome of [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1) may be responsible for this
 
  | Genome |	Plasmid1ab | Plasmid2 |
  | :--- | :--- | :--- | :--- |
  | N50 | 134484 | 4564 | 11477|
  | GC% | 35.22 | 31.69 | 34.69 |

Here's the QUAST outputs for each assembly:
 
| Genome stats | PrHT3_with_plasmids | PrHT3_Plasmid1ab | PrHT3_Plasmid2| PrHT3_genome_only |
|-|-|-|-|-|
| NG50 | 134484 | - | - | 134484 |
| NG90 | 20903 | - | - | 20903 |
| LG50 | 5 | - | - | 5 |
| LG90 | 23 | - | - | 23 |
| Mismatches |  |  |  |  |
| # N's | 0 | 0 | 0 | 0 |
| Statistics without reference |  |  |  |  |
| # contigs | 77 | 4 | 7 | 66 |
| # contigs (>= 0 bp) | 119 | 8 | 13 | 98 |
| # contigs (>= 1000 bp) | 65 | 4 | 7 | 54 |
| # contigs (>= 5000 bp) | 37 | 0 | 5 | 32 |
| # contigs (>= 10000 bp) | 33 | 0 | 4 | 29 |
| # contigs (>= 25000 bp) | 20 | 0 | 0 | 20 |
| # contigs (>= 50000 bp) | 14 | 0 | 0 | 14 |
| Largest contig | 435796 | 4753 | 12568 | 435796 |
| Total length | 2506114 | 11842 | 55552 | 2438720 |
| Total length (>= 0 bp) | 2518618 | 12772 | 57382 | 2448464 |
| Total length (>= 1000 bp) | 2497578 | 11842 | 55552 | 2430184 |
| Total length (>= 5000 bp) | 2432816 | 0 | 52464 | 2380352 |
| Total length (>= 10000 bp) | 2400036 | 0 | 46492 | 2353544 |
| Total length (>= 25000 bp) | 2207483 | 0 | 0 | 2207483 |
| Total length (>= 50000 bp) | 1970301 | 0 | 0 | 1970301 |
| N50 | 134484 | 4564 | 11477 | 134484 |
| N90 | 20903 | 1367 | 5972 | 32769 |
| L50 | 5 | 2 | 3 | 5 |
| L90 | 23 | 3 | 5 | 20 |
| GC (%) | 35.22 | 31.69 | 34.69 | 35.25 |
 








[HOME](/README.md)
	 
	  
	   
	   












For [figures click here](/fig/)