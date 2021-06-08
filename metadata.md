---
---
# Lactococcus Metadata

Genomic DNA was received on 2021-02-26 at the Oklahoma State University Genomics Center.


Library kit:

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

Trimmomatic Command: ***[script 1](/scripts.md#trim01)**

Orphaned reads from Trimmomatic were discarded and trimmed reads were repaired using BBTools `re-pair` software v. 38.90 **[script 2](/scripts.md#BB01)**

Number of Reads surviving Trimmomatic and `re-pair` Read1:135,271,743

Number of Reads surviving Trimmomatic and `re-pair` Read2:135,271,743

### ASSEMBLY

Current readfile names: L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq, L_lactis_S1_LALL_R2
.trim.Gtrim.fixed.fastq

Genome reads are thresholded to 1-million read chunks **[script3](/scripts.md#thresh01)**

Thresholded `.fastq` files containing 1M-4M reads each are created by `cat` at defined sizes to be tested for best assembly. Smaller and larger sizes were tested. The use of ≤4M reads total gave good overall genome coverage for identifying plasmid elements, while higher numbers (8M) could be used with read mapping. 
**[script4](/scripts.md#cat01)**

After testing, 2M read `fastq` files were named: `LacR1aaab.fastq`, and `LacR2aaab.fastq`. Similarly, 4M read `fastq` files were named: `LacR1aaabacad.fastq`, and `LacR2aaabacad.fastq`.

#### Pre-Assembly (Assembly with plasmids)

Initially 8M reads were assembled using SPAdes 3.15.0 using the --careful and --plasmid options as in [script 5](/scripts.md#scr05). This step allowed for the visualization and removal of any plasmid sequences from the genomic assembly. 

Plasmid output assembly graph pathways (`.gfa` files) are the most important part of this output. In this case the file `assembly_graph_after_simplification.gfa` is output. The `.gfa` file was opened using `Bandage` v. 0.8.1 [http://rrwick.github.io/Bandage/](http://rrwick.github.io/Bandage/). The default assembly graph image created (colored by read depth) is shown below:

![Lactococcus assembly using --plasmid --careful](/fig/graph1.png).

This graph shows several important issues:
1. The Illumina sequencing was very high quality as there are no "dead-ends".
2. This graph clearly shows at least one separate high-copy-number plasmid.
3. The graph *implies* there is another disproportionately high-copy region within the genome assembly.

An additional outputs are the files `assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which contain only the SPAdes predicted plasmid sequence elements, and `assembly_graph.fastg` visualized with `Bandage` is shown below:

![Lactococcus predicted plasmids from SPAdes using --plasmid --careful](/fig/graph0_scaffolding.png)

Now we can see that SPAdes predicts at least two plasmids with one set of predicted plasmid scaffolds having much higher read counts than the other. Based on these data, three processes were performed to allow for independent assemblies:

1. Isolation of the high-copy read plasmid sequences (Plasmid1) 
2. Isolation of the lower-copy read plasmid sequences (Plasmid2)
3. Removal of the presumptive plasmid reads from the rest of the genomic reads for assembly. 

The metadata for the SPAdes assembly from 8M reads using the --careful --plasmid options is shown below:

  | Node count:	| 1,743	| N50:	| 37,182 bp|
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
  
  
  ### Read data separation
  
  - The nodes of the presumptive plasmids can be selected, and the sequences can be output from Bandage as `.fasta` files (e.g. "Bandage_plasmid1.fasta" and "Bandage_plasmid2.fasta". 
  - To identify reads corresponding to these sequences, the Bandage `.fasta` outputs were converted into a Blast+ database (v. 2.8.1) [script 6](/scripts.md#scr06).
  - The complete set of Lactococcus reads `.fastq` files can be converted to `.fasta` files [script 7](/scripts.md#scr07).
  - The Blast database can then be queried with the Lactococcus reads `.fasta` files outputting the read names that match the plasmid node sequences [script 8](/scripts.md#scr08).
  - The read names can be cleaned up with an `awk` script [script 9](/scripts.md#scr09) to make a file with only read names  
  - The cleaned read names can then be used directly on the original read `fastq` files to output the presumptive plasmid reads [script 10](/scripts#scr10) or to combine plasmid reads and exclude those reads creating genomic read files [script 11](/scripts.md#scr11).
  
  | Output Reads filename | Presumptive Target |
  | ------- | -------|
  |
  
  
    
	 
	  
	   
	   












For [figures click here](/fig/)