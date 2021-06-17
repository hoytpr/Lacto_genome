---
---
[HOME](/README.md)


# Lactococcus Metadata

Genomic DNA was received on 2021-02-26 at the Oklahoma State University Genomics Center.

DNA quality by Tapestation analysis: Excellent

![DNA](/fig/genomic-DNA-tapestation.png)

DNA concentration: 17.4 ng/ul

Library kit: KAPA/Roche HyperPlus (Cat.# KK8512)

Library preparation result: Excellent

![library](/fig/Library-QC.png)

Sequencing Kit: Illumina (2 X 75bp) MID-output kit (150 cycles)

Sequencing Start Date: 2021-03-09

Sequencing Completed Date: 2021-03-10

Sequencing Output: 18.85 GB

Run Number: 210309_NB501827_0133_AHMV5HAFX2

Data Archive Date: 2021-03-10

Archive Location: The University of Oklahoma Petastore (soon to be OURRstore)

Primary Data Filenames: `L_lactis_S1_LALL_R1_001.fastq.gz` and `L_lactis_S1_LALL_R2_001.fastq.gz`

Files processed through `bcl2fastq`?: YES

Number of Reads Passed Filter Read1:144,378,652

Number of Reads Passed Filter Read2:144,378,652

Post-sequencing QC:Trimmomatic v. 0.38 

Trimmomatic Command: ***[Script 1](/scripts.md#trim01)**

Orphaned reads from Trimmomatic were discarded and trimmed reads were repaired using BBTools `re-pair` software v. 38.90 **[Script 2](/scripts.md#BB01)**

Number of Reads surviving Trimmomatic and `re-pair` Read1:135,271,743

Number of Reads surviving Trimmomatic and `re-pair` Read2:135,271,743

### ASSEMBLY

Assembly readfile names: `L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq`, `L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq`

All G-trimmed and re-paired reads were divided into to 1-million read "chunks" **[Script 3](/scripts.md#thresh01)**
These `.fastq` files containing 1M-4M reads each are created by `split` and then concatenated together at 1M read intervals to be tested for the best assembly. Subsequently, the use of ≤4M reads was found to provide good overall genome coverage for identifying plasmid elements, while higher numbers (8M) could be used with read mapping. 
**[Script 4](/scripts.md#cat01)**

For testing and assemblies 2M reads `fastq` files were named according to the number of 1M reads "chunks" were used for example; 2M reads files were named: `LacR1aaab.fastq`, and `LacR2aaab.fastq`. Similarly, 4M read `fastq` files were named: `LacR1aaabacad.fastq`, and `LacR2aaabacad.fastq`.

#### Pre-Assembly (Assembly with plasmids)

Initially 8M reads were assembled using SPAdes 3.15.0 using the `--careful` and `--plasmid` options as in **[Script 5](/scripts.md#scr05)**. This step allowed for the visualization and removal of any plasmid sequences from the genomic assembly. 

Plasmid output assembly graph pathways (`.gfa` files) are the most important part of this output. In this case the file `assembly_graph_after_simplification.gfa` is output. The `.gfa` file was opened using `Bandage` v. 0.8.1 [http://rrwick.github.io/Bandage/](http://rrwick.github.io/Bandage/). The default assembly graph image created (colored by read depth) is shown below:

![Lactococcus assembly using --plasmid --careful](/fig/graph1.png)

This graph shows several important issues:
1. The Illumina sequencing was very high quality as there are no "dead-ends".
2. This graph clearly shows at least one separate high-copy-number plasmid.
3. The graph shows there are other disproportionately high-copy regions within the genome assembly.

Additional SPAdes outputs are the files `assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which contain only the SPAdes predicted plasmid sequence elements. The `assembly_graph.fastg` file is visualized with `Bandage` and shown below:

![Lactococcus predicted plasmids from SPAdes using --plasmid --careful](/fig/graph0_scaffolding.png)

This graph shows that SPAdes predicts at least two plasmids with one set of predicted plasmid scaffolds having much higher read counts than the other. Based on these data, three processes were performed to allow for independent assemblies:

1. Isolation of the high-copy read plasmid sequences (Plasmid1) 
2. Isolation of the lower-copy read plasmid sequences (Plasmid2)
3. Removal of the presumptive plasmid reads from the rest of the genomic reads for genome assembly. 


  ### Read data separation
  
  - The nodes of the presumptive plasmids can be selected, and the sequences can be output from Bandage as `.fasta` files (*e.g.* "Bandage_plasmid1.fasta" and "Bandage_plasmid2.fasta"). For a description of the differences between `Bandage` nodes and edges, vs. assembly contigs, please see the [Bandage Wiki Page](https://github.com/rrwick/Bandage/wiki). 
  - To identify reads corresponding to these plasmid sequences, the Bandage `.fasta` outputs were converted into a Blast+ database (v. 2.8.1). **[Script 6](/scripts.md#scr06)**
  - The complete set of Lactococcus reads `.fastq` files was converted to `.fasta` files **[Script 7](/scripts.md#scr07)**.
  - The Blast database was queried with the Lactococcus reads `.fasta` files outputting the read names that match the plasmid node sequences. **[Script 8](/scripts.md#scr08)**
  - The read names were cleaned up with an `awk` script **[Script 9](/scripts.md#scr09)** to make a file with ***only*** read names.  
  - The cleaned read names can then be used directly on the original read `.fastq` files to output the presumptive plasmid reads in `.fastq` format. **[Script 10](/scripts.md#scr10)** 
  - We then combined the plasmid read names **[Script 11](/scripts.md#scr11)** and created a ***genomic*** read names file by first generating a file of **all** read names and then removing all presumptive plasmid read names. **[Script 12](/scripts.md#scr12)**.
  - Use the genomics read names to extract the genomics `.fastq` reads. **[Script 13](scripts.md#scr13)**
  - Determine the number of genomic reads remaining (shown below).

```
$ wc -l gLacR1aaabacadfixed.fastq
14011972 gLacR1aaabacadfixed.fastq  #(3,502,993 reads)
$ wc -l gLacR2aaabacadfixed.fastq
14011972 gLacR2aaabacadfixed.fastq  #(3,502,993 reads)
```

 - Reassemble the genome. **[Script 14](scripts.md#scr14)** 
 
 ### Creating SAM and BAM files
 
 Genome SAM and BAM files were generated using Bowtie2 v. 2.3.4.1 
 
 The Bowtie2 process begins with and building and "inspection" of the reference genome, genome followed by alignment 
 of the reads to the reference genome, generating a `.SAM` file. Our reference genome was NCBI accession [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1) throughout. **[Script 15](/scripts.md#15)**
 
 The `.SAM` file was converted to a `.BAM` file, sorted, and indexed by Samtools v. 1.10 **[Spript 16](/scripts.md#16)** and the `.BAM` file was submitted with a scaffolded contig assembly to NCBI as part of BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925).
 
 If needed, a consensus sequence of the newly assembled genome can be generated by bcftools/1.8 and samtools/1.10. **[Script 17](/scripts.md#17)** 
 
 The Plasmid 2 consensus sequence was found by Blast (NCBI) to be over 98% identical to [CP065736.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065736.1), an unnamed 58,335 bp plasmid asociated with our reference strain [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1).
 
 We used CP065736.1 as a reference "genome" to map our Plasmid 2 sequences as a `.SAM` file, and similarly to a `.BAM` file for submission to NCBI with assemblies under BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925). 
 
 The Plasmid 1 consensus sequence did not show an overall homology greater than 60% to any plasmids or genomes in the NCBI databases. Because Plasmid 1 had no identifiable reference genome, it was submitted as `.fastq` reads to the SRA, and the assembly sequence as contigs rather than scaffolds. The NCBI BioProject accession is [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925). **Please note the PrHT3 genome and pPrHT3 plasmid-2 are combined within "sample 1" of the NCBI
BioProject**
 
 <a name="met01"></a>
 To determine the N50 of the separate molecules, the `quast` software ([see citations](/citations.md)) was used to compare assembly results on `.fasta` files of the genome reads with plasmids, the genome reads without plasmids, and on each set of plasmid reads separately. [Script 18](/scripts.md#scr18) 
 These comparisons used [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1) as the reference genome.  

 
| | Genome |	Plasmid-1ab | Plasmid2 |
| :--- | :--- | :--- | :--- |
| N50 | 134484 | 4564 | 11477|
| GC% | 35.22 | 31.69 | 34.69 |

The QUAST outputs (contig size cutoff default = 500 bp) for each assembly are shown below:
 
| Genome stats | PrHT3_with_plasmids | PrHT3_Plasmid-1ab | PrHT3_Plasmid2| PrHT3_genome_only |
|-|-|-|-|-|
| Mismatches |  |  |  |  |
| # N's | 0 | 0 | 0 | 0 |
| # contigs | 77 | 4 | 7 | 66 |
| # contigs (>= 0 bp) | 119 | 8 | 13 | 98 |
| # contigs (>= 1000 bp) | 65 | 4 | 7 | 54 |
| Largest contig | 435796 | 4753 | 12568 | 435796 |
| Total length (>= 0 bp) | 2518618 | 12772 | 57382 | **2448464** |
| Total length (>= 1000 bp) | 2497578 | 11842 | 55552 | 2430184 |
| N50 | 134484 | 4564 | 11477 | 134484 |
| N90 | 20903 | 1367 | 5972 | 32769 |
| L50 | 5 | 2 | 3 | 5 |
| L90 | 23 | 3 | 5 | 20 |
| GC (%) | 35.22 | 31.69 | 34.69 | 35.25 |
 

### Plasmid-1ab: Is it one or two plasmids?

Plasmid-1ab was named because it is unclear that this is a single plasmid. Some evidence suggests it may be two plasmids with regions of shared sequence identity. This was initially suspected in the `Bandage` visualization shown above, and was supported by isolation plasmid-1ab sequences. The sequences had very high coverage relative to the genome and [a separate page](/plasmid1ab.md) is presented to describe why it was left as "Plasmid-1ab"






[TO README Page](/README.md)
	 
	  
	   
	   












For [figures click here](/fig/)